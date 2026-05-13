// Register File

module Reg_File(clk, reset, RegWrite, Rs1, Rs2, Rd, Write_data, read_data1, read_data2); //rs1 and rs2 are read reg 1 and 2, Rd is destination register

input clk, reset, RegWrite;
input [4:0] Rs1, Rs2, Rd; 
input [31:0] Write_data;
output [31:0] read_data1, read_data2;
integer k;
reg [31:0] Registers[31:0];

always @(posedge clk or posedge reset)
begin
    if(reset)
        begin
            for(k=0; k<32; k=k+1)begin
               Registers[k] <= 32'b0; 
            end
        end
    else if(RegWrite && Rd != 5'b0)begin //register 0 should always read 0 as per RISC-V specifications
        Registers[Rd] <= Write_data;
    end 
end

assign read_data1 = Registers[Rs1];
assign read_data2 = Registers[Rs2];

endmodule
