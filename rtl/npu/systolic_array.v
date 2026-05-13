// ══════════════════════════════════════════════════════════════
// 4×4 Systolic Array — 16 MAC Units wired in a grid
//
// Data flows:
//   Activations (A) enter from the LEFT  and flow RIGHT
//   Weights     (B) enter from the TOP   and flow DOWN
//   Results accumulate inside each PE
//
//          top_in[0]  top_in[1]  top_in[2]  top_in[3]
//             │          │          │          │
//             ▼          ▼          ▼          ▼
// left[0] ─▸[0,0]─────▸[0,1]─────▸[0,2]─────▸[0,3]─▸
//             │          │          │          │
//             ▼          ▼          ▼          ▼
// left[1] ─▸[1,0]─────▸[1,1]─────▸[1,2]─────▸[1,3]─▸
//             │          │          │          │
//             ▼          ▼          ▼          ▼
// left[2] ─▸[2,0]─────▸[2,1]─────▸[2,2]─────▸[2,3]─▸
//             │          │          │          │
//             ▼          ▼          ▼          ▼
// left[3] ─▸[3,0]─────▸[3,1]─────▸[3,2]─────▸[3,3]─▸
//
// After computation, each PE(i,j) holds C[i][j] = Σ_k A[i][k]×B[k][j]
//
// result_sel chooses which PE's accumulator to read (0–15).
// ══════════════════════════════════════════════════════════════
module Systolic_Array_4x4(
    input        clk, reset, enable, clear,
    // Left inputs — one per row (fed by controller with skewed A data)
    input  [7:0] left_in_0, left_in_1, left_in_2, left_in_3,
    // Top inputs — one per column (fed by controller with skewed B data)
    input  [7:0] top_in_0, top_in_1, top_in_2, top_in_3,
    // Result read port
    input  [3:0] result_sel,
    output reg [31:0] result_out
);

// ── Internal wires: horizontal (a) data flow ──
// a_r_I_J = a_out of PE(I,J), which feeds a_in of PE(I,J+1)
wire [7:0] a_r_0_0, a_r_0_1, a_r_0_2, a_r_0_3;
wire [7:0] a_r_1_0, a_r_1_1, a_r_1_2, a_r_1_3;
wire [7:0] a_r_2_0, a_r_2_1, a_r_2_2, a_r_2_3;
wire [7:0] a_r_3_0, a_r_3_1, a_r_3_2, a_r_3_3;

// ── Internal wires: vertical (b) data flow ──
// b_d_I_J = b_out of PE(I,J), which feeds b_in of PE(I+1,J)
wire [7:0] b_d_0_0, b_d_0_1, b_d_0_2, b_d_0_3;
wire [7:0] b_d_1_0, b_d_1_1, b_d_1_2, b_d_1_3;
wire [7:0] b_d_2_0, b_d_2_1, b_d_2_2, b_d_2_3;
wire [7:0] b_d_3_0, b_d_3_1, b_d_3_2, b_d_3_3;

// ── Accumulator outputs ──
wire [31:0] acc_0_0, acc_0_1, acc_0_2, acc_0_3;
wire [31:0] acc_1_0, acc_1_1, acc_1_2, acc_1_3;
wire [31:0] acc_2_0, acc_2_1, acc_2_2, acc_2_3;
wire [31:0] acc_3_0, acc_3_1, acc_3_2, acc_3_3;


// ╔══════════════════════════════════════════════════╗
// ║              ROW 0: PE(0,0) to PE(0,3)           ║
// ╚══════════════════════════════════════════════════╝
MAC_Unit pe_0_0(.clk(clk), .reset(reset), .enable(enable), .clear(clear),
    .a_in(left_in_0), .b_in(top_in_0),
    .a_out(a_r_0_0),  .b_out(b_d_0_0), .acc(acc_0_0));

MAC_Unit pe_0_1(.clk(clk), .reset(reset), .enable(enable), .clear(clear),
    .a_in(a_r_0_0),   .b_in(top_in_1),
    .a_out(a_r_0_1),  .b_out(b_d_0_1), .acc(acc_0_1));

MAC_Unit pe_0_2(.clk(clk), .reset(reset), .enable(enable), .clear(clear),
    .a_in(a_r_0_1),   .b_in(top_in_2),
    .a_out(a_r_0_2),  .b_out(b_d_0_2), .acc(acc_0_2));

MAC_Unit pe_0_3(.clk(clk), .reset(reset), .enable(enable), .clear(clear),
    .a_in(a_r_0_2),   .b_in(top_in_3),
    .a_out(a_r_0_3),  .b_out(b_d_0_3), .acc(acc_0_3));


// ╔══════════════════════════════════════════════════╗
// ║              ROW 1: PE(1,0) to PE(1,3)           ║
// ╚══════════════════════════════════════════════════╝
MAC_Unit pe_1_0(.clk(clk), .reset(reset), .enable(enable), .clear(clear),
    .a_in(left_in_1), .b_in(b_d_0_0),
    .a_out(a_r_1_0),  .b_out(b_d_1_0), .acc(acc_1_0));

MAC_Unit pe_1_1(.clk(clk), .reset(reset), .enable(enable), .clear(clear),
    .a_in(a_r_1_0),   .b_in(b_d_0_1),
    .a_out(a_r_1_1),  .b_out(b_d_1_1), .acc(acc_1_1));

MAC_Unit pe_1_2(.clk(clk), .reset(reset), .enable(enable), .clear(clear),
    .a_in(a_r_1_1),   .b_in(b_d_0_2),
    .a_out(a_r_1_2),  .b_out(b_d_1_2), .acc(acc_1_2));

MAC_Unit pe_1_3(.clk(clk), .reset(reset), .enable(enable), .clear(clear),
    .a_in(a_r_1_2),   .b_in(b_d_0_3),
    .a_out(a_r_1_3),  .b_out(b_d_1_3), .acc(acc_1_3));


// ╔══════════════════════════════════════════════════╗
// ║              ROW 2: PE(2,0) to PE(2,3)           ║
// ╚══════════════════════════════════════════════════╝
MAC_Unit pe_2_0(.clk(clk), .reset(reset), .enable(enable), .clear(clear),
    .a_in(left_in_2), .b_in(b_d_1_0),
    .a_out(a_r_2_0),  .b_out(b_d_2_0), .acc(acc_2_0));

MAC_Unit pe_2_1(.clk(clk), .reset(reset), .enable(enable), .clear(clear),
    .a_in(a_r_2_0),   .b_in(b_d_1_1),
    .a_out(a_r_2_1),  .b_out(b_d_2_1), .acc(acc_2_1));

MAC_Unit pe_2_2(.clk(clk), .reset(reset), .enable(enable), .clear(clear),
    .a_in(a_r_2_1),   .b_in(b_d_1_2),
    .a_out(a_r_2_2),  .b_out(b_d_2_2), .acc(acc_2_2));

MAC_Unit pe_2_3(.clk(clk), .reset(reset), .enable(enable), .clear(clear),
    .a_in(a_r_2_2),   .b_in(b_d_1_3),
    .a_out(a_r_2_3),  .b_out(b_d_2_3), .acc(acc_2_3));


// ╔══════════════════════════════════════════════════╗
// ║              ROW 3: PE(3,0) to PE(3,3)           ║
// ╚══════════════════════════════════════════════════╝
MAC_Unit pe_3_0(.clk(clk), .reset(reset), .enable(enable), .clear(clear),
    .a_in(left_in_3), .b_in(b_d_2_0),
    .a_out(a_r_3_0),  .b_out(b_d_3_0), .acc(acc_3_0));

MAC_Unit pe_3_1(.clk(clk), .reset(reset), .enable(enable), .clear(clear),
    .a_in(a_r_3_0),   .b_in(b_d_2_1),
    .a_out(a_r_3_1),  .b_out(b_d_3_1), .acc(acc_3_1));

MAC_Unit pe_3_2(.clk(clk), .reset(reset), .enable(enable), .clear(clear),
    .a_in(a_r_3_1),   .b_in(b_d_2_2),
    .a_out(a_r_3_2),  .b_out(b_d_3_2), .acc(acc_3_2));

MAC_Unit pe_3_3(.clk(clk), .reset(reset), .enable(enable), .clear(clear),
    .a_in(a_r_3_2),   .b_in(b_d_2_3),
    .a_out(a_r_3_3),  .b_out(b_d_3_3), .acc(acc_3_3));


// ╔══════════════════════════════════════════════════╗
// ║           Result Read Multiplexer                 ║
// ╚══════════════════════════════════════════════════╝
// Selects one of the 16 accumulators for readback.
// result_sel = i*4 + j selects PE(i,j).
always @(*) begin
    case (result_sel)
        4'd0:  result_out = acc_0_0;
        4'd1:  result_out = acc_0_1;
        4'd2:  result_out = acc_0_2;
        4'd3:  result_out = acc_0_3;
        4'd4:  result_out = acc_1_0;
        4'd5:  result_out = acc_1_1;
        4'd6:  result_out = acc_1_2;
        4'd7:  result_out = acc_1_3;
        4'd8:  result_out = acc_2_0;
        4'd9:  result_out = acc_2_1;
        4'd10: result_out = acc_2_2;
        4'd11: result_out = acc_2_3;
        4'd12: result_out = acc_3_0;
        4'd13: result_out = acc_3_1;
        4'd14: result_out = acc_3_2;
        4'd15: result_out = acc_3_3;
        default: result_out = 32'b0;
    endcase
end

endmodule
