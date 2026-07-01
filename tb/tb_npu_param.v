// ══════════════════════════════════════════════════════════════
// NPU Parameterization Testbench
//
// Proves the ARRAY_SIZE parameter actually works (not just
// compiles) by instantiating a 2x2 and an 8x8 NPU side by side,
// running a full matrix multiply on each through the memory-mapped
// interface, and checking every result element against a golden
// model computed in the testbench.
//
// Run with:  make test_param   (Verilator --binary --timing)
// ══════════════════════════════════════════════════════════════
module tb_npu_param;

reg clk, reset;

integer pass_count, fail_count;

// ── 2x2 instance ────────────────────────────────────
reg         mw2, mr2;
reg  [7:0]  addr2;
reg  [31:0] wd2;
wire [31:0] rd2;

NPU_Top #(.ARRAY_SIZE(2)) npu2(
    .clk(clk), .reset(reset),
    .mem_write(mw2), .mem_read(mr2),
    .address(addr2), .write_data(wd2), .read_data(rd2)
);

// ── 4x4 instance (default size, used for the signed test) ──
reg         mw4, mr4;
reg  [7:0]  addr4;
reg  [31:0] wd4;
wire [31:0] rd4;

NPU_Top #(.ARRAY_SIZE(4)) npu4(
    .clk(clk), .reset(reset),
    .mem_write(mw4), .mem_read(mr4),
    .address(addr4), .write_data(wd4), .read_data(rd4)
);

// ── 8x8 instance ────────────────────────────────────
reg         mw8, mr8;
reg  [7:0]  addr8;
reg  [31:0] wd8;
wire [31:0] rd8;

NPU_Top #(.ARRAY_SIZE(8)) npu8(
    .clk(clk), .reset(reset),
    .mem_write(mw8), .mem_read(mr8),
    .address(addr8), .write_data(wd8), .read_data(rd8)
);

// ── MMIO helper tasks (one pair per instance) ───────
task write2(input [7:0] a, input [31:0] d); begin
    @(negedge clk); mw2 = 1; addr2 = a; wd2 = d;
    @(negedge clk); mw2 = 0;
end endtask

task read2(input [7:0] a, output [31:0] d); begin
    @(negedge clk); mr2 = 1; addr2 = a;
    @(negedge clk); d = rd2; mr2 = 0;
end endtask

task write4(input [7:0] a, input [31:0] d); begin
    @(negedge clk); mw4 = 1; addr4 = a; wd4 = d;
    @(negedge clk); mw4 = 0;
end endtask

task read4(input [7:0] a, output [31:0] d); begin
    @(negedge clk); mr4 = 1; addr4 = a;
    @(negedge clk); d = rd4; mr4 = 0;
end endtask

task write8(input [7:0] a, input [31:0] d); begin
    @(negedge clk); mw8 = 1; addr8 = a; wd8 = d;
    @(negedge clk); mw8 = 0;
end endtask

task read8(input [7:0] a, output [31:0] d); begin
    @(negedge clk); mr8 = 1; addr8 = a;
    @(negedge clk); d = rd8; mr8 = 0;
end endtask

// ── Test data / golden model storage ────────────────
reg [7:0]  A_m [0:63];
reg [7:0]  B_m [0:63];
reg [31:0] golden [0:63];
reg [31:0] got;
integer i, j, k, n, sum, timeout;
integer t;  // scratch for explicit 8-bit truncations

initial begin
    clk = 0; reset = 1;
    mw2 = 0; mr2 = 0; addr2 = 0; wd2 = 0;
    mw8 = 0; mr8 = 0; addr8 = 0; wd8 = 0;
    pass_count = 0; fail_count = 0;
    #12;
    reset = 0;

    // ════════════════ 2x2 NPU ════════════════
    n = 2;
    $display("");
    $display("== 2x2 NPU (ARRAY_SIZE=2) ======================");
    for (i = 0; i < n; i = i + 1)
        for (j = 0; j < n; j = j + 1) begin
            t = i + 2*j + 1;  A_m[i*n+j] = t[7:0];
            t = 3*i + j + 2;  B_m[i*n+j] = t[7:0];
        end
    for (i = 0; i < n; i = i + 1)
        for (j = 0; j < n; j = j + 1) begin
            sum = 0;
            for (k = 0; k < n; k = k + 1)
                sum = sum + A_m[i*n+k] * B_m[k*n+j];
            golden[i*n+j] = sum;
        end

    // Load A and B over MMIO (A at offset 0, B at offset n*n)
    for (i = 0; i < n*n; i = i + 1) begin
        t = i;        write2(t[7:0], {24'b0, A_m[i]});
        t = i + n*n;  write2(t[7:0], {24'b0, B_m[i]});
    end

    // Start (control register at 3*n*n) and poll status (3*n*n + 1)
    t = 3*n*n;  write2(t[7:0], 32'd1);
    got = 0; timeout = 0;
    while (got[0] !== 1'b1 && timeout < 100) begin
        t = 3*n*n + 1;  read2(t[7:0], got);
        timeout = timeout + 1;
    end
    if (got[0] !== 1'b1) begin
        $display("FAIL | 2x2 NPU never asserted done");
        fail_count = fail_count + 1;
    end

    // Read and check all results (C region at offset 2*n*n)
    for (i = 0; i < n*n; i = i + 1) begin
        t = 2*n*n + i;  read2(t[7:0], got);
        if (got === golden[i]) begin
            $display("PASS | 2x2 C[%0d][%0d] = %0d", i/n, i%n, got);
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL | 2x2 C[%0d][%0d] expected %0d, got %0d",
                     i/n, i%n, golden[i], got);
            fail_count = fail_count + 1;
        end
    end

    // ════════════════ 4x4 NPU — SIGNED int8 ════════════════
    // Negative weights/activations, as in real quantized NN
    // inference. Expected results computed BY HAND (not by the
    // testbench), e.g. C[0][0] = 1*(-2) + (-2)*1 + 3*0 + (-4)*3 = -16.
    $display("");
    $display("== 4x4 NPU signed int8 test ====================");
    begin : signed_test
        reg signed [31:0] golden_s [0:15];
        // A = [[  1, -2,   3,  -4],     B = [[-2,  0,  1, -3],
        //      [ -5,  6,  -7,   8],          [ 1, -1,  0,  2],
        //      [  9,-10,  11, -12],          [ 0,  2, -1,  1],
        //      [-13, 14, -15,  16]]          [ 3,  0, -2,  0]]
        A_m[0]  =  8'sd1;   A_m[1]  = -8'sd2;  A_m[2]  =  8'sd3;   A_m[3]  = -8'sd4;
        A_m[4]  = -8'sd5;   A_m[5]  =  8'sd6;  A_m[6]  = -8'sd7;   A_m[7]  =  8'sd8;
        A_m[8]  =  8'sd9;   A_m[9]  = -8'sd10; A_m[10] =  8'sd11;  A_m[11] = -8'sd12;
        A_m[12] = -8'sd13;  A_m[13] =  8'sd14; A_m[14] = -8'sd15;  A_m[15] =  8'sd16;
        B_m[0]  = -8'sd2;   B_m[1]  =  8'sd0;  B_m[2]  =  8'sd1;   B_m[3]  = -8'sd3;
        B_m[4]  =  8'sd1;   B_m[5]  = -8'sd1;  B_m[6]  =  8'sd0;   B_m[7]  =  8'sd2;
        B_m[8]  =  8'sd0;   B_m[9]  =  8'sd2;  B_m[10] = -8'sd1;   B_m[11] =  8'sd1;
        B_m[12] =  8'sd3;   B_m[13] =  8'sd0;  B_m[14] = -8'sd2;   B_m[15] =  8'sd0;
        // Hand-verified C = A x B:
        golden_s[0]  = -32'sd16; golden_s[1]  =  32'sd8;   golden_s[2]  =  32'sd6;   golden_s[3]  = -32'sd4;
        golden_s[4]  =  32'sd40; golden_s[5]  = -32'sd20;  golden_s[6]  = -32'sd14;  golden_s[7]  =  32'sd20;
        golden_s[8]  = -32'sd64; golden_s[9]  =  32'sd32;  golden_s[10] =  32'sd22;  golden_s[11] = -32'sd36;
        golden_s[12] =  32'sd88; golden_s[13] = -32'sd44;  golden_s[14] = -32'sd30;  golden_s[15] =  32'sd52;

        for (i = 0; i < 16; i = i + 1) begin
            write4(i[7:0],      {24'b0, A_m[i]});
            write4(i[7:0] + 16, {24'b0, B_m[i]});
        end

        write4(8'd48, 32'd1);           // start
        got = 0; timeout = 0;
        while (got[0] !== 1'b1 && timeout < 100) begin
            read4(8'd49, got);          // status
            timeout = timeout + 1;
        end
        if (got[0] !== 1'b1) begin
            $display("FAIL | 4x4 signed NPU never asserted done");
            fail_count = fail_count + 1;
        end

        for (i = 0; i < 16; i = i + 1) begin
            read4(8'd32 + i[7:0], got);
            if ($signed(got) === golden_s[i]) begin
                $display("PASS | signed C[%0d][%0d] = %0d", i/4, i%4, $signed(got));
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL | signed C[%0d][%0d] expected %0d, got %0d",
                         i/4, i%4, golden_s[i], $signed(got));
                fail_count = fail_count + 1;
            end
        end
    end

    // ════════════════ 8x8 NPU ════════════════
    n = 8;
    $display("");
    $display("== 8x8 NPU (ARRAY_SIZE=8) ======================");
    for (i = 0; i < n; i = i + 1)
        for (j = 0; j < n; j = j + 1) begin
            t = (i + 2*j + 1) % 13;  A_m[i*n+j] = t[7:0];
            t = (3*i + j + 2) % 11;  B_m[i*n+j] = t[7:0];
        end
    for (i = 0; i < n; i = i + 1)
        for (j = 0; j < n; j = j + 1) begin
            sum = 0;
            for (k = 0; k < n; k = k + 1)
                sum = sum + A_m[i*n+k] * B_m[k*n+j];
            golden[i*n+j] = sum;
        end

    for (i = 0; i < n*n; i = i + 1) begin
        t = i;        write8(t[7:0], {24'b0, A_m[i]});
        t = i + n*n;  write8(t[7:0], {24'b0, B_m[i]});
    end

    t = 3*n*n;  write8(t[7:0], 32'd1);
    got = 0; timeout = 0;
    while (got[0] !== 1'b1 && timeout < 100) begin
        t = 3*n*n + 1;  read8(t[7:0], got);
        timeout = timeout + 1;
    end
    if (got[0] !== 1'b1) begin
        $display("FAIL | 8x8 NPU never asserted done");
        fail_count = fail_count + 1;
    end

    for (i = 0; i < n*n; i = i + 1) begin
        t = 2*n*n + i;  read8(t[7:0], got);
        if (got === golden[i]) begin
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL | 8x8 C[%0d][%0d] expected %0d, got %0d",
                     i/n, i%n, golden[i], got);
            fail_count = fail_count + 1;
        end
    end
    $display("8x8: all 64 elements checked");

    // ════════════════ 4x4 NPU — RANDOMIZED (30 cases) ════════════════
    // Random signed int8 matrices (full -128..127 range), golden
    // reference computed in the testbench, every element self-checked.
    $display("");
    $display("== 4x4 NPU randomized signed tests (30 cases) ==");
    begin : random_test
        integer test_num, errors;
        reg [31:0] exp;
        for (test_num = 0; test_num < 30; test_num = test_num + 1) begin
            // Generate a random signed matrix pair
            for (i = 0; i < 16; i = i + 1) begin
                t = $random;  A_m[i] = t[7:0];
                t = $random;  B_m[i] = t[7:0];
            end
            // Golden reference (signed arithmetic)
            for (i = 0; i < 4; i = i + 1)
                for (j = 0; j < 4; j = j + 1) begin
                    sum = 0;
                    for (k = 0; k < 4; k = k + 1)
                        sum = sum + $signed(A_m[i*4+k]) * $signed(B_m[k*4+j]);
                    golden[i*4+j] = sum;
                end

            // Load, start, poll, read back — all via MMIO
            for (i = 0; i < 16; i = i + 1) begin
                write4(i[7:0],      {24'b0, A_m[i]});
                write4(i[7:0] + 16, {24'b0, B_m[i]});
            end
            write4(8'd48, 32'd1);
            got = 0; timeout = 0;
            while (got[0] !== 1'b1 && timeout < 100) begin
                read4(8'd49, got);
                timeout = timeout + 1;
            end

            errors = 0;
            for (i = 0; i < 16; i = i + 1) begin
                read4(8'd32 + i[7:0], got);
                if (got === golden[i]) begin
                    pass_count = pass_count + 1;
                end else begin
                    $display("FAIL | case %0d C[%0d][%0d] expected %0d, got %0d",
                             test_num, i/4, i%4, $signed(golden[i]), $signed(got));
                    fail_count = fail_count + 1;
                    errors = errors + 1;
                end
            end
            if (errors == 0)
                $display("PASS | random case %0d (16/16 elements)", test_num);
        end
    end

    // ════════════════ Summary ════════════════
    $display("");
    $display("================================================");
    $display("Results: %0d PASS, %0d FAIL", pass_count, fail_count);
    if (fail_count == 0)
        $display("ALL TESTS PASSED");
    else
        $display("TEST FAILED");
    $display("================================================");
    $finish;
end

always begin
    #5 clk = ~clk;
end

endmodule
