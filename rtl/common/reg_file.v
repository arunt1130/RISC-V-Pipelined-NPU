// Register File
//
// WRITE_BYPASS: when 1 (default), a same-cycle write to Rd is
// forwarded combinationally to a read of the same register. The
// pipelined core needs this: the WB stage writes while the ID
// stage reads, and the reader must see the new value.
// The single-cycle core sets it to 0 — there the reader must see
// the OLD value (the write commits on the clock edge), and the
// bypass would form a combinational loop through the ALU.

module Reg_File(clk, reset, RegWrite, Rs1, Rs2, Rd, Write_data, read_data1, read_data2); //rs1 and rs2 are read reg 1 and 2, Rd is destination register

parameter WRITE_BYPASS = 1;

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

assign read_data1 = (WRITE_BYPASS != 0 && RegWrite && (Rd != 0) && (Rd == Rs1)) ? Write_data : Registers[Rs1];
assign read_data2 = (WRITE_BYPASS != 0 && RegWrite && (Rd != 0) && (Rd == Rs2)) ? Write_data : Registers[Rs2];

endmodule
