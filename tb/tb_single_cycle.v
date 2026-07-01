// ══════════════════════════════════════════════════════════════
// Single-Cycle Testbench
//
// Runs the same instruction sequence as tb_pipeline_top.v on the
// single-cycle core. Since there is no pipelining there are no
// hazards — back-to-back dependent instructions and branches just
// work, and the final architectural state must match what the
// pipelined core produces for the same program.
//
// Run with:  make test_single   (Verilator --binary --timing)
// ══════════════════════════════════════════════════════════════
module tb_single_cycle;

reg clk, reset;

Single_Cycle_Top uut(.clk(clk), .reset(reset));

integer pass_count, fail_count;

initial begin
    clk = 0;
    reset = 1;
    pass_count = 0;
    fail_count = 0;
    #10;
    reset = 0;

    // ── Initialize registers ────────────────────────────────
    uut.Reg_File.Registers[1]  = 5;
    uut.Reg_File.Registers[2]  = 10;
    uut.Reg_File.Registers[3]  = 15;
    uut.Reg_File.Registers[4]  = 20;
    uut.Reg_File.Registers[5]  = 3;
    uut.Reg_File.Registers[6]  = 7;

    // ── Program (identical to tb_pipeline_top.v) ────────────
    // I[0]:  NOP
    // I[1]:  add x7,  x1, x2   → 5+10 = 15
    // I[2]:  sub x8,  x7, x3   → 15-15 = 0   (back-to-back dep)
    // I[3]:  and x9,  x7, x4   → 15&20 = 4
    // I[4]:  or  x11, x8, x5   → 0|3  = 3
    // I[5]:  add x12, x1, x1   → 5+5  = 10
    // I[6]:  lw  x13, 4(x0)    → D_Mem[4] = 42
    // I[7]:  add x14, x13, x1  → 42+5 = 47   (use right after load)
    // I[8]:  add x15, x14, x2  → 47+10 = 57
    // I[9]:  add x16, x5, x6   → 3+7  = 10
    // I[10]: beq x5, x5, 12    → taken, skips I[11] and I[12]
    // I[11]: add x17, x1, x1   → never executes (x17 stays 0)
    // I[12]: add x18, x2, x2   → never executes (x18 stays 0)
    // I[13]: add x19, x3, x4   → 15+20 = 35  (branch target)
    uut.Inst_Memory.I_Mem[0]  = 32'h00000000;
    uut.Inst_Memory.I_Mem[1]  = 32'b0000000_00010_00001_000_00111_0110011;
    uut.Inst_Memory.I_Mem[2]  = 32'b0100000_00011_00111_000_01000_0110011;
    uut.Inst_Memory.I_Mem[3]  = 32'b0000000_00100_00111_111_01001_0110011;
    uut.Inst_Memory.I_Mem[4]  = 32'b0000000_00101_01000_110_01011_0110011;
    uut.Inst_Memory.I_Mem[5]  = 32'b0000000_00001_00001_000_01100_0110011;
    uut.Inst_Memory.I_Mem[6]  = 32'b000000000100_00000_010_01101_0000011;
    uut.Inst_Memory.I_Mem[7]  = 32'b0000000_00001_01101_000_01110_0110011;
    uut.Inst_Memory.I_Mem[8]  = 32'b0000000_00010_01110_000_01111_0110011;
    uut.Inst_Memory.I_Mem[9]  = 32'b0000000_00110_00101_000_10000_0110011;
    uut.Inst_Memory.I_Mem[10] = 32'b0000000_00101_00101_000_01100_1100011;
    uut.Inst_Memory.I_Mem[11] = 32'b0000000_00001_00001_000_10001_0110011;
    uut.Inst_Memory.I_Mem[12] = 32'b0000000_00010_00010_000_10010_0110011;
    uut.Inst_Memory.I_Mem[13] = 32'b0000000_00100_00011_000_10011_0110011;

    // Data for the load test
    uut.Data_mem.D_Memory[4] = 32'd42;

    // One instruction per cycle, 13 executed instructions
    // (I[11], I[12] are skipped) — 20 cycles is plenty.
    repeat(20) @(posedge clk);
    #1;

    $display("");
    $display("== SINGLE-CYCLE CORE TESTS =====================");
    check(uut.Reg_File.Registers[7],  32'd15, "add x7=x1+x2");
    check(uut.Reg_File.Registers[8],  32'd0,  "sub x8=x7-x3");
    check(uut.Reg_File.Registers[9],  32'd4,  "and x9=x7&x4");
    check(uut.Reg_File.Registers[11], 32'd3,  "or  x11=x8|x5");
    check(uut.Reg_File.Registers[12], 32'd10, "add x12=x1+x1");
    check(uut.Reg_File.Registers[13], 32'd42, "lw  x13=Mem[4]");
    check(uut.Reg_File.Registers[14], 32'd47, "add x14=x13+x1");
    check(uut.Reg_File.Registers[15], 32'd57, "add x15=x14+x2");
    check(uut.Reg_File.Registers[16], 32'd10, "add x16=x5+x6");
    check(uut.Reg_File.Registers[17], 32'd0,  "beq skipped x17");
    check(uut.Reg_File.Registers[18], 32'd0,  "beq skipped x18");
    check(uut.Reg_File.Registers[19], 32'd35, "add x19=x3+x4");

    $display("================================================");
    $display("Results: %0d PASS, %0d FAIL", pass_count, fail_count);
    if (fail_count == 0)
        $display("ALL TESTS PASSED");
    else
        $display("TEST FAILED");
    $display("================================================");
    $finish;
end

task check;
    input [31:0] actual;
    input [31:0] expected;
    input [127:0] label;
    begin
        if (actual === expected) begin
            $display("PASS | %-16s | got %0d", label, actual);
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL | %-16s | expected %0d | got %0d",
                      label, expected, actual);
            fail_count = fail_count + 1;
        end
    end
endtask

always begin
    #5 clk = ~clk;
end

endmodule
