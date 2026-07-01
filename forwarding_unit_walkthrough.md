# Forwarding Unit Deep Walkthrough

## Start Here: What Even Is a Pipeline?

Before diving into the code, you need to understand the problem the forwarding unit is solving.

A 5-stage pipeline means every instruction spends 5 clock cycles getting processed. Rather than waiting for instruction 1 to fully finish before starting instruction 2, the CPU overlaps them — like an assembly line at a factory. While instruction 1 is in stage 2, instruction 2 is already in stage 1, instruction 3 is about to enter, and so on.

The 5 stages in this processor:

```
Cycle →     1       2       3       4       5
Instr 1:   [IF]   [ID]    [EX]   [MEM]   [WB]
Instr 2:          [IF]    [ID]    [EX]   [MEM]
Instr 3:                  [IF]    [ID]    [EX]
```

- **IF** = Instruction Fetch (grab the instruction from memory)
- **ID** = Instruction Decode (figure out what it does, read registers)
- **EX** = Execute (run it through the ALU — add, subtract, etc.)
- **MEM** = Memory (read or write data memory if needed)
- **WB** = Writeback (write the result back into the register file)

Here's the problem: **a register is only updated at the very end, in WB.** But by the time WB runs, the next instruction has already read the register in its ID stage and gotten the **old, stale value.**

---

## The Data Hazard Problem

Imagine this code:

```assembly
add x1, x2, x3   # x1 = x2 + x3
sub x4, x1, x5   # x4 = x1 - x5  <-- needs the NEW x1!
```

Without any fix, this is what the pipeline does:

```
Cycle →      1     2     3     4     5     6
add x1:     [IF]  [ID]  [EX]  [MEM] [WB]
sub x4:           [IF]  [ID]  [EX]  [MEM] [WB]
                         ↑
                  sub reads x1 HERE (Cycle 3, ID stage)
                  But add doesn't write x1 until Cycle 5 (WB)!
```

`sub` reads `x1` in cycle 3, but `add` doesn't update `x1` in the register file until cycle 5. `sub` gets the wrong value — whatever `x1` was *before* `add` ran.

**The forwarding unit is the fix.** Instead of waiting for the register file to be updated, it detects this conflict and directly reroutes the computed result from wherever it is in the pipeline right now into the ALU input that needs it.

---

## The Forwarding Unit File

The entire module lives in [forwarding_unit.v](file:///c:/Users/ArunT/OneDrive/Desktop/RISC-V%20Core/rtl/pipeline/forwarding_unit.v).

It is a **purely combinational** module — no clock, no memory, no state. Every cycle, it looks at a snapshot of what's in the pipeline and immediately outputs the correct mux select signals. It reacts instantly.

---

## Inputs and Outputs (The Module Ports)

```verilog
module Forwarding_Unit(
    input [4:0] RS1_EX, RS2_EX,
    input [4:0] RD_MEM, RD_WB,
    input       RegWrite_MEM, RegWrite_WB,
    output reg [1:0] ForwardA, ForwardB
);
```

→ [Lines 20–25](file:///c:/Users/ArunT/OneDrive/Desktop/RISC-V%20Core/rtl/pipeline/forwarding_unit.v#L20-L25)

Let's break down every signal:

| Signal | Direction | What It Is |
|---|---|---|
| `RS1_EX` | Input | The **first source register** the instruction in EX wants to read. e.g. for `sub x4, x1, x5`, this is `x1`. |
| `RS2_EX` | Input | The **second source register** the instruction in EX wants to read. e.g. for `sub x4, x1, x5`, this is `x5`. |
| `RD_MEM` | Input | The **destination register** of whatever instruction is currently sitting in the MEM stage. e.g. if `add x1, x2, x3` is in MEM, this is `x1`. |
| `RD_WB` | Input | The **destination register** of whatever instruction is currently sitting in the WB stage. |
| `RegWrite_MEM` | Input | A 1-bit flag: does the instruction in MEM actually write to a register? (A `sw` store doesn't — it just saves data to memory.) |
| `RegWrite_WB` | Input | Same flag but for the WB stage. |
| `ForwardA` | Output | 2-bit mux select for **ALU Input A** (controls which value RS1_EX actually gets). |
| `ForwardB` | Output | 2-bit mux select for **ALU Input B** (controls which value RS2_EX actually gets). |

The `ForwardA` and `ForwardB` outputs go directly into 3-to-1 multiplexers sitting right before the ALU. The encoding means:
- `2'b00` → Use the value from the register file (no hazard, everything is fine)
- `2'b10` → Skip the register file, grab the value directly from the MEM stage pipeline register
- `2'b01` → Skip the register file, grab the value directly from the WB stage

---

## ForwardA Logic — Line by Line

```verilog
always @(*) begin
    // ── ForwardA (ALU input A) ──
    if (RegWrite_MEM && RD_MEM != 5'b0 && RD_MEM == RS1_EX)
        ForwardA = 2'b10;   // forward from MEM
    else if (RegWrite_WB && RD_WB != 5'b0 && RD_WB == RS1_EX)
        ForwardA = 2'b01;   // forward from WB
    else
        ForwardA = 2'b00;   // no forwarding
```

→ [Lines 27–34](file:///c:/Users/ArunT/OneDrive/Desktop/RISC-V%20Core/rtl/pipeline/forwarding_unit.v#L27-L34)

The `always @(*)` just means: "re-evaluate this logic every time any input changes." This is standard combinational Verilog.

### Condition 1: Check EX/MEM Forwarding

```verilog
if (RegWrite_MEM && RD_MEM != 5'b0 && RD_MEM == RS1_EX)
```

→ [Line 29](file:///c:/Users/ArunT/OneDrive/Desktop/RISC-V%20Core/rtl/pipeline/forwarding_unit.v#L29)

This is three conditions all joined with `&&`, meaning **all three must be true** to forward from MEM. Think of it as three safety checks:

**Check 1: `RegWrite_MEM`**

Does the instruction in MEM even produce a result that goes into a register? If it's a `sw` (store word), the answer is no — it writes to *memory*, not to a *register*. If we skipped this check and `sw` was in MEM, we might accidentally forward whatever garbage value is floating on the `ALU_result_MEM` wire into the ALU. This gate prevents that.

**Check 2: `RD_MEM != 5'b0`**

Is the destination register something other than `x0`? In RISC-V, `x0` is special — it is permanently hardwired to the value 0 and **can never be changed**. An instruction like `add x0, x1, x2` looks like it writes to `x0`, but the hardware ignores the write. Any instruction that reads `x0` always gets `0`, not whatever `add` computed. If we didn't check this, a previous instruction writing to `x0` could accidentally forward its result to someone reading `x0`, giving them a non-zero value when they should always get 0.

**Check 3: `RD_MEM == RS1_EX`**

Is the register the MEM instruction is writing to (`RD_MEM`) the same register the EX instruction is trying to read (`RS1_EX`)? This is the actual hazard detection. If `add x1, x2, x3` is in MEM and `sub x4, x1, x5` is in EX, then `RD_MEM == x1` and `RS1_EX == x1`, so this matches.

**All three true → `ForwardA = 2'b10`**: Route the ALU input A mux to pick `ALU_result_MEM` — the result computed by the instruction in MEM — instead of the register file value.

### Condition 2: Check MEM/WB Forwarding

```verilog
else if (RegWrite_WB && RD_WB != 5'b0 && RD_WB == RS1_EX)
```

→ [Line 31](file:///c:/Users/ArunT/OneDrive/Desktop/RISC-V%20Core/rtl/pipeline/forwarding_unit.v#L31)

This is the *exact same three-check pattern*, but now looking at the WB stage instead of MEM. This catches the case where there's a **2-cycle gap** between the producer and consumer:

```assembly
add x1, x2, x3   # Produces x1
nop               # Filler instruction (1-cycle gap)
sub x4, x1, x5   # Consumes x1 — add is now in WB, not MEM
```

Notice this is `else if`, not a second `if`. The `else` means this check only runs if the first MEM check *failed*. That ordering is what establishes **priority**.

**All three true → `ForwardA = 2'b01`**: Route ALU input A to use `WriteBack_WB` — the value about to be written into the register file.

### Condition 3: Default — No Forwarding

```verilog
else
    ForwardA = 2'b00;   // no forwarding
```

→ [Lines 33–34](file:///c:/Users/ArunT/OneDrive/Desktop/RISC-V%20Core/rtl/pipeline/forwarding_unit.v#L33-L34)

If neither MEM nor WB has a matching destination, there's no hazard. The register file already has the correct, up-to-date value, so the ALU reads it normally.

---

## ForwardB Logic — Same Thing, Different Register

```verilog
    // ── ForwardB (ALU input B / store data) ──
    if (RegWrite_MEM && RD_MEM != 5'b0 && RD_MEM == RS2_EX)
        ForwardB = 2'b10;   // forward from MEM
    else if (RegWrite_WB && RD_WB != 5'b0 && RD_WB == RS2_EX)
        ForwardB = 2'b01;   // forward from WB
    else
        ForwardB = 2'b00;   // no forwarding
```

→ [Lines 36–42](file:///c:/Users/ArunT/OneDrive/Desktop/RISC-V%20Core/rtl/pipeline/forwarding_unit.v#L36-L42)

Identical logic, just checking `RS2_EX` (the second source register) instead of `RS1_EX`. An instruction can have hazards on both its inputs simultaneously, so both `ForwardA` and `ForwardB` are evaluated independently every cycle.

---

## Why EX/MEM Must Have Priority Over MEM/WB

This is the most subtle and important design decision in the entire module.

Consider this sequence:

```assembly
addi x1, x0, 10   # Instruction A: x1 = 10
addi x1, x0, 20   # Instruction B: x1 = 20  (overwrites x1!)
add  x2, x1, x1   # Instruction C: x2 = x1 + x1  (needs x1 = 20)
```

When Instruction C is in the EX stage:

```
Instr A:  [WB]               <- RD_WB  = x1, value = 10
Instr B:  [MEM]              <- RD_MEM = x1, value = 20
Instr C:  [EX]               <- RS1_EX = x1, needs correct value
```

- `RD_WB == x1` (Instruction A, the older write, is in WB)
- `RD_MEM == x1` (Instruction B, the newer write, is in MEM)
- Both match `RS1_EX == x1`

Both forwarding conditions fire! But only one can win. The correct answer is `x1 = 20`, which is in the **MEM stage** (Instruction B). Instruction B is more recent in program order — it happened after A and overwrote x1.

**If MEM/WB had priority instead:**
The unit would forward `x1 = 10` from Instruction A in WB. Let's make the bug obvious:

```assembly
addi x1, x0, 10   # x1 = 10
addi x1, x0, 99   # x1 = 99
add  x2, x1, x0   # should get x2 = 99, but wrong priority gives x2 = 10
```

With flipped priority, `ForwardA` would output `2'b01` (WB), routing `x1 = 10` into the ALU. `x2` becomes `10`. That is a **silent, catastrophic bug** — the CPU computes the wrong answer without any error signal.

The `if` / `else if` structure in [lines 29 and 31](file:///c:/Users/ArunT/OneDrive/Desktop/RISC-V%20Core/rtl/pipeline/forwarding_unit.v#L29-L31) guarantees that if MEM matches, WB is never even evaluated. This is not optional — **it is structurally required for correct execution.**

---

## Concrete Assembly Traces

### Trace 1: EX/MEM Forwarding Triggered (1-instruction gap)

```assembly
add x1, x2, x3   # Produces x1
sub x4, x1, x5   # Consumes x1 immediately
```

Step through the pipeline:

| Cycle | EX | MEM | WB | ForwardA |
|---|---|---|---|---|
| 3 | add | — | — | `2'b00` (nothing to forward yet) |
| 4 | **sub** | **add** | — | `2'b10` ← EX/MEM fires! |

At **Cycle 4**:
- `add x1, x2, x3` is in **MEM**. Its ALU result (`x2 + x3`) sits in the `EX/MEM` pipeline register, on the wire `ALU_result_MEM`.
- `sub x4, x1, x5` is in **EX**. It needs `x1`.
- Forwarding Unit evaluates [line 29](file:///c:/Users/ArunT/OneDrive/Desktop/RISC-V%20Core/rtl/pipeline/forwarding_unit.v#L29):
  - `RegWrite_MEM = 1` ✅ (`add` writes to a register)
  - `RD_MEM = x1` ≠ `x0` ✅
  - `RD_MEM (x1) == RS1_EX (x1)` ✅
- **Result:** `ForwardA = 2'b10`
- The mux in front of ALU Input A selects `ALU_result_MEM`, bypassing the stale register file. The ALU computes the correct subtraction.

### Trace 2: MEM/WB Forwarding Triggered (2-instruction gap)

```assembly
add x1, x2, x3   # Produces x1
and x8, x9, x10  # Unrelated (filler)
sub x4, x1, x5   # Consumes x1 — two cycles later
```

| Cycle | EX | MEM | WB | ForwardA |
|---|---|---|---|---|
| 3 | add | — | — | `2'b00` |
| 4 | and | add | — | `2'b00` (and doesn't read x1) |
| 5 | **sub** | **and** | **add** | `2'b01` ← MEM/WB fires! |

At **Cycle 5**:
- `add x1, x2, x3` is in **WB**. Its result is on the `WriteBack_WB` wire.
- `and x8, x9, x10` is in **MEM**. `RD_MEM = x8`, not `x1`.
- `sub x4, x1, x5` is in **EX**. It needs `x1`.
- Forwarding Unit evaluates [line 29](file:///c:/Users/ArunT/OneDrive/Desktop/RISC-V%20Core/rtl/pipeline/forwarding_unit.v#L29) first: `RD_MEM = x8 ≠ x1`. ❌ Skipped.
- Falls to [line 31](file:///c:/Users/ArunT/OneDrive/Desktop/RISC-V%20Core/rtl/pipeline/forwarding_unit.v#L31): `RegWrite_WB = 1` ✅, `RD_WB = x1` ✅, `RD_WB == RS1_EX` ✅
- **Result:** `ForwardA = 2'b01`
- The mux selects `WriteBack_WB`, routing the result of `add` from the WB stage directly into the ALU — one cycle before it would have landed in the register file.

> [!NOTE]
> This is why Trace 2 doesn't need a stall bubble. Even though `add` hasn't written to the register file yet, forwarding from WB provides the value in time. No wasted cycles.

---

## Summary Table

| Scenario | Gap | Forward Signal | Source Wire |
|---|---|---|---|
| Producer in MEM, consumer in EX | 1 instruction | `ForwardA/B = 2'b10` | `ALU_result_MEM` |
| Producer in WB, consumer in EX | 2 instructions | `ForwardA/B = 2'b01` | `WriteBack_WB` |
| No hazard | 3+ instructions | `ForwardA/B = 2'b00` | Register file output |
| Both MEM and WB match (overwrite case) | — | `ForwardA/B = 2'b10` | MEM always wins (most recent write) |
