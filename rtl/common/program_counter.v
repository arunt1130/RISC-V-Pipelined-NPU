// Program Counter

module Program_counter(clk, reset, stall, PC_in, PC_out);

input clk, reset, stall;
input [31:0] PC_in;
output reg [31:0] PC_out;

always @(posedge clk or posedge reset)
begin

if(reset)
    PC_out <= 32'b0;     //non blocking
else if(!stall)
    PC_out <= PC_in;     //non blocking
// else: stall — PC holds its current value
end
endmodule
