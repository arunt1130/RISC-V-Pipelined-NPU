// ──────────────────────────────────────────────
// Pipeline Register 4: Memory → Writeback
// The simplest register. By this point most control
// signals have been consumed. Only two remain —
// MemtoReg (selects between ALU result and memory
// data for writeback) and RegWrite (enables the
// register file write). Carries both possible
// writeback values so the mux can choose between them,
// plus RD so the register file knows where to write.
// ──────────────────────────────────────────────
module MEM_WB_Reg(
    input        clk, reset,
    input        MemtoReg_in, RegWrite_in,
    input [31:0] ALU_result_in, MemData_in,
    input [4:0]  RD_in,
    output reg        MemtoReg_out, RegWrite_out,
    output reg [31:0] ALU_result_out, MemData_out,
    output reg [4:0]  RD_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            MemtoReg_out   <= 1'b0;
            RegWrite_out   <= 1'b0;
            ALU_result_out <= 32'b0;
            MemData_out    <= 32'b0;
            RD_out         <= 5'b0;
        end
        else begin
            MemtoReg_out   <= MemtoReg_in;
            RegWrite_out   <= RegWrite_in;
            ALU_result_out <= ALU_result_in;
            MemData_out    <= MemData_in;
            RD_out         <= RD_in;
        end
    end
endmodule
