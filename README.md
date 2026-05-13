# RISC-V Core — From Single-Cycle to Pipelined Processor

A learning-oriented RISC-V RV32I processor implementation in Verilog, built from scratch to understand CPU microarchitecture and AI hardware design.

## What Is This?

This project implements a **RISC-V RV32I processor** in two stages of increasing complexity:

1. **Single-cycle** — one instruction per clock cycle, simplest possible datapath
2. **5-stage pipelined** — overlapping execution with hazard detection, data forwarding, and branch flushing

The long-term goal is to integrate a **systolic array NPU** (neural processing unit) as a memory-mapped accelerator attached to the CPU, combining classical CPU design with AI hardware.

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

## Directory Structure

```
├── rtl/
│   ├── common/          # Shared modules (ALU, RegFile, Control, memories, muxes)
│   ├── single_cycle/    # Single-cycle top module (placeholder — to be restored)
│   ├── pipeline/        # Pipeline registers, forwarding unit, hazard detection, top module
│   └── npu/             # Systolic array NPU (planned)
├── tb/                  # Testbenches
├── assembler/           # Python RISC-V assembler (planned)
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

## Roadmap

- [x] Single-cycle RV32I processor
- [x] 5-stage pipeline with forwarding
- [x] Hazard detection (load-use stalling)
- [x] Branch flushing (assume not taken)
- [ ] Systolic array NPU (memory-mapped)
- [ ] Python assembler
- [ ] Extended ISA support (shifts, comparisons, jumps)

## Tools

- **HDL**: Verilog (IEEE 1364-2005)
- **Simulator**: Questa / ModelSim
- **ISA**: RISC-V RV32I (subset)
