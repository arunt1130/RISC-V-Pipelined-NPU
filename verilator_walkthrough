# Verilator Simulation Environment Transition

We have successfully migrated your RISC-V SoC to a persistent, cycle-accurate C++ simulation environment using Verilator. The simulation allows an external Host program (written in C++) to communicate bidirectionally with the Verilog SoC through Memory-Mapped I/O (MMIO).

## What Was Accomplished

### 1. Hardware-Host MMIO Integration
- Mapped Address `512` (Bit 9) to the Host Interface.
- Refactored `pipeline_top.v`'s memory data multiplexer to support `host_rx_data` alongside Data Memory and NPU data.
- Added `host_tx_data` and `host_tx_valid` outputs driven by the `MemWrite` signal targeting address 512.

### 2. Dynamic Firmware Loading
- Refactored `Instruction_Mem.v` to use an `initial` block instead of an asynchronous reset to prevent the firmware from being wiped upon startup.
- Utilized Verilog's `$value$plusargs` feature to dynamically pass firmware from the Verilator execution command (`+firmware=assembler/firmware.hex`).

### 3. C++ Simulation Harness
- Wrote `sim/sim_main.cpp` to drive the clock, inject test data over the Host interface, and poll for `host_tx_valid` to read responses.
- Developed a non-blocking request-response architecture allowing the Verilog firmware to independently poll the host for tasks, offload them to the NPU, and push the results back.

### 4. Critical Pipeline Bug Fix
During verification, the simulation unexpectedly timed out. We performed a deep-dive trace analysis and uncovered an extremely subtle edge-case bug in the 5-stage pipeline architecture:

> [!WARNING]
> **The Branch-Hazard Collision Bug**
> 
> **Scenario:** A taken branch evaluates in the MEM stage (asserting `PCSrc_MEM = 1`). At the exact same time, a speculative instruction in the ID/EX boundary triggers a load-use hazard stall (asserting `stall = 1`).
> 
> **Result:** The Hazard Detection Unit (HDU) would stall the Program Counter (setting `write_enable = 0`). Because the PC was frozen, the branch target jump (`PCSrc_MEM = 1`) was completely ignored and lost! The pipeline would eventually un-stall and continue fetching wrong-path instructions as if the branch had never occurred.

**The Fix:**
We updated `pipeline_top.v` to mask the hazard stall when a branch is taken. Since a taken branch flushes the speculative instructions causing the hazard anyway, we defined a new `actual_stall` wire:
```verilog
wire actual_stall = stall_hazard & ~PCSrc_MEM;
```
This forces the Program Counter and IF/ID registers to update to the branch target, overriding the phantom hazard.

## Final Verification Result
After resolving the bug, the entire end-to-end flow passed perfectly:

```
[RTL] Loading firmware from assembler/firmware.hex
[RTL] First instruction: 00200093
[Host] Reset released, SoC running.
[Host] Cycle 20: Injected Command = 10
[Host] Cycle 48: Received Response from SoC = 46
[Host] Math verified correctly! 2*3 + 4*10 = 46
[Host] Simulation completed successfully.
```

The system is now fully prepared to run continuous neural-network evaluation workloads!
