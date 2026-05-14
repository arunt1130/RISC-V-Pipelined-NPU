// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtop.h for the primary calling header

#ifndef VERILATED_VTOP___024ROOT_H_
#define VERILATED_VTOP___024ROOT_H_  // guard

#include "verilated.h"


class Vtop__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtop___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    // Anonymous structures to workaround compiler member-count bugs
    struct {
        VL_IN8(clk,0,0);
        VL_IN8(reset,0,0);
        VL_OUT8(host_tx_valid,0,0);
        CData/*0:0*/ top__DOT__stall_hazard;
        CData/*0:0*/ top__DOT__flush_IFID;
        CData/*0:0*/ top__DOT__flush_IDEX;
        CData/*0:0*/ top__DOT__ALUSrc_ID;
        CData/*0:0*/ top__DOT__MemtoReg_ID;
        CData/*0:0*/ top__DOT__RegWrite_ID;
        CData/*0:0*/ top__DOT__MemRead_ID;
        CData/*0:0*/ top__DOT__MemWrite_ID;
        CData/*0:0*/ top__DOT__Branch_ID;
        CData/*1:0*/ top__DOT__ALUOp_ID;
        CData/*0:0*/ top__DOT__fun7_EX;
        CData/*2:0*/ top__DOT__fun3_EX;
        CData/*4:0*/ top__DOT__RS1_EX;
        CData/*4:0*/ top__DOT__RS2_EX;
        CData/*4:0*/ top__DOT__RD_EX;
        CData/*0:0*/ top__DOT__ALUSrc_EX;
        CData/*0:0*/ top__DOT__MemtoReg_EX;
        CData/*0:0*/ top__DOT__RegWrite_EX;
        CData/*0:0*/ top__DOT__MemRead_EX;
        CData/*0:0*/ top__DOT__MemWrite_EX;
        CData/*0:0*/ top__DOT__Branch_EX;
        CData/*1:0*/ top__DOT__ALUOp_EX;
        CData/*0:0*/ top__DOT__zero_EX;
        CData/*0:0*/ top__DOT__MemtoReg_MEM;
        CData/*0:0*/ top__DOT__RegWrite_MEM;
        CData/*0:0*/ top__DOT__MemRead_MEM;
        CData/*0:0*/ top__DOT__MemWrite_MEM;
        CData/*0:0*/ top__DOT__Branch_MEM;
        CData/*0:0*/ top__DOT__zero_MEM;
        CData/*4:0*/ top__DOT__RD_MEM;
        CData/*0:0*/ top__DOT__npu_select;
        CData/*0:0*/ top__DOT__dmem_select;
        CData/*0:0*/ top__DOT__npu_MemWrite;
        CData/*0:0*/ top__DOT__MemtoReg_WB;
        CData/*0:0*/ top__DOT__RegWrite_WB;
        CData/*4:0*/ top__DOT__RD_WB;
        CData/*0:0*/ top__DOT__Reg_File__DOT____VdfgTmp_h6aa9bfce__0;
        CData/*1:0*/ top__DOT__npu__DOT__state;
        CData/*3:0*/ top__DOT__npu__DOT__cycle_count;
        CData/*7:0*/ top__DOT__npu__DOT__left_in_0;
        CData/*7:0*/ top__DOT__npu__DOT__left_in_1;
        CData/*7:0*/ top__DOT__npu__DOT__left_in_2;
        CData/*7:0*/ top__DOT__npu__DOT__left_in_3;
        CData/*7:0*/ top__DOT__npu__DOT__top_in_0;
        CData/*7:0*/ top__DOT__npu__DOT__top_in_1;
        CData/*7:0*/ top__DOT__npu__DOT__top_in_2;
        CData/*7:0*/ top__DOT__npu__DOT__top_in_3;
        CData/*7:0*/ top__DOT__npu__DOT__sa__DOT__a_r_0_0;
        CData/*7:0*/ top__DOT__npu__DOT__sa__DOT__a_r_0_1;
        CData/*7:0*/ top__DOT__npu__DOT__sa__DOT__a_r_0_2;
        CData/*7:0*/ top__DOT__npu__DOT__sa__DOT__a_r_1_0;
        CData/*7:0*/ top__DOT__npu__DOT__sa__DOT__a_r_1_1;
        CData/*7:0*/ top__DOT__npu__DOT__sa__DOT__a_r_1_2;
        CData/*7:0*/ top__DOT__npu__DOT__sa__DOT__a_r_2_0;
        CData/*7:0*/ top__DOT__npu__DOT__sa__DOT__a_r_2_1;
        CData/*7:0*/ top__DOT__npu__DOT__sa__DOT__a_r_2_2;
        CData/*7:0*/ top__DOT__npu__DOT__sa__DOT__a_r_3_0;
        CData/*7:0*/ top__DOT__npu__DOT__sa__DOT__a_r_3_1;
        CData/*7:0*/ top__DOT__npu__DOT__sa__DOT__a_r_3_2;
        CData/*7:0*/ top__DOT__npu__DOT__sa__DOT__b_d_0_0;
        CData/*7:0*/ top__DOT__npu__DOT__sa__DOT__b_d_0_1;
    };
    struct {
        CData/*7:0*/ top__DOT__npu__DOT__sa__DOT__b_d_0_2;
        CData/*7:0*/ top__DOT__npu__DOT__sa__DOT__b_d_0_3;
        CData/*7:0*/ top__DOT__npu__DOT__sa__DOT__b_d_1_0;
        CData/*7:0*/ top__DOT__npu__DOT__sa__DOT__b_d_1_1;
        CData/*7:0*/ top__DOT__npu__DOT__sa__DOT__b_d_1_2;
        CData/*7:0*/ top__DOT__npu__DOT__sa__DOT__b_d_1_3;
        CData/*7:0*/ top__DOT__npu__DOT__sa__DOT__b_d_2_0;
        CData/*7:0*/ top__DOT__npu__DOT__sa__DOT__b_d_2_1;
        CData/*7:0*/ top__DOT__npu__DOT__sa__DOT__b_d_2_2;
        CData/*7:0*/ top__DOT__npu__DOT__sa__DOT__b_d_2_3;
        CData/*0:0*/ __VstlFirstIteration;
        CData/*0:0*/ __VicoFirstIteration;
        CData/*0:0*/ __Vtrigprevexpr___TOP__clk__0;
        CData/*0:0*/ __Vtrigprevexpr___TOP__reset__0;
        CData/*0:0*/ __VactContinue;
        VL_OUT(host_tx_data,31,0);
        VL_IN(host_rx_data,31,0);
        IData/*31:0*/ top__DOT__PC_IF;
        IData/*31:0*/ top__DOT__PC_next;
        IData/*31:0*/ top__DOT__PC_ID;
        IData/*31:0*/ top__DOT__instruction_ID;
        IData/*31:0*/ top__DOT__ImmExt_ID;
        IData/*31:0*/ top__DOT__PC_EX;
        IData/*31:0*/ top__DOT__RD1_EX;
        IData/*31:0*/ top__DOT__RD2_EX;
        IData/*31:0*/ top__DOT__ImmExt_EX;
        IData/*31:0*/ top__DOT__ForwardB_data_EX;
        IData/*31:0*/ top__DOT__ALU_result_EX;
        IData/*31:0*/ top__DOT__ALU_result_MEM;
        IData/*31:0*/ top__DOT__RD2_MEM;
        IData/*31:0*/ top__DOT__BranchTarget_MEM;
        IData/*31:0*/ top__DOT__MemData_MEM;
        IData/*31:0*/ top__DOT__ALU_result_WB;
        IData/*31:0*/ top__DOT__MemData_WB;
        IData/*31:0*/ top__DOT__WriteBack_WB;
        VlWide<64>/*2047:0*/ top__DOT__Inst_Memory__DOT__fw_file;
        IData/*31:0*/ top__DOT__npu__DOT__sa__DOT__acc_0_0;
        IData/*31:0*/ top__DOT__npu__DOT__sa__DOT__acc_0_1;
        IData/*31:0*/ top__DOT__npu__DOT__sa__DOT__acc_0_2;
        IData/*31:0*/ top__DOT__npu__DOT__sa__DOT__acc_0_3;
        IData/*31:0*/ top__DOT__npu__DOT__sa__DOT__acc_1_0;
        IData/*31:0*/ top__DOT__npu__DOT__sa__DOT__acc_1_1;
        IData/*31:0*/ top__DOT__npu__DOT__sa__DOT__acc_1_2;
        IData/*31:0*/ top__DOT__npu__DOT__sa__DOT__acc_1_3;
        IData/*31:0*/ top__DOT__npu__DOT__sa__DOT__acc_2_0;
        IData/*31:0*/ top__DOT__npu__DOT__sa__DOT__acc_2_1;
        IData/*31:0*/ top__DOT__npu__DOT__sa__DOT__acc_2_2;
        IData/*31:0*/ top__DOT__npu__DOT__sa__DOT__acc_2_3;
        IData/*31:0*/ top__DOT__npu__DOT__sa__DOT__acc_3_0;
        IData/*31:0*/ top__DOT__npu__DOT__sa__DOT__acc_3_1;
        IData/*31:0*/ top__DOT__npu__DOT__sa__DOT__acc_3_2;
        IData/*31:0*/ top__DOT__npu__DOT__sa__DOT__acc_3_3;
        IData/*31:0*/ __VactIterCount;
        VlUnpacked<IData/*31:0*/, 64> top__DOT__Inst_Memory__DOT__I_Mem;
        VlUnpacked<IData/*31:0*/, 32> top__DOT__Reg_File__DOT__Registers;
        VlUnpacked<IData/*31:0*/, 64> top__DOT__Data_mem__DOT__D_Memory;
        VlUnpacked<CData/*7:0*/, 16> top__DOT__npu__DOT__A_reg;
        VlUnpacked<CData/*7:0*/, 16> top__DOT__npu__DOT__B_reg;
    };
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VicoTriggered;
    VlTriggerVec<2> __VactTriggered;
    VlTriggerVec<2> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vtop__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vtop___024root(Vtop__Syms* symsp, const char* v__name);
    ~Vtop___024root();
    VL_UNCOPYABLE(Vtop___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
