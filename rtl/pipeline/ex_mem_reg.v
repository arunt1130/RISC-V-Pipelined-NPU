// ──────────────────────────────────────────────
// Pipeline Register 3: Execute → Memory
// Sits between the ALU and data memory.
// Carries the ALU result (used as memory address for
// loads/stores, or as the final writeback value for
// arithmetic). Also carries RD2 which is the store
// value for SW instructions. Zero flag and branch
// signal are carried together — the memory stage
// ANDs them to decide whether to redirect the PC.
// ──────────────────────────────────────────────
module EX_MEM_Reg(
    input        clk, reset, flush,
    // Control signals
    input        MemtoReg_in, RegWrite_in,
    input        MemRead_in, MemWrite_in, Branch_in,
    // Data
    input        zero_in,
    input [31:0] ALU_result_in, RD2_in, BranchTarget_in,
    // Destination register
    input [4:0]  RD_in,

    // Control signals out
    output reg        MemtoReg_out, RegWrite_out,
    output reg        MemRead_out, MemWrite_out, Branch_out,
    // Data out
    output reg        zero_out,
    output reg [31:0] ALU_result_out, RD2_out, BranchTarget_out,
    // Destination register out
    output reg [4:0]  RD_out
);
    always @(posedge clk or posedge reset) begin
        if (reset || flush) begin
            MemtoReg_out     <= 1'b0;
            RegWrite_out     <= 1'b0;
            MemRead_out      <= 1'b0;
            MemWrite_out     <= 1'b0;
            Branch_out       <= 1'b0;
            zero_out         <= 1'b0;
            ALU_result_out   <= 32'b0;
            RD2_out          <= 32'b0;
            BranchTarget_out <= 32'b0;
            RD_out           <= 5'b0;
        end
        else begin
            MemtoReg_out     <= MemtoReg_in;
            RegWrite_out     <= RegWrite_in;
            MemRead_out      <= MemRead_in;
            MemWrite_out     <= MemWrite_in;
            Branch_out       <= Branch_in;
            zero_out         <= zero_in;
            ALU_result_out   <= ALU_result_in;
            RD2_out          <= RD2_in;
            BranchTarget_out <= BranchTarget_in;
            RD_out           <= RD_in;
        end
    end
endmodule
