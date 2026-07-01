# Walkthrough: Pipeline Steps 2.5 & 3

> **Note:** This is a historical development log. The monolithic `Single_cycle.v` it references has since been split into `rtl/common/`, `rtl/pipeline/`, and `rtl/single_cycle/`.

## Changes Made

### 1. Added `fun7` and `fun3` to ID/EX Pipeline Register

**File:** `Single_cycle.v`

**What:** Added two new port pairs to `ID_EX_Reg`:
- `fun7_in` / `fun7_out` (1-bit) — carries `instruction[30]`
- `fun3_in` / `fun3_out` (3-bit) — carries `instruction[14:12]`

**Why:** In the single-cycle design, the ALU Control reads `fun7` and `fun3` directly from the instruction wire. In the pipeline, the instruction wire belongs to whatever is currently in Fetch — by the time we reach Execute, the instruction is gone. So these fields are extracted in Decode and latched through ID/EX.

---

### 2. Rewrote `top` Module — Single-Cycle → Pipelined

**What:** Replaced the flat single-cycle `top` module (39 lines) with a fully pipelined version (~310 lines) organized into 5 stages with 4 pipeline registers between them.

**Wire naming convention:**
| Suffix | Stage | Example |
|--------|-------|---------|
| `_IF` | Fetch | `PC_IF`, `instruction_IF`, `PCplus4_IF` |
| `_ID` | Decode | `PC_ID`, `RD1_ID`, `fun7_ID`, `ALUSrc_ID` |
| `_EX` | Execute | `ALU_result_EX`, `fun7_EX`, `BranchTarget_EX` |
| `_MEM` | Memory | `ALU_result_MEM`, `MemData_MEM`, `PCSrc_MEM` |
| `_WB` | Writeback | `WriteBack_WB`, `RegWrite_WB`, `RD_WB` |

**Key architectural changes from single-cycle:**

1. **Register file write port** now driven from WB stage (`RegWrite_WB`, `RD_WB`, `WriteBack_WB`)
2. **ALU Control** reads `fun7` / `fun3` from ID/EX register outputs, not from instruction wire
3. **Branch decision** happens in MEM stage (branch AND zero → PCSrc_MEM)
4. **Hazard controls** all tied to `0` for now (stall, flush_IFID, flush_IDEX, flush_EXMEM)

**Testbench fix:** `uut.PC_top` → `uut.PC_IF` (line 872)

---

## What Was NOT Changed

- All functional unit modules (ALU, ALU_Control, Reg_File, Instruction_Mem, Data_Memory, ImmGen, Control_Unit, muxes, adder, AND gate)
- All four pipeline register modules (IF_ID, ID_EX, EX_MEM, MEM_WB)
- Testbench logic (will need rework in Step 4 for pipeline timing)

---

## Next: Step 4 — Get Pipeline Working Without Hazard Handling

The testbench still uses single-cycle timing (expects results one cycle after instruction). In the pipeline, results don't appear until the instruction reaches Writeback (4 cycles after fetch). Step 4 will:

1. Write a new testbench with **independent instructions** (no register dependencies between consecutive instructions)
2. Account for **pipeline fill latency** — wait 4 extra cycles for the first instruction to reach WB
3. Verify each instruction produces the correct result at the correct time
4. Confirm the pipeline fills and drains correctly
