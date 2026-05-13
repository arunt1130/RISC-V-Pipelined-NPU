// ──────────────────────────────────────────────
// Hazard Detection Unit (Step 6)
// Sits in the Decode stage. Detects the load-use
// case: when a LOAD instruction in Execute (MemRead_EX=1)
// writes to a register that the NEXT instruction
// (currently in Decode) needs to read.
//
// Forwarding can't help here because the load data
// won't be available until the END of the MEM stage,
// but Execute needs it at the START. Solution: stall
// for exactly ONE cycle, then forwarding handles it.
//
// When a load-use hazard is detected:
//   stall = 1      → freezes PC and IF/ID register
//   flush_IDEX = 1 → inserts a bubble (NOP) into ID/EX
// ──────────────────────────────────────────────
module Hazard_Detection_Unit(
    input [4:0] RS1_ID, RS2_ID,
    input [4:0] RD_EX,
    input       MemRead_EX,
    output reg  stall,
    output reg  flush_IDEX
);

always @(*) begin
    if (MemRead_EX
        && (RD_EX == RS1_ID || RD_EX == RS2_ID)
        && RD_EX != 5'b0) begin
        stall      = 1'b1;
        flush_IDEX = 1'b1;
    end
    else begin
        stall      = 1'b0;
        flush_IDEX = 1'b0;
    end
end

endmodule
