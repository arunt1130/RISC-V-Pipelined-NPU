// ══════════════════════════════════════════════════════════════
// MAC Unit — Processing Element for the Systolic Array
//
// Each cell in the 4×4 systolic array is one of these.
// On each enabled clock cycle it:
//   1. Multiplies a_in × b_in and adds to its accumulator
//   2. Passes a_in to the right neighbor (a_out)
//   3. Passes b_in to the cell below (b_out)
//
// Data widths:
//   Inputs:      8-bit (typical for AI inference, like Google's TPU)
//   Accumulator: 32-bit (prevents overflow: worst case 4×127×127 = 64,516)
//
// Control:
//   enable — gates computation and data flow
//   clear  — resets the accumulator to 0 before a new matrix multiply
// ══════════════════════════════════════════════════════════════
module MAC_Unit(
    input        clk, reset, enable, clear,
    input  [7:0] a_in,       // activation from the left
    input  [7:0] b_in,       // weight from above
    output reg [7:0] a_out,  // passed to the right neighbor
    output reg [7:0] b_out,  // passed to the cell below
    output reg [31:0] acc    // accumulated result
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        a_out <= 8'b0;
        b_out <= 8'b0;
        acc   <= 32'b0;
    end
    else if (clear) begin
        // Zero the accumulator before a new computation.
        // Also zero the pass-throughs so stale data doesn't
        // leak into the array during the next computation.
        a_out <= 8'b0;
        b_out <= 8'b0;
        acc   <= 32'b0;
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
