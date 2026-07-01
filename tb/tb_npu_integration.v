// ══════════════════════════════════════════════════════════════
// NPU Integration Testbench — CPU-driven, assembler-generated
//
// Runs assembler/matmul_npu_test.hex (built from matmul_npu_test.s
// by the Python assembler — no hand-encoded instruction bits) on
// the full pipelined CPU:
//
//   1. The program initializes A and B in data memory
//   2. Copies both matrices into the NPU register bank via sw
//   3. Starts the NPU via the control register
//   4. Polls the status register via lw/beq until done
//   5. Copies all 16 results back into data memory
//   6. Streams the 16 C values out through the host MMIO port
//
// The testbench captures the streamed values (skipping the two
// benchmark phase markers) and checks them against the
// hand-verifiable golden result. It also checks the copy of C
// left in data memory. Every NPU access goes through real sw/lw
// instructions — no hierarchical shortcuts drive the design.
//
//   A = [[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]]
//   B = [[2,0,1,3],[1,1,0,2],[0,2,1,1],[3,0,2,0]]
//   C = [[16,8,12,10],[40,20,28,34],[64,32,44,58],[88,44,60,82]]
//
// Run with:  make test_npu   (Verilator --binary --timing)
// ══════════════════════════════════════════════════════════════
module tb_npu_integration;

reg clk, reset;
wire [31:0] host_tx_data;
wire        host_tx_valid;

top uut(
    .clk(clk), .reset(reset),
    .host_tx_data(host_tx_data),
    .host_tx_valid(host_tx_valid),
    .host_rx_data(32'b0)
);

integer pass_count, fail_count;
integer i, tx_events, cycles;

// Golden result C = A x B (hand-verified)
reg [31:0] golden [0:15];
// Streamed values captured from the host port
reg [31:0] streamed [0:15];

initial begin
    golden[0]  = 32'd16; golden[1]  = 32'd8;  golden[2]  = 32'd12; golden[3]  = 32'd10;
    golden[4]  = 32'd40; golden[5]  = 32'd20; golden[6]  = 32'd28; golden[7]  = 32'd34;
    golden[8]  = 32'd64; golden[9]  = 32'd32; golden[10] = 32'd44; golden[11] = 32'd58;
    golden[12] = 32'd88; golden[13] = 32'd44; golden[14] = 32'd60; golden[15] = 32'd82;
end

initial begin
    clk = 0;
    reset = 1;
    pass_count = 0;
    fail_count = 0;
    tx_events = 0;
    #10;
    reset = 0;

    // Load the assembler-generated program (after reset so nothing
    // clears it)
    #2;
    $readmemh("assembler/matmul_npu_test.hex", uut.Inst_Memory.I_Mem);

    $display("");
    $display("== NPU INTEGRATION (CPU-driven, assembled hex) ==");

    // Run until the program has streamed all 16 results:
    // 2 marker stores + 16 value stores = 18 TX events.
    cycles = 0;
    while (tx_events < 18 && cycles < 5000) begin
        @(posedge clk);
        #1;
        if (host_tx_valid) begin
            if (tx_events >= 2)
                streamed[tx_events - 2] = host_tx_data;
            tx_events = tx_events + 1;
        end
        cycles = cycles + 1;
    end

    if (tx_events < 18) begin
        $display("FAIL | timeout: only %0d/18 host TX events after %0d cycles",
                 tx_events, cycles);
        fail_count = fail_count + 1;
    end

    // ── Check the streamed results ──────────────────────
    for (i = 0; i < 16; i = i + 1) begin
        if (streamed[i] === golden[i]) begin
            $display("PASS | streamed C[%0d][%0d] = %0d", i/4, i%4, streamed[i]);
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL | streamed C[%0d][%0d] expected %0d, got %0d",
                     i/4, i%4, golden[i], streamed[i]);
            fail_count = fail_count + 1;
        end
    end

    // ── Check the copy written back to data memory ──────
    for (i = 0; i < 16; i = i + 1) begin
        if (uut.Data_mem.D_Memory[32 + i] === golden[i]) begin
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL | DMEM[%0d] expected %0d, got %0d",
                     32 + i, golden[i], uut.Data_mem.D_Memory[32 + i]);
            fail_count = fail_count + 1;
        end
    end
    $display("DMEM copy of C checked (16 elements)");

    $display("==================================================");
    $display("Results: %0d PASS, %0d FAIL", pass_count, fail_count);
    if (fail_count == 0)
        $display("ALL TESTS PASSED");
    else
        $display("TEST FAILED");
    $display("==================================================");
    $finish;
end

always begin
    #5 clk = ~clk;
end

endmodule
