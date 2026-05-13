// ──────────────────────────────────────────────
// 3-to-1 Multiplexer (used for forwarding paths)
// sel = 2'b00 → in0 (register file value, no forward)
// sel = 2'b01 → in1 (writeback value, WB forward)
// sel = 2'b10 → in2 (memory stage value, MEM forward)
// ──────────────────────────────────────────────
module Mux3to1(sel, in0, in1, in2, out);

input [1:0] sel;
input [31:0] in0, in1, in2;
output reg [31:0] out;

always @(*) begin
    case(sel)
        2'b00 : out = in0;
        2'b01 : out = in1;
        2'b10 : out = in2;
        default : out = in0;
    endcase
end

endmodule
