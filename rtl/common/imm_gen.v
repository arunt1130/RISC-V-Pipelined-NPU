// Immediate Generator

module ImmGen(Opcode, instruction, ImmExt);

input [6:0] Opcode;
input [31:0] instruction;
output reg [31:0] ImmExt;

always@(*)
begin
    case (Opcode)
        7'b0000011 : ImmExt = {{20{instruction[31]}}, instruction[31:20]}; // For I-type (load), make 20 copies of MSB of instruction and concatenate to the 12 immediate bits of the I-type instruction, thus preserving the sign of the immediate bits for ALU and other 32-bit units to handle
        7'b0010011 : ImmExt = {{20{instruction[31]}}, instruction[31:20]}; // For I-type (arithmetic), same encoding as load immediate
        7'b0100011 : ImmExt = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // For S-type (store)
        7'b1100011 : ImmExt = {{19{instruction[31]}}, instruction[31], instruction [7], instruction[30:25], instruction[11:8],1'b0}; // For SB-type (branch)
        default    : ImmExt = 32'b0; // default to 0 for unknown opcodes
    endcase
end

endmodule
