// ══════════════════════════════════════════════════════════════
// NPU Integration Testbench
//
// Tests the systolic array NPU connected to the RISC-V pipeline.
//
// TEST 1 — NPU Isolation (direct register writes):
//   Writes matrices A and B directly into the NPU register bank,
//   triggers computation, waits for done, reads all 16 results.
//
// TEST 2 — CPU-Driven (via sw/lw instructions):
//   Uses RISC-V instructions to write matrix data, start the NPU,
//   poll the status register, and read results back.
//
// Test matrices:
//   A (diagonal):          B:                    C = A × B:
//   ┌─────────────┐   ┌─────────────┐   ┌──────────────────┐
//   │ 1  0  0  0  │   │ 1  2  3  4  │   │  1   2   3   4   │
//   │ 0  2  0  0  │ × │ 5  6  7  8  │ = │ 10  12  14  16   │
//   │ 0  0  3  0  │   │ 9 10 11 12  │   │ 27  30  33  36   │
//   │ 0  0  0  4  │   │13 14 15 16  │   │ 52  56  60  64   │
//   └─────────────┘   └─────────────┘   └──────────────────┘
// ══════════════════════════════════════════════════════════════
module tb_npu_integration;

reg clk, reset;

top uut(.clk(clk), .reset(reset));

integer pass_count, fail_count;
integer i;

// Expected results: C = A × B (hand-calculated)
// C[0] = {1,  2,  3,  4}
// C[1] = {10, 12, 14, 16}
// C[2] = {27, 30, 33, 36}
// C[3] = {52, 56, 60, 64}
reg [31:0] expected [0:15];

initial begin
    // Expected C matrix (row-major)
    expected[0]  = 32'd1;   expected[1]  = 32'd2;
    expected[2]  = 32'd3;   expected[3]  = 32'd4;
    expected[4]  = 32'd10;  expected[5]  = 32'd12;
    expected[6]  = 32'd14;  expected[7]  = 32'd16;
    expected[8]  = 32'd27;  expected[9]  = 32'd30;
    expected[10] = 32'd33;  expected[11] = 32'd36;
    expected[12] = 32'd52;  expected[13] = 32'd56;
    expected[14] = 32'd60;  expected[15] = 32'd64;
end

initial begin
    clk = 0;
    reset = 1;
    pass_count = 0;
    fail_count = 0;
    #10;
    reset = 0;
    #5;

    // ══════════════════════════════════════════════════════════
    // TEST 1: NPU ISOLATION — Direct Register Bank Access
    // Bypass the CPU pipeline entirely. Write matrices directly
    // into the NPU, trigger computation, verify results.
    // ══════════════════════════════════════════════════════════
    $display("");
    $display("══ TEST 1: NPU ISOLATION (Direct Access) ═════════");

    // ── Write Matrix A (diagonal: 1,2,3,4) ──────────────
    // A[0][0]=1, A[1][1]=2, A[2][2]=3, A[3][3]=4, rest=0
    for (i = 0; i < 16; i = i + 1)
        uut.npu.A_reg[i] = 8'd0;
    uut.npu.A_reg[0]  = 8'd1;   // A[0][0]
    uut.npu.A_reg[5]  = 8'd2;   // A[1][1]
    uut.npu.A_reg[10] = 8'd3;   // A[2][2]
    uut.npu.A_reg[15] = 8'd4;   // A[3][3]

    // ── Write Matrix B ──────────────────────────────────
    // B = [[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]]
    uut.npu.B_reg[0]  = 8'd1;   uut.npu.B_reg[1]  = 8'd2;
    uut.npu.B_reg[2]  = 8'd3;   uut.npu.B_reg[3]  = 8'd4;
    uut.npu.B_reg[4]  = 8'd5;   uut.npu.B_reg[5]  = 8'd6;
    uut.npu.B_reg[6]  = 8'd7;   uut.npu.B_reg[7]  = 8'd8;
    uut.npu.B_reg[8]  = 8'd9;   uut.npu.B_reg[9]  = 8'd10;
    uut.npu.B_reg[10] = 8'd11;  uut.npu.B_reg[11] = 8'd12;
    uut.npu.B_reg[12] = 8'd13;  uut.npu.B_reg[13] = 8'd14;
    uut.npu.B_reg[14] = 8'd15;  uut.npu.B_reg[15] = 8'd16;

    // ── Trigger computation by forcing FSM ──────────────
    // Simulate what happens when the CPU writes 1 to control
    // register: force the FSM into CLEAR state
    @(posedge clk);
    uut.npu.state = 2'b01;  // CLEAR
    uut.npu.cycle_count = 3'b0;

    // Wait for CLEAR (1 cycle) + COMPUTE (7 cycles) + 1 margin
    repeat(10) @(posedge clk);
    #1;

    // ── Verify results ──────────────────────────────────
    // Read each PE's accumulator via the systolic array result mux
    $display("  Checking all 16 result elements...");
    for (i = 0; i < 16; i = i + 1) begin
        // Drive result_sel and read result_out
        // We read directly from the systolic array through the NPU
        check_npu_result(i, expected[i]);
    end

    // ══════════════════════════════════════════════════════════
    // TEST 2: CPU-DRIVEN FLOW — Memory-Mapped Access
    // Use actual RISC-V sw/lw instructions to write to the NPU,
    // start computation, poll status, and read results.
    //
    // We test a simpler case: write a few A and B values via sw,
    // trigger start via sw, verify done via lw, read one result.
    //
    // Re-initialize everything for a fresh test.
    // ══════════════════════════════════════════════════════════
    $display("");
    $display("══ TEST 2: CPU-DRIVEN FLOW (sw/lw) ═══════════════");

    // Reset the processor
    reset = 1;
    #10;
    reset = 0;

    // Initialize registers for CPU test
    // x1 will hold matrix values, x2 will hold status
    uut.Reg_File.Registers[0]  = 32'd0;
    uut.Reg_File.Registers[1]  = 32'd0;   // scratch
    uut.Reg_File.Registers[2]  = 32'd0;   // status readback
    uut.Reg_File.Registers[3]  = 32'd1;   // constant 1 (for A[0][0] and start)
    uut.Reg_File.Registers[4]  = 32'd2;   // constant 2 (for B values)
    uut.Reg_File.Registers[5]  = 32'd3;   // constant 3
    uut.Reg_File.Registers[6]  = 32'd0;   // result readback
    uut.Reg_File.Registers[7]  = 32'd0;

    // Simple test: A = identity first row (1,0,0,0; rest 0)
    // B[0][0] = 5, rest of B = 0
    // C[0][0] should = 1*5 = 5

    // Pre-clear NPU registers (since we only write a few via CPU)
    for (i = 0; i < 16; i = i + 1) begin
        uut.npu.A_reg[i] = 8'd0;
        uut.npu.B_reg[i] = 8'd0;
    end

    // Program:
    // I[0]: addi x1, x0, 1        → x1 = 1 (value for A[0][0])
    // I[1]: sw   x1, 256(x0)      → NPU A[0][0] = 1
    // I[2]: addi x1, x0, 5        → x1 = 5 (value for B[0][0])
    // I[3]: sw   x1, 272(x0)      → NPU B[0][0] = 5
    // I[4]: addi x1, x0, 1        → x1 = 1 (start signal)
    // I[5]: sw   x1, 304(x0)      → NPU control = 1 (START!)
    // I[6]: NOP (let NPU compute — 9 cycles: CLEAR + 7 COMPUTE + margin)
    // I[7]-I[15]: NOPs (wait for NPU)
    // I[16]: lw  x2, 305(x0)      → read NPU status (done)
    // I[17]: lw  x6, 288(x0)      → read NPU C[0][0]

    // addi x1, x0, 1 → I-type: imm=1, rs1=x0, funct3=000, rd=x1, opcode=0010011
    uut.Inst_Memory.I_Mem[0]  = 32'b000000000001_00000_000_00001_0010011;
    // sw x1, 256(x0) → S-type: imm=256=0x100=12'b000100000000
    // imm[11:5]=0001000, rs2=x1=00001, rs1=x0=00000, funct3=010, imm[4:0]=00000
    uut.Inst_Memory.I_Mem[1]  = 32'b0001000_00001_00000_010_00000_0100011;
    // addi x1, x0, 5
    uut.Inst_Memory.I_Mem[2]  = 32'b000000000101_00000_000_00001_0010011;
    // sw x1, 272(x0) → imm=272=0x110=12'b000100010000
    // imm[11:5]=0001000, imm[4:0]=10000
    uut.Inst_Memory.I_Mem[3]  = 32'b0001000_00001_00000_010_10000_0100011;
    // addi x1, x0, 1
    uut.Inst_Memory.I_Mem[4]  = 32'b000000000001_00000_000_00001_0010011;
    // sw x1, 304(x0) → imm=304=0x130=12'b000100110000
    // imm[11:5]=0001001, imm[4:0]=10000
    uut.Inst_Memory.I_Mem[5]  = 32'b0001001_00001_00000_010_10000_0100011;
    // NOPs to wait for NPU computation
    uut.Inst_Memory.I_Mem[6]  = 32'h00000000;
    uut.Inst_Memory.I_Mem[7]  = 32'h00000000;
    uut.Inst_Memory.I_Mem[8]  = 32'h00000000;
    uut.Inst_Memory.I_Mem[9]  = 32'h00000000;
    uut.Inst_Memory.I_Mem[10] = 32'h00000000;
    uut.Inst_Memory.I_Mem[11] = 32'h00000000;
    uut.Inst_Memory.I_Mem[12] = 32'h00000000;
    uut.Inst_Memory.I_Mem[13] = 32'h00000000;
    uut.Inst_Memory.I_Mem[14] = 32'h00000000;
    uut.Inst_Memory.I_Mem[15] = 32'h00000000;
    // lw x2, 305(x0) → I-type load: imm=305=0x131=12'b000100110001
    // imm=000100110001, rs1=x0=00000, funct3=010, rd=x2=00010
    uut.Inst_Memory.I_Mem[16] = 32'b000100110001_00000_010_00010_0000011;
    // lw x6, 288(x0) → imm=288=0x120=12'b000100100000
    uut.Inst_Memory.I_Mem[17] = 32'b000100100000_00000_010_00110_0000011;
    // NOP padding
    uut.Inst_Memory.I_Mem[18] = 32'h00000000;

    // Run the pipeline long enough for all instructions + NPU computation
    // 18 instructions × ~6 cycles each + NPU time = ~120 cycles is plenty
    repeat(120) @(posedge clk);
    #1;

    // Check: x2 should have status = 1 (done)
    check(uut.Reg_File.Registers[2], 32'd1, "CPU: NPU status=done");

    // Check: x6 should have C[0][0] = 1*5 = 5
    check(uut.Reg_File.Registers[6], 32'd5, "CPU: C[0][0]=1*5=5");

    // ══════════════════════════════════════════════════════════
    $display("");
    $display("══════════════════════════════════════════════════");
    $display("Results: %0d PASS, %0d FAIL", pass_count, fail_count);
    $display("══════════════════════════════════════════════════");
    $stop;
end

// ── Helper task: read NPU result via hierarchical access ──
task check_npu_result;
    input integer idx;
    input [31:0] exp;
    reg [31:0] actual;
    begin
        // Directly read the PE accumulator through the systolic array
        case (idx)
            0:  actual = uut.npu.sa.pe_0_0.acc;
            1:  actual = uut.npu.sa.pe_0_1.acc;
            2:  actual = uut.npu.sa.pe_0_2.acc;
            3:  actual = uut.npu.sa.pe_0_3.acc;
            4:  actual = uut.npu.sa.pe_1_0.acc;
            5:  actual = uut.npu.sa.pe_1_1.acc;
            6:  actual = uut.npu.sa.pe_1_2.acc;
            7:  actual = uut.npu.sa.pe_1_3.acc;
            8:  actual = uut.npu.sa.pe_2_0.acc;
            9:  actual = uut.npu.sa.pe_2_1.acc;
            10: actual = uut.npu.sa.pe_2_2.acc;
            11: actual = uut.npu.sa.pe_2_3.acc;
            12: actual = uut.npu.sa.pe_3_0.acc;
            13: actual = uut.npu.sa.pe_3_1.acc;
            14: actual = uut.npu.sa.pe_3_2.acc;
            15: actual = uut.npu.sa.pe_3_3.acc;
            default: actual = 32'hDEADBEEF;
        endcase
        if (actual === exp) begin
            $display("  PASS | C[%0d][%0d] = %0d", idx/4, idx%4, actual);
            pass_count = pass_count + 1;
        end
        else begin
            $display("  FAIL | C[%0d][%0d] expected %0d, got %0d",
                      idx/4, idx%4, exp, actual);
            fail_count = fail_count + 1;
        end
    end
endtask

// ── Standard check task ──
task check;
    input [31:0] actual;
    input [31:0] expected_val;
    input [63:0] label;
    begin
        if (actual === expected_val) begin
            $display("  PASS | %-24s | got %0d", label, actual);
            pass_count = pass_count + 1;
        end
        else begin
            $display("  FAIL | %-24s | expected %0d | got %0d",
                      label, expected_val, actual);
            fail_count = fail_count + 1;
        end
    end
endtask

always begin
    #5 clk = ~clk;
end

endmodule
