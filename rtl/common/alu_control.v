//ALU Control
module ALU_Control(ALUOp, fun7, fun3, Control_out);

input fun7;
input [2:0] fun3;
input [1:0] ALUOp;
output reg [3:0] Control_out;

always @(*)
begin
    if (ALUOp == 2'b00) begin
        Control_out = 4'b0010; // load/store -> add
    end else if (ALUOp == 2'b01) begin
        Control_out = 4'b0110; // branch -> sub
    end else if (ALUOp == 2'b11) begin
        // I-type arithmetic. fun7 is part of immediate, ignore it.
        case (fun3)
            3'b000: Control_out = 4'b0010; // addi -> add
            3'b111: Control_out = 4'b0000; // andi -> and (if implemented)
            3'b110: Control_out = 4'b0001; // ori -> or (if implemented)
            default: Control_out = 4'b0010;
        endcase
    end else begin
        // R-type (ALUOp == 2'b10)
        case ({fun7, fun3})
            4'b0_000 : Control_out = 4'b0010; // add
            4'b1_000 : Control_out = 4'b0110; // sub
            4'b0_111 : Control_out = 4'b0000; // and
            4'b0_110 : Control_out = 4'b0001; // or
            default : Control_out = 4'b0010; // default to ADD
        endcase
    end
end

endmodule
