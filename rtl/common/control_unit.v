// Control Unit
//
// Jump  = 1 for jal and jalr (unconditionally redirect the PC and
//         write PC+4 into rd)
// JALR  = 1 for jalr only (jump target comes from the ALU result
//         rs1+imm instead of PC+imm)
module Control_Unit(instruction, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump, JALR);

input [6:0] instruction;
output reg Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, Jump, JALR;
output reg [1:0] ALUOp;

always @(*)
begin
    case (instruction)                                                       // ALUSrc_MemtoReg_RegWrite_MemRead_MemWrite_Branch_Jump_JALR_ALUOp
        7'b0110011 : {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, JALR, ALUOp} = 10'b0010000_0_10; // r-type
        7'b0000011 : {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, JALR, ALUOp} = 10'b1111000_0_00; // i-type (lw)
        7'b0100011 : {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, JALR, ALUOp} = 10'b1000100_0_00; // s-type
        7'b1100011 : {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, JALR, ALUOp} = 10'b0000010_0_01; // sb-type
        7'b0010011 : {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, JALR, ALUOp} = 10'b1010000_0_11; // i-type arithmetic
        7'b1101111 : {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, JALR, ALUOp} = 10'b0010001_0_00; // jal:  rd=PC+4, target=PC+imm
        7'b1100111 : {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, JALR, ALUOp} = 10'b1010001_1_00; // jalr: rd=PC+4, target=rs1+imm (ALU add)
    default : {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, JALR, ALUOp} = 10'b0;
    endcase
end

endmodule
