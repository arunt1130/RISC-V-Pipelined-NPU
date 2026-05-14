// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop__pch.h"
#include "Vtop___024root.h"

VL_INLINE_OPT void Vtop___024root___ico_sequent__TOP__0(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___ico_sequent__TOP__0\n"); );
    // Body
    vlSelf->top__DOT__MemData_MEM = ((0x200U & vlSelf->top__DOT__ALU_result_MEM)
                                      ? vlSelf->host_rx_data
                                      : ((IData)(vlSelf->top__DOT__npu_select)
                                          ? (((IData)(vlSelf->top__DOT__MemRead_MEM) 
                                              & (IData)(vlSelf->top__DOT__npu_select))
                                              ? ((0xfU 
                                                  >= 
                                                  (0xffU 
                                                   & vlSelf->top__DOT__ALU_result_MEM))
                                                  ? 
                                                 vlSelf->top__DOT__npu__DOT__A_reg
                                                 [(0xfU 
                                                   & vlSelf->top__DOT__ALU_result_MEM)]
                                                  : 
                                                 (((0x10U 
                                                    <= 
                                                    (0xffU 
                                                     & vlSelf->top__DOT__ALU_result_MEM)) 
                                                   & (0x1fU 
                                                      >= 
                                                      (0xffU 
                                                       & vlSelf->top__DOT__ALU_result_MEM)))
                                                   ? 
                                                  vlSelf->top__DOT__npu__DOT__B_reg
                                                  [
                                                  (0xfU 
                                                   & vlSelf->top__DOT__ALU_result_MEM)]
                                                   : 
                                                  (((0x20U 
                                                     <= 
                                                     (0xffU 
                                                      & vlSelf->top__DOT__ALU_result_MEM)) 
                                                    & (0x2fU 
                                                       >= 
                                                       (0xffU 
                                                        & vlSelf->top__DOT__ALU_result_MEM)))
                                                    ? 
                                                   ((8U 
                                                     & vlSelf->top__DOT__ALU_result_MEM)
                                                     ? 
                                                    ((4U 
                                                      & vlSelf->top__DOT__ALU_result_MEM)
                                                      ? 
                                                     ((2U 
                                                       & vlSelf->top__DOT__ALU_result_MEM)
                                                       ? 
                                                      ((1U 
                                                        & vlSelf->top__DOT__ALU_result_MEM)
                                                        ? vlSelf->top__DOT__npu__DOT__sa__DOT__acc_3_3
                                                        : vlSelf->top__DOT__npu__DOT__sa__DOT__acc_3_2)
                                                       : 
                                                      ((1U 
                                                        & vlSelf->top__DOT__ALU_result_MEM)
                                                        ? vlSelf->top__DOT__npu__DOT__sa__DOT__acc_3_1
                                                        : vlSelf->top__DOT__npu__DOT__sa__DOT__acc_3_0))
                                                      : 
                                                     ((2U 
                                                       & vlSelf->top__DOT__ALU_result_MEM)
                                                       ? 
                                                      ((1U 
                                                        & vlSelf->top__DOT__ALU_result_MEM)
                                                        ? vlSelf->top__DOT__npu__DOT__sa__DOT__acc_2_3
                                                        : vlSelf->top__DOT__npu__DOT__sa__DOT__acc_2_2)
                                                       : 
                                                      ((1U 
                                                        & vlSelf->top__DOT__ALU_result_MEM)
                                                        ? vlSelf->top__DOT__npu__DOT__sa__DOT__acc_2_1
                                                        : vlSelf->top__DOT__npu__DOT__sa__DOT__acc_2_0)))
                                                     : 
                                                    ((4U 
                                                      & vlSelf->top__DOT__ALU_result_MEM)
                                                      ? 
                                                     ((2U 
                                                       & vlSelf->top__DOT__ALU_result_MEM)
                                                       ? 
                                                      ((1U 
                                                        & vlSelf->top__DOT__ALU_result_MEM)
                                                        ? vlSelf->top__DOT__npu__DOT__sa__DOT__acc_1_3
                                                        : vlSelf->top__DOT__npu__DOT__sa__DOT__acc_1_2)
                                                       : 
                                                      ((1U 
                                                        & vlSelf->top__DOT__ALU_result_MEM)
                                                        ? vlSelf->top__DOT__npu__DOT__sa__DOT__acc_1_1
                                                        : vlSelf->top__DOT__npu__DOT__sa__DOT__acc_1_0))
                                                      : 
                                                     ((2U 
                                                       & vlSelf->top__DOT__ALU_result_MEM)
                                                       ? 
                                                      ((1U 
                                                        & vlSelf->top__DOT__ALU_result_MEM)
                                                        ? vlSelf->top__DOT__npu__DOT__sa__DOT__acc_0_3
                                                        : vlSelf->top__DOT__npu__DOT__sa__DOT__acc_0_2)
                                                       : 
                                                      ((1U 
                                                        & vlSelf->top__DOT__ALU_result_MEM)
                                                        ? vlSelf->top__DOT__npu__DOT__sa__DOT__acc_0_1
                                                        : vlSelf->top__DOT__npu__DOT__sa__DOT__acc_0_0))))
                                                    : 
                                                   ((0x31U 
                                                     == 
                                                     (0xffU 
                                                      & vlSelf->top__DOT__ALU_result_MEM))
                                                     ? 
                                                    (3U 
                                                     == (IData)(vlSelf->top__DOT__npu__DOT__state))
                                                     : 0U))))
                                              : 0U)
                                          : (((IData)(vlSelf->top__DOT__MemRead_MEM) 
                                              & (IData)(vlSelf->top__DOT__dmem_select))
                                              ? vlSelf->top__DOT__Data_mem__DOT__D_Memory
                                             [(0x3fU 
                                               & vlSelf->top__DOT__ALU_result_MEM)]
                                              : 0U)));
}

void Vtop___024root___eval_ico(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_ico\n"); );
    // Body
    if ((1ULL & vlSelf->__VicoTriggered.word(0U))) {
        Vtop___024root___ico_sequent__TOP__0(vlSelf);
    }
}

void Vtop___024root___eval_triggers__ico(Vtop___024root* vlSelf);

bool Vtop___024root___eval_phase__ico(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_phase__ico\n"); );
    // Init
    CData/*0:0*/ __VicoExecute;
    // Body
    Vtop___024root___eval_triggers__ico(vlSelf);
    __VicoExecute = vlSelf->__VicoTriggered.any();
    if (__VicoExecute) {
        Vtop___024root___eval_ico(vlSelf);
    }
    return (__VicoExecute);
}

void Vtop___024root___eval_act(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_act\n"); );
}

extern const VlUnpacked<CData/*1:0*/, 256> Vtop__ConstPool__TABLE_h5c3900e3_0;
extern const VlUnpacked<CData/*1:0*/, 256> Vtop__ConstPool__TABLE_h323c7dac_0;
extern const VlUnpacked<CData/*3:0*/, 256> Vtop__ConstPool__TABLE_h3ec01428_0;
extern const VlUnpacked<CData/*3:0*/, 64> Vtop__ConstPool__TABLE_hba5961b7_0;
extern const VlUnpacked<CData/*0:0*/, 128> Vtop__ConstPool__TABLE_h75b8279d_0;
extern const VlUnpacked<CData/*0:0*/, 128> Vtop__ConstPool__TABLE_h7ca8bf9e_0;
extern const VlUnpacked<CData/*0:0*/, 128> Vtop__ConstPool__TABLE_h4608f605_0;
extern const VlUnpacked<CData/*0:0*/, 128> Vtop__ConstPool__TABLE_ha96ed2bf_0;
extern const VlUnpacked<CData/*0:0*/, 128> Vtop__ConstPool__TABLE_he4685dc5_0;
extern const VlUnpacked<CData/*1:0*/, 128> Vtop__ConstPool__TABLE_ha2dc09bf_0;

VL_INLINE_OPT void Vtop___024root___nba_sequent__TOP__0(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___nba_sequent__TOP__0\n"); );
    // Init
    IData/*31:0*/ top__DOT__ForwardA_data_EX;
    top__DOT__ForwardA_data_EX = 0;
    IData/*31:0*/ __Vilp;
    CData/*1:0*/ top__DOT__ForwardA_sel;
    top__DOT__ForwardA_sel = 0;
    CData/*1:0*/ top__DOT__ForwardB_sel;
    top__DOT__ForwardB_sel = 0;
    IData/*31:0*/ top__DOT__ALU_mux_out_EX;
    top__DOT__ALU_mux_out_EX = 0;
    CData/*3:0*/ top__DOT__ALU_ctrl_EX;
    top__DOT__ALU_ctrl_EX = 0;
    CData/*6:0*/ __Vtableidx1;
    __Vtableidx1 = 0;
    CData/*5:0*/ __Vtableidx2;
    __Vtableidx2 = 0;
    CData/*7:0*/ __Vtableidx3;
    __Vtableidx3 = 0;
    CData/*0:0*/ __Vdlyvset__top__DOT__Inst_Memory__DOT__I_Mem__v0;
    __Vdlyvset__top__DOT__Inst_Memory__DOT__I_Mem__v0 = 0;
    CData/*0:0*/ __Vdlyvset__top__DOT__Reg_File__DOT__Registers__v0;
    __Vdlyvset__top__DOT__Reg_File__DOT__Registers__v0 = 0;
    CData/*4:0*/ __Vdlyvdim0__top__DOT__Reg_File__DOT__Registers__v32;
    __Vdlyvdim0__top__DOT__Reg_File__DOT__Registers__v32 = 0;
    IData/*31:0*/ __Vdlyvval__top__DOT__Reg_File__DOT__Registers__v32;
    __Vdlyvval__top__DOT__Reg_File__DOT__Registers__v32 = 0;
    CData/*0:0*/ __Vdlyvset__top__DOT__Reg_File__DOT__Registers__v32;
    __Vdlyvset__top__DOT__Reg_File__DOT__Registers__v32 = 0;
    CData/*0:0*/ __Vdlyvset__top__DOT__Data_mem__DOT__D_Memory__v0;
    __Vdlyvset__top__DOT__Data_mem__DOT__D_Memory__v0 = 0;
    CData/*5:0*/ __Vdlyvdim0__top__DOT__Data_mem__DOT__D_Memory__v64;
    __Vdlyvdim0__top__DOT__Data_mem__DOT__D_Memory__v64 = 0;
    IData/*31:0*/ __Vdlyvval__top__DOT__Data_mem__DOT__D_Memory__v64;
    __Vdlyvval__top__DOT__Data_mem__DOT__D_Memory__v64 = 0;
    CData/*0:0*/ __Vdlyvset__top__DOT__Data_mem__DOT__D_Memory__v64;
    __Vdlyvset__top__DOT__Data_mem__DOT__D_Memory__v64 = 0;
    CData/*1:0*/ __Vdly__top__DOT__npu__DOT__state;
    __Vdly__top__DOT__npu__DOT__state = 0;
    CData/*0:0*/ __Vdlyvset__top__DOT__npu__DOT__A_reg__v0;
    __Vdlyvset__top__DOT__npu__DOT__A_reg__v0 = 0;
    CData/*3:0*/ __Vdlyvdim0__top__DOT__npu__DOT__A_reg__v16;
    __Vdlyvdim0__top__DOT__npu__DOT__A_reg__v16 = 0;
    CData/*7:0*/ __Vdlyvval__top__DOT__npu__DOT__A_reg__v16;
    __Vdlyvval__top__DOT__npu__DOT__A_reg__v16 = 0;
    CData/*0:0*/ __Vdlyvset__top__DOT__npu__DOT__A_reg__v16;
    __Vdlyvset__top__DOT__npu__DOT__A_reg__v16 = 0;
    CData/*0:0*/ __Vdlyvset__top__DOT__npu__DOT__B_reg__v0;
    __Vdlyvset__top__DOT__npu__DOT__B_reg__v0 = 0;
    CData/*3:0*/ __Vdlyvdim0__top__DOT__npu__DOT__B_reg__v16;
    __Vdlyvdim0__top__DOT__npu__DOT__B_reg__v16 = 0;
    CData/*7:0*/ __Vdlyvval__top__DOT__npu__DOT__B_reg__v16;
    __Vdlyvval__top__DOT__npu__DOT__B_reg__v16 = 0;
    CData/*0:0*/ __Vdlyvset__top__DOT__npu__DOT__B_reg__v16;
    __Vdlyvset__top__DOT__npu__DOT__B_reg__v16 = 0;
    IData/*31:0*/ __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_0;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_0 = 0;
    IData/*31:0*/ __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_1;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_1 = 0;
    IData/*31:0*/ __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_2;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_2 = 0;
    IData/*31:0*/ __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_3;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_3 = 0;
    IData/*31:0*/ __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_0;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_0 = 0;
    IData/*31:0*/ __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_1;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_1 = 0;
    IData/*31:0*/ __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_2;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_2 = 0;
    IData/*31:0*/ __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_3;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_3 = 0;
    IData/*31:0*/ __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_0;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_0 = 0;
    IData/*31:0*/ __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_1;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_1 = 0;
    IData/*31:0*/ __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_2;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_2 = 0;
    IData/*31:0*/ __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_3;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_3 = 0;
    IData/*31:0*/ __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_0;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_0 = 0;
    IData/*31:0*/ __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_1;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_1 = 0;
    IData/*31:0*/ __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_2;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_2 = 0;
    IData/*31:0*/ __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_3;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_3 = 0;
    // Body
    __Vdlyvset__top__DOT__Inst_Memory__DOT__I_Mem__v0 = 0U;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_0 = vlSelf->top__DOT__npu__DOT__sa__DOT__acc_0_0;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_0 = vlSelf->top__DOT__npu__DOT__sa__DOT__acc_1_0;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_1 = vlSelf->top__DOT__npu__DOT__sa__DOT__acc_0_1;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_0 = vlSelf->top__DOT__npu__DOT__sa__DOT__acc_2_0;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_1 = vlSelf->top__DOT__npu__DOT__sa__DOT__acc_1_1;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_2 = vlSelf->top__DOT__npu__DOT__sa__DOT__acc_0_2;
    __Vdlyvset__top__DOT__npu__DOT__B_reg__v0 = 0U;
    __Vdlyvset__top__DOT__npu__DOT__B_reg__v16 = 0U;
    __Vdlyvset__top__DOT__npu__DOT__A_reg__v0 = 0U;
    __Vdlyvset__top__DOT__npu__DOT__A_reg__v16 = 0U;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_0 = vlSelf->top__DOT__npu__DOT__sa__DOT__acc_3_0;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_3 = vlSelf->top__DOT__npu__DOT__sa__DOT__acc_0_3;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_1 = vlSelf->top__DOT__npu__DOT__sa__DOT__acc_2_1;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_2 = vlSelf->top__DOT__npu__DOT__sa__DOT__acc_1_2;
    __Vdly__top__DOT__npu__DOT__state = vlSelf->top__DOT__npu__DOT__state;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_1 = vlSelf->top__DOT__npu__DOT__sa__DOT__acc_3_1;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_3 = vlSelf->top__DOT__npu__DOT__sa__DOT__acc_1_3;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_2 = vlSelf->top__DOT__npu__DOT__sa__DOT__acc_2_2;
    __Vdlyvset__top__DOT__Data_mem__DOT__D_Memory__v0 = 0U;
    __Vdlyvset__top__DOT__Data_mem__DOT__D_Memory__v64 = 0U;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_2 = vlSelf->top__DOT__npu__DOT__sa__DOT__acc_3_2;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_3 = vlSelf->top__DOT__npu__DOT__sa__DOT__acc_2_3;
    __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_3 = vlSelf->top__DOT__npu__DOT__sa__DOT__acc_3_3;
    __Vdlyvset__top__DOT__Reg_File__DOT__Registers__v0 = 0U;
    __Vdlyvset__top__DOT__Reg_File__DOT__Registers__v32 = 0U;
    __Vtableidx3 = (((IData)(vlSelf->top__DOT__npu__DOT__cycle_count) 
                     << 4U) | ((((IData)(vlSelf->top__DOT__npu_MemWrite) 
                                 & ((0x30U == (0xffU 
                                               & vlSelf->top__DOT__ALU_result_MEM)) 
                                    & vlSelf->top__DOT__RD2_MEM)) 
                                << 3U) | (((IData)(vlSelf->top__DOT__npu__DOT__state) 
                                           << 1U) | (IData)(vlSelf->reset))));
    if ((1U & Vtop__ConstPool__TABLE_h5c3900e3_0[__Vtableidx3])) {
        __Vdly__top__DOT__npu__DOT__state = Vtop__ConstPool__TABLE_h323c7dac_0
            [__Vtableidx3];
    }
    if ((2U & Vtop__ConstPool__TABLE_h5c3900e3_0[__Vtableidx3])) {
        vlSelf->top__DOT__npu__DOT__cycle_count = Vtop__ConstPool__TABLE_h3ec01428_0
            [__Vtableidx3];
    }
    vlSelf->top__DOT__zero_MEM = ((1U & (~ ((IData)(vlSelf->reset) 
                                            | (IData)(vlSelf->top__DOT__flush_IFID)))) 
                                  && (IData)(vlSelf->top__DOT__zero_EX));
    vlSelf->top__DOT__ALUSrc_EX = ((1U & (~ ((IData)(vlSelf->reset) 
                                             | (IData)(vlSelf->top__DOT__flush_IDEX)))) 
                                   && (IData)(vlSelf->top__DOT__ALUSrc_ID));
    vlSelf->top__DOT__Branch_MEM = ((1U & (~ ((IData)(vlSelf->reset) 
                                              | (IData)(vlSelf->top__DOT__flush_IFID)))) 
                                    && (IData)(vlSelf->top__DOT__Branch_EX));
    vlSelf->top__DOT__MemRead_MEM = ((1U & (~ ((IData)(vlSelf->reset) 
                                               | (IData)(vlSelf->top__DOT__flush_IFID)))) 
                                     && (IData)(vlSelf->top__DOT__MemRead_EX));
    vlSelf->top__DOT__MemtoReg_WB = ((1U & (~ (IData)(vlSelf->reset))) 
                                     && (IData)(vlSelf->top__DOT__MemtoReg_MEM));
    vlSelf->top__DOT__fun7_EX = ((1U & (~ ((IData)(vlSelf->reset) 
                                           | (IData)(vlSelf->top__DOT__flush_IDEX)))) 
                                 && (1U & (vlSelf->top__DOT__instruction_ID 
                                           >> 0x1eU)));
    if (((IData)(vlSelf->reset) | (IData)(vlSelf->top__DOT__flush_IDEX))) {
        vlSelf->top__DOT__ALUOp_EX = 0U;
        vlSelf->top__DOT__fun3_EX = 0U;
        vlSelf->top__DOT__RS1_EX = 0U;
        vlSelf->top__DOT__RS2_EX = 0U;
        vlSelf->top__DOT__RD1_EX = 0U;
        vlSelf->top__DOT__RD2_EX = 0U;
    } else {
        vlSelf->top__DOT__ALUOp_EX = vlSelf->top__DOT__ALUOp_ID;
        vlSelf->top__DOT__fun3_EX = (7U & (vlSelf->top__DOT__instruction_ID 
                                           >> 0xcU));
        vlSelf->top__DOT__RS1_EX = (0x1fU & (vlSelf->top__DOT__instruction_ID 
                                             >> 0xfU));
        vlSelf->top__DOT__RS2_EX = (0x1fU & (vlSelf->top__DOT__instruction_ID 
                                             >> 0x14U));
        vlSelf->top__DOT__RD1_EX = (((IData)(vlSelf->top__DOT__Reg_File__DOT____VdfgTmp_h6aa9bfce__0) 
                                     & ((IData)(vlSelf->top__DOT__RD_WB) 
                                        == (0x1fU & 
                                            (vlSelf->top__DOT__instruction_ID 
                                             >> 0xfU))))
                                     ? vlSelf->top__DOT__WriteBack_WB
                                     : vlSelf->top__DOT__Reg_File__DOT__Registers
                                    [(0x1fU & (vlSelf->top__DOT__instruction_ID 
                                               >> 0xfU))]);
        vlSelf->top__DOT__RD2_EX = (((IData)(vlSelf->top__DOT__Reg_File__DOT____VdfgTmp_h6aa9bfce__0) 
                                     & ((IData)(vlSelf->top__DOT__RD_WB) 
                                        == (0x1fU & 
                                            (vlSelf->top__DOT__instruction_ID 
                                             >> 0x14U))))
                                     ? vlSelf->top__DOT__WriteBack_WB
                                     : vlSelf->top__DOT__Reg_File__DOT__Registers
                                    [(0x1fU & (vlSelf->top__DOT__instruction_ID 
                                               >> 0x14U))]);
    }
    vlSelf->top__DOT__BranchTarget_MEM = (((IData)(vlSelf->reset) 
                                           | (IData)(vlSelf->top__DOT__flush_IFID))
                                           ? 0U : (vlSelf->top__DOT__ImmExt_EX 
                                                   + vlSelf->top__DOT__PC_EX));
    if (((IData)(vlSelf->reset) | (IData)(vlSelf->top__DOT__flush_IDEX))) {
        vlSelf->top__DOT__ImmExt_EX = 0U;
        vlSelf->top__DOT__PC_EX = 0U;
    } else {
        vlSelf->top__DOT__ImmExt_EX = vlSelf->top__DOT__ImmExt_ID;
        vlSelf->top__DOT__PC_EX = vlSelf->top__DOT__PC_ID;
    }
    if (vlSelf->reset) {
        __Vdlyvset__top__DOT__Inst_Memory__DOT__I_Mem__v0 = 1U;
        __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_0 = 0U;
        __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_0 = 0U;
        __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_1 = 0U;
        __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_0 = 0U;
        __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_1 = 0U;
        __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_2 = 0U;
        __Vdlyvset__top__DOT__npu__DOT__B_reg__v0 = 1U;
        __Vdlyvset__top__DOT__npu__DOT__A_reg__v0 = 1U;
        __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_0 = 0U;
        __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_3 = 0U;
        __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_1 = 0U;
        __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_2 = 0U;
        __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_1 = 0U;
        __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_3 = 0U;
        __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_2 = 0U;
        __Vdlyvset__top__DOT__Data_mem__DOT__D_Memory__v0 = 1U;
    } else {
        if ((1U == (IData)(vlSelf->top__DOT__npu__DOT__state))) {
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_0 = 0U;
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_0 = 0U;
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_1 = 0U;
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_0 = 0U;
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_1 = 0U;
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_2 = 0U;
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_0 = 0U;
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_3 = 0U;
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_1 = 0U;
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_2 = 0U;
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_1 = 0U;
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_3 = 0U;
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_2 = 0U;
        } else if ((2U == (IData)(vlSelf->top__DOT__npu__DOT__state))) {
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_0 
                = (vlSelf->top__DOT__npu__DOT__sa__DOT__acc_0_0 
                   + ((IData)(vlSelf->top__DOT__npu__DOT__left_in_0) 
                      * (IData)(vlSelf->top__DOT__npu__DOT__top_in_0)));
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_0 
                = (vlSelf->top__DOT__npu__DOT__sa__DOT__acc_1_0 
                   + ((IData)(vlSelf->top__DOT__npu__DOT__left_in_1) 
                      * (IData)(vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_0_0)));
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_1 
                = (vlSelf->top__DOT__npu__DOT__sa__DOT__acc_0_1 
                   + ((IData)(vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_0_0) 
                      * (IData)(vlSelf->top__DOT__npu__DOT__top_in_1)));
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_0 
                = (vlSelf->top__DOT__npu__DOT__sa__DOT__acc_2_0 
                   + ((IData)(vlSelf->top__DOT__npu__DOT__left_in_2) 
                      * (IData)(vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_1_0)));
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_1 
                = (vlSelf->top__DOT__npu__DOT__sa__DOT__acc_1_1 
                   + ((IData)(vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_1_0) 
                      * (IData)(vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_0_1)));
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_2 
                = (vlSelf->top__DOT__npu__DOT__sa__DOT__acc_0_2 
                   + ((IData)(vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_0_1) 
                      * (IData)(vlSelf->top__DOT__npu__DOT__top_in_2)));
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_0 
                = (vlSelf->top__DOT__npu__DOT__sa__DOT__acc_3_0 
                   + ((IData)(vlSelf->top__DOT__npu__DOT__left_in_3) 
                      * (IData)(vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_2_0)));
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_3 
                = (vlSelf->top__DOT__npu__DOT__sa__DOT__acc_0_3 
                   + ((IData)(vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_0_2) 
                      * (IData)(vlSelf->top__DOT__npu__DOT__top_in_3)));
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_1 
                = (vlSelf->top__DOT__npu__DOT__sa__DOT__acc_2_1 
                   + ((IData)(vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_2_0) 
                      * (IData)(vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_1_1)));
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_2 
                = (vlSelf->top__DOT__npu__DOT__sa__DOT__acc_1_2 
                   + ((IData)(vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_1_1) 
                      * (IData)(vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_0_2)));
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_1 
                = (vlSelf->top__DOT__npu__DOT__sa__DOT__acc_3_1 
                   + ((IData)(vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_3_0) 
                      * (IData)(vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_2_1)));
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_3 
                = (vlSelf->top__DOT__npu__DOT__sa__DOT__acc_1_3 
                   + ((IData)(vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_1_2) 
                      * (IData)(vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_0_3)));
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_2 
                = (vlSelf->top__DOT__npu__DOT__sa__DOT__acc_2_2 
                   + ((IData)(vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_2_1) 
                      * (IData)(vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_1_2)));
        }
        if (vlSelf->top__DOT__npu_MemWrite) {
            if ((0xfU < (0xffU & vlSelf->top__DOT__ALU_result_MEM))) {
                if (((0x10U <= (0xffU & vlSelf->top__DOT__ALU_result_MEM)) 
                     & (0x1fU >= (0xffU & vlSelf->top__DOT__ALU_result_MEM)))) {
                    __Vdlyvval__top__DOT__npu__DOT__B_reg__v16 
                        = (0xffU & vlSelf->top__DOT__RD2_MEM);
                    __Vdlyvset__top__DOT__npu__DOT__B_reg__v16 = 1U;
                    __Vdlyvdim0__top__DOT__npu__DOT__B_reg__v16 
                        = (0xfU & vlSelf->top__DOT__ALU_result_MEM);
                }
            }
            if ((0xfU >= (0xffU & vlSelf->top__DOT__ALU_result_MEM))) {
                __Vdlyvval__top__DOT__npu__DOT__A_reg__v16 
                    = (0xffU & vlSelf->top__DOT__RD2_MEM);
                __Vdlyvset__top__DOT__npu__DOT__A_reg__v16 = 1U;
                __Vdlyvdim0__top__DOT__npu__DOT__A_reg__v16 
                    = (0xfU & vlSelf->top__DOT__ALU_result_MEM);
            }
        }
        if (((IData)(vlSelf->top__DOT__MemWrite_MEM) 
             & (IData)(vlSelf->top__DOT__dmem_select))) {
            __Vdlyvval__top__DOT__Data_mem__DOT__D_Memory__v64 
                = vlSelf->top__DOT__RD2_MEM;
            __Vdlyvset__top__DOT__Data_mem__DOT__D_Memory__v64 = 1U;
            __Vdlyvdim0__top__DOT__Data_mem__DOT__D_Memory__v64 
                = (0x3fU & vlSelf->top__DOT__ALU_result_MEM);
        }
    }
    vlSelf->top__DOT__RD2_MEM = (((IData)(vlSelf->reset) 
                                  | (IData)(vlSelf->top__DOT__flush_IFID))
                                  ? 0U : vlSelf->top__DOT__ForwardB_data_EX);
    if (vlSelf->reset) {
        __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_2 = 0U;
        __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_3 = 0U;
        __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_3 = 0U;
        __Vdlyvset__top__DOT__Reg_File__DOT__Registers__v0 = 1U;
        vlSelf->top__DOT__MemData_WB = 0U;
        vlSelf->top__DOT__ALU_result_WB = 0U;
    } else {
        if ((1U == (IData)(vlSelf->top__DOT__npu__DOT__state))) {
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_2 = 0U;
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_3 = 0U;
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_3 = 0U;
        } else if ((2U == (IData)(vlSelf->top__DOT__npu__DOT__state))) {
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_2 
                = (vlSelf->top__DOT__npu__DOT__sa__DOT__acc_3_2 
                   + ((IData)(vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_3_1) 
                      * (IData)(vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_2_2)));
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_3 
                = (vlSelf->top__DOT__npu__DOT__sa__DOT__acc_2_3 
                   + ((IData)(vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_2_2) 
                      * (IData)(vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_1_3)));
            __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_3 
                = (vlSelf->top__DOT__npu__DOT__sa__DOT__acc_3_3 
                   + ((IData)(vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_3_2) 
                      * (IData)(vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_2_3)));
        }
        if (((IData)(vlSelf->top__DOT__RegWrite_WB) 
             & (0U != (IData)(vlSelf->top__DOT__RD_WB)))) {
            __Vdlyvval__top__DOT__Reg_File__DOT__Registers__v32 
                = vlSelf->top__DOT__WriteBack_WB;
            __Vdlyvset__top__DOT__Reg_File__DOT__Registers__v32 = 1U;
            __Vdlyvdim0__top__DOT__Reg_File__DOT__Registers__v32 
                = vlSelf->top__DOT__RD_WB;
        }
        vlSelf->top__DOT__MemData_WB = vlSelf->top__DOT__MemData_MEM;
        vlSelf->top__DOT__ALU_result_WB = vlSelf->top__DOT__ALU_result_MEM;
    }
    if (((IData)(vlSelf->reset) | (IData)(vlSelf->top__DOT__flush_IFID))) {
        vlSelf->top__DOT__ALU_result_MEM = 0U;
        vlSelf->top__DOT__PC_ID = 0U;
    } else {
        vlSelf->top__DOT__ALU_result_MEM = vlSelf->top__DOT__ALU_result_EX;
        if ((1U & (~ (IData)(vlSelf->top__DOT__stall_hazard)))) {
            vlSelf->top__DOT__PC_ID = vlSelf->top__DOT__PC_IF;
        }
    }
    if (vlSelf->reset) {
        vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_2_0 = 0U;
        vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_0_2 = 0U;
        vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_2_1 = 0U;
        vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_1_2 = 0U;
        vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_2_2 = 0U;
        vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_2_2 = 0U;
        vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_3_2 = 0U;
        vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_2_3 = 0U;
        vlSelf->top__DOT__RD_WB = 0U;
    } else {
        if ((1U == (IData)(vlSelf->top__DOT__npu__DOT__state))) {
            vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_2_0 = 0U;
            vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_0_2 = 0U;
            vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_2_1 = 0U;
            vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_1_2 = 0U;
            vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_2_2 = 0U;
            vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_2_2 = 0U;
            vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_3_2 = 0U;
            vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_2_3 = 0U;
        } else if ((2U == (IData)(vlSelf->top__DOT__npu__DOT__state))) {
            vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_2_0 
                = vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_1_0;
            vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_0_2 
                = vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_0_1;
            vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_2_1 
                = vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_1_1;
            vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_1_2 
                = vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_1_1;
            vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_2_2 
                = vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_1_2;
            vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_2_2 
                = vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_2_1;
            vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_3_2 
                = vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_3_1;
            vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_2_3 
                = vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_1_3;
        }
        vlSelf->top__DOT__RD_WB = vlSelf->top__DOT__RD_MEM;
    }
    vlSelf->top__DOT__RD_MEM = (((IData)(vlSelf->reset) 
                                 | (IData)(vlSelf->top__DOT__flush_IFID))
                                 ? 0U : (IData)(vlSelf->top__DOT__RD_EX));
    vlSelf->top__DOT__RD_EX = (((IData)(vlSelf->reset) 
                                | (IData)(vlSelf->top__DOT__flush_IDEX))
                                ? 0U : (0x1fU & (vlSelf->top__DOT__instruction_ID 
                                                 >> 7U)));
    if (((IData)(vlSelf->reset) | (IData)(vlSelf->top__DOT__flush_IFID))) {
        vlSelf->top__DOT__instruction_ID = 0U;
    } else if ((1U & (~ (IData)(vlSelf->top__DOT__stall_hazard)))) {
        vlSelf->top__DOT__instruction_ID = vlSelf->top__DOT__Inst_Memory__DOT__I_Mem
            [(0x3fU & (vlSelf->top__DOT__PC_IF >> 2U))];
    }
    if (vlSelf->reset) {
        vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_1_0 = 0U;
        vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_0_1 = 0U;
        vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_1_1 = 0U;
        vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_1_1 = 0U;
        vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_1_2 = 0U;
        vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_2_1 = 0U;
        vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_3_1 = 0U;
        vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_1_3 = 0U;
        vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_0_0 = 0U;
        vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_0_0 = 0U;
        vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_0_1 = 0U;
        vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_1_0 = 0U;
        vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_0_2 = 0U;
        vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_2_0 = 0U;
        vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_3_0 = 0U;
        vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_0_3 = 0U;
        vlSelf->top__DOT__PC_IF = 0U;
    } else {
        if ((1U == (IData)(vlSelf->top__DOT__npu__DOT__state))) {
            vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_1_0 = 0U;
            vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_0_1 = 0U;
            vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_1_1 = 0U;
            vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_1_1 = 0U;
            vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_1_2 = 0U;
            vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_2_1 = 0U;
            vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_3_1 = 0U;
            vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_1_3 = 0U;
            vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_0_0 = 0U;
            vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_0_0 = 0U;
            vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_0_1 = 0U;
            vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_1_0 = 0U;
            vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_0_2 = 0U;
            vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_2_0 = 0U;
            vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_3_0 = 0U;
            vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_0_3 = 0U;
        } else if ((2U == (IData)(vlSelf->top__DOT__npu__DOT__state))) {
            vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_1_0 
                = vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_0_0;
            vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_0_1 
                = vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_0_0;
            vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_1_1 
                = vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_0_1;
            vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_1_1 
                = vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_1_0;
            vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_1_2 
                = vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_0_2;
            vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_2_1 
                = vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_2_0;
            vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_3_1 
                = vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_3_0;
            vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_1_3 
                = vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_0_3;
            vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_0_0 
                = vlSelf->top__DOT__npu__DOT__top_in_0;
            vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_0_0 
                = vlSelf->top__DOT__npu__DOT__left_in_0;
            vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_0_1 
                = vlSelf->top__DOT__npu__DOT__top_in_1;
            vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_1_0 
                = vlSelf->top__DOT__npu__DOT__left_in_1;
            vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_0_2 
                = vlSelf->top__DOT__npu__DOT__top_in_2;
            vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_2_0 
                = vlSelf->top__DOT__npu__DOT__left_in_2;
            vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_3_0 
                = vlSelf->top__DOT__npu__DOT__left_in_3;
            vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_0_3 
                = vlSelf->top__DOT__npu__DOT__top_in_3;
        }
        if ((1U & (~ (IData)(vlSelf->top__DOT__stall_hazard)))) {
            vlSelf->top__DOT__PC_IF = vlSelf->top__DOT__PC_next;
        }
    }
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_0_0 = __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_0;
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_1_0 = __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_0;
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_0_1 = __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_1;
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_2_0 = __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_0;
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_1_1 = __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_1;
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_0_2 = __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_2;
    if (__Vdlyvset__top__DOT__npu__DOT__B_reg__v0) {
        vlSelf->top__DOT__npu__DOT__B_reg[0U] = 0U;
        vlSelf->top__DOT__npu__DOT__B_reg[1U] = 0U;
        vlSelf->top__DOT__npu__DOT__B_reg[2U] = 0U;
        vlSelf->top__DOT__npu__DOT__B_reg[3U] = 0U;
        vlSelf->top__DOT__npu__DOT__B_reg[4U] = 0U;
        vlSelf->top__DOT__npu__DOT__B_reg[5U] = 0U;
        vlSelf->top__DOT__npu__DOT__B_reg[6U] = 0U;
        vlSelf->top__DOT__npu__DOT__B_reg[7U] = 0U;
        vlSelf->top__DOT__npu__DOT__B_reg[8U] = 0U;
        vlSelf->top__DOT__npu__DOT__B_reg[9U] = 0U;
        vlSelf->top__DOT__npu__DOT__B_reg[0xaU] = 0U;
        vlSelf->top__DOT__npu__DOT__B_reg[0xbU] = 0U;
        vlSelf->top__DOT__npu__DOT__B_reg[0xcU] = 0U;
        vlSelf->top__DOT__npu__DOT__B_reg[0xdU] = 0U;
        vlSelf->top__DOT__npu__DOT__B_reg[0xeU] = 0U;
        vlSelf->top__DOT__npu__DOT__B_reg[0xfU] = 0U;
    }
    if (__Vdlyvset__top__DOT__npu__DOT__B_reg__v16) {
        vlSelf->top__DOT__npu__DOT__B_reg[__Vdlyvdim0__top__DOT__npu__DOT__B_reg__v16] 
            = __Vdlyvval__top__DOT__npu__DOT__B_reg__v16;
    }
    if (__Vdlyvset__top__DOT__npu__DOT__A_reg__v0) {
        vlSelf->top__DOT__npu__DOT__A_reg[0U] = 0U;
        vlSelf->top__DOT__npu__DOT__A_reg[1U] = 0U;
        vlSelf->top__DOT__npu__DOT__A_reg[2U] = 0U;
        vlSelf->top__DOT__npu__DOT__A_reg[3U] = 0U;
        vlSelf->top__DOT__npu__DOT__A_reg[4U] = 0U;
        vlSelf->top__DOT__npu__DOT__A_reg[5U] = 0U;
        vlSelf->top__DOT__npu__DOT__A_reg[6U] = 0U;
        vlSelf->top__DOT__npu__DOT__A_reg[7U] = 0U;
        vlSelf->top__DOT__npu__DOT__A_reg[8U] = 0U;
        vlSelf->top__DOT__npu__DOT__A_reg[9U] = 0U;
        vlSelf->top__DOT__npu__DOT__A_reg[0xaU] = 0U;
        vlSelf->top__DOT__npu__DOT__A_reg[0xbU] = 0U;
        vlSelf->top__DOT__npu__DOT__A_reg[0xcU] = 0U;
        vlSelf->top__DOT__npu__DOT__A_reg[0xdU] = 0U;
        vlSelf->top__DOT__npu__DOT__A_reg[0xeU] = 0U;
        vlSelf->top__DOT__npu__DOT__A_reg[0xfU] = 0U;
    }
    if (__Vdlyvset__top__DOT__npu__DOT__A_reg__v16) {
        vlSelf->top__DOT__npu__DOT__A_reg[__Vdlyvdim0__top__DOT__npu__DOT__A_reg__v16] 
            = __Vdlyvval__top__DOT__npu__DOT__A_reg__v16;
    }
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_3_0 = __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_0;
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_0_3 = __Vdly__top__DOT__npu__DOT__sa__DOT__acc_0_3;
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_2_1 = __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_1;
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_1_2 = __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_2;
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_3_1 = __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_1;
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_1_3 = __Vdly__top__DOT__npu__DOT__sa__DOT__acc_1_3;
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_2_2 = __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_2;
    if (__Vdlyvset__top__DOT__Data_mem__DOT__D_Memory__v0) {
        __Vilp = 0U;
        while ((__Vilp <= 0x3fU)) {
            vlSelf->top__DOT__Data_mem__DOT__D_Memory[__Vilp] = 0U;
            __Vilp = ((IData)(1U) + __Vilp);
        }
    }
    if (__Vdlyvset__top__DOT__Data_mem__DOT__D_Memory__v64) {
        vlSelf->top__DOT__Data_mem__DOT__D_Memory[__Vdlyvdim0__top__DOT__Data_mem__DOT__D_Memory__v64] 
            = __Vdlyvval__top__DOT__Data_mem__DOT__D_Memory__v64;
    }
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_3_2 = __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_2;
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_2_3 = __Vdly__top__DOT__npu__DOT__sa__DOT__acc_2_3;
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_3_3 = __Vdly__top__DOT__npu__DOT__sa__DOT__acc_3_3;
    if (__Vdlyvset__top__DOT__Reg_File__DOT__Registers__v0) {
        vlSelf->top__DOT__Reg_File__DOT__Registers[0U] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[1U] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[2U] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[3U] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[4U] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[5U] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[6U] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[7U] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[8U] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[9U] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[0xaU] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[0xbU] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[0xcU] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[0xdU] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[0xeU] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[0xfU] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[0x10U] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[0x11U] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[0x12U] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[0x13U] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[0x14U] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[0x15U] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[0x16U] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[0x17U] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[0x18U] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[0x19U] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[0x1aU] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[0x1bU] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[0x1cU] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[0x1dU] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[0x1eU] = 0U;
        vlSelf->top__DOT__Reg_File__DOT__Registers[0x1fU] = 0U;
    }
    if (__Vdlyvset__top__DOT__Reg_File__DOT__Registers__v32) {
        vlSelf->top__DOT__Reg_File__DOT__Registers[__Vdlyvdim0__top__DOT__Reg_File__DOT__Registers__v32] 
            = __Vdlyvval__top__DOT__Reg_File__DOT__Registers__v32;
    }
    vlSelf->top__DOT__MemWrite_MEM = ((1U & (~ ((IData)(vlSelf->reset) 
                                                | (IData)(vlSelf->top__DOT__flush_IFID)))) 
                                      && (IData)(vlSelf->top__DOT__MemWrite_EX));
    vlSelf->top__DOT__RegWrite_WB = ((1U & (~ (IData)(vlSelf->reset))) 
                                     && (IData)(vlSelf->top__DOT__RegWrite_MEM));
    vlSelf->top__DOT__Branch_EX = ((1U & (~ ((IData)(vlSelf->reset) 
                                             | (IData)(vlSelf->top__DOT__flush_IDEX)))) 
                                   && (IData)(vlSelf->top__DOT__Branch_ID));
    vlSelf->top__DOT__MemRead_EX = ((1U & (~ ((IData)(vlSelf->reset) 
                                              | (IData)(vlSelf->top__DOT__flush_IDEX)))) 
                                    && (IData)(vlSelf->top__DOT__MemRead_ID));
    vlSelf->top__DOT__MemtoReg_MEM = ((1U & (~ ((IData)(vlSelf->reset) 
                                                | (IData)(vlSelf->top__DOT__flush_IFID)))) 
                                      && (IData)(vlSelf->top__DOT__MemtoReg_EX));
    __Vtableidx2 = (((IData)(vlSelf->top__DOT__fun7_EX) 
                     << 5U) | (((IData)(vlSelf->top__DOT__fun3_EX) 
                                << 2U) | (IData)(vlSelf->top__DOT__ALUOp_EX)));
    top__DOT__ALU_ctrl_EX = Vtop__ConstPool__TABLE_hba5961b7_0
        [__Vtableidx2];
    vlSelf->top__DOT__WriteBack_WB = ((IData)(vlSelf->top__DOT__MemtoReg_WB)
                                       ? vlSelf->top__DOT__MemData_WB
                                       : vlSelf->top__DOT__ALU_result_WB);
    vlSelf->host_tx_data = vlSelf->top__DOT__RD2_MEM;
    vlSelf->top__DOT__MemWrite_EX = ((1U & (~ ((IData)(vlSelf->reset) 
                                               | (IData)(vlSelf->top__DOT__flush_IDEX)))) 
                                     && (IData)(vlSelf->top__DOT__MemWrite_ID));
    vlSelf->top__DOT__RegWrite_MEM = ((1U & (~ ((IData)(vlSelf->reset) 
                                                | (IData)(vlSelf->top__DOT__flush_IFID)))) 
                                      && (IData)(vlSelf->top__DOT__RegWrite_EX));
    vlSelf->top__DOT__MemtoReg_EX = ((1U & (~ ((IData)(vlSelf->reset) 
                                               | (IData)(vlSelf->top__DOT__flush_IDEX)))) 
                                     && (IData)(vlSelf->top__DOT__MemtoReg_ID));
    vlSelf->host_tx_valid = ((IData)(vlSelf->top__DOT__MemWrite_MEM) 
                             & (vlSelf->top__DOT__ALU_result_MEM 
                                >> 9U));
    vlSelf->top__DOT__npu_select = (IData)((0x100U 
                                            == (0x300U 
                                                & vlSelf->top__DOT__ALU_result_MEM)));
    vlSelf->top__DOT__Reg_File__DOT____VdfgTmp_h6aa9bfce__0 
        = ((IData)(vlSelf->top__DOT__RegWrite_WB) & 
           (0U != (IData)(vlSelf->top__DOT__RD_WB)));
    vlSelf->top__DOT__npu_MemWrite = ((IData)(vlSelf->top__DOT__MemWrite_MEM) 
                                      & (IData)(vlSelf->top__DOT__npu_select));
    vlSelf->top__DOT__dmem_select = (1U & ((~ (IData)(vlSelf->top__DOT__npu_select)) 
                                           & (~ (vlSelf->top__DOT__ALU_result_MEM 
                                                 >> 9U))));
    vlSelf->top__DOT__RegWrite_EX = ((1U & (~ ((IData)(vlSelf->reset) 
                                               | (IData)(vlSelf->top__DOT__flush_IDEX)))) 
                                     && (IData)(vlSelf->top__DOT__RegWrite_ID));
    top__DOT__ForwardA_sel = ((((IData)(vlSelf->top__DOT__RegWrite_MEM) 
                                & (0U != (IData)(vlSelf->top__DOT__RD_MEM))) 
                               & ((IData)(vlSelf->top__DOT__RD_MEM) 
                                  == (IData)(vlSelf->top__DOT__RS1_EX)))
                               ? 2U : ((((IData)(vlSelf->top__DOT__RegWrite_WB) 
                                         & (0U != (IData)(vlSelf->top__DOT__RD_WB))) 
                                        & ((IData)(vlSelf->top__DOT__RD_WB) 
                                           == (IData)(vlSelf->top__DOT__RS1_EX)))
                                        ? 1U : 0U));
    top__DOT__ForwardB_sel = ((((IData)(vlSelf->top__DOT__RegWrite_MEM) 
                                & (0U != (IData)(vlSelf->top__DOT__RD_MEM))) 
                               & ((IData)(vlSelf->top__DOT__RD_MEM) 
                                  == (IData)(vlSelf->top__DOT__RS2_EX)))
                               ? 2U : ((((IData)(vlSelf->top__DOT__RegWrite_WB) 
                                         & (0U != (IData)(vlSelf->top__DOT__RD_WB))) 
                                        & ((IData)(vlSelf->top__DOT__RD_WB) 
                                           == (IData)(vlSelf->top__DOT__RS2_EX)))
                                        ? 1U : 0U));
    vlSelf->top__DOT__npu__DOT__state = __Vdly__top__DOT__npu__DOT__state;
    top__DOT__ForwardA_data_EX = ((0U == (IData)(top__DOT__ForwardA_sel))
                                   ? vlSelf->top__DOT__RD1_EX
                                   : ((1U == (IData)(top__DOT__ForwardA_sel))
                                       ? vlSelf->top__DOT__WriteBack_WB
                                       : ((2U == (IData)(top__DOT__ForwardA_sel))
                                           ? vlSelf->top__DOT__ALU_result_MEM
                                           : vlSelf->top__DOT__RD1_EX)));
    vlSelf->top__DOT__ForwardB_data_EX = ((0U == (IData)(top__DOT__ForwardB_sel))
                                           ? vlSelf->top__DOT__RD2_EX
                                           : ((1U == (IData)(top__DOT__ForwardB_sel))
                                               ? vlSelf->top__DOT__WriteBack_WB
                                               : ((2U 
                                                   == (IData)(top__DOT__ForwardB_sel))
                                                   ? vlSelf->top__DOT__ALU_result_MEM
                                                   : vlSelf->top__DOT__RD2_EX)));
    if (((2U == (IData)(vlSelf->top__DOT__npu__DOT__state)) 
         & (3U >= (IData)(vlSelf->top__DOT__npu__DOT__cycle_count)))) {
        vlSelf->top__DOT__npu__DOT__left_in_0 = vlSelf->top__DOT__npu__DOT__A_reg
            [vlSelf->top__DOT__npu__DOT__cycle_count];
        vlSelf->top__DOT__npu__DOT__top_in_0 = vlSelf->top__DOT__npu__DOT__B_reg
            [(0xfU & VL_SHIFTL_III(4,32,32, (IData)(vlSelf->top__DOT__npu__DOT__cycle_count), 2U))];
    } else {
        vlSelf->top__DOT__npu__DOT__left_in_0 = 0U;
        vlSelf->top__DOT__npu__DOT__top_in_0 = 0U;
    }
    if ((((2U == (IData)(vlSelf->top__DOT__npu__DOT__state)) 
          & (1U <= (IData)(vlSelf->top__DOT__npu__DOT__cycle_count))) 
         & (4U >= (IData)(vlSelf->top__DOT__npu__DOT__cycle_count)))) {
        vlSelf->top__DOT__npu__DOT__left_in_1 = vlSelf->top__DOT__npu__DOT__A_reg
            [(0xfU & ((IData)(4U) + ((IData)(vlSelf->top__DOT__npu__DOT__cycle_count) 
                                     - (IData)(1U))))];
        vlSelf->top__DOT__npu__DOT__top_in_1 = vlSelf->top__DOT__npu__DOT__B_reg
            [(0xfU & ((IData)(1U) + VL_SHIFTL_III(4,32,32, 
                                                  ((IData)(vlSelf->top__DOT__npu__DOT__cycle_count) 
                                                   - (IData)(1U)), 2U)))];
    } else {
        vlSelf->top__DOT__npu__DOT__left_in_1 = 0U;
        vlSelf->top__DOT__npu__DOT__top_in_1 = 0U;
    }
    if ((((2U == (IData)(vlSelf->top__DOT__npu__DOT__state)) 
          & (3U <= (IData)(vlSelf->top__DOT__npu__DOT__cycle_count))) 
         & (6U >= (IData)(vlSelf->top__DOT__npu__DOT__cycle_count)))) {
        vlSelf->top__DOT__npu__DOT__top_in_3 = vlSelf->top__DOT__npu__DOT__B_reg
            [(0xfU & ((IData)(3U) + VL_SHIFTL_III(4,32,32, 
                                                  ((IData)(vlSelf->top__DOT__npu__DOT__cycle_count) 
                                                   - (IData)(3U)), 2U)))];
        vlSelf->top__DOT__npu__DOT__left_in_3 = vlSelf->top__DOT__npu__DOT__A_reg
            [(0xfU & ((IData)(0xcU) + ((IData)(vlSelf->top__DOT__npu__DOT__cycle_count) 
                                       - (IData)(3U))))];
    } else {
        vlSelf->top__DOT__npu__DOT__top_in_3 = 0U;
        vlSelf->top__DOT__npu__DOT__left_in_3 = 0U;
    }
    if ((((2U == (IData)(vlSelf->top__DOT__npu__DOT__state)) 
          & (2U <= (IData)(vlSelf->top__DOT__npu__DOT__cycle_count))) 
         & (5U >= (IData)(vlSelf->top__DOT__npu__DOT__cycle_count)))) {
        vlSelf->top__DOT__npu__DOT__left_in_2 = vlSelf->top__DOT__npu__DOT__A_reg
            [(0xfU & ((IData)(8U) + ((IData)(vlSelf->top__DOT__npu__DOT__cycle_count) 
                                     - (IData)(2U))))];
        vlSelf->top__DOT__npu__DOT__top_in_2 = vlSelf->top__DOT__npu__DOT__B_reg
            [(0xfU & ((IData)(2U) + VL_SHIFTL_III(4,32,32, 
                                                  ((IData)(vlSelf->top__DOT__npu__DOT__cycle_count) 
                                                   - (IData)(2U)), 2U)))];
    } else {
        vlSelf->top__DOT__npu__DOT__left_in_2 = 0U;
        vlSelf->top__DOT__npu__DOT__top_in_2 = 0U;
    }
    vlSelf->top__DOT__MemData_MEM = ((0x200U & vlSelf->top__DOT__ALU_result_MEM)
                                      ? vlSelf->host_rx_data
                                      : ((IData)(vlSelf->top__DOT__npu_select)
                                          ? (((IData)(vlSelf->top__DOT__MemRead_MEM) 
                                              & (IData)(vlSelf->top__DOT__npu_select))
                                              ? ((0xfU 
                                                  >= 
                                                  (0xffU 
                                                   & vlSelf->top__DOT__ALU_result_MEM))
                                                  ? 
                                                 vlSelf->top__DOT__npu__DOT__A_reg
                                                 [(0xfU 
                                                   & vlSelf->top__DOT__ALU_result_MEM)]
                                                  : 
                                                 (((0x10U 
                                                    <= 
                                                    (0xffU 
                                                     & vlSelf->top__DOT__ALU_result_MEM)) 
                                                   & (0x1fU 
                                                      >= 
                                                      (0xffU 
                                                       & vlSelf->top__DOT__ALU_result_MEM)))
                                                   ? 
                                                  vlSelf->top__DOT__npu__DOT__B_reg
                                                  [
                                                  (0xfU 
                                                   & vlSelf->top__DOT__ALU_result_MEM)]
                                                   : 
                                                  (((0x20U 
                                                     <= 
                                                     (0xffU 
                                                      & vlSelf->top__DOT__ALU_result_MEM)) 
                                                    & (0x2fU 
                                                       >= 
                                                       (0xffU 
                                                        & vlSelf->top__DOT__ALU_result_MEM)))
                                                    ? 
                                                   ((8U 
                                                     & vlSelf->top__DOT__ALU_result_MEM)
                                                     ? 
                                                    ((4U 
                                                      & vlSelf->top__DOT__ALU_result_MEM)
                                                      ? 
                                                     ((2U 
                                                       & vlSelf->top__DOT__ALU_result_MEM)
                                                       ? 
                                                      ((1U 
                                                        & vlSelf->top__DOT__ALU_result_MEM)
                                                        ? vlSelf->top__DOT__npu__DOT__sa__DOT__acc_3_3
                                                        : vlSelf->top__DOT__npu__DOT__sa__DOT__acc_3_2)
                                                       : 
                                                      ((1U 
                                                        & vlSelf->top__DOT__ALU_result_MEM)
                                                        ? vlSelf->top__DOT__npu__DOT__sa__DOT__acc_3_1
                                                        : vlSelf->top__DOT__npu__DOT__sa__DOT__acc_3_0))
                                                      : 
                                                     ((2U 
                                                       & vlSelf->top__DOT__ALU_result_MEM)
                                                       ? 
                                                      ((1U 
                                                        & vlSelf->top__DOT__ALU_result_MEM)
                                                        ? vlSelf->top__DOT__npu__DOT__sa__DOT__acc_2_3
                                                        : vlSelf->top__DOT__npu__DOT__sa__DOT__acc_2_2)
                                                       : 
                                                      ((1U 
                                                        & vlSelf->top__DOT__ALU_result_MEM)
                                                        ? vlSelf->top__DOT__npu__DOT__sa__DOT__acc_2_1
                                                        : vlSelf->top__DOT__npu__DOT__sa__DOT__acc_2_0)))
                                                     : 
                                                    ((4U 
                                                      & vlSelf->top__DOT__ALU_result_MEM)
                                                      ? 
                                                     ((2U 
                                                       & vlSelf->top__DOT__ALU_result_MEM)
                                                       ? 
                                                      ((1U 
                                                        & vlSelf->top__DOT__ALU_result_MEM)
                                                        ? vlSelf->top__DOT__npu__DOT__sa__DOT__acc_1_3
                                                        : vlSelf->top__DOT__npu__DOT__sa__DOT__acc_1_2)
                                                       : 
                                                      ((1U 
                                                        & vlSelf->top__DOT__ALU_result_MEM)
                                                        ? vlSelf->top__DOT__npu__DOT__sa__DOT__acc_1_1
                                                        : vlSelf->top__DOT__npu__DOT__sa__DOT__acc_1_0))
                                                      : 
                                                     ((2U 
                                                       & vlSelf->top__DOT__ALU_result_MEM)
                                                       ? 
                                                      ((1U 
                                                        & vlSelf->top__DOT__ALU_result_MEM)
                                                        ? vlSelf->top__DOT__npu__DOT__sa__DOT__acc_0_3
                                                        : vlSelf->top__DOT__npu__DOT__sa__DOT__acc_0_2)
                                                       : 
                                                      ((1U 
                                                        & vlSelf->top__DOT__ALU_result_MEM)
                                                        ? vlSelf->top__DOT__npu__DOT__sa__DOT__acc_0_1
                                                        : vlSelf->top__DOT__npu__DOT__sa__DOT__acc_0_0))))
                                                    : 
                                                   ((0x31U 
                                                     == 
                                                     (0xffU 
                                                      & vlSelf->top__DOT__ALU_result_MEM))
                                                     ? 
                                                    (3U 
                                                     == (IData)(vlSelf->top__DOT__npu__DOT__state))
                                                     : 0U))))
                                              : 0U)
                                          : (((IData)(vlSelf->top__DOT__MemRead_MEM) 
                                              & (IData)(vlSelf->top__DOT__dmem_select))
                                              ? vlSelf->top__DOT__Data_mem__DOT__D_Memory
                                             [(0x3fU 
                                               & vlSelf->top__DOT__ALU_result_MEM)]
                                              : 0U)));
    top__DOT__ALU_mux_out_EX = ((IData)(vlSelf->top__DOT__ALUSrc_EX)
                                 ? vlSelf->top__DOT__ImmExt_EX
                                 : vlSelf->top__DOT__ForwardB_data_EX);
    vlSelf->top__DOT__ALU_result_EX = ((8U & (IData)(top__DOT__ALU_ctrl_EX))
                                        ? 0U : ((4U 
                                                 & (IData)(top__DOT__ALU_ctrl_EX))
                                                 ? 
                                                ((2U 
                                                  & (IData)(top__DOT__ALU_ctrl_EX))
                                                  ? 
                                                 ((1U 
                                                   & (IData)(top__DOT__ALU_ctrl_EX))
                                                   ? 0U
                                                   : 
                                                  (top__DOT__ForwardA_data_EX 
                                                   - top__DOT__ALU_mux_out_EX))
                                                  : 0U)
                                                 : 
                                                ((2U 
                                                  & (IData)(top__DOT__ALU_ctrl_EX))
                                                  ? 
                                                 ((1U 
                                                   & (IData)(top__DOT__ALU_ctrl_EX))
                                                   ? 0U
                                                   : 
                                                  (top__DOT__ForwardA_data_EX 
                                                   + top__DOT__ALU_mux_out_EX))
                                                  : 
                                                 ((1U 
                                                   & (IData)(top__DOT__ALU_ctrl_EX))
                                                   ? 
                                                  (top__DOT__ForwardA_data_EX 
                                                   | top__DOT__ALU_mux_out_EX)
                                                   : 
                                                  (top__DOT__ForwardA_data_EX 
                                                   & top__DOT__ALU_mux_out_EX)))));
    vlSelf->top__DOT__zero_EX = (0U == vlSelf->top__DOT__ALU_result_EX);
    if (__Vdlyvset__top__DOT__Inst_Memory__DOT__I_Mem__v0) {
        __Vilp = 0U;
        while ((__Vilp <= 0x3fU)) {
            vlSelf->top__DOT__Inst_Memory__DOT__I_Mem[__Vilp] = 0U;
            __Vilp = ((IData)(1U) + __Vilp);
        }
    }
    vlSelf->top__DOT__flush_IFID = ((IData)(vlSelf->top__DOT__Branch_MEM) 
                                    & (IData)(vlSelf->top__DOT__zero_MEM));
    vlSelf->top__DOT__ImmExt_ID = ((0x40U & vlSelf->top__DOT__instruction_ID)
                                    ? ((0x20U & vlSelf->top__DOT__instruction_ID)
                                        ? ((0x10U & vlSelf->top__DOT__instruction_ID)
                                            ? 0U : 
                                           ((8U & vlSelf->top__DOT__instruction_ID)
                                             ? 0U : 
                                            ((4U & vlSelf->top__DOT__instruction_ID)
                                              ? 0U : 
                                             ((2U & vlSelf->top__DOT__instruction_ID)
                                               ? ((1U 
                                                   & vlSelf->top__DOT__instruction_ID)
                                                   ? 
                                                  (((- (IData)(
                                                               (vlSelf->top__DOT__instruction_ID 
                                                                >> 0x1fU))) 
                                                    << 0xdU) 
                                                   | ((0x1000U 
                                                       & (vlSelf->top__DOT__instruction_ID 
                                                          >> 0x13U)) 
                                                      | ((0x800U 
                                                          & (vlSelf->top__DOT__instruction_ID 
                                                             << 4U)) 
                                                         | ((0x7e0U 
                                                             & (vlSelf->top__DOT__instruction_ID 
                                                                >> 0x14U)) 
                                                            | (0x1eU 
                                                               & (vlSelf->top__DOT__instruction_ID 
                                                                  >> 7U))))))
                                                   : 0U)
                                               : 0U))))
                                        : 0U) : ((0x20U 
                                                  & vlSelf->top__DOT__instruction_ID)
                                                  ? 
                                                 ((0x10U 
                                                   & vlSelf->top__DOT__instruction_ID)
                                                   ? 0U
                                                   : 
                                                  ((8U 
                                                    & vlSelf->top__DOT__instruction_ID)
                                                    ? 0U
                                                    : 
                                                   ((4U 
                                                     & vlSelf->top__DOT__instruction_ID)
                                                     ? 0U
                                                     : 
                                                    ((2U 
                                                      & vlSelf->top__DOT__instruction_ID)
                                                      ? 
                                                     ((1U 
                                                       & vlSelf->top__DOT__instruction_ID)
                                                       ? 
                                                      (((- (IData)(
                                                                   (vlSelf->top__DOT__instruction_ID 
                                                                    >> 0x1fU))) 
                                                        << 0xcU) 
                                                       | ((0xfe0U 
                                                           & (vlSelf->top__DOT__instruction_ID 
                                                              >> 0x14U)) 
                                                          | (0x1fU 
                                                             & (vlSelf->top__DOT__instruction_ID 
                                                                >> 7U))))
                                                       : 0U)
                                                      : 0U))))
                                                  : 
                                                 ((0x10U 
                                                   & vlSelf->top__DOT__instruction_ID)
                                                   ? 
                                                  ((8U 
                                                    & vlSelf->top__DOT__instruction_ID)
                                                    ? 0U
                                                    : 
                                                   ((4U 
                                                     & vlSelf->top__DOT__instruction_ID)
                                                     ? 0U
                                                     : 
                                                    ((2U 
                                                      & vlSelf->top__DOT__instruction_ID)
                                                      ? 
                                                     ((1U 
                                                       & vlSelf->top__DOT__instruction_ID)
                                                       ? 
                                                      (((- (IData)(
                                                                   (vlSelf->top__DOT__instruction_ID 
                                                                    >> 0x1fU))) 
                                                        << 0xcU) 
                                                       | (vlSelf->top__DOT__instruction_ID 
                                                          >> 0x14U))
                                                       : 0U)
                                                      : 0U)))
                                                   : 
                                                  ((8U 
                                                    & vlSelf->top__DOT__instruction_ID)
                                                    ? 0U
                                                    : 
                                                   ((4U 
                                                     & vlSelf->top__DOT__instruction_ID)
                                                     ? 0U
                                                     : 
                                                    ((2U 
                                                      & vlSelf->top__DOT__instruction_ID)
                                                      ? 
                                                     ((1U 
                                                       & vlSelf->top__DOT__instruction_ID)
                                                       ? 
                                                      (((- (IData)(
                                                                   (vlSelf->top__DOT__instruction_ID 
                                                                    >> 0x1fU))) 
                                                        << 0xcU) 
                                                       | (vlSelf->top__DOT__instruction_ID 
                                                          >> 0x14U))
                                                       : 0U)
                                                      : 0U))))));
    vlSelf->top__DOT__flush_IDEX = ((IData)(vlSelf->top__DOT__flush_IFID) 
                                    | (((IData)(vlSelf->top__DOT__MemRead_EX) 
                                        & (((IData)(vlSelf->top__DOT__RD_EX) 
                                            == (0x1fU 
                                                & (vlSelf->top__DOT__instruction_ID 
                                                   >> 0xfU))) 
                                           | ((IData)(vlSelf->top__DOT__RD_EX) 
                                              == (0x1fU 
                                                  & (vlSelf->top__DOT__instruction_ID 
                                                     >> 0x14U))))) 
                                       & (0U != (IData)(vlSelf->top__DOT__RD_EX))));
    __Vtableidx1 = (0x7fU & vlSelf->top__DOT__instruction_ID);
    vlSelf->top__DOT__ALUSrc_ID = Vtop__ConstPool__TABLE_h75b8279d_0
        [__Vtableidx1];
    vlSelf->top__DOT__MemtoReg_ID = Vtop__ConstPool__TABLE_h7ca8bf9e_0
        [__Vtableidx1];
    vlSelf->top__DOT__RegWrite_ID = Vtop__ConstPool__TABLE_h4608f605_0
        [__Vtableidx1];
    vlSelf->top__DOT__MemRead_ID = Vtop__ConstPool__TABLE_h7ca8bf9e_0
        [__Vtableidx1];
    vlSelf->top__DOT__MemWrite_ID = Vtop__ConstPool__TABLE_ha96ed2bf_0
        [__Vtableidx1];
    vlSelf->top__DOT__Branch_ID = Vtop__ConstPool__TABLE_he4685dc5_0
        [__Vtableidx1];
    vlSelf->top__DOT__ALUOp_ID = Vtop__ConstPool__TABLE_ha2dc09bf_0
        [__Vtableidx1];
    vlSelf->top__DOT__stall_hazard = (((IData)(vlSelf->top__DOT__MemRead_EX) 
                                       & (((IData)(vlSelf->top__DOT__RD_EX) 
                                           == (0x1fU 
                                               & (vlSelf->top__DOT__instruction_ID 
                                                  >> 0xfU))) 
                                          | ((IData)(vlSelf->top__DOT__RD_EX) 
                                             == (0x1fU 
                                                 & (vlSelf->top__DOT__instruction_ID 
                                                    >> 0x14U))))) 
                                      & (0U != (IData)(vlSelf->top__DOT__RD_EX)));
    vlSelf->top__DOT__PC_next = ((IData)(vlSelf->top__DOT__flush_IFID)
                                  ? vlSelf->top__DOT__BranchTarget_MEM
                                  : ((IData)(4U) + vlSelf->top__DOT__PC_IF));
}

VL_INLINE_OPT void Vtop___024root___nba_sequent__TOP__1(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___nba_sequent__TOP__1\n"); );
    // Init
    VlWide<3>/*95:0*/ __Vtemp_1;
    // Body
    __Vtemp_1[0U] = 0x653d2573U;
    __Vtemp_1[1U] = 0x6d776172U;
    __Vtemp_1[2U] = 0x666972U;
    if (VL_UNLIKELY(VL_VALUEPLUSARGS_INW(2048, VL_CVT_PACK_STR_NW(3, __Vtemp_1), 
                                         vlSelf->top__DOT__Inst_Memory__DOT__fw_file))) {
        VL_READMEM_N(true, 32, 64, 0, VL_CVT_PACK_STR_NW(64, vlSelf->top__DOT__Inst_Memory__DOT__fw_file)
                     ,  &(vlSelf->top__DOT__Inst_Memory__DOT__I_Mem)
                     , 0, ~0ULL);
    }
}

void Vtop___024root___eval_nba(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_nba\n"); );
    // Body
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vtop___024root___nba_sequent__TOP__0(vlSelf);
    }
    if ((2ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vtop___024root___nba_sequent__TOP__1(vlSelf);
    }
}

void Vtop___024root___eval_triggers__act(Vtop___024root* vlSelf);

bool Vtop___024root___eval_phase__act(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_phase__act\n"); );
    // Init
    VlTriggerVec<2> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vtop___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelf->__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
        vlSelf->__VnbaTriggered.thisOr(vlSelf->__VactTriggered);
        Vtop___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vtop___024root___eval_phase__nba(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_phase__nba\n"); );
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelf->__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vtop___024root___eval_nba(vlSelf);
        vlSelf->__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__ico(Vtop___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__nba(Vtop___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__act(Vtop___024root* vlSelf);
#endif  // VL_DEBUG

void Vtop___024root___eval(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval\n"); );
    // Init
    IData/*31:0*/ __VicoIterCount;
    CData/*0:0*/ __VicoContinue;
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VicoIterCount = 0U;
    vlSelf->__VicoFirstIteration = 1U;
    __VicoContinue = 1U;
    while (__VicoContinue) {
        if (VL_UNLIKELY((0x64U < __VicoIterCount))) {
#ifdef VL_DEBUG
            Vtop___024root___dump_triggers__ico(vlSelf);
#endif
            VL_FATAL_MT("rtl/pipeline/pipeline_top.v", 12, "", "Input combinational region did not converge.");
        }
        __VicoIterCount = ((IData)(1U) + __VicoIterCount);
        __VicoContinue = 0U;
        if (Vtop___024root___eval_phase__ico(vlSelf)) {
            __VicoContinue = 1U;
        }
        vlSelf->__VicoFirstIteration = 0U;
    }
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
            Vtop___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("rtl/pipeline/pipeline_top.v", 12, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                Vtop___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("rtl/pipeline/pipeline_top.v", 12, "", "Active region did not converge.");
            }
            vlSelf->__VactIterCount = ((IData)(1U) 
                                       + vlSelf->__VactIterCount);
            vlSelf->__VactContinue = 0U;
            if (Vtop___024root___eval_phase__act(vlSelf)) {
                vlSelf->__VactContinue = 1U;
            }
        }
        if (Vtop___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vtop___024root___eval_debug_assertions(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelf->reset & 0xfeU))) {
        Verilated::overWidthError("reset");}
}
#endif  // VL_DEBUG
