// ══════════════════════════════════════════════════════════════
// MAC Unit — Processing Element for the Systolic Array
//
// Each cell in the systolic array is one of these.
// On each enabled clock cycle it:
//   1. Multiplies a_in × b_in and adds to its accumulator
//   2. Passes a_in to the right neighbor (a_out)
//   3. Passes b_in to the cell below (b_out)
//
// Data widths (parameterized):
//   Inputs:      signed DATA_WIDTH-bit (int8, like quantized NN
//                weights/activations — signed in real inference)
//   Accumulator: signed ACC_WIDTH-bit (32-bit prevents overflow)
//
// Control:
//   enable — gates computation and data flow
//   clear  — resets the accumulator to 0 before a new matrix multiply
// ══════════════════════════════════════════════════════════════
module MAC_Unit #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32
)(
    input                              clk, reset, enable, clear,
    input  signed [DATA_WIDTH-1:0]     a_in,   // activation from the left
    input  signed [DATA_WIDTH-1:0]     b_in,   // weight from above
    output reg signed [DATA_WIDTH-1:0] a_out,  // passed to the right neighbor
    output reg signed [DATA_WIDTH-1:0] b_out,  // passed to the cell below
    output reg signed [ACC_WIDTH-1:0]  acc     // accumulated result
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        a_out <= {DATA_WIDTH{1'b0}};
        b_out <= {DATA_WIDTH{1'b0}};
        acc   <= {ACC_WIDTH{1'b0}};
    end
    else if (clear) begin
        // Zero the accumulator before a new computation.
        // Also zero the pass-throughs so stale data doesn't
        // leak into the array during the next computation.
        a_out <= {DATA_WIDTH{1'b0}};
        b_out <= {DATA_WIDTH{1'b0}};
        acc   <= {ACC_WIDTH{1'b0}};
    end
    else if (enable) begin
        // The core MAC operation: accumulate a×b
        acc   <= acc + (a_in * b_in);
        // Pass data through to neighbors — this is what makes
        // it "systolic": data pulses through the array like
        // blood through a heart, one cell per clock cycle.
        a_out <= a_in;
        b_out <= b_in;
    end
    // else: hold all values (array is idle)
end

endmodule
