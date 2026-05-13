# RISC-V Core — CPU Pipeline + AI Accelerator

A learning-oriented RISC-V RV32I processor implementation in Verilog, built from scratch to understand CPU microarchitecture and the intersection of classical CPU design with modern AI hardware.

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
| `tb/tb_pipeline_top.v` | Self-checking testbench for the pipeline |

## Simulation (Questa / ModelSim)

### Compile all source files

```bash
vlog rtl/common/*.v rtl/pipeline/*.v tb/tb_pipeline_top.v
```

### Run the testbench

```bash
vsim -c tb_top -do "run -all; quit"
```

### Interactive simulation (with waveforms)

```bash
vsim tb_top
add wave -r /*
run -all
```

### Expected output

```
══ GROUP 1: FORWARDING TESTS ═══════════════════
PASS | FWD: add x7=x1+x2   | got 15
PASS | FWD: sub x8=x7-x3   | got 0
PASS | FWD: and x9=x7&x4   | got 4
PASS | FWD: or x11=x8|x5   | got 3
PASS | FWD: add x12=x1+x1  | got 10

══ GROUP 2: LOAD-USE HAZARD TEST ═════════════════
PASS | LU: lw x13=Mem[4]   | got 42
PASS | LU: add x14=x13+x1  | got 47
PASS | LU: add x15=x14+x2  | got 57

══ GROUP 3: BRANCH TEST ═════════════════════════
PASS | BR: add x16=x5+x6   | got 10
PASS | BR: x17 flushed=0    | got 0
PASS | BR: x18 flushed=0    | got 0
PASS | BR: add x19=x3+x4   | got 35

══════════════════════════════════════════════════
Results: 12 PASS, 0 FAIL
══════════════════════════════════════════════════
```

### NPU Integration Test

To test the Systolic Array NPU and the memory-mapped CPU interface, run the NPU testbench:

```bash
# Compile
vlog rtl/common/*.v rtl/pipeline/*.v rtl/npu/*.v tb/tb_npu_integration.v

# Run command-line simulation
vsim -c tb_npu_integration -do "run -all; quit"

# Run interactive GUI simulation
vsim tb_npu_integration
add wave -r /*
run -all
```

**Expected NPU Output:**

```
══ TEST 1: NPU ISOLATION (Direct Access) ═════════
  Checking all 16 result elements...
  PASS | C[0][0] = 1
  ...
  PASS | C[3][3] = 64

══ TEST 2: CPU-DRIVEN FLOW (sw/lw) ═══════════════
  PASS | CPU: NPU status=done   | got 1
  PASS | CPU: C[0][0]=1*5=5     | got 5

══════════════════════════════════════════════════
Results: 18 PASS, 0 FAIL
══════════════════════════════════════════════════
```

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
- [ ] Extended ISA support (shifts, comparisons, jumps)

## Tools

- **HDL**: Verilog (IEEE 1364-2005)
- **Simulator**: Questa / ModelSim
- **ISA**: RISC-V RV32I (subset)
