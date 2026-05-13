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
wire [31:0] MemData_MEM;       // muxed read output (data memory OR NPU)
wire        PCSrc_MEM;          // branch AND zero → selects branch target

// Step 8+9: NPU address decoding
// Bit 8 of the address selects the device:
//   0 = Data Memory (addresses 0–255)
//   1 = NPU         (addresses 256+)
wire        npu_select = ALU_result_MEM[8];
wire        dmem_MemWrite = MemWrite_MEM & ~npu_select;
wire        dmem_MemRead  = MemRead_MEM  & ~npu_select;
wire        npu_MemWrite  = MemWrite_MEM &  npu_select;
wire        npu_MemRead   = MemRead_MEM  &  npu_select;
wire [31:0] dmem_data_out;     // data memory read output
wire [31:0] npu_data_out;      // NPU read output

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
// ║  (with NPU integration — Steps 8+9)               ║
// ╚══════════════════════════════════════════════════╝

// Data Memory — only active when address is in data memory range
Data_Memory Data_mem(
    .clk(clk), .reset(reset),
    .MemWrite(dmem_MemWrite),
    .MemRead(dmem_MemRead),
    .read_address(ALU_result_MEM),
    .Write_data(RD2_MEM),
    .MemData_out(dmem_data_out)
);

// NPU — only active when address is in NPU range (bit 8 set)
NPU_Top npu(
    .clk(clk), .reset(reset),
    .mem_write(npu_MemWrite),
    .mem_read(npu_MemRead),
    .address(ALU_result_MEM[7:0]),   // lower 8 bits as NPU offset
    .write_data(RD2_MEM),
    .read_data(npu_data_out)
);

// Mux read data: NPU or Data Memory based on address
assign MemData_MEM = npu_select ? npu_data_out : dmem_data_out;

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
