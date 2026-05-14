// Instruction Memory

module Instruction_Mem(clk, reset, read_address, instruction_out);

input clk, reset;
input [31:0] read_address;
output [31:0] instruction_out;
integer k;

reg [31:0] I_Mem[63:0];

    reg [8*256-1:0] fw_file;
    initial begin
        if ($value$plusargs("firmware=%s", fw_file)) begin
            $display("[RTL] Loading firmware from %0s", fw_file);
            $readmemh(fw_file, I_Mem);
            $display("[RTL] First instruction: %x", I_Mem[0]);
        end else begin
            $display("[RTL] No +firmware plusarg found!");
        end
    end

assign instruction_out = I_Mem[read_address >> 2]; //right shifts by 2 bits (equivalent to dividing by 4)

always @(posedge clk) begin
end

endmodule
