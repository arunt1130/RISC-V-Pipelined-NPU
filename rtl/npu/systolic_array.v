// ══════════════════════════════════════════════════════════════
// Parameterized Systolic Array — ARRAY_SIZE x ARRAY_SIZE MAC grid
//
// Data flows:
//   Activations (A) enter from the LEFT  and flow RIGHT
//   Weights     (B) enter from the TOP   and flow DOWN
//   Results accumulate inside each PE
//
//          top_in[0]  top_in[1]  ...  top_in[N-1]
//             │          │               │
//             ▼          ▼               ▼
// left[0] ─▸[0,0]─────▸[0,1]── ... ──▸[0,N-1]─▸
//             │          │               │
//             ▼          ▼               ▼
// left[1] ─▸[1,0]─────▸[1,1]── ... ──▸[1,N-1]─▸
//            ...        ...             ...
//
// After computation, each PE(i,j) holds C[i][j] = Σ_k A[i][k]×B[k][j]
//
// Ports are flattened buses (Verilog-2001 has no array ports):
//   left_in[i*DATA_WIDTH +: DATA_WIDTH] feeds row i
//   top_in [j*DATA_WIDTH +: DATA_WIDTH] feeds column j
//
// result_sel = i*ARRAY_SIZE + j selects PE(i,j)'s accumulator.
// ══════════════════════════════════════════════════════════════
module Systolic_Array #(
    parameter ARRAY_SIZE = 4,
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32
)(
    input                                clk, reset, enable, clear,
    // Left inputs — one lane per row (skewed A data from controller)
    input  [ARRAY_SIZE*DATA_WIDTH-1:0]   left_in,
    // Top inputs — one lane per column (skewed B data from controller)
    input  [ARRAY_SIZE*DATA_WIDTH-1:0]   top_in,
    // Result read port
    input  [7:0]                         result_sel,
    output [ACC_WIDTH-1:0]               result_out
);

// ── Internal mesh wiring ──
// a_wire[i][j] is the activation entering PE(i,j) from the left;
// column ARRAY_SIZE holds the unused right-edge outputs.
// b_wire[i][j] is the weight entering PE(i,j) from above;
// row ARRAY_SIZE holds the unused bottom-edge outputs.
wire [DATA_WIDTH-1:0] a_wire [0:ARRAY_SIZE-1][0:ARRAY_SIZE];
wire [DATA_WIDTH-1:0] b_wire [0:ARRAY_SIZE][0:ARRAY_SIZE-1];
wire [ACC_WIDTH-1:0]  acc    [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];

genvar gi, gj;
generate
    // Edge feeds from the flattened input buses
    for (gi = 0; gi < ARRAY_SIZE; gi = gi + 1) begin : left_edge
        assign a_wire[gi][0] = left_in[gi*DATA_WIDTH +: DATA_WIDTH];
    end
    for (gj = 0; gj < ARRAY_SIZE; gj = gj + 1) begin : top_edge
        assign b_wire[0][gj] = top_in[gj*DATA_WIDTH +: DATA_WIDTH];
    end

    // The PE grid
    for (gi = 0; gi < ARRAY_SIZE; gi = gi + 1) begin : row
        for (gj = 0; gj < ARRAY_SIZE; gj = gj + 1) begin : col
            MAC_Unit #(
                .DATA_WIDTH(DATA_WIDTH),
                .ACC_WIDTH(ACC_WIDTH)
            ) pe (
                .clk(clk), .reset(reset),
                .enable(enable), .clear(clear),
                .a_in (a_wire[gi][gj]),
                .b_in (b_wire[gi][gj]),
                .a_out(a_wire[gi][gj+1]),
                .b_out(b_wire[gi+1][gj]),
                .acc  (acc[gi][gj])
            );
        end
    end
endgenerate

// ── Result read multiplexer ──
// result_sel = i*ARRAY_SIZE + j selects PE(i,j)'s accumulator.
localparam SEL_W = (ARRAY_SIZE > 1) ? $clog2(ARRAY_SIZE) : 1;
wire [7:0] sel_row = result_sel / ARRAY_SIZE;
wire [7:0] sel_col = result_sel % ARRAY_SIZE;
assign result_out = acc[sel_row[SEL_W-1:0]][sel_col[SEL_W-1:0]];

endmodule
