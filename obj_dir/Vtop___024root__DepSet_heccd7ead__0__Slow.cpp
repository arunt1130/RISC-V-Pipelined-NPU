// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop__pch.h"
#include "Vtop___024root.h"

VL_ATTR_COLD void Vtop___024root___eval_static(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_static\n"); );
}

VL_ATTR_COLD void Vtop___024root___eval_initial(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_initial\n"); );
    // Body
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = vlSelf->clk;
    vlSelf->__Vtrigprevexpr___TOP__reset__0 = vlSelf->reset;
}

VL_ATTR_COLD void Vtop___024root___eval_final(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_final\n"); );
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__stl(Vtop___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vtop___024root___eval_phase__stl(Vtop___024root* vlSelf);

VL_ATTR_COLD void Vtop___024root___eval_settle(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_settle\n"); );
    // Init
    IData/*31:0*/ __VstlIterCount;
    CData/*0:0*/ __VstlContinue;
    // Body
    __VstlIterCount = 0U;
    vlSelf->__VstlFirstIteration = 1U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        if (VL_UNLIKELY((0x64U < __VstlIterCount))) {
#ifdef VL_DEBUG
            Vtop___024root___dump_triggers__stl(vlSelf);
#endif
            VL_FATAL_MT("rtl/pipeline/pipeline_top.v", 12, "", "Settle region did not converge.");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        __VstlContinue = 0U;
        if (Vtop___024root___eval_phase__stl(vlSelf)) {
            __VstlContinue = 1U;
        }
        vlSelf->__VstlFirstIteration = 0U;
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__stl(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VstlTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VstlTriggered.word(0U))) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

extern const VlUnpacked<CData/*3:0*/, 64> Vtop__ConstPool__TABLE_hba5961b7_0;
extern const VlUnpacked<CData/*0:0*/, 128> Vtop__ConstPool__TABLE_h75b8279d_0;
extern const VlUnpacked<CData/*0:0*/, 128> Vtop__ConstPool__TABLE_h7ca8bf9e_0;
extern const VlUnpacked<CData/*0:0*/, 128> Vtop__ConstPool__TABLE_h4608f605_0;
extern const VlUnpacked<CData/*0:0*/, 128> Vtop__ConstPool__TABLE_ha96ed2bf_0;
extern const VlUnpacked<CData/*0:0*/, 128> Vtop__ConstPool__TABLE_he4685dc5_0;
extern const VlUnpacked<CData/*1:0*/, 128> Vtop__ConstPool__TABLE_ha2dc09bf_0;

VL_ATTR_COLD void Vtop___024root___stl_sequent__TOP__0(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___stl_sequent__TOP__0\n"); );
    // Init
    IData/*31:0*/ top__DOT__ForwardA_data_EX;
    top__DOT__ForwardA_data_EX = 0;
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
    // Body
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
    vlSelf->host_tx_data = vlSelf->top__DOT__RD2_MEM;
    vlSelf->host_tx_valid = ((IData)(vlSelf->top__DOT__MemWrite_MEM) 
                             & (vlSelf->top__DOT__ALU_result_MEM 
                                >> 9U));
    vlSelf->top__DOT__Reg_File__DOT____VdfgTmp_h6aa9bfce__0 
        = ((IData)(vlSelf->top__DOT__RegWrite_WB) & 
           (0U != (IData)(vlSelf->top__DOT__RD_WB)));
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
    __Vtableidx2 = (((IData)(vlSelf->top__DOT__fun7_EX) 
                     << 5U) | (((IData)(vlSelf->top__DOT__fun3_EX) 
                                << 2U) | (IData)(vlSelf->top__DOT__ALUOp_EX)));
    top__DOT__ALU_ctrl_EX = Vtop__ConstPool__TABLE_hba5961b7_0
        [__Vtableidx2];
    vlSelf->top__DOT__flush_IFID = ((IData)(vlSelf->top__DOT__Branch_MEM) 
                                    & (IData)(vlSelf->top__DOT__zero_MEM));
    top__DOT__ForwardA_sel = ((((IData)(vlSelf->top__DOT__RegWrite_MEM) 
                                & (0U != (IData)(vlSelf->top__DOT__RD_MEM))) 
                               & ((IData)(vlSelf->top__DOT__RD_MEM) 
                                  == (IData)(vlSelf->top__DOT__RS1_EX)))
                               ? 2U : ((((IData)(vlSelf->top__DOT__RegWrite_WB) 
                                         & (0U != (IData)(vlSelf->top__DOT__RD_WB))) 
                                        & ((IData)(vlSelf->top__DOT__RD_WB) 
                                           == (IData)(vlSelf->top__DOT__RS1_EX)))
                                        ? 1U : 0U));
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
    top__DOT__ForwardB_sel = ((((IData)(vlSelf->top__DOT__RegWrite_MEM) 
                                & (0U != (IData)(vlSelf->top__DOT__RD_MEM))) 
                               & ((IData)(vlSelf->top__DOT__RD_MEM) 
                                  == (IData)(vlSelf->top__DOT__RS2_EX)))
                               ? 2U : ((((IData)(vlSelf->top__DOT__RegWrite_WB) 
                                         & (0U != (IData)(vlSelf->top__DOT__RD_WB))) 
                                        & ((IData)(vlSelf->top__DOT__RD_WB) 
                                           == (IData)(vlSelf->top__DOT__RS2_EX)))
                                        ? 1U : 0U));
    vlSelf->top__DOT__WriteBack_WB = ((IData)(vlSelf->top__DOT__MemtoReg_WB)
                                       ? vlSelf->top__DOT__MemData_WB
                                       : vlSelf->top__DOT__ALU_result_WB);
    vlSelf->top__DOT__npu_select = (IData)((0x100U 
                                            == (0x300U 
                                                & vlSelf->top__DOT__ALU_result_MEM)));
    vlSelf->top__DOT__PC_next = ((IData)(vlSelf->top__DOT__flush_IFID)
                                  ? vlSelf->top__DOT__BranchTarget_MEM
                                  : ((IData)(4U) + vlSelf->top__DOT__PC_IF));
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
    vlSelf->top__DOT__npu_MemWrite = ((IData)(vlSelf->top__DOT__MemWrite_MEM) 
                                      & (IData)(vlSelf->top__DOT__npu_select));
    vlSelf->top__DOT__dmem_select = (1U & ((~ (IData)(vlSelf->top__DOT__npu_select)) 
                                           & (~ (vlSelf->top__DOT__ALU_result_MEM 
                                                 >> 9U))));
    top__DOT__ALU_mux_out_EX = ((IData)(vlSelf->top__DOT__ALUSrc_EX)
                                 ? vlSelf->top__DOT__ImmExt_EX
                                 : vlSelf->top__DOT__ForwardB_data_EX);
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
}

VL_ATTR_COLD void Vtop___024root___eval_stl(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_stl\n"); );
    // Body
    if ((1ULL & vlSelf->__VstlTriggered.word(0U))) {
        Vtop___024root___stl_sequent__TOP__0(vlSelf);
    }
}

VL_ATTR_COLD void Vtop___024root___eval_triggers__stl(Vtop___024root* vlSelf);

VL_ATTR_COLD bool Vtop___024root___eval_phase__stl(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_phase__stl\n"); );
    // Init
    CData/*0:0*/ __VstlExecute;
    // Body
    Vtop___024root___eval_triggers__stl(vlSelf);
    __VstlExecute = vlSelf->__VstlTriggered.any();
    if (__VstlExecute) {
        Vtop___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__ico(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___dump_triggers__ico\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VicoTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VicoTriggered.word(0U))) {
        VL_DBG_MSGF("         'ico' region trigger index 0 is active: Internal 'ico' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__act(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VactTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge clk or posedge reset)\n");
    }
    if ((2ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 1 is active: @(negedge reset)\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__nba(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge clk or posedge reset)\n");
    }
    if ((2ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 1 is active: @(negedge reset)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vtop___024root___ctor_var_reset(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->clk = VL_RAND_RESET_I(1);
    vlSelf->reset = VL_RAND_RESET_I(1);
    vlSelf->host_tx_data = VL_RAND_RESET_I(32);
    vlSelf->host_tx_valid = VL_RAND_RESET_I(1);
    vlSelf->host_rx_data = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__stall_hazard = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__flush_IFID = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__flush_IDEX = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__PC_IF = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__PC_next = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__PC_ID = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__instruction_ID = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__ImmExt_ID = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__ALUSrc_ID = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__MemtoReg_ID = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__RegWrite_ID = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__MemRead_ID = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__MemWrite_ID = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__Branch_ID = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__ALUOp_ID = VL_RAND_RESET_I(2);
    vlSelf->top__DOT__PC_EX = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__RD1_EX = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__RD2_EX = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__ImmExt_EX = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__fun7_EX = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__fun3_EX = VL_RAND_RESET_I(3);
    vlSelf->top__DOT__RS1_EX = VL_RAND_RESET_I(5);
    vlSelf->top__DOT__RS2_EX = VL_RAND_RESET_I(5);
    vlSelf->top__DOT__RD_EX = VL_RAND_RESET_I(5);
    vlSelf->top__DOT__ALUSrc_EX = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__MemtoReg_EX = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__RegWrite_EX = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__MemRead_EX = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__MemWrite_EX = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__Branch_EX = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__ALUOp_EX = VL_RAND_RESET_I(2);
    vlSelf->top__DOT__ForwardB_data_EX = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__ALU_result_EX = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__zero_EX = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__MemtoReg_MEM = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__RegWrite_MEM = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__MemRead_MEM = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__MemWrite_MEM = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__Branch_MEM = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__zero_MEM = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__ALU_result_MEM = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__RD2_MEM = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__BranchTarget_MEM = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__RD_MEM = VL_RAND_RESET_I(5);
    vlSelf->top__DOT__MemData_MEM = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__npu_select = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__dmem_select = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__npu_MemWrite = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__MemtoReg_WB = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__RegWrite_WB = VL_RAND_RESET_I(1);
    vlSelf->top__DOT__ALU_result_WB = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__MemData_WB = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__RD_WB = VL_RAND_RESET_I(5);
    vlSelf->top__DOT__WriteBack_WB = VL_RAND_RESET_I(32);
    for (int __Vi0 = 0; __Vi0 < 64; ++__Vi0) {
        vlSelf->top__DOT__Inst_Memory__DOT__I_Mem[__Vi0] = VL_RAND_RESET_I(32);
    }
    VL_RAND_RESET_W(2048, vlSelf->top__DOT__Inst_Memory__DOT__fw_file);
    for (int __Vi0 = 0; __Vi0 < 32; ++__Vi0) {
        vlSelf->top__DOT__Reg_File__DOT__Registers[__Vi0] = VL_RAND_RESET_I(32);
    }
    vlSelf->top__DOT__Reg_File__DOT____VdfgTmp_h6aa9bfce__0 = 0;
    for (int __Vi0 = 0; __Vi0 < 64; ++__Vi0) {
        vlSelf->top__DOT__Data_mem__DOT__D_Memory[__Vi0] = VL_RAND_RESET_I(32);
    }
    for (int __Vi0 = 0; __Vi0 < 16; ++__Vi0) {
        vlSelf->top__DOT__npu__DOT__A_reg[__Vi0] = VL_RAND_RESET_I(8);
    }
    for (int __Vi0 = 0; __Vi0 < 16; ++__Vi0) {
        vlSelf->top__DOT__npu__DOT__B_reg[__Vi0] = VL_RAND_RESET_I(8);
    }
    vlSelf->top__DOT__npu__DOT__state = VL_RAND_RESET_I(2);
    vlSelf->top__DOT__npu__DOT__cycle_count = VL_RAND_RESET_I(4);
    vlSelf->top__DOT__npu__DOT__left_in_0 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__left_in_1 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__left_in_2 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__left_in_3 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__top_in_0 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__top_in_1 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__top_in_2 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__top_in_3 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_0_0 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_0_1 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_0_2 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_1_0 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_1_1 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_1_2 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_2_0 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_2_1 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_2_2 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_3_0 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_3_1 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__sa__DOT__a_r_3_2 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_0_0 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_0_1 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_0_2 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_0_3 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_1_0 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_1_1 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_1_2 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_1_3 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_2_0 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_2_1 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_2_2 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__sa__DOT__b_d_2_3 = VL_RAND_RESET_I(8);
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_0_0 = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_0_1 = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_0_2 = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_0_3 = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_1_0 = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_1_1 = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_1_2 = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_1_3 = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_2_0 = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_2_1 = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_2_2 = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_2_3 = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_3_0 = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_3_1 = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_3_2 = VL_RAND_RESET_I(32);
    vlSelf->top__DOT__npu__DOT__sa__DOT__acc_3_3 = VL_RAND_RESET_I(32);
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__reset__0 = VL_RAND_RESET_I(1);
}
