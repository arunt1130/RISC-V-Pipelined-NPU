// ══════════════════════════════════════════════════════════════
// Pipeline Testbench — Steps 5–7
// Tests forwarding, load-use stalling, and branch flushing.
//
// PIPELINE TIMING REMINDER:
//   With no hazards, I_Mem[N] writes back at posedge (N+6).
//   Load-use adds 1 stall cycle to all subsequent instructions.
//   Branch taken flushes 3 instructions (3-cycle penalty).
// ══════════════════════════════════════════════════════════════
module tb_top;

reg clk, reset;

top uut(.clk(clk), .reset(reset));

integer pass_count, fail_count;

initial begin
    clk = 0;
    reset = 1;
    pass_count = 0;
    fail_count = 0;
    #10;
    reset = 0;

    // ── Initialize registers ────────────────────────────────
    uut.Reg_File.Registers[0]  = 0;
    uut.Reg_File.Registers[1]  = 5;
    uut.Reg_File.Registers[2]  = 10;
    uut.Reg_File.Registers[3]  = 15;
    uut.Reg_File.Registers[4]  = 20;
    uut.Reg_File.Registers[5]  = 3;
    uut.Reg_File.Registers[6]  = 7;
    uut.Reg_File.Registers[7]  = 0;
    uut.Reg_File.Registers[8]  = 0;
    uut.Reg_File.Registers[9]  = 0;
    uut.Reg_File.Registers[10] = 100;
    uut.Reg_File.Registers[11] = 0;
    uut.Reg_File.Registers[12] = 0;
    uut.Reg_File.Registers[13] = 0;
    uut.Reg_File.Registers[14] = 0;
    uut.Reg_File.Registers[15] = 0;
    uut.Reg_File.Registers[16] = 0;
    uut.Reg_File.Registers[17] = 0;
    uut.Reg_File.Registers[18] = 0;
    uut.Reg_File.Registers[19] = 0;
    uut.Reg_File.Registers[20] = 0;

    // ══════════════════════════════════════════════════════════
    // TEST GROUP 1: FORWARDING (Steps 5)
    // Back-to-back dependent instructions — forwarding resolves
    // the hazard without any stalls.
    //
    // I[0]: NOP
    // I[1]: add  x7,  x1,  x2    → 5+10=15     → x7=15
    // I[2]: sub  x8,  x7,  x3    → 15-15=0     → x8=0  (forward x7 from MEM)
    // I[3]: and  x9,  x7,  x4    → 15 & 20=4   → x9=4  (forward x7 from WB)
    // I[4]: or   x11, x8,  x5    → 0 | 3=3     → x11=3 (forward x8 from WB)
    // I[5]: add  x12, x1,  x1    → 5+5=10      → x12=10 (independent)
    //
    // === TEST GROUP 2: LOAD-USE HAZARD (Step 6) ===
    // I[6]: lw   x13, 4(x0)      → D_Mem[4]=42 → x13=42
    // I[7]: add  x14, x13, x1    → 42+5=47     → x14=47 (STALL 1 cycle, then forward)
    // I[8]: add  x15, x14, x2    → 47+10=57    → x15=57 (forward x14 from MEM)
    //
    // === TEST GROUP 3: BRANCH (Step 7) ===
    // I[9]:  add  x16, x5, x6    → 3+7=10      → x16=10
    // I[10]: beq  x5, x5, 12     → branch taken (x5==x5), jump to I[13]
    // I[11]: add  x17, x1, x1    → SHOULD BE FLUSHED (10 if not)
    // I[12]: add  x18, x2, x2    → SHOULD BE FLUSHED (20 if not)
    // I[13]: add  x19, x3, x4    → 15+20=35    → x19=35 (branch target)
    // ══════════════════════════════════════════════════════════

    // ── Group 1: Forwarding tests ───────────────────────────
    uut.Inst_Memory.I_Mem[0]  = 32'h00000000;                                // NOP
    uut.Inst_Memory.I_Mem[1]  = 32'b0000000_00010_00001_000_00111_0110011;    // add x7, x1, x2
    uut.Inst_Memory.I_Mem[2]  = 32'b0100000_00011_00111_000_01000_0110011;    // sub x8, x7, x3
    uut.Inst_Memory.I_Mem[3]  = 32'b0000000_00100_00111_111_01001_0110011;    // and x9, x7, x4
    uut.Inst_Memory.I_Mem[4]  = 32'b0000000_00101_01000_110_01011_0110011;    // or  x11, x8, x5
    uut.Inst_Memory.I_Mem[5]  = 32'b0000000_00001_00001_000_01100_0110011;    // add x12, x1, x1

    // ── Group 2: Load-use test ──────────────────────────────
    uut.Inst_Memory.I_Mem[6]  = 32'b000000000100_00000_010_01101_0000011;     // lw  x13, 4(x0)
    uut.Inst_Memory.I_Mem[7]  = 32'b0000000_00001_01101_000_01110_0110011;    // add x14, x13, x1
    uut.Inst_Memory.I_Mem[8]  = 32'b0000000_00010_01110_000_01111_0110011;    // add x15, x14, x2

    // ── Group 3: Branch test ────────────────────────────────
    uut.Inst_Memory.I_Mem[9]  = 32'b0000000_00110_00101_000_10000_0110011;    // add x16, x5, x6
    uut.Inst_Memory.I_Mem[10] = 32'b0000000_00101_00101_000_01100_1100011;    // beq x5, x5, 12
    uut.Inst_Memory.I_Mem[11] = 32'b0000000_00001_00001_000_10001_0110011;    // add x17, x1, x1 (FLUSHED)
    uut.Inst_Memory.I_Mem[12] = 32'b0000000_00010_00010_000_10010_0110011;    // add x18, x2, x2 (FLUSHED)
    uut.Inst_Memory.I_Mem[13] = 32'b0000000_00100_00011_000_10011_0110011;    // add x19, x3, x4

    // Pre-load data memory for load test
    // lw x13, 4(x0): address = 0+4 = 4 → D_Memory[4] = 42
    uut.Data_mem.D_Memory[4] = 32'd42;

    // ══════════════════════════════════════════════════════════
    // GROUP 1: FORWARDING TESTS
    // No stalls — pipeline runs at full speed
    // I_Mem[1] writes back at posedge 6
    // ══════════════════════════════════════════════════════════
    $display("");
    $display("══ GROUP 1: FORWARDING TESTS ═══════════════════");

    repeat(5) @(posedge clk);  // pipeline fills (NOP through)
    #1;

    @(posedge clk); #1;  // I[1] WB: add x7, x1, x2 → 5+10=15
    check(uut.Reg_File.Registers[7], 32'd15, "FWD: add x7=x1+x2");

    @(posedge clk); #1;  // I[2] WB: sub x8, x7, x3 → 15-15=0 (x7 forwarded from MEM)
    check(uut.Reg_File.Registers[8], 32'd0,  "FWD: sub x8=x7-x3");

    @(posedge clk); #1;  // I[3] WB: and x9, x7, x4 → 15&20=4 (x7 forwarded from WB)
    check(uut.Reg_File.Registers[9], 32'd4,  "FWD: and x9=x7&x4");

    @(posedge clk); #1;  // I[4] WB: or x11, x8, x5 → 0|3=3 (x8 forwarded from WB)
    check(uut.Reg_File.Registers[11], 32'd3, "FWD: or x11=x8|x5");

    @(posedge clk); #1;  // I[5] WB: add x12, x1, x1 → 5+5=10
    check(uut.Reg_File.Registers[12], 32'd10, "FWD: add x12=x1+x1");

    // ══════════════════════════════════════════════════════════
    // GROUP 2: LOAD-USE HAZARD TEST
    // I[6] is a LW. I[7] reads x13 (the loaded value).
    // The hazard unit inserts 1 stall cycle.
    // So I[7]'s WB is delayed by 1 cycle.
    // ══════════════════════════════════════════════════════════
    $display("");
    $display("══ GROUP 2: LOAD-USE HAZARD TEST ═════════════════");

    @(posedge clk); #1;  // I[6] WB: lw x13, 4(x0) → D_Mem[4]=42
    check(uut.Reg_File.Registers[13], 32'd42, "LU: lw x13=Mem[4]");

    // I[7] had a 1-cycle stall, so it arrives 1 cycle later than normal
    @(posedge clk); #1;  // stall bubble passes through
    @(posedge clk); #1;  // I[7] WB: add x14, x13, x1 → 42+5=47
    check(uut.Reg_File.Registers[14], 32'd47, "LU: add x14=x13+x1");

    @(posedge clk); #1;  // I[8] WB: add x15, x14, x2 → 47+10=57
    check(uut.Reg_File.Registers[15], 32'd57, "LU: add x15=x14+x2");

    // ══════════════════════════════════════════════════════════
    // GROUP 3: BRANCH TEST
    // I[10] is beq x5,x5,12 — branch taken.
    // I[11] and I[12] should be flushed (x17 and x18 stay 0).
    // I[13] is the branch target (add x19).
    // Branch penalty is 3 cycles (flush IF/ID, ID/EX, EX/MEM).
    // ══════════════════════════════════════════════════════════
    $display("");
    $display("══ GROUP 3: BRANCH TEST ═════════════════════════");

    @(posedge clk); #1;  // I[9] WB: add x16, x5, x6 → 3+7=10
    check(uut.Reg_File.Registers[16], 32'd10, "BR: add x16=x5+x6");

    // I[10] (beq) goes through pipeline — when it reaches MEM,
    // PCSrc_MEM=1, flushing I[11], I[12], and whatever is in EX/MEM.
    // The branch target I[13] gets fetched after the flush.
    // We need to wait for the flushed bubbles + I[13] to reach WB.

    // Wait for branch to resolve and flushed instructions to pass
    repeat(4) @(posedge clk); #1;

    // Verify flushed instructions did NOT write
    check(uut.Reg_File.Registers[17], 32'd0, "BR: x17 flushed=0");
    check(uut.Reg_File.Registers[18], 32'd0, "BR: x18 flushed=0");

    // Wait for branch target instruction to write back
    repeat(3) @(posedge clk); #1;
    check(uut.Reg_File.Registers[19], 32'd35, "BR: add x19=x3+x4");

    // ══════════════════════════════════════════════════════════
    $display("");
    $display("══════════════════════════════════════════════════");
    $display("Results: %0d PASS, %0d FAIL", pass_count, fail_count);
    $display("══════════════════════════════════════════════════");
    $stop;
end

// Self-checking task — prints PASS or FAIL for each test
task check;
    input [31:0] actual;
    input [31:0] expected;
    input [63:0] label;
    begin
        if (actual === expected) begin
            $display("PASS | %-20s | got %0d", label, actual);
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL | %-20s | expected %0d | got %0d", 
                      label, expected, actual);
            fail_count = fail_count + 1;
        end
    end
endtask

always begin
    #5 clk = ~clk;
end

endmodule
