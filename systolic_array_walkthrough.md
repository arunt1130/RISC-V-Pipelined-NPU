# Walkthrough: Systolic Array NPU & Memory-Mapped Interface

Hello! I have fully implemented and committed the Verilog code for the 4x4 Systolic Array NPU and integrated it with your RISC-V pipeline. 

As requested, here is a **thorough explanation** of exactly what was built, how the systolic array achieves its massive performance boost, and how the CPU interacts with it.

---

## 1. The Processing Element: The MAC Unit

At the very heart of the NPU (and AI accelerators like Google's TPU) is the **Multiply-Accumulate (MAC) Unit**. 
In standard CPU architectures, a multiplication followed by an addition takes multiple clock cycles, reads from registers, and writes back to registers. 

Our MAC unit (`rtl/npu/mac_unit.v`) is much simpler and specialized:
* It takes two 8-bit inputs: an activation `a_in` (from the left) and a weight `b_in` (from above).
* Every clock cycle, it computes `(a_in * b_in)` and adds it to an internal 32-bit `acc` (accumulator).
* Crucially, it **passes its inputs to its neighbors**: `a_out` goes to the right, `b_out` goes down.

## 2. The 4x4 Systolic Array: Data Like a Heartbeat

"Systole" is a medical term for the contraction of the heart that pumps blood. In a **Systolic Array** (`rtl/npu/systolic_array.v`), data is pumped through a grid of MAC units rhythmically, one step per clock cycle.

### Why is this faster than a CPU?
A traditional CPU executing `C = A x B` for a 4x4 matrix would need to do 64 separate multiplications and 48 additions, loading and storing registers constantly. This creates a severe memory bottleneck (the "von Neumann bottleneck").

In our 4x4 systolic array, we have **16 MAC units working in parallel**. Once the pipeline is full, it performs 16 multiplications and 16 additions *simultaneously per clock cycle* without needing to read/write from a central memory or register file. Data simply flows from one unit to the next.

### Skewed Data Entry (The "Wave")
To make a systolic array compute a matrix multiplication `C = A x B`, the data must arrive at the exact right time. 
If we feed all rows of `A` from the left and columns of `B` from the top simultaneously, the values would mismatch. For example, `A[0][1]` shouldn't meet `B[1][0]` in cell `(0,0)`.

Instead, the `npu_top.v` controller feeds the data in a **skewed (staggered)** format:
* Row 0 of `A` goes in immediately.
* Row 1 of `A` is delayed by 1 cycle.
* Row 2 of `A` is delayed by 2 cycles, and so on.
* Columns of `B` are staggered the same way from the top.

```text
Cycle 0: Only PE(0,0) receives valid A and B data and computes.
Cycle 1: The data from PE(0,0) flows right and down. PE(0,1) and PE(1,0) compute.
Cycle 2: PE(0,2), PE(1,1), PE(2,0) compute. (A diagonal wave of computation!)
...
Cycle 6: The wave reaches the bottom right. PE(3,3) computes its final value.
```
In just **7 clock cycles**, the 16 PEs complete the entire 4x4 matrix multiplication. A traditional simple CPU would take well over 200 cycles!

## 3. The Memory-Mapped CPU Interface

We needed a way for our RISC-V CPU to talk to this NPU without inventing new instructions. We used **Memory-Mapping**. 
We modified the MEM stage of the pipeline (`pipeline_top.v`) to decode the memory address:
* Address `0 to 63`: Normal Data Memory.
* Address `256 to 305`: Routed to the NPU. (Specifically, if bit 8 of the address is `1`, `npu_select` becomes active).

### The NPU Register Map (`npu_top.v`)
* **Offset 0-15 (Addr 256-271):** 16 slots for Matrix A.
* **Offset 16-31 (Addr 272-287):** 16 slots for Matrix B.
* **Offset 32-47 (Addr 288-303):** 16 slots for the Matrix C result (Read-only).
* **Offset 48 (Addr 304):** Control Register. Writing `1` starts the FSM.
* **Offset 49 (Addr 305):** Status Register. Reading it tells you if it's done (`1` = done).

### How the FSM Works
1. **IDLE:** The NPU waits while the CPU uses `sw` (store word) to load the matrix data into `A_reg` and `B_reg`.
2. **CLEAR:** When the CPU writes to Addr 304, the FSM transitions to CLEAR, sending a clear signal to all MAC units to zero their accumulators.
3. **COMPUTE:** For 7 cycles, the controller generates the "skewed" inputs from `A_reg` and `B_reg` and feeds them into the left and top of the systolic array.
4. **DONE:** The computation is finished. The status bit at Addr 305 turns to `1`. The CPU uses `lw` (load word) to read the 32-bit results from Addr 288-303.

## 4. Testing & Verification

I wrote a comprehensive testbench (`tb/tb_npu_integration.v`) that tests this in two ways:
1. **Isolation Test:** We reach directly into the NPU registers via the testbench, load a diagonal matrix `A` and a dense matrix `B`, and trigger the FSM. We wait 9 cycles and read the 16 results.
2. **CPU-Driven Test:** We load actual RISC-V instructions (`addi`, `sw`, `lw`) into the instruction memory to programmatically load data into the NPU, trigger the control register, poll the status register, and load the computed result back into a CPU register.

Both tests pass successfully!

---
Let me know if you have any questions about the data flow or the Verilog implementation, or if you're ready to proceed to the next step of your project!
