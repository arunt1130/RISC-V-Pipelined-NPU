# RISC-V Core — CPU Pipeline + AI Accelerator

A RISC-V RV32I processor implementation in Verilog, built from scratch to understand CPU microarchitecture and the intersection of classical CPU design with modern AI hardware.

## What Is This?

This project implements a **RISC-V RV32I processor** spanning three stages of increasing complexity:

1. **Single-cycle** — one instruction per clock cycle, simplest possible datapath
2. **5-stage pipelined** — overlapping execution with hazard detection, data forwarding, and branch flushing
3. **Systolic array NPU** — a 4x4 matrix multiplication AI accelerator integrated directly into the CPU as a memory-mapped coprocessor

## Architecture Overview

### Pipeline Stages

```
┌──────┐    ┌──────┐    ┌──────┐    ┌──────┐    ┌──────┐
│  IF  │───▸│  ID  │───▸│  EX  │───▸│ MEM  │───▸│  WB  │
│Fetch │    │Decode│    │Execut│    │Memory│    │Write │
│      │    │      │    │      │    │      │    │ Back │
└──────┘    └──────┘    └──────┘    └──────┘    └──────┘
   │            │           │           │
   ▼            ▼           ▼           ▼
 IF/ID        ID/EX      EX/MEM     MEM/WB
 Register     Register   Register   Register
```

### Hazard Handling

| Hazard Type | Example | Solution |
|-------------|---------|----------|
| **Data hazard** (R-R) | `add x1,x2,x3` → `sub x4,x1,x5` | Forwarding from MEM/WB stages |
| **Load-use** | `lw x1,0(x2)` → `add x3,x1,x4` | 1-cycle stall + forwarding |
| **Control** (branch) | `beq x1,x2,target` | Assume not taken, flush on taken (3-cycle penalty) |
| **Control** (jump) | `jal ra,func` / `jalr x0,0(ra)` | Resolved in MEM like branches, always flush (3-cycle penalty) |

### Supported Instructions

| Type | Instructions |
|------|-------------|
| **R-type** | `add`, `sub`, `and`, `or` |
| **I-type** | `addi`, `lw` |
| **S-type** | `sw` |
| **SB-type** | `beq` |
| **UJ-type** | `jal` |
| **I-type (jump)** | `jalr` |

`jal`/`jalr` enable real function calls and returns — see `assembler/jump_test.s` for a program that calls a subroutine twice and returns via the link register.

### Systolic Array NPU

The NPU is a memory-mapped AI accelerator integrated into the CPU's memory stage. At its core is a **4×4 grid of MAC (Multiply-Accumulate) units** — the grid is generated from a single `ARRAY_SIZE` parameter (2x2 and 8x8 instances are built and verified by `make test_param`). MAC inputs are **signed int8**, matching real quantized NN inference. 

* **Memory-Mapped Interface**: Addresses `256–305` route to the NPU instead of Data Memory.
  * `256–271`: Matrix A storage
  * `272–287`: Matrix B storage
  * `288–303`: Matrix C (read-only result)
  * `304`: Control register (write `1` to start)
  * `305`: Status register (read bit 0 for `done`)
* **Data Flow**: To compute a matrix multiplication in hardware, data is fed into the array in a **skewed** format. Row *i* is delayed by *i* clock cycles, and Column *j* is delayed by *j* clock cycles. This ensures the correct elements meet inside the grid at the exact right time.
* **Speed**: A 4x4 matrix multiplication takes exactly **10 clock cycles** (`3N-2`) inside the NPU, drastically faster than traditional CPU instructions.

## Directory Structure

```
├── rtl/
│   ├── common/          # Shared modules (ALU, RegFile, Control, memories, muxes)
│   ├── single_cycle/    # Single-cycle top module (no pipelining — simplest datapath)
│   ├── pipeline/        # Pipeline registers, forwarding unit, hazard detection, top module
│   └── npu/             # Systolic array NPU (MAC unit, 4x4 array, controller)
├── tb/                  # Testbenches (includes pipeline and NPU integration)
├── assembler/
│   ├── assembler.py     # Main CLI entry point
│   ├── encoder.py       # Instruction format bitwise encoders
│   ├── isa.py           # Opcode, funct3, funct7, and register definitions
│   ├── parser.py        # Text parser and label resolution
│   └── test.s           # Example assembly program
├── docs/                # Documentation
└── .gitignore
```

### Key Files

| File | Description |
|------|-------------|
| `rtl/single_cycle/single_cycle_top.v` | Top-level single-cycle processor (`make test_single`) |
| `rtl/pipeline/pipeline_top.v` | Top-level pipelined processor |
| `rtl/pipeline/forwarding_unit.v` | Data hazard forwarding logic |
| `rtl/pipeline/hazard_detection_unit.v` | Load-use stall detection |
| `rtl/common/alu.v` | 32-bit ALU (add, sub, and, or) |
| `rtl/common/control_unit.v` | Main control decoder |
| `rtl/common/reg_file.v` | 32x32 register file (x0 hardwired to 0) |
| `tb/tb_pipeline_top.v` | Deprecated Verilog testbench |
| `sim/sim_main.cpp` | **Verilator C++ simulation harness and Host interface** |

## SoC Verification Guide (CPU + NPU + Host)

### 1. C++ Simulation Harness (`sim/sim_main.cpp`)

**Verilator** is used to compile the Verilog RTL into a cycle-accurate C++ model. The `sim_main.cpp` program acts as the Host, driving the clock, injecting payloads into the CPU over Memory-Mapped I/O, and waiting for the hardware to process and return neural network inferences.

I created `assembler/cpu_test.s` which acts as the "torture test" for the pipeline. It is intentionally designed to trigger pipeline stalls, data forwarding, and branch flushing. 

#### What it tests:
* **I-Type & R-Type**: Basic arithmetic (`add`, `sub`, `addi`) and bitwise logic (`and`, `or`).
* **Forwarding Hazards**: Back-to-back dependent registers force the pipeline to forward data from the EX/MEM and MEM/WB stages.
* **Load-Use Hazards**: A `sw` followed by a `lw` and an immediate `add` operation using the loaded value inserts a 1-cycle stall bubble.
* **Control Hazards**: Forward/backward branches test 3-cycle pipeline flushes.

### 2. NPU Integration & Host Polling (`firmware.s`)

The firmware acts as the bridge between the Host software and the NPU hardware.

#### Memory Map Extensions
The NPU is activated when the memory address is >= 256 (Bit 8 is set). This was expanded to include the Host interface:
* **Matrix A (16 bytes)**: Address `256` to `271`
* **Matrix B (16 bytes)**: Address `272` to `287`
* **Matrix C (16 words)**: Address `288` to `303` (Read-only)
* **Start Register**: Address `304` (Write 1 to start)
* **Status Register**: Address `305` (Read bit 0 for done flag)
* **Host RX**: Address `512` (Read from Host C++ software)
* **Host TX**: Address `512` (Write to Host C++ software)

#### Execution Flow:
1. Firmware polls Address `512` until the Host injects a non-zero command.
2. Firmware writes matrices to NPU and triggers the start flag.
3. Executes a `lw` / `beq` polling loop to wait for the NPU status flag.
4. Reads `C[0][0]` back from the NPU.
5. Writes the result back to Address `512` which the C++ Host catches.

### 3. Running the Firmware Simulation

Everything is automated through the Makefile. You must be in a Linux/WSL environment with Verilator installed.

```bash
# Assemble the firmware
python assembler/assembler.py assembler/firmware.s assembler/firmware.hex

# Compile the hardware and run the C++ simulation
make run
```

#### Expected Output
You will see the Host program boot the SoC, inject the payload, and wait for the hardware to process the NPU workload cycle-by-cycle:

```text
[RTL] Loading firmware from assembler/firmware.hex
[RTL] First instruction: 00200093
[Host] Reset released, SoC running.
[Host] Cycle 20: Injected Command = 10
[Host] Cycle 48: Received Response from SoC = 46
[Host] Math verified correctly! 2*3 + 4*10 = 46
[Host] Simulation completed successfully.
```

### 4. Running the NPU Benchmark (`benchmark.cpp`)

`sim/benchmark.cpp` compares a 4x4 matrix multiply done in software on the pipelined CPU against the same multiply offloaded to the NPU — with **both paths measured from actual RTL execution**, cycle by cycle.

```bash
# Compile and run the benchmark simulation
make bench
```

**Methodology.** Two real assembly programs (`assembler/matmul_cpu_test.s` and `assembler/matmul_npu_test.s`, assembled with the Python assembler) run on the same pipelined CPU RTL under Verilator:

* **CPU path**: a software triple loop. Since this ISA has no `mul` instruction, each `A[i][k] * B[k][j]` product is computed by repeated addition — that is what a matrix multiply honestly costs on this core.
* **NPU path**: copies A and B from data memory into the NPU register bank with real `sw` instructions, writes the start register, polls the status register with `lw`/`beq` until done, and copies the results back. The measured window includes all of that MMIO transfer overhead — no testbench shortcuts or hierarchical register pokes.

Both programs start from the same state (matrices in data memory) and end in the same state (result in data memory). Each brackets its work with a store to the host MMIO port (address 512); the C++ harness counts clock cycles between the two markers, then captures the 16 result values the program streams out and checks them against a golden software model.

**Expected Output:**
```text
===========================================
        NPU vs CPU BENCHMARK RESULTS       
===========================================
[SUCCESS] Both results match the golden model.

Matrix C (from RTL):
   16     8    12    10 
   40    20    28    34 
   64    32    44    58 
   88    44    60    82 

Measured RTL clock cycles (4x4 matmul, data in DMEM to result in DMEM):
-------------------------------------------
 Path                    | Cycles          
-------------------------------------------
 CPU (software loops)    |     1784
 NPU (MMIO offload)      |      453
-------------------------------------------
 NPU Speedup             | 3.94x
===========================================
```

Note that the NPU's raw compute is only 10 cycles (`3N-2` for N=4); the 453-cycle offload time is dominated by moving 32 operands and 16 results across the one-word-per-instruction memory-mapped interface. That data-movement bottleneck is itself a realistic result — it is why real accelerators use DMA engines and wide buses rather than programmed I/O.

### 5. Running the Test Suite

All testbenches are self-checking (golden-model comparisons, PASS/FAIL per element) and run under Verilator `--binary --timing` with warnings treated as errors:

```bash
make test           # run everything below
make test_single    # single-cycle core (same program as the pipeline TB)
make test_param     # NPU at 2x2/4x4/8x8, signed int8, plus 30 randomized matrix pairs
make test_npu       # CPU-driven NPU matmul via assembler-generated program
make test_cpu_e2e   # pipeline hazard torture test from cpu_test.s
make test_npu_e2e   # NPU MMIO flow from npu_test.s
make test_jump      # jal/jalr function calls on BOTH cores side by side
make lint           # strict lint over all RTL (no waivers)
```

### 6. Python Assembler

This repository includes a custom, modular RV32I assembler written in Python that can convert `.s` assembly files into a `.hex` file to be loaded into the Verilog instruction memory using `$readmemh()`.

```bash
# Run the assembler on the test file
python assembler/assembler.py assembler/test.s output.hex
```

The assembler handles:
* **Standard instructions**: `add, sub, and, or, addi, lw, sw, beq, jal, jalr`
* **Pseudoinstructions**: `nop`
* **Label resolution**: Forward and backward branches (e.g. `loop:`, `beq x1, x2, loop`)
* **Standard registers and ABIs**: `x0-x31`, `zero`, `sp`, `a0`, `t0`, etc.

## Roadmap

- [x] Single-cycle RV32I processor
- [x] 5-stage pipeline with forwarding
- [x] Hazard detection (load-use stalling)
- [x] Branch flushing (assume not taken)
- [x] Systolic array NPU (memory-mapped)
- [x] Python assembler
- [x] Host/SoC MMIO integration via C++ testbench
- [x] Jumps (`jal`/`jalr` — function calls and returns)
- [x] Parameterized systolic array (ARRAY_SIZE) with signed int8 MACs
- [x] Randomized self-checking NPU verification (golden-model reference)
- [x] Lint-clean build (`verilator --lint-only`, warnings fatal)
- [ ] Extended ISA support (shifts, comparisons)
- [x] Full neural network evaluation workload (benchmarked)

## Tools

- **HDL**: Verilog (IEEE 1364-2005)
- **Simulator**: Verilator 5+ (C++ model)
- **ISA**: RISC-V RV32I (subset)
