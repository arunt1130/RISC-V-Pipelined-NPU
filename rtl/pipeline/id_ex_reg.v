// ──────────────────────────────────────────────
// Pipeline Register 2: Decode → Execute
// Sits between the register file and the ALU.
// Carries every control signal and data value that
// the execute stage needs. Also carries RS1, RS2, RD
// register addresses — the forwarding unit will need
// these later to detect and resolve data hazards.
// No stall input here — stalling is handled by inserting
// a bubble (flush=1) when the hazard unit detects one.
// ──────────────────────────────────────────────
module ID_EX_Reg(
    input        clk, reset, flush,
    // Control signals
    input        ALUSrc_in, MemtoReg_in, RegWrite_in,
    input        MemRead_in, MemWrite_in, Branch_in,
    input [1:0]  ALUOp_in,
    // Data
    input [31:0] PC_in, RD1_in, RD2_in, ImmExt_in,
    // ALU decode fields — extracted from instruction in decode,
    // carried here because the instruction word is gone by execute
    input        fun7_in,
    input [2:0]  fun3_in,
    // Register addresses for forwarding unit
    input [4:0]  RS1_in, RS2_in, RD_in,

    // Control signals out
    output reg        ALUSrc_out, MemtoReg_out, RegWrite_out,
    output reg        MemRead_out, MemWrite_out, Branch_out,
    output reg [1:0]  ALUOp_out,
    // Data out
    output reg [31:0] PC_out, RD1_out, RD2_out, ImmExt_out,
    // ALU decode fields out
    output reg        fun7_out,
    output reg [2:0]  fun3_out,
    // Register addresses out
    output reg [4:0]  RS1_out, RS2_out, RD_out
);
    always @(posedge clk or posedge reset) begin
        if (reset || flush) begin
            // Zero all control signals — this creates a bubble
            // (NOP) that flows through execute doing nothing
            ALUSrc_out   <= 1'b0;
            MemtoReg_out <= 1'b0;
            RegWrite_out <= 1'b0;
            MemRead_out  <= 1'b0;
            MemWrite_out <= 1'b0;
            Branch_out   <= 1'b0;
            ALUOp_out    <= 2'b0;
            // Zero all data
            PC_out       <= 32'b0;
            RD1_out      <= 32'b0;
            RD2_out      <= 32'b0;
            ImmExt_out   <= 32'b0;
            fun7_out     <= 1'b0;
            fun3_out     <= 3'b0;
            RS1_out      <= 5'b0;
            RS2_out      <= 5'b0;
            RD_out       <= 5'b0;
        end
        else begin
            ALUSrc_out   <= ALUSrc_in;
            MemtoReg_out <= MemtoReg_in;
            RegWrite_out <= RegWrite_in;
            MemRead_out  <= MemRead_in;
            MemWrite_out <= MemWrite_in;
            Branch_out   <= Branch_in;
            ALUOp_out    <= ALUOp_in;
            PC_out       <= PC_in;
            RD1_out      <= RD1_in;
            RD2_out      <= RD2_in;
            ImmExt_out   <= ImmExt_in;
            fun7_out     <= fun7_in;
            fun3_out     <= fun3_in;
            RS1_out      <= RS1_in;
            RS2_out      <= RS2_in;
            RD_out       <= RD_in;
        end
    end
endmodule
