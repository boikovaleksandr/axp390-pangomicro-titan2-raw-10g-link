///////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2019 PANGO MICROSYSTEMS, INC
// ALL RIGHTS REVERVED.
//
// THE SOURCE CODE CONTAINED HEREIN IS PROPRIETARY TO PANGO MICROSYSTEMS, INC.
// IT SHALL NOT BE REPRODUCED OR DISCLOSED IN WHOLE OR IN PART OR USED BY
// PARTIES WITHOUT WRITTEN AUTHORIZATION FROM THE OWNER.
//
///////////////////////////////////////////////////////////////////////////////
//
// Library:
// Filename:
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
module  ipm2t_hssthp_rst_hpll_v1_3#( 
    parameter FREE_CLOCK_FREQ         = 100            ,//Unit is MHz, free clock  freq from GUI Freq: 0~200MHz
    parameter SINGLEHPLL_BONDING = "TRUE",
    parameter MULTHPLL_BONDING   = "TRUE"
)(
    //User Side 
    input  wire                   clk                     ,
    input  wire                   i_hpll_rst              ,
    input  wire                   HPLL_READY_0            ,
    input  wire                   HPLL_READY_1            ,
    input  wire                   i_wtchdg_clr_hpll       ,
    output wire    [1 : 0]        o_wtchdg_st_hpll        ,
    output wire                   o_hpll_done             ,
    output wire                   P_HPLL_POWERDOWN        ,
    output wire                   P_HPLL_RST              ,
    output wire                   P_HPLL_VCO_CALIB_EN     ,
    output wire                   P_REFCLK_DIV_SYNC       ,
    output wire                   P_HPLL_DIV_SYNC         ,
    output wire                   tx_sync_hpll
);


localparam PLL_LOCK_RISE_CNTR_WIDTH    = 12  ;
`ifdef IPM2T_HSST_SPEEDUP_SIM
localparam PLL_LOCK_RISE_CNTR_VALUE    = 20;
`else
localparam PLL_LOCK_RISE_CNTR_VALUE    = 2048;
`endif
localparam PLL_LOCK_WTCHDG_CNTR1_WIDTH = 10  ;
localparam PLL_LOCK_WTCHDG_CNTR2_WIDTH = 10  ; 

//****************************************************************************//
//                      Internal Signal                                       //
//****************************************************************************//
wire              i_hpll_rstn    ;
wire              s_hpll_rstn    ;
wire              s_pll_lock_0   ;
wire              s_pll_lock_1   ;
wire              pll_lock       ;
wire              wtchdg_rstn    ;
wire              hpll_rstn      ;
wire              s_pll_lock     ;
//****************************************************************************//
//                      Sequential and Logic                                  //
//****************************************************************************//
assign   i_hpll_rstn = ~i_hpll_rst        ;
//Sync signal
ipm2t_hssthp_rst_sync_v1_0 hpll_rstn_sync (.clk(clk), .rst_n(i_hpll_rstn), .sig_async(1'b1), .sig_synced(s_hpll_rstn));
ipm2t_hssthp_rst_sync_v1_0 hpll0_lock_sync (.clk(clk), .rst_n(s_hpll_rstn), .sig_async(HPLL_READY_0), .sig_synced(s_pll_lock_0));
ipm2t_hssthp_rst_sync_v1_0 hpll1_lock_sync (.clk(clk), .rst_n(s_hpll_rstn), .sig_async(HPLL_READY_1), .sig_synced(s_pll_lock_1));

assign s_pll_lock=(MULTHPLL_BONDING=="TRUE")?s_pll_lock_0&&s_pll_lock_1 : s_pll_lock_0 ;
//Debounce
ipm2t_hssthp_rst_debounce_v1_0  #(.RISE_CNTR_WIDTH(PLL_LOCK_RISE_CNTR_WIDTH), .RISE_CNTR_VALUE(PLL_LOCK_RISE_CNTR_VALUE))
pll0_lock_deb             (.clk(clk), .rst_n(s_hpll_rstn), .signal_b(s_pll_lock), .signal_deb(pll_lock));

ipm2t_hssthp_rst_wtchdg_v1_0  #(.WTCHDG_CNTR1_WIDTH(PLL_LOCK_WTCHDG_CNTR1_WIDTH), .WTCHDG_CNTR2_WIDTH(PLL_LOCK_WTCHDG_CNTR2_WIDTH))
pll0_lock_wtchdg       (.clk(clk), .rst_n(s_hpll_rstn), .wtchdg_clr(i_wtchdg_clr_hpll), .wtchdg_in(s_pll_lock), .wtchdg_rst_n(wtchdg_rstn), .wtchdg_st(o_wtchdg_st_hpll));

assign hpll_rstn  =  wtchdg_rstn && s_hpll_rstn  ;

//-----  Instance pll Rst Fsm Module -----------
ipm2t_hssthp_hpll_rst_fsm_v1_3#(
    .FREE_CLOCK_FREQ    (FREE_CLOCK_FREQ    ),
    .SINGLEHPLL_BONDING (SINGLEHPLL_BONDING ),
    .MULTHPLL_BONDING   (MULTHPLL_BONDING   )
) hpll_rst_fsm_0 (
    .clk                (clk                ),
    .rst_n              (hpll_rstn          ),
    .pll_lock           (s_pll_lock         ),
    .P_HPLL_POWERDOWN   (P_HPLL_POWERDOWN   ),
    .P_HPLL_RST         (P_HPLL_RST         ),
    .P_HPLL_VCO_CALIB_EN(P_HPLL_VCO_CALIB_EN),
    .P_REFCLK_DIV_SYNC  (P_REFCLK_DIV_SYNC  ),
    .P_HPLL_DIV_SYNC    (P_HPLL_DIV_SYNC    ),
    .tx_sync_hpll       (tx_sync_hpll       ),
    .o_hpll_done        (o_hpll_done        ) 
);


endmodule
