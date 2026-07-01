// ══════════════════════════════════════════════════════════════
// Single-Cycle Top Module
//
// The simplest possible RV32I datapath: every instruction
// completes in one clock cycle. Built from the same shared
// modules in rtl/common/ as the pipelined core — the only
// difference is the wiring: no pipeline registers, no forwarding,
// no hazard detection. Everything flows combinationally from the
// PC to the writeback mux within a single cycle; state (PC,
// register file, data memory) updates on the clock edge.
//
//   PC → I-Mem → Decode (RegFile / ImmGen / Control)
//      → ALU → Data Memory → Writeback mux → RegFile
//
// Branches resolve in the same cycle: (Branch AND zero) selects
// PC+Imm instead of PC+4, so no flushing is ever needed.
// ══════════════════════════════════════════════════════════════
module Single_Cycle_Top(
    input clk, reset
);

// ── Fetch ───────────────────────────────────────────
wire [31:0] PC;             // current PC
wire [31:0] PCplus4;        // PC + 4
wire [31:0] PC_next;        // next PC (PC+4 or branch target)
wire [31:0] instruction;    // fetched instruction

// ── Decode ──────────────────────────────────────────
wire [31:0] RD1, RD2;       // register file read data
wire [31:0] ImmExt;         // sign-extended immediate
wire        Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
wire        Jump, JALR;     // jal / jalr
wire [1:0]  ALUOp;

// ── Execute ─────────────────────────────────────────
wire [3:0]  ALU_ctrl;
wire [31:0] ALU_mux_out;    // RD2 or immediate
wire [31:0] ALU_result;
wire        zero;
wire [31:0] BranchTarget;   // PC + immediate
wire        PCSrc;          // branch taken
wire [31:0] jump_target;    // jal: PC+imm, jalr: rs1+imm
wire        pc_redirect;    // branch taken OR jump

// ── Memory / Writeback ──────────────────────────────
wire [31:0] MemData;
wire [31:0] WriteBack;

// Program Counter (stall tied off — nothing ever stalls here)
Program_counter PC_reg(
    .clk(clk), .reset(reset),
    .stall(1'b0),
    .PC_in(PC_next),
    .PC_out(PC)
);

PCplus4 PC_Adder(
    .fromPC(PC),
    .NextoPC(PCplus4)
);

Instruction_Mem Inst_Memory(
    .clk(clk), .reset(reset),
    .read_address(PC),
    .instruction_out(instruction)
);

// WRITE_BYPASS=0: single-cycle reads must return the pre-edge
// register value (see reg_file.v)
Reg_File #(.WRITE_BYPASS(0)) Reg_File(
    .clk(clk), .reset(reset),
    .RegWrite(RegWrite),
    .Rs1(instruction[19:15]),
    .Rs2(instruction[24:20]),
    .Rd(instruction[11:7]),
    .Write_data(WriteBack),
    .read_data1(RD1),
    .read_data2(RD2)
);

ImmGen ImmGen(
    .Opcode(instruction[6:0]),
    .instruction(instruction),
    .ImmExt(ImmExt)
);

Control_Unit Control_Unit(
    .instruction(instruction[6:0]),
    .Branch(Branch),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .ALUOp(ALUOp),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .Jump(Jump),
    .JALR(JALR)
);

ALU_Control ALU_Control(
    .ALUOp(ALUOp),
    .fun7(instruction[30]),
    .fun3(instruction[14:12]),
    .Control_out(ALU_ctrl)
);

// ALU input B: register value or immediate
Mux1 ALU_mux(
    .sel1(ALUSrc),
    .A1(RD2),
    .B1(ImmExt),
    .Mux1_Out(ALU_mux_out)
);

ALU ALU(
    .A(RD1),
    .B(ALU_mux_out),
    .Control_in(ALU_ctrl),
    .ALU_Result(ALU_result),
    .zero(zero)
);

// Branch target: PC + immediate
Adder BranchAdder(
    .in_1(PC),
    .in_2(ImmExt),
    .Sum_out(BranchTarget)
);

AND_logic AND_branch(
    .branch(Branch),
    .zero(zero),
    .and_out(PCSrc)
);

// Jumps redirect unconditionally. jal targets PC+imm (the branch
// adder output); jalr targets rs1+imm (the ALU result, bit 0
// cleared per the RISC-V spec).
assign jump_target = JALR ? (ALU_result & 32'hFFFFFFFE) : BranchTarget;
assign pc_redirect = PCSrc | Jump;

Mux2 PC_mux(
    .sel2(pc_redirect),
    .A2(PCplus4),
    .B2(jump_target),
    .Mux2_Out(PC_next)
);

Data_Memory Data_mem(
    .clk(clk), .reset(reset),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .read_address(ALU_result),
    .Write_data(RD2),
    .MemData_out(MemData)
);

// Writeback: ALU result or loaded data; jumps write the link
// value (PC+4) into rd instead
wire [31:0] WB_pre;
Mux3 WB_mux(
    .sel3(MemtoReg),
    .A3(ALU_result),
    .B3(MemData),
    .Mux3_Out(WB_pre)
);
assign WriteBack = Jump ? PCplus4 : WB_pre;

endmodule
