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


//PC + 4

module PCplus4(fromPC, NextoPC);

input [31:0] fromPC;
output[31:0] NextoPC;

assign NextoPC = 4 + fromPC;
endmodule


// Instruction Memory

module Instruction_Mem(clk, reset, read_address, instruction_out);

input clk, reset;
input [31:0] read_address;
output [31:0] instruction_out;
integer k;

reg [31:0] I_Mem[63:0];

always @(posedge clk or posedge reset)
begin
    if(reset)
        begin
            for(k=0; k<64; k=k+1)begin
                I_Mem[k] <= 32'b0;
            end
        end
end

assign instruction_out = I_Mem[read_address >> 2]; //right shifts by 2 bits (equivalent to dividing by 4)

endmodule

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

// Immediate Generator

module ImmGen(Opcode, instruction, ImmExt);

input [6:0] Opcode;
input [31:0] instruction;
output reg [31:0] ImmExt;

always@(*)
begin
    case (Opcode)
        7'b0000011 : ImmExt = {{20{instruction[31]}}, instruction[31:20]}; // For I-type (load), make 20 copies of MSB of instruction and concatenate to the 12 immediate bits of the I-type instruction, thus preserving the sign of the immediate bits for ALU and other 32-bit units to handle
        7'b0010011 : ImmExt = {{20{instruction[31]}}, instruction[31:20]}; // For I-type (arithmetic), same encoding as load immediate
        7'b0100011 : ImmExt = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // For S-type (store)
        7'b1100011 : ImmExt = {{19{instruction[31]}}, instruction[31], instruction [7], instruction[30:25], instruction[11:8],1'b0}; // For SB-type (branch)
        default    : ImmExt = 32'b0; // default to 0 for unknown opcodes
    endcase
end

endmodule


// Control Unit
module Control_Unit(instruction, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);

input [6:0] instruction;
output reg Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
output reg [1:0] ALUOp;

always @(*) 
begin
    case (instruction)
        7'b0110011 : {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 8'b001000_10; //r-type
        7'b0000011 : {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 8'b111100_00; //i-type
        7'b0100011 : {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 8'b100010_00; //s-type
        7'b1100011 : {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 8'b000001_01; //sb-type
        7'b0010011 : {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 8'b101000_10; // i-type arithmetic
    default : {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 8'b00000000;
    endcase
end

endmodule

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


//ALU Control
module ALU_Control(ALUOp, fun7, fun3, Control_out);

input fun7;
input [2:0] fun3;
input [1:0] ALUOp;
output reg [3:0] Control_out;

always @(*)
begin
    case ({ALUOp, fun7, fun3})
        6'b00_0_000 : Control_out = 4'b0010; // load/store -> add
        6'b01_0_000 : Control_out = 4'b0110; // branch -> sub
        6'b10_0_000 : Control_out = 4'b0010; // add
        6'b10_1_000 : Control_out = 4'b0110; // sub
        6'b10_0_111 : Control_out = 4'b0000; // and
        6'b10_0_110 : Control_out = 4'b0001; // or
        default : Control_out = 4'b0010; // default to ADD
    endcase
end

endmodule

//Data Memory
module Data_Memory(clk, reset, MemWrite, MemRead, read_address, Write_data, MemData_out);

input clk, reset, MemWrite, MemRead;
input [31:0] read_address, Write_data;
output [31:0] MemData_out;
integer k;
reg [31:0] D_Memory[63:0];

always@(posedge clk or posedge reset)
begin
    if(reset) begin
        for(k=0; k<64; k=k+1) begin
            D_Memory[k] <= 32'b0;
        end
    end
    else if(MemWrite) begin
        D_Memory[read_address] <= Write_data;
    end
end

assign MemData_out = (MemRead) ? D_Memory[read_address] : 32'b0;

endmodule

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


// AND logic
module AND_logic(branch, zero, and_out);

input branch, zero;
output and_out;

assign and_out = branch & zero;

endmodule

// Adder
module Adder(in_1, in_2, Sum_out);

input [31:0] in_1, in_2;
output [31:0] Sum_out;

assign Sum_out = in_1 + in_2;

endmodule


// ──────────────────────────────────────────────
// Forwarding Unit (Step 5)
// Lives in the Execute stage. Compares the source
// registers of the instruction in Execute (RS1_EX,
// RS2_EX) to the destination registers of instructions
// in Memory (RD_MEM) and Writeback (RD_WB).
//
// If a match is found, it tells the forwarding muxes
// to grab the computed value from MEM or WB instead
// of the stale value from the register file.
//
// ForwardA/B encoding:
//   2'b00 = no forwarding, use register file value
//   2'b10 = forward from MEM stage (ALU_result_MEM)
//   2'b01 = forward from WB stage  (WriteBack_WB)
//
// MEM has priority over WB because it holds the
// MORE RECENT result (the instruction closer in time).
// ──────────────────────────────────────────────
module Forwarding_Unit(
    input [4:0] RS1_EX, RS2_EX,
    input [4:0] RD_MEM, RD_WB,
    input       RegWrite_MEM, RegWrite_WB,
    output reg [1:0] ForwardA, ForwardB
);

always @(*) begin
    // ── ForwardA (ALU input A) ──
    if (RegWrite_MEM && RD_MEM != 5'b0 && RD_MEM == RS1_EX)
        ForwardA = 2'b10;   // forward from MEM
    else if (RegWrite_WB && RD_WB != 5'b0 && RD_WB == RS1_EX)
        ForwardA = 2'b01;   // forward from WB
    else
        ForwardA = 2'b00;   // no forwarding

    // ── ForwardB (ALU input B / store data) ──
    if (RegWrite_MEM && RD_MEM != 5'b0 && RD_MEM == RS2_EX)
        ForwardB = 2'b10;   // forward from MEM
    else if (RegWrite_WB && RD_WB != 5'b0 && RD_WB == RS2_EX)
        ForwardB = 2'b01;   // forward from WB
    else
        ForwardB = 2'b00;   // no forwarding
end

endmodule


// ──────────────────────────────────────────────
// 3-to-1 Multiplexer (used for forwarding paths)
// sel = 2'b00 → in0 (register file value, no forward)
// sel = 2'b01 → in1 (writeback value, WB forward)
// sel = 2'b10 → in2 (memory stage value, MEM forward)
// ──────────────────────────────────────────────
module Mux3to1(sel, in0, in1, in2, out);

input [1:0] sel;
input [31:0] in0, in1, in2;
output reg [31:0] out;

always @(*) begin
    case(sel)
        2'b00 : out = in0;
        2'b01 : out = in1;
        2'b10 : out = in2;
        default : out = in0;
    endcase
end

endmodule


// ──────────────────────────────────────────────
// Hazard Detection Unit (Step 6)
// Sits in the Decode stage. Detects the load-use
// case: when a LOAD instruction in Execute (MemRead_EX=1)
// writes to a register that the NEXT instruction
// (currently in Decode) needs to read.
//
// Forwarding can't help here because the load data
// won't be available until the END of the MEM stage,
// but Execute needs it at the START. Solution: stall
// for exactly ONE cycle, then forwarding handles it.
//
// When a load-use hazard is detected:
//   stall = 1      → freezes PC and IF/ID register
//   flush_IDEX = 1 → inserts a bubble (NOP) into ID/EX
// ──────────────────────────────────────────────
module Hazard_Detection_Unit(
    input [4:0] RS1_ID, RS2_ID,
    input [4:0] RD_EX,
    input       MemRead_EX,
    output reg  stall,
    output reg  flush_IDEX
);

always @(*) begin
    if (MemRead_EX
        && (RD_EX == RS1_ID || RD_EX == RS2_ID)
        && RD_EX != 5'b0) begin
        stall      = 1'b1;
        flush_IDEX = 1'b1;
    end
    else begin
        stall      = 1'b0;
        flush_IDEX = 1'b0;
    end
end

endmodule

//Pipeline Registers
// ──────────────────────────────────────────────
// Pipeline Register 1: Fetch → Decode
// Sits between instruction memory and the register
// file/control unit. Latches the fetched instruction
// and current PC so the decode stage can use them
// on the next cycle while fetch moves to the next instruction.
// flush: zeroes everything out (used for branch hazards)
// stall: freezes the register in place (used for load-use hazards)
// ──────────────────────────────────────────────
module IF_ID_Reg(
    input        clk, reset, flush, stall,
    input [31:0] PC_in, instruction_in,
    output reg [31:0] PC_out, instruction_out
);
    always @(posedge clk or posedge reset) begin
        if (reset || flush) begin
            PC_out          <= 32'b0;
            instruction_out <= 32'b0;
        end
        else if (!stall) begin
            PC_out          <= PC_in;
            instruction_out <= instruction_in;
        end
        // if stall: outputs hold their current value (implicit)
    end
endmodule


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
    // Control signals
    input        MemtoReg_in, RegWrite_in,
    // Data
    input [31:0] ALU_result_in, MemData_in,
    // Destination register
    input [4:0]  RD_in,

    // Control signals out
    output reg        MemtoReg_out, RegWrite_out,
    // Data out
    output reg [31:0] ALU_result_out, MemData_out,
    // Destination register out
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

// ══════════════════════════════════════════════════════════════
// Pipelined Top Module — with Forwarding, Hazard Detection,
// and Branch Flushing (Steps 5–7)
//
// Wire naming convention: signal_STAGE
//   _IF  = produced in Fetch
//   _ID  = produced in Decode
//   _EX  = produced in Execute
//   _MEM = produced in Memory
//   _WB  = produced in Writeback
// ══════════════════════════════════════════════════════════════
module top(clk, reset);
input clk, reset;

// ── Hazard / flush control wires ────────────────────────────
// These are now driven by the Hazard Detection Unit and
// branch logic — no longer hardcoded to 0.
wire stall_hazard;          // from Hazard Detection Unit
wire flush_IDEX_hazard;     // from Hazard Detection Unit

// Branch flush: when PCSrc_MEM = 1 (branch taken), flush
// the three wrong instructions in IF/ID, ID/EX, EX/MEM
wire flush_IFID;
wire flush_IDEX;
wire flush_EXMEM;

// ────────────────── IF stage wires ──────────────────
wire [31:0] PC_IF;              // current PC
wire [31:0] PCplus4_IF;         // PC + 4
wire [31:0] instruction_IF;     // raw instruction from I-Mem
wire [31:0] PC_next;            // mux output → PC input

// ────────────────── ID stage wires ──────────────────
// From IF/ID register outputs
wire [31:0] PC_ID;
wire [31:0] instruction_ID;
// Decoded from instruction_ID
wire [31:0] RD1_ID, RD2_ID;    // register file read data
wire [31:0] ImmExt_ID;         // sign-extended immediate
wire        fun7_ID;            // instruction_ID[30]
wire [2:0]  fun3_ID;            // instruction_ID[14:12]
wire [4:0]  RS1_ID, RS2_ID, RD_ID;
// Control signals produced in Decode
wire        ALUSrc_ID, MemtoReg_ID, RegWrite_ID;
wire        MemRead_ID, MemWrite_ID, Branch_ID;
wire [1:0]  ALUOp_ID;

// ────────────────── EX stage wires ──────────────────
// From ID/EX register outputs
wire [31:0] PC_EX, RD1_EX, RD2_EX, ImmExt_EX;
wire        fun7_EX;
wire [2:0]  fun3_EX;
wire [4:0]  RS1_EX, RS2_EX, RD_EX;
wire        ALUSrc_EX, MemtoReg_EX, RegWrite_EX;
wire        MemRead_EX, MemWrite_EX, Branch_EX;
wire [1:0]  ALUOp_EX;
// Forwarding mux outputs (Step 5)
wire [31:0] ForwardA_data_EX;  // forwarded value for ALU input A
wire [31:0] ForwardB_data_EX;  // forwarded value for ALU input B / store data
wire [1:0]  ForwardA_sel;       // forwarding mux select for A
wire [1:0]  ForwardB_sel;       // forwarding mux select for B
// Computed in Execute
wire [31:0] ALU_mux_out_EX;    // mux output into ALU input B
wire [31:0] ALU_result_EX;     // ALU output
wire        zero_EX;            // ALU zero flag
wire [3:0]  ALU_ctrl_EX;       // ALU control output
wire [31:0] BranchTarget_EX;   // PC_EX + ImmExt_EX

// ────────────────── MEM stage wires ──────────────────
// From EX/MEM register outputs
wire        MemtoReg_MEM, RegWrite_MEM;
wire        MemRead_MEM, MemWrite_MEM, Branch_MEM;
wire        zero_MEM;
wire [31:0] ALU_result_MEM, RD2_MEM, BranchTarget_MEM;
wire [4:0]  RD_MEM;
// Computed in Memory
wire [31:0] MemData_MEM;       // data memory read output
wire        PCSrc_MEM;          // branch AND zero → selects branch target

// ────────────────── WB stage wires ──────────────────
// From MEM/WB register outputs
wire        MemtoReg_WB, RegWrite_WB;
wire [31:0] ALU_result_WB, MemData_WB;
wire [4:0]  RD_WB;
// Computed in Writeback
wire [31:0] WriteBack_WB;      // mux: ALU result or memory data


// ╔══════════════════════════════════════════════════╗
// ║        HAZARD & FLUSH CONTROL LOGIC               ║
// ╚══════════════════════════════════════════════════╝

// Step 7: Branch flush — when branch is taken, flush
// the three instructions that were fetched after the branch
assign flush_IFID  = PCSrc_MEM;
assign flush_EXMEM = PCSrc_MEM;

// Step 6+7: ID/EX flush comes from EITHER a load-use
// stall OR a branch flush — either one inserts a bubble
assign flush_IDEX = flush_IDEX_hazard | PCSrc_MEM;


// ╔══════════════════════════════════════════════════╗
// ║                  IF — FETCH                      ║
// ╚══════════════════════════════════════════════════╝

// Program Counter — now has stall input (Step 6)
Program_counter PC(
    .clk(clk), .reset(reset),
    .stall(stall_hazard),       // ← from Hazard Detection Unit
    .PC_in(PC_next),
    .PC_out(PC_IF)
);

// PC + 4
PCplus4 PC_Adder(
    .fromPC(PC_IF),
    .NextoPC(PCplus4_IF)
);

// Instruction Memory
Instruction_Mem Inst_Memory(
    .clk(clk), .reset(reset),
    .read_address(PC_IF),
    .instruction_out(instruction_IF)
);


// ╔══════════════════════════════════════════════════╗
// ║              IF/ID Pipeline Register              ║
// ╚══════════════════════════════════════════════════╝

IF_ID_Reg IFID(
    .clk(clk), .reset(reset),
    .flush(flush_IFID),
    .stall(stall_hazard),       // ← from Hazard Detection Unit
    .PC_in(PC_IF),           .PC_out(PC_ID),
    .instruction_in(instruction_IF), .instruction_out(instruction_ID)
);


// ╔══════════════════════════════════════════════════╗
// ║                 ID — DECODE                       ║
// ╚══════════════════════════════════════════════════╝

// Extract register addresses from instruction
assign RS1_ID = instruction_ID[19:15];
assign RS2_ID = instruction_ID[24:20];
assign RD_ID  = instruction_ID[11:7];

// Extract ALU decode fields — these travel through ID/EX
// to the ALU Control in Execute
assign fun7_ID = instruction_ID[30];
assign fun3_ID = instruction_ID[14:12];

// Register File
// NOTE: Write port is driven from WB stage (not ID)
Reg_File Reg_File(
    .clk(clk), .reset(reset),
    .RegWrite(RegWrite_WB),        // ← from Writeback
    .Rs1(RS1_ID), .Rs2(RS2_ID),
    .Rd(RD_WB),                    // ← from Writeback
    .Write_data(WriteBack_WB),     // ← from Writeback
    .read_data1(RD1_ID),
    .read_data2(RD2_ID)
);

// Immediate Generator
ImmGen ImmGen(
    .Opcode(instruction_ID[6:0]),
    .instruction(instruction_ID),
    .ImmExt(ImmExt_ID)
);

// Control Unit
Control_Unit Control_Unit(
    .instruction(instruction_ID[6:0]),
    .Branch(Branch_ID),
    .MemRead(MemRead_ID),
    .MemtoReg(MemtoReg_ID),
    .ALUOp(ALUOp_ID),
    .MemWrite(MemWrite_ID),
    .ALUSrc(ALUSrc_ID),
    .RegWrite(RegWrite_ID)
);

// Step 6: Hazard Detection Unit — sits in Decode, looks at Execute
Hazard_Detection_Unit HDU(
    .RS1_ID(RS1_ID),
    .RS2_ID(RS2_ID),
    .RD_EX(RD_EX),
    .MemRead_EX(MemRead_EX),
    .stall(stall_hazard),
    .flush_IDEX(flush_IDEX_hazard)
);


// ╔══════════════════════════════════════════════════╗
// ║              ID/EX Pipeline Register              ║
// ╚══════════════════════════════════════════════════╝

ID_EX_Reg IDEX(
    .clk(clk), .reset(reset), .flush(flush_IDEX),
    // Control in
    .ALUSrc_in(ALUSrc_ID),  .MemtoReg_in(MemtoReg_ID), .RegWrite_in(RegWrite_ID),
    .MemRead_in(MemRead_ID), .MemWrite_in(MemWrite_ID), .Branch_in(Branch_ID),
    .ALUOp_in(ALUOp_ID),
    // Data in
    .PC_in(PC_ID), .RD1_in(RD1_ID), .RD2_in(RD2_ID), .ImmExt_in(ImmExt_ID),
    // ALU decode fields in
    .fun7_in(fun7_ID), .fun3_in(fun3_ID),
    // Register addresses in
    .RS1_in(RS1_ID), .RS2_in(RS2_ID), .RD_in(RD_ID),
    // Control out
    .ALUSrc_out(ALUSrc_EX), .MemtoReg_out(MemtoReg_EX), .RegWrite_out(RegWrite_EX),
    .MemRead_out(MemRead_EX), .MemWrite_out(MemWrite_EX), .Branch_out(Branch_EX),
    .ALUOp_out(ALUOp_EX),
    // Data out
    .PC_out(PC_EX), .RD1_out(RD1_EX), .RD2_out(RD2_EX), .ImmExt_out(ImmExt_EX),
    // ALU decode fields out
    .fun7_out(fun7_EX), .fun3_out(fun3_EX),
    // Register addresses out
    .RS1_out(RS1_EX), .RS2_out(RS2_EX), .RD_out(RD_EX)
);


// ╔══════════════════════════════════════════════════╗
// ║                EX — EXECUTE                       ║
// ║  (with Forwarding — Step 5)                       ║
// ╚══════════════════════════════════════════════════╝

// Step 5: Forwarding Unit — compares EX sources to MEM/WB destinations
Forwarding_Unit FWD(
    .RS1_EX(RS1_EX), .RS2_EX(RS2_EX),
    .RD_MEM(RD_MEM), .RD_WB(RD_WB),
    .RegWrite_MEM(RegWrite_MEM), .RegWrite_WB(RegWrite_WB),
    .ForwardA(ForwardA_sel), .ForwardB(ForwardB_sel)
);

// Step 5: ForwardA mux — selects ALU input A
//   00: RD1_EX (register file, no hazard)
//   01: WriteBack_WB (forward from WB)
//   10: ALU_result_MEM (forward from MEM)
Mux3to1 ForwardA_mux(
    .sel(ForwardA_sel),
    .in0(RD1_EX),
    .in1(WriteBack_WB),
    .in2(ALU_result_MEM),
    .out(ForwardA_data_EX)
);

// Step 5: ForwardB mux — selects register data for ALU input B / store data
//   00: RD2_EX (register file, no hazard)
//   01: WriteBack_WB (forward from WB)
//   10: ALU_result_MEM (forward from MEM)
Mux3to1 ForwardB_mux(
    .sel(ForwardB_sel),
    .in0(RD2_EX),
    .in1(WriteBack_WB),
    .in2(ALU_result_MEM),
    .out(ForwardB_data_EX)
);

// ALU Control — reads fun7/fun3 from ID/EX register outputs
ALU_Control ALU_Control(
    .ALUOp(ALUOp_EX),
    .fun7(fun7_EX),
    .fun3(fun3_EX),
    .Control_out(ALU_ctrl_EX)
);

// ALU source mux: forwarded register data OR immediate
// ForwardB_data_EX is the (possibly forwarded) register value.
// ALUSrc selects between it and the immediate.
Mux1 ALU_mux(
    .sel1(ALUSrc_EX),
    .A1(ForwardB_data_EX),    // ← forwarded value (was RD2_EX)
    .B1(ImmExt_EX),
    .Mux1_Out(ALU_mux_out_EX)
);

// ALU — input A is now ForwardA_data_EX (was RD1_EX)
ALU ALU(
    .A(ForwardA_data_EX),     // ← forwarded value (was RD1_EX)
    .B(ALU_mux_out_EX),
    .Control_in(ALU_ctrl_EX),
    .ALU_Result(ALU_result_EX),
    .zero(zero_EX)
);

// Branch target adder: PC + immediate
Adder BranchAdder(
    .in_1(PC_EX),
    .in_2(ImmExt_EX),
    .Sum_out(BranchTarget_EX)
);


// ╔══════════════════════════════════════════════════╗
// ║             EX/MEM Pipeline Register              ║
// ╚══════════════════════════════════════════════════╝

EX_MEM_Reg EXMEM(
    .clk(clk), .reset(reset), .flush(flush_EXMEM),
    // Control in
    .MemtoReg_in(MemtoReg_EX), .RegWrite_in(RegWrite_EX),
    .MemRead_in(MemRead_EX), .MemWrite_in(MemWrite_EX), .Branch_in(Branch_EX),
    // Data in
    .zero_in(zero_EX),
    .ALU_result_in(ALU_result_EX),
    .RD2_in(ForwardB_data_EX),    // ← forwarded value for store data (was RD2_EX)
    .BranchTarget_in(BranchTarget_EX),
    .RD_in(RD_EX),
    // Control out
    .MemtoReg_out(MemtoReg_MEM), .RegWrite_out(RegWrite_MEM),
    .MemRead_out(MemRead_MEM), .MemWrite_out(MemWrite_MEM), .Branch_out(Branch_MEM),
    // Data out
    .zero_out(zero_MEM),
    .ALU_result_out(ALU_result_MEM), .RD2_out(RD2_MEM), .BranchTarget_out(BranchTarget_MEM),
    .RD_out(RD_MEM)
);


// ╔══════════════════════════════════════════════════╗
// ║                MEM — MEMORY                       ║
// ╚══════════════════════════════════════════════════╝

// Data Memory
Data_Memory Data_mem(
    .clk(clk), .reset(reset),
    .MemWrite(MemWrite_MEM),
    .MemRead(MemRead_MEM),
    .read_address(ALU_result_MEM),
    .Write_data(RD2_MEM),
    .MemData_out(MemData_MEM)
);

// Branch decision: Branch AND zero → PCSrc
AND_logic AND_branch(
    .branch(Branch_MEM),
    .zero(zero_MEM),
    .and_out(PCSrc_MEM)
);

// PC source mux: PC+4 or branch target
Mux2 PC_mux(
    .sel2(PCSrc_MEM),
    .A2(PCplus4_IF),
    .B2(BranchTarget_MEM),
    .Mux2_Out(PC_next)
);


// ╔══════════════════════════════════════════════════╗
// ║             MEM/WB Pipeline Register              ║
// ╚══════════════════════════════════════════════════╝

MEM_WB_Reg MEMWB(
    .clk(clk), .reset(reset),
    // Control in
    .MemtoReg_in(MemtoReg_MEM), .RegWrite_in(RegWrite_MEM),
    // Data in
    .ALU_result_in(ALU_result_MEM), .MemData_in(MemData_MEM),
    .RD_in(RD_MEM),
    // Control out
    .MemtoReg_out(MemtoReg_WB), .RegWrite_out(RegWrite_WB),
    // Data out
    .ALU_result_out(ALU_result_WB), .MemData_out(MemData_WB),
    .RD_out(RD_WB)
);


// ╔══════════════════════════════════════════════════╗
// ║               WB — WRITEBACK                      ║
// ╚══════════════════════════════════════════════════╝

// Writeback mux: ALU result or memory data
Mux3 WB_mux(
    .sel3(MemtoReg_WB),
    .A3(ALU_result_WB),
    .B3(MemData_WB),
    .Mux3_Out(WriteBack_WB)
);

// Register file write port is connected above in Reg_File instantiation:
//   .RegWrite(RegWrite_WB), .Rd(RD_WB), .Write_data(WriteBack_WB)

endmodule



// ══════════════════════════════════════════════════════════════
// Pipeline Testbench — Steps 5–7
// Tests forwarding, load-use stalling, and branch flushing.
//
// PIPELINE TIMING REMINDER:
//   With no hazards, I_Mem[N] writes back at posedge (N+6).
//   Load-use adds 1 stall cycle to all subsequent instructions.
//   Branch taken flushes 3 instructions (3-cycle penalty).
// ══════════════════════════════════════════════════════════════
module tb_top;

reg clk, reset;

top uut(.clk(clk), .reset(reset));

integer pass_count, fail_count;

initial begin
    clk = 0;
    reset = 1;
    pass_count = 0;
    fail_count = 0;
    #10;
    reset = 0;

    // ── Initialize registers ────────────────────────────────
    uut.Reg_File.Registers[0]  = 0;
    uut.Reg_File.Registers[1]  = 5;
    uut.Reg_File.Registers[2]  = 10;
    uut.Reg_File.Registers[3]  = 15;
    uut.Reg_File.Registers[4]  = 20;
    uut.Reg_File.Registers[5]  = 3;
    uut.Reg_File.Registers[6]  = 7;
    uut.Reg_File.Registers[7]  = 0;
    uut.Reg_File.Registers[8]  = 0;
    uut.Reg_File.Registers[9]  = 0;
    uut.Reg_File.Registers[10] = 100;
    uut.Reg_File.Registers[11] = 0;
    uut.Reg_File.Registers[12] = 0;
    uut.Reg_File.Registers[13] = 0;
    uut.Reg_File.Registers[14] = 0;
    uut.Reg_File.Registers[15] = 0;
    uut.Reg_File.Registers[16] = 0;
    uut.Reg_File.Registers[17] = 0;
    uut.Reg_File.Registers[18] = 0;
    uut.Reg_File.Registers[19] = 0;
    uut.Reg_File.Registers[20] = 0;

    // ══════════════════════════════════════════════════════════
    // TEST GROUP 1: FORWARDING (Steps 5)
    // Back-to-back dependent instructions — forwarding resolves
    // the hazard without any stalls.
    //
    // I[0]: NOP
    // I[1]: add  x7,  x1,  x2    → 5+10=15     → x7=15
    // I[2]: sub  x8,  x7,  x3    → 15-15=0     → x8=0  (forward x7 from MEM)
    // I[3]: and  x9,  x7,  x4    → 15 & 20=4   → x9=4  (forward x7 from WB)
    // I[4]: or   x11, x8,  x5    → 0 | 3=3     → x11=3 (forward x8 from WB)
    // I[5]: add  x12, x1,  x1    → 5+5=10      → x12=10 (independent)
    //
    // === TEST GROUP 2: LOAD-USE HAZARD (Step 6) ===
    // I[6]: lw   x13, 4(x0)      → D_Mem[4]=42 → x13=42
    // I[7]: add  x14, x13, x1    → 42+5=47     → x14=47 (STALL 1 cycle, then forward)
    // I[8]: add  x15, x14, x2    → 47+10=57    → x15=57 (forward x14 from MEM)
    //
    // === TEST GROUP 3: BRANCH (Step 7) ===
    // I[9]:  add  x16, x5, x6    → 3+7=10      → x16=10
    // I[10]: beq  x5, x5, 12     → branch taken (x5==x5), jump to I[13]
    // I[11]: add  x17, x1, x1    → SHOULD BE FLUSHED (10 if not)
    // I[12]: add  x18, x2, x2    → SHOULD BE FLUSHED (20 if not)
    // I[13]: add  x19, x3, x4    → 15+20=35    → x19=35 (branch target)
    // ══════════════════════════════════════════════════════════

    // ── Group 1: Forwarding tests ───────────────────────────
    uut.Inst_Memory.I_Mem[0]  = 32'h00000000;                                // NOP
    uut.Inst_Memory.I_Mem[1]  = 32'b0000000_00010_00001_000_00111_0110011;    // add x7, x1, x2
    uut.Inst_Memory.I_Mem[2]  = 32'b0100000_00011_00111_000_01000_0110011;    // sub x8, x7, x3
    uut.Inst_Memory.I_Mem[3]  = 32'b0000000_00100_00111_111_01001_0110011;    // and x9, x7, x4
    uut.Inst_Memory.I_Mem[4]  = 32'b0000000_00101_01000_110_01011_0110011;    // or  x11, x8, x5
    uut.Inst_Memory.I_Mem[5]  = 32'b0000000_00001_00001_000_01100_0110011;    // add x12, x1, x1

    // ── Group 2: Load-use test ──────────────────────────────
    uut.Inst_Memory.I_Mem[6]  = 32'b000000000100_00000_010_01101_0000011;     // lw  x13, 4(x0)
    uut.Inst_Memory.I_Mem[7]  = 32'b0000000_00001_01101_000_01110_0110011;    // add x14, x13, x1
    uut.Inst_Memory.I_Mem[8]  = 32'b0000000_00010_01110_000_01111_0110011;    // add x15, x14, x2

    // ── Group 3: Branch test ────────────────────────────────
    uut.Inst_Memory.I_Mem[9]  = 32'b0000000_00110_00101_000_10000_0110011;    // add x16, x5, x6
    uut.Inst_Memory.I_Mem[10] = 32'b0000000_00101_00101_000_01100_1100011;    // beq x5, x5, 12
    uut.Inst_Memory.I_Mem[11] = 32'b0000000_00001_00001_000_10001_0110011;    // add x17, x1, x1 (FLUSHED)
    uut.Inst_Memory.I_Mem[12] = 32'b0000000_00010_00010_000_10010_0110011;    // add x18, x2, x2 (FLUSHED)
    uut.Inst_Memory.I_Mem[13] = 32'b0000000_00100_00011_000_10011_0110011;    // add x19, x3, x4

    // Pre-load data memory for load test
    // lw x13, 4(x0): address = 0+4 = 4 → D_Memory[4] = 42
    uut.Data_mem.D_Memory[4] = 32'd42;

    // ══════════════════════════════════════════════════════════
    // GROUP 1: FORWARDING TESTS
    // No stalls — pipeline runs at full speed
    // I_Mem[1] writes back at posedge 6
    // ══════════════════════════════════════════════════════════
    $display("");
    $display("══ GROUP 1: FORWARDING TESTS ═══════════════════");

    repeat(5) @(posedge clk);  // pipeline fills (NOP through)
    #1;

    @(posedge clk); #1;  // I[1] WB: add x7, x1, x2 → 5+10=15
    check(uut.Reg_File.Registers[7], 32'd15, "FWD: add x7=x1+x2");

    @(posedge clk); #1;  // I[2] WB: sub x8, x7, x3 → 15-15=0 (x7 forwarded from MEM)
    check(uut.Reg_File.Registers[8], 32'd0,  "FWD: sub x8=x7-x3");

    @(posedge clk); #1;  // I[3] WB: and x9, x7, x4 → 15&20=4 (x7 forwarded from WB)
    check(uut.Reg_File.Registers[9], 32'd4,  "FWD: and x9=x7&x4");

    @(posedge clk); #1;  // I[4] WB: or x11, x8, x5 → 0|3=3 (x8 forwarded from WB)
    check(uut.Reg_File.Registers[11], 32'd3, "FWD: or x11=x8|x5");

    @(posedge clk); #1;  // I[5] WB: add x12, x1, x1 → 5+5=10
    check(uut.Reg_File.Registers[12], 32'd10, "FWD: add x12=x1+x1");

    // ══════════════════════════════════════════════════════════
    // GROUP 2: LOAD-USE HAZARD TEST
    // I[6] is a LW. I[7] reads x13 (the loaded value).
    // The hazard unit inserts 1 stall cycle.
    // So I[7]'s WB is delayed by 1 cycle.
    // ══════════════════════════════════════════════════════════
    $display("");
    $display("══ GROUP 2: LOAD-USE HAZARD TEST ═════════════════");

    @(posedge clk); #1;  // I[6] WB: lw x13, 4(x0) → D_Mem[4]=42
    check(uut.Reg_File.Registers[13], 32'd42, "LU: lw x13=Mem[4]");

    // I[7] had a 1-cycle stall, so it arrives 1 cycle later than normal
    @(posedge clk); #1;  // stall bubble passes through
    @(posedge clk); #1;  // I[7] WB: add x14, x13, x1 → 42+5=47
    check(uut.Reg_File.Registers[14], 32'd47, "LU: add x14=x13+x1");

    @(posedge clk); #1;  // I[8] WB: add x15, x14, x2 → 47+10=57
    check(uut.Reg_File.Registers[15], 32'd57, "LU: add x15=x14+x2");

    // ══════════════════════════════════════════════════════════
    // GROUP 3: BRANCH TEST
    // I[10] is beq x5,x5,12 — branch taken.
    // I[11] and I[12] should be flushed (x17 and x18 stay 0).
    // I[13] is the branch target (add x19).
    // Branch penalty is 3 cycles (flush IF/ID, ID/EX, EX/MEM).
    // ══════════════════════════════════════════════════════════
    $display("");
    $display("══ GROUP 3: BRANCH TEST ═════════════════════════");

    @(posedge clk); #1;  // I[9] WB: add x16, x5, x6 → 3+7=10
    check(uut.Reg_File.Registers[16], 32'd10, "BR: add x16=x5+x6");

    // I[10] (beq) goes through pipeline — when it reaches MEM,
    // PCSrc_MEM=1, flushing I[11], I[12], and whatever is in EX/MEM.
    // The branch target I[13] gets fetched after the flush.
    // We need to wait for the flushed bubbles + I[13] to reach WB.

    // Wait for branch to resolve and flushed instructions to pass
    repeat(4) @(posedge clk); #1;

    // Verify flushed instructions did NOT write
    check(uut.Reg_File.Registers[17], 32'd0, "BR: x17 flushed=0");
    check(uut.Reg_File.Registers[18], 32'd0, "BR: x18 flushed=0");

    // Wait for branch target instruction to write back
    repeat(3) @(posedge clk); #1;
    check(uut.Reg_File.Registers[19], 32'd35, "BR: add x19=x3+x4");

    // ══════════════════════════════════════════════════════════
    $display("");
    $display("══════════════════════════════════════════════════");
    $display("Results: %0d PASS, %0d FAIL", pass_count, fail_count);
    $display("══════════════════════════════════════════════════");
    $stop;
end

// Self-checking task — prints PASS or FAIL for each test
task check;
    input [31:0] actual;
    input [31:0] expected;
    input [63:0] label;
    begin
        if (actual === expected) begin
            $display("PASS | %-20s | got %0d", label, actual);
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL | %-20s | expected %0d | got %0d", 
                      label, expected, actual);
            fail_count = fail_count + 1;
        end
    end
endtask

always begin
    #5 clk = ~clk;
end

endmodule

