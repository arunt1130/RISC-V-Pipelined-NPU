// ──────────────────────────────────────────────
// Forwarding Unit (Step 5)
// Lives in the Execute stage. Compares the source
// registers of the instruction in Execute (RS1_EX,
// RS2_EX) to the destination registers of instructions
// in Memory (RD_MEM) and Writeback (RD_WB).
//
// If a match is found, it tells the forwarding muxes
// to grab the computed value from MEM or WB instead
// of the stale value from the register file.
//
// ForwardA/B encoding:
//   2'b00 = no forwarding, use register file value
//   2'b10 = forward from MEM stage (ALU_result_MEM)
//   2'b01 = forward from WB stage  (WriteBack_WB)
//
// MEM has priority over WB because it holds the
// MORE RECENT result (the instruction closer in time).
// ──────────────────────────────────────────────
module Forwarding_Unit(
    input [4:0] RS1_EX, RS2_EX,
    input [4:0] RD_MEM, RD_WB,
    input       RegWrite_MEM, RegWrite_WB,
    output reg [1:0] ForwardA, ForwardB
);

always @(*) begin
    // ── ForwardA (ALU input A) ──
    if (RegWrite_MEM && RD_MEM != 5'b0 && RD_MEM == RS1_EX)
        ForwardA = 2'b10;   // forward from MEM
    else if (RegWrite_WB && RD_WB != 5'b0 && RD_WB == RS1_EX)
        ForwardA = 2'b01;   // forward from WB
    else
        ForwardA = 2'b00;   // no forwarding

    // ── ForwardB (ALU input B / store data) ──
    if (RegWrite_MEM && RD_MEM != 5'b0 && RD_MEM == RS2_EX)
        ForwardB = 2'b10;   // forward from MEM
    else if (RegWrite_WB && RD_WB != 5'b0 && RD_WB == RS2_EX)
        ForwardB = 2'b01;   // forward from WB
    else
        ForwardB = 2'b00;   // no forwarding
end

endmodule
