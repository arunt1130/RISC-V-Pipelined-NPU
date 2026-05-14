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

### Supported Instructions

| Type | Instructions |
|------|-------------|
| **R-type** | `add`, `sub`, `and`, `or` |
| **I-type** | `addi`, `lw` |
| **S-type** | `sw` |
| **SB-type** | `beq` |

### Systolic Array NPU

The NPU is a memory-mapped AI accelerator integrated into the CPU's memory stage. At its core is a **4×4 grid of MAC (Multiply-Accumulate) units**. 

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
│   ├── single_cycle/    # Single-cycle top module (placeholder — to be restored)
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
| `rtl/pipeline/pipeline_top.v` | Top-level pipelined processor |
| `rtl/pipeline/forwarding_unit.v` | Data hazard forwarding logic |
| `rtl/pipeline/hazard_detection_unit.v` | Load-use stall detection |
| `rtl/common/alu.v` | 32-bit ALU (add, sub, and, or) |
| `rtl/common/control_unit.v` | Main control decoder |
| `rtl/common/reg_file.v` | 32x32 register file (x0 hardwired to 0) |
| `tb/tb_pipeline_top.v` | Deprecated Verilog testbench |
| `sim/sim_main.cpp` | **Verilator C++ simulation harness and Host interface** |

## SoC Verification Guide (CPU + NPU + Host)

This guide walks through the end-to-end verification flow for testing the pipelined CPU and the memory-mapped Systolic Array NPU using the Python assembler and our **persistent Verilator C++ environment**.

### 1. C++ Simulation Harness (`sim/sim_main.cpp`)

We use **Verilator** to compile the Verilog RTL into a cycle-accurate C++ model. The `sim_main.cpp` program acts as the Host, driving the clock, injecting payloads into the CPU over Memory-Mapped I/O, and waiting for the hardware to process and return neural network inferences.

I created `assembler/cpu_test.s` which acts as our "torture test" for the pipeline. It is intentionally designed to trigger pipeline stalls, data forwarding, and branch flushing. 

#### What it tests:
* **I-Type & R-Type**: Basic arithmetic (`add`, `sub`, `addi`) and bitwise logic (`and`, `or`).
* **Forwarding Hazards**: Back-to-back dependent registers force the pipeline to forward data from the EX/MEM and MEM/WB stages.
* **Load-Use Hazards**: A `sw` followed by a `lw` and an immediate `add` operation using the loaded value inserts a 1-cycle stall bubble.
* **Control Hazards**: Forward/backward branches test 3-cycle pipeline flushes.

### 2. NPU Integration & Host Polling (`firmware.s`)

The firmware acts as the bridge between the Host software and the NPU hardware.

#### Memory Map Extensions
The NPU is activated when the memory address is >= 256 (Bit 8 is set). We expanded this to include the Host interface:
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

### 3. Running the Simulation

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

### 4. Debugging Strategies

If you write new assembly programs and they fail, follow this hierarchy of debugging:

> [!WARNING]
> Verilator does not automatically capture waveforms like Questa. To debug internally, either add `$display` statements in the Verilog or enable VCD tracing in `sim_main.cpp`.

#### Step 1: Check PC Updating
* Add a `$display` in `instruction_mem.v` to print the PC every cycle. Is it incrementing by 4? 
* If it stalls forever, check the `Hazard_Detection_Unit`'s `stall` signal. Remember that if a branch is taken (`PCSrc_MEM == 1`), it should override and un-stall the PC!

#### Step 2: Check Immediate Generation
Are I-Type instructions generating the correct values? Look at `uut.ImmGen.Imm_out`. If a negative offset (like `-1` in a loop counter) is being misinterpreted as a massive positive number, your Sign Extension logic is broken.

#### Step 3: Check Forwarding
If a math operation yields the wrong result, but the instruction *before* it calculated the right one, the Forwarding Unit is broken.
* Inspect `uut.Forwarding_Unit.ForwardA` and `ForwardB`.
* `00` means it's reading from the register file.
* `10` means it's forwarding from EX/MEM (the instruction immediately preceding).
* `01` means it's forwarding from MEM/WB (the instruction two steps back).

#### Step 4: Check Branch Flushing
If a branch is taken, but the instructions *immediately following it* in the assembly file still execute and corrupt your registers, your flush logic is broken.
* A taken branch sets `uut.PCSrc_MEM = 1`. 
* This should force `IF_Flush`, `ID_Flush`, and `EX_Flush` to 1 on the next clock edge, replacing the instructions in the pipeline with `0x00000000` (NOPs). Verify this happens in the waveform.

### Python Assembler

This repository includes a custom, modular RV32I assembler written in Python that can convert `.s` assembly files into a `.hex` file to be loaded into the Verilog instruction memory using `$readmemh()`.

```bash
# Run the assembler on the test file
python assembler/assembler.py assembler/test.s output.hex
```

The assembler handles:
* **Standard instructions**: `add, sub, and, or, addi, lw, sw, beq`
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
- [ ] Extended ISA support (shifts, comparisons, jumps)
- [ ] Full neural network evaluation workload

## Tools

- **HDL**: Verilog (IEEE 1364-2005)
- **Simulator**: Verilator 5+ (C++ model)
- **ISA**: RISC-V RV32I (subset)
