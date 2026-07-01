// ══════════════════════════════════════════════════════════════
// NPU vs CPU Benchmark — measured entirely from RTL execution.
//
// Two real assembly programs (assembled with the Python assembler)
// are each run through the actual pipelined CPU RTL:
//
//   assembler/matmul_cpu_test.hex — 4x4 matmul in pure software.
//     The ISA has no multiply instruction, so each product is
//     computed by repeated addition.
//
//   assembler/matmul_npu_test.hex — the same matmul offloaded to
//     the systolic array NPU using real memory-mapped sw/lw
//     instructions: copy A/B in, write the start register, poll
//     the status register, copy C back. No hierarchical pokes.
//
// Both programs bracket their work with stores to the host MMIO
// port (address 512). The harness counts clock cycles between the
// first marker (start) and second marker (end), then captures the
// 16 result values the program streams out and checks them against
// a golden C++ model. The speedup is the ratio of the two measured
// windows.
//
// Usage: Vbenchmark <cpu_program.hex> <npu_program.hex>
// ══════════════════════════════════════════════════════════════
#include <iostream>
#include <iomanip>
#include <string>
#include <vector>
#include <verilated.h>
#include "Vtop.h"

struct RunResult {
    uint64_t total_cycles   = 0;   // reset -> last verification value
    uint64_t compute_cycles = 0;   // between the two marker stores
    std::vector<uint32_t> c_values;
    bool ok = false;
};

// Run one program on the RTL and extract the measurement protocol:
// TX event 1 = start marker, TX event 2 = end marker,
// TX events 3..18 = the 16 elements of C.
static RunResult run_program(const std::string& hexfile) {
    RunResult res;

    // Each run gets its own Verilated context so each program's
    // +firmware plusarg is seen only by its own model.
    VerilatedContext* ctx = new VerilatedContext;
    std::string plusarg = "+firmware=" + hexfile;
    const char* args[] = { plusarg.c_str() };
    ctx->commandArgsAdd(1, args);

    Vtop* top = new Vtop{ctx};

    // Reset
    top->clk = 0;
    top->reset = 1;
    top->host_rx_data = 0;
    top->eval();
    for (int i = 0; i < 4; i++) {
        top->clk = 1; top->eval();
        top->clk = 0; top->eval();
    }
    top->reset = 0;
    top->eval();

    const uint64_t TIMEOUT = 200000;
    uint64_t cycle = 0;
    uint64_t start_cycle = 0, end_cycle = 0;
    int tx_events = 0;

    while (cycle < TIMEOUT) {
        top->clk = 1; top->eval();
        top->clk = 0; top->eval();
        cycle++;

        if (top->host_tx_valid) {
            tx_events++;
            if (tx_events == 1) {
                start_cycle = cycle;            // start marker
            } else if (tx_events == 2) {
                end_cycle = cycle;              // end marker
            } else {
                res.c_values.push_back(top->host_tx_data);
                if (res.c_values.size() == 16) {
                    res.total_cycles   = cycle;
                    res.compute_cycles = end_cycle - start_cycle;
                    res.ok = true;
                    break;
                }
            }
        }
    }

    if (!res.ok) {
        std::cout << "[ERROR] " << hexfile << ": timeout after " << cycle
                  << " cycles (" << tx_events << " TX events seen)\n";
    }

    top->final();
    delete top;
    delete ctx;
    return res;
}

int main(int argc, char** argv) {
    if (argc < 3) {
        std::cout << "Usage: " << argv[0]
                  << " <cpu_program.hex> <npu_program.hex>\n";
        return 1;
    }

    // Golden reference — must match the matrices initialized by
    // both assembly programs.
    const int A[4][4] = {
        { 1,  2,  3,  4},
        { 5,  6,  7,  8},
        { 9, 10, 11, 12},
        {13, 14, 15, 16}
    };
    const int B[4][4] = {
        {2, 0, 1, 3},
        {1, 1, 0, 2},
        {0, 2, 1, 1},
        {3, 0, 2, 0}
    };
    int golden[4][4];
    for (int i = 0; i < 4; i++)
        for (int j = 0; j < 4; j++) {
            int sum = 0;
            for (int k = 0; k < 4; k++) sum += A[i][k] * B[k][j];
            golden[i][j] = sum;
        }

    std::cout << "[Bench] Running software matmul on the pipelined CPU RTL...\n";
    RunResult cpu = run_program(argv[1]);
    std::cout << "[Bench] Running NPU-offloaded matmul on the same RTL...\n";
    RunResult npu = run_program(argv[2]);

    if (!cpu.ok || !npu.ok) return 1;

    // Verify both result streams against the golden model
    auto verify = [&](const RunResult& r, const char* name) {
        bool match = true;
        for (int i = 0; i < 16; i++) {
            if ((int)r.c_values[i] != golden[i / 4][i % 4]) {
                std::cout << "[ERROR] " << name << " C[" << i / 4 << "]["
                          << i % 4 << "] expected " << golden[i / 4][i % 4]
                          << ", got " << r.c_values[i] << "\n";
                match = false;
            }
        }
        return match;
    };
    bool cpu_match = verify(cpu, "CPU");
    bool npu_match = verify(npu, "NPU");

    std::cout << "\n===========================================\n";
    std::cout << "        NPU vs CPU BENCHMARK RESULTS       \n";
    std::cout << "===========================================\n";

    if (cpu_match && npu_match) {
        std::cout << "[SUCCESS] Both results match the golden model.\n\n";
    } else {
        std::cout << "[ERROR] Result mismatch detected!\n\n";
    }

    std::cout << "Matrix C (from RTL):\n";
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++)
            std::cout << std::setw(5) << npu.c_values[i * 4 + j] << " ";
        std::cout << "\n";
    }

    std::cout << "\nMeasured RTL clock cycles (4x4 matmul, data in DMEM to result in DMEM):\n";
    std::cout << "-------------------------------------------\n";
    std::cout << " Path                    | Cycles          \n";
    std::cout << "-------------------------------------------\n";
    std::cout << " CPU (software loops)    | " << std::setw(8) << cpu.compute_cycles << "\n";
    std::cout << " NPU (MMIO offload)      | " << std::setw(8) << npu.compute_cycles << "\n";
    std::cout << "-------------------------------------------\n";

    double speedup = (double)cpu.compute_cycles / (double)npu.compute_cycles;
    std::cout << " NPU Speedup             | " << std::fixed
              << std::setprecision(2) << speedup << "x\n";
    std::cout << "===========================================\n";

    return (cpu_match && npu_match) ? 0 : 1;
}
