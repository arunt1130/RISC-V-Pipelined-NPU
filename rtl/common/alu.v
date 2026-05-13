//ALU
module ALU(A, B, Control_in, ALU_Result, zero);

input [31:0] A, B;
input [3:0] Control_in;
output reg zero;
output reg [31:0] ALU_Result;

always @(*)
begin
    case(Control_in)
    4'b0000 : ALU_Result = A & B;
    4'b0001 : ALU_Result = A | B;
    4'b0010 : ALU_Result = A + B;
    4'b0110 : ALU_Result = A - B;
    default : ALU_Result = 32'b0;
    endcase
    zero = (ALU_Result == 32'b0); // zero flag reflects actual result for any operation
end

endmodule
