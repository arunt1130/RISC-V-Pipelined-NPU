//Pipeline Registers
// ──────────────────────────────────────────────
// Pipeline Register 1: Fetch → Decode
// Sits between instruction memory and the register
// file/control unit. Latches the fetched instruction
// and current PC so the decode stage can use them
// on the next cycle while fetch moves to the next instruction.
// flush: zeroes everything out (used for branch hazards)
// stall: freezes the register in place (used for load-use hazards)
// ──────────────────────────────────────────────
module IF_ID_Reg(
    input        clk, reset, flush, stall,
    input [31:0] PC_in, instruction_in,
    output reg [31:0] PC_out, instruction_out
);
    always @(posedge clk or posedge reset) begin
        if (reset || flush) begin
            PC_out          <= 32'b0;
            instruction_out <= 32'b0;
        end
        else if (!stall) begin
            PC_out          <= PC_in;
            instruction_out <= instruction_in;
        end
        // if stall: outputs hold their current value (implicit)
    end
endmodule
