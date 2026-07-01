// ══════════════════════════════════════════════════════════════
// jal/jalr Testbench — runs assembler/jump_test.hex on BOTH cores
//
// The same assembler-generated program (function calls via jal,
// returns via jalr, a plain jal x0 jump) runs on the pipelined
// core and the single-cycle core side by side. Both must reach
// the identical architectural state.
//
// Run with:  make test_jump   (Verilator --binary --timing)
// ══════════════════════════════════════════════════════════════
module tb_jump;

reg clk, reset;

// ── Pipelined core ──
wire [31:0] host_tx_data;
wire        host_tx_valid;
top pipe(
    .clk(clk), .reset(reset),
    .host_tx_data(host_tx_data),
    .host_tx_valid(host_tx_valid),
    .host_rx_data(32'b0)
);

// ── Single-cycle core ──
Single_Cycle_Top sc(.clk(clk), .reset(reset));

integer pass_count, fail_count;

initial begin
    clk = 0;
    reset = 1;
    pass_count = 0;
    fail_count = 0;
    #10;
    reset = 0;
    #2;

    $readmemh("assembler/jump_test.hex", pipe.Inst_Memory.I_Mem);
    $readmemh("assembler/jump_test.hex", sc.Inst_Memory.I_Mem);

    // 12 executed instructions; the pipeline pays 3 cycles per
    // taken jump/branch — 200 cycles is far more than enough for
    // both cores to park in the end loop.
    repeat(200) @(posedge clk);
    #1;

    $display("");
    $display("== JAL/JALR — PIPELINED CORE ===================");
    check(pipe.Reg_File.Registers[1],  32'd16, "pipe x1  (link)");
    check(pipe.Reg_File.Registers[10], 32'd20, "pipe x10 (5*2*2)");
    check(pipe.Reg_File.Registers[11], 32'd11, "pipe x11 (10+1)");
    check(pipe.Reg_File.Registers[12], 32'd22, "pipe x12 (20+2)");
    check(pipe.Reg_File.Registers[13], 32'd0,  "pipe x13 (skipped)");
    check(pipe.Reg_File.Registers[14], 32'd7,  "pipe x14 (landed)");

    $display("");
    $display("== JAL/JALR — SINGLE-CYCLE CORE ================");
    check(sc.Reg_File.Registers[1],  32'd16, "sc x1  (link)");
    check(sc.Reg_File.Registers[10], 32'd20, "sc x10 (5*2*2)");
    check(sc.Reg_File.Registers[11], 32'd11, "sc x11 (10+1)");
    check(sc.Reg_File.Registers[12], 32'd22, "sc x12 (20+2)");
    check(sc.Reg_File.Registers[13], 32'd0,  "sc x13 (skipped)");
    check(sc.Reg_File.Registers[14], 32'd7,  "sc x14 (landed)");

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
    input [143:0] label;
    begin
        if (actual === expected) begin
            $display("PASS | %-18s | got %0d", label, actual);
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL | %-18s | expected %0d | got %0d",
                      label, expected, actual);
            fail_count = fail_count + 1;
        end
    end
endtask

always begin
    #5 clk = ~clk;
end

endmodule
