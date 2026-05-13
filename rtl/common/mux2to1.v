//Multiplexers

//Mux1
module Mux1(sel1, A1, B1, Mux1_Out);

input sel1;
input [31:0] A1, B1;
output [31:0] Mux1_Out;

assign Mux1_Out = (sel1==1'b0) ? A1 : B1;

endmodule
//Mux 2
module Mux2(sel2, A2, B2, Mux2_Out);

input sel2;
input [31:0] A2, B2;
output [31:0] Mux2_Out;

assign Mux2_Out = (sel2==1'b0) ? A2 : B2;

endmodule
//mux3
module Mux3(sel3, A3, B3, Mux3_Out);

input sel3;
input [31:0] A3, B3;
output [31:0] Mux3_Out;

assign Mux3_Out = (sel3==1'b0) ? A3 : B3;

endmodule
