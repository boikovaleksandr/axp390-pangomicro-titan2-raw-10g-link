
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
`timescale 1ns/100fs

module Transceiver_10G_if_top (
    
    input          i_free_clk                    ,
    input          i_hpll_rst                    ,
    input          i_hpll_wtchdg_clr             ,
    input          i_hsst_fifo_clr_0             ,          
    input  [2:0]   i_loop_dbg_0                  ,
    output [1:0]   o_hpll_wtchdg_st              ,
    output         o_hpll_done                   ,
    output         o_txlane_done_0               ,
    output         o_rxlane_done_0               ,
    input          i_p_refckn_0                  ,
    input          i_p_refckp_0                  ,
    output         o_p_refck2core_0              ,
    output         o_p_hpll_lock                 ,
    output         o_p_rx_sigdet_sta_0           ,
    output         o_p_lx_cdr_align_0            ,
    input          i_p_l0rxn                     ,
    input          i_p_l0rxp                     ,
    output         o_p_l0txn                     ,
    output         o_p_l0txp                     ,
    input          i_p_cfg_clk                   ,
    input          i_p_cfg_rst                   ,
    input          i_p_cfg_psel                  ,
    input          i_p_cfg_enable                ,
    input          i_p_cfg_write                 ,
    input [15:0]   i_p_cfg_addr                  ,
    input [7:0]    i_p_cfg_wdata                 ,
    output [7:0]   o_p_cfg_rdata                 ,
    output         o_p_cfg_int                   ,
    output         o_p_cfg_ready                 ,
    output [5:0]   o_rxstatus_0                  ,
    output [7:0]   o_rdisper_0                   , 
    output [7:0]   o_rdecer_0                    , 
    input          src_rst                       ,
    input          chk_rst                       ,
    output [3:0]   o_pl_err                      
);


// ********************* UI parameters *********************
localparam CH0_PROTOCOL = "CUSTOMERIZEDx1";
localparam CH1_PROTOCOL = "CUSTOMERIZEDx1";
localparam CH2_PROTOCOL = "CUSTOMERIZEDx1";
localparam CH3_PROTOCOL = "CUSTOMERIZEDx1";
localparam CH0_RXPCS_CTC = "Bypassed";
localparam CH1_RXPCS_CTC = "Bypassed";
localparam CH2_RXPCS_CTC = "Bypassed";
localparam CH3_RXPCS_CTC = "Bypassed";
 localparam TD_8BIT_ONLY_0 = "FALSE"; 
 localparam TD_10BIT_ONLY_0 = "FALSE"; 
 localparam TD_8B10B_8BIT_0 = "FALSE"; 
 localparam TD_16BIT_ONLY_0 = "FALSE"; 
 localparam TD_20BIT_ONLY_0 = "FALSE"; 
 localparam TD_8B10B_16BIT_0 = "FALSE"; 
 localparam TD_32BIT_ONLY_0 = "FALSE"; 
 localparam TD_40BIT_ONLY_0 = "FALSE"; 
 localparam TD_64BIT_ONLY_0 = "FALSE"; 
 localparam TD_80BIT_ONLY_0 = "FALSE"; 
 localparam TD_8B10B_32BIT_0 = "FALSE"; 
 localparam TD_8B10B_64BIT_0 = "FALSE"; 
 localparam TD_64B66B_16BIT_0 = "FALSE"; 
 localparam TD_64B66B_32BIT_0 = "FALSE"; 
 localparam TD_64B66B_64BIT_0 = "TRUE"; 
 localparam TD_64B67B_16BIT_0 = "FALSE"; 
 localparam TD_64B67B_32BIT_0 = "FALSE"; 
 localparam TD_64B67B_64BIT_0 = "FALSE"; 
 localparam TD_64B66B_CAUI_32BIT_0 = "FALSE"; 
 localparam TD_64B66B_CAUI_64BIT_0 = "FALSE"; 
 localparam TD_128B130B_32BIT_0 = "FALSE"; 
 localparam TD_128B130B_64BIT_0 = "FALSE"; 
 localparam TD_8BIT_ONLY_1 = "FALSE"; 
 localparam TD_10BIT_ONLY_1 = "FALSE"; 
 localparam TD_8B10B_8BIT_1 = "FALSE"; 
 localparam TD_16BIT_ONLY_1 = "FALSE"; 
 localparam TD_20BIT_ONLY_1 = "FALSE"; 
 localparam TD_8B10B_16BIT_1 = "FALSE"; 
 localparam TD_32BIT_ONLY_1 = "FALSE"; 
 localparam TD_40BIT_ONLY_1 = "FALSE"; 
 localparam TD_64BIT_ONLY_1 = "FALSE"; 
 localparam TD_80BIT_ONLY_1 = "FALSE"; 
 localparam TD_8B10B_32BIT_1 = "FALSE"; 
 localparam TD_8B10B_64BIT_1 = "FALSE"; 
 localparam TD_64B66B_16BIT_1 = "FALSE"; 
 localparam TD_64B66B_32BIT_1 = "FALSE"; 
 localparam TD_64B66B_64BIT_1 = "FALSE"; 
 localparam TD_64B67B_16BIT_1 = "FALSE"; 
 localparam TD_64B67B_32BIT_1 = "FALSE"; 
 localparam TD_64B67B_64BIT_1 = "FALSE"; 
 localparam TD_64B66B_CAUI_32BIT_1 = "FALSE"; 
 localparam TD_64B66B_CAUI_64BIT_1 = "FALSE"; 
 localparam TD_128B130B_32BIT_1 = "FALSE"; 
 localparam TD_128B130B_64BIT_1 = "FALSE"; 
 localparam TD_8BIT_ONLY_2 = "FALSE"; 
 localparam TD_10BIT_ONLY_2 = "FALSE"; 
 localparam TD_8B10B_8BIT_2 = "FALSE"; 
 localparam TD_16BIT_ONLY_2 = "FALSE"; 
 localparam TD_20BIT_ONLY_2 = "FALSE"; 
 localparam TD_8B10B_16BIT_2 = "FALSE"; 
 localparam TD_32BIT_ONLY_2 = "FALSE"; 
 localparam TD_40BIT_ONLY_2 = "FALSE"; 
 localparam TD_64BIT_ONLY_2 = "FALSE"; 
 localparam TD_80BIT_ONLY_2 = "FALSE"; 
 localparam TD_8B10B_32BIT_2 = "FALSE"; 
 localparam TD_8B10B_64BIT_2 = "FALSE"; 
 localparam TD_64B66B_16BIT_2 = "FALSE"; 
 localparam TD_64B66B_32BIT_2 = "FALSE"; 
 localparam TD_64B66B_64BIT_2 = "FALSE"; 
 localparam TD_64B67B_16BIT_2 = "FALSE"; 
 localparam TD_64B67B_32BIT_2 = "FALSE"; 
 localparam TD_64B67B_64BIT_2 = "FALSE"; 
 localparam TD_64B66B_CAUI_32BIT_2 = "FALSE"; 
 localparam TD_64B66B_CAUI_64BIT_2 = "FALSE"; 
 localparam TD_128B130B_32BIT_2 = "FALSE"; 
 localparam TD_128B130B_64BIT_2 = "FALSE"; 
 localparam TD_8BIT_ONLY_3 = "FALSE"; 
 localparam TD_10BIT_ONLY_3 = "FALSE"; 
 localparam TD_8B10B_8BIT_3 = "FALSE"; 
 localparam TD_16BIT_ONLY_3 = "FALSE"; 
 localparam TD_20BIT_ONLY_3 = "FALSE"; 
 localparam TD_8B10B_16BIT_3 = "FALSE"; 
 localparam TD_32BIT_ONLY_3 = "FALSE"; 
 localparam TD_40BIT_ONLY_3 = "FALSE"; 
 localparam TD_64BIT_ONLY_3 = "FALSE"; 
 localparam TD_80BIT_ONLY_3 = "FALSE"; 
 localparam TD_8B10B_32BIT_3 = "FALSE"; 
 localparam TD_8B10B_64BIT_3 = "FALSE"; 
 localparam TD_64B66B_16BIT_3 = "FALSE"; 
 localparam TD_64B66B_32BIT_3 = "FALSE"; 
 localparam TD_64B66B_64BIT_3 = "FALSE"; 
 localparam TD_64B67B_16BIT_3 = "FALSE"; 
 localparam TD_64B67B_32BIT_3 = "FALSE"; 
 localparam TD_64B67B_64BIT_3 = "FALSE"; 
 localparam TD_64B66B_CAUI_32BIT_3 = "FALSE"; 
 localparam TD_64B66B_CAUI_64BIT_3 = "FALSE"; 
 localparam TD_128B130B_32BIT_3 = "FALSE"; 
 localparam TD_128B130B_64BIT_3 = "FALSE"; 
 localparam RD_8BIT_ONLY_0 = "FALSE"; 
 localparam RD_10BIT_ONLY_0 = "FALSE"; 
 localparam RD_8B10B_8BIT_0 = "FALSE"; 
 localparam RD_16BIT_ONLY_0 = "FALSE"; 
 localparam RD_20BIT_ONLY_0 = "FALSE"; 
 localparam RD_8B10B_16BIT_0 = "FALSE"; 
 localparam RD_32BIT_ONLY_0 = "FALSE"; 
 localparam RD_40BIT_ONLY_0 = "FALSE"; 
 localparam RD_64BIT_ONLY_0 = "FALSE"; 
 localparam RD_80BIT_ONLY_0 = "FALSE"; 
 localparam RD_8B10B_32BIT_0 = "FALSE"; 
 localparam RD_8B10B_64BIT_0 = "FALSE"; 
 localparam RD_64B66B_16BIT_0 = "FALSE"; 
 localparam RD_64B66B_32BIT_0 = "FALSE"; 
 localparam RD_64B66B_64BIT_0 = "TRUE"; 
 localparam RD_64B67B_16BIT_0 = "FALSE"; 
 localparam RD_64B67B_32BIT_0 = "FALSE"; 
 localparam RD_64B67B_64BIT_0 = "FALSE"; 
 localparam RD_64B66B_CAUI_32BIT_0 = "FALSE"; 
 localparam RD_64B66B_CAUI_64BIT_0 = "FALSE"; 
 localparam RD_128B130B_32BIT_0 = "FALSE"; 
 localparam RD_128B130B_64BIT_0 = "FALSE"; 
 localparam RD_8BIT_ONLY_1 = "FALSE"; 
 localparam RD_10BIT_ONLY_1 = "FALSE"; 
 localparam RD_8B10B_8BIT_1 = "FALSE"; 
 localparam RD_16BIT_ONLY_1 = "FALSE"; 
 localparam RD_20BIT_ONLY_1 = "FALSE"; 
 localparam RD_8B10B_16BIT_1 = "FALSE"; 
 localparam RD_32BIT_ONLY_1 = "FALSE"; 
 localparam RD_40BIT_ONLY_1 = "FALSE"; 
 localparam RD_64BIT_ONLY_1 = "FALSE"; 
 localparam RD_80BIT_ONLY_1 = "FALSE"; 
 localparam RD_8B10B_32BIT_1 = "FALSE"; 
 localparam RD_8B10B_64BIT_1 = "FALSE"; 
 localparam RD_64B66B_16BIT_1 = "FALSE"; 
 localparam RD_64B66B_32BIT_1 = "FALSE"; 
 localparam RD_64B66B_64BIT_1 = "FALSE"; 
 localparam RD_64B67B_16BIT_1 = "FALSE"; 
 localparam RD_64B67B_32BIT_1 = "FALSE"; 
 localparam RD_64B67B_64BIT_1 = "FALSE"; 
 localparam RD_64B66B_CAUI_32BIT_1 = "FALSE"; 
 localparam RD_64B66B_CAUI_64BIT_1 = "FALSE"; 
 localparam RD_128B130B_32BIT_1 = "FALSE"; 
 localparam RD_128B130B_64BIT_1 = "FALSE"; 
 localparam RD_8BIT_ONLY_2 = "FALSE"; 
 localparam RD_10BIT_ONLY_2 = "FALSE"; 
 localparam RD_8B10B_8BIT_2 = "FALSE"; 
 localparam RD_16BIT_ONLY_2 = "FALSE"; 
 localparam RD_20BIT_ONLY_2 = "FALSE"; 
 localparam RD_8B10B_16BIT_2 = "FALSE"; 
 localparam RD_32BIT_ONLY_2 = "FALSE"; 
 localparam RD_40BIT_ONLY_2 = "FALSE"; 
 localparam RD_64BIT_ONLY_2 = "FALSE"; 
 localparam RD_80BIT_ONLY_2 = "FALSE"; 
 localparam RD_8B10B_32BIT_2 = "FALSE"; 
 localparam RD_8B10B_64BIT_2 = "FALSE"; 
 localparam RD_64B66B_16BIT_2 = "FALSE"; 
 localparam RD_64B66B_32BIT_2 = "FALSE"; 
 localparam RD_64B66B_64BIT_2 = "FALSE"; 
 localparam RD_64B67B_16BIT_2 = "FALSE"; 
 localparam RD_64B67B_32BIT_2 = "FALSE"; 
 localparam RD_64B67B_64BIT_2 = "FALSE"; 
 localparam RD_64B66B_CAUI_32BIT_2 = "FALSE"; 
 localparam RD_64B66B_CAUI_64BIT_2 = "FALSE"; 
 localparam RD_128B130B_32BIT_2 = "FALSE"; 
 localparam RD_128B130B_64BIT_2 = "FALSE"; 
 localparam RD_8BIT_ONLY_3 = "FALSE"; 
 localparam RD_10BIT_ONLY_3 = "FALSE"; 
 localparam RD_8B10B_8BIT_3 = "FALSE"; 
 localparam RD_16BIT_ONLY_3 = "FALSE"; 
 localparam RD_20BIT_ONLY_3 = "FALSE"; 
 localparam RD_8B10B_16BIT_3 = "FALSE"; 
 localparam RD_32BIT_ONLY_3 = "FALSE"; 
 localparam RD_40BIT_ONLY_3 = "FALSE"; 
 localparam RD_64BIT_ONLY_3 = "FALSE"; 
 localparam RD_80BIT_ONLY_3 = "FALSE"; 
 localparam RD_8B10B_32BIT_3 = "FALSE"; 
 localparam RD_8B10B_64BIT_3 = "FALSE"; 
 localparam RD_64B66B_16BIT_3 = "FALSE"; 
 localparam RD_64B66B_32BIT_3 = "FALSE"; 
 localparam RD_64B66B_64BIT_3 = "FALSE"; 
 localparam RD_64B67B_16BIT_3 = "FALSE"; 
 localparam RD_64B67B_32BIT_3 = "FALSE"; 
 localparam RD_64B67B_64BIT_3 = "FALSE"; 
 localparam RD_64B66B_CAUI_32BIT_3 = "FALSE"; 
 localparam RD_64B66B_CAUI_64BIT_3 = "FALSE"; 
 localparam RD_128B130B_32BIT_3 = "FALSE"; 
 localparam RD_128B130B_64BIT_3 = "FALSE"; 

// ********************* DUT *********************

wire         o_p_calib_done                  ;
wire         i_p_pll_tx_sel_0              ;
wire         i_p_pll_tx_sel_1              ;
wire         i_p_pll_tx_sel_2              ;
wire         i_p_pll_tx_sel_3              ;
wire         i_p_pll_rx_sel_0              ;
wire         i_p_pll_rx_sel_1              ;
wire         i_p_pll_rx_sel_2              ;
wire         i_p_pll_rx_sel_3              ;
assign       i_p_pll_tx_sel_0                = 1'b0;
assign       i_p_pll_tx_sel_1                = 1'b0;
assign       i_p_pll_tx_sel_2                = 1'b0;
assign       i_p_pll_tx_sel_3                = 1'b0;
assign       i_p_pll_rx_sel_0                = 1'b0;
assign       i_p_pll_rx_sel_1                = 1'b0;
assign       i_p_pll_rx_sel_2                = 1'b0;
assign       i_p_pll_rx_sel_3                = 1'b0;
wire           i_pll_lock_tx_0               = 1'b1;
wire           i_pll_lock_tx_1               = 1'b1;
wire           i_pll_lock_tx_2               = 1'b1;
wire           i_pll_lock_tx_3               = 1'b1;
wire           i_pll_lock_rx_0               = 1'b1;
wire           i_pll_lock_rx_1               = 1'b1;
wire           i_pll_lock_rx_2               = 1'b1;
wire           i_pll_lock_rx_3               = 1'b1;
wire           o_p_clk2core_tx_0             ;
wire           o_p_clk2core_tx_1             ;
wire           o_p_clk2core_tx_2             ;
wire           o_p_clk2core_tx_3             ;
wire           i_p_tx0_clk_fr_core           ;
wire           i_p_tx1_clk_fr_core           ;
wire           i_p_tx2_clk_fr_core           ;
wire           i_p_tx3_clk_fr_core           ;
wire           i_p_tx0_clk2_fr_core          ;
wire           i_p_tx1_clk2_fr_core          ;
wire           i_p_tx2_clk2_fr_core          ;
wire           i_p_tx3_clk2_fr_core          ;
wire           o_p_clk2core_rx_0             ;
wire           o_p_clk2core_rx_1             ;
wire           o_p_clk2core_rx_2             ;
wire           o_p_clk2core_rx_3             ;
wire           i_p_clk2core_rx_0             ;
wire           i_p_clk2core_rx_1             ;
wire           i_p_clk2core_rx_2             ;
wire           i_p_clk2core_rx_3             ;
wire           i_p_rx0_clk_fr_core           ;
wire           i_p_rx1_clk_fr_core           ;
wire           i_p_rx2_clk_fr_core           ;
wire           i_p_rx3_clk_fr_core           ;
wire           i_p_rx0_clk2_fr_core          ;
wire           i_p_rx1_clk2_fr_core          ;
wire           i_p_rx2_clk2_fr_core          ;
wire           i_p_rx3_clk2_fr_core          ;

wire   [63:0]  i_txd_0                       ;
wire   [6:0]   i_txq_0                       ;
wire   [2:0]   i_txh_0                       ;
//fabric clock
generate
    if((CH0_PROTOCOL=="XAUI")||(CH0_PROTOCOL=="PCIEx4")||(CH0_PROTOCOL=="CUSTOMERIZEDx4")) begin : BONDING_LANE0123
        assign          i_p_tx0_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_tx1_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_tx2_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_tx3_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_rx0_clk_fr_core           = (CH0_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_0 : o_p_clk2core_tx_0;
        assign          i_p_rx1_clk_fr_core           = (CH1_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_0 : o_p_clk2core_tx_0;
        assign          i_p_rx2_clk_fr_core           = (CH2_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_0 : o_p_clk2core_tx_0;
        assign          i_p_rx3_clk_fr_core           = (CH3_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_0 : o_p_clk2core_tx_0;
    end
    else if((CH0_PROTOCOL=="CUSTOMERIZEDx2" || CH0_PROTOCOL=="PCIEx2") && (CH2_PROTOCOL!="CUSTOMERIZEDx2" && CH2_PROTOCOL!="PCIEx2"))begin : BONDING_LANE01
        assign          i_p_tx0_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_tx1_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_tx2_clk_fr_core           = o_p_clk2core_tx_2; 
        assign          i_p_tx3_clk_fr_core           = o_p_clk2core_tx_3; 
        assign          i_p_rx0_clk_fr_core           = (CH0_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_0 : o_p_clk2core_tx_0;
        assign          i_p_rx1_clk_fr_core           = (CH1_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_0 : o_p_clk2core_tx_0;
        assign          i_p_rx2_clk_fr_core           = (CH2_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_2 : o_p_clk2core_tx_2;
        assign          i_p_rx3_clk_fr_core           = (CH3_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_3 : o_p_clk2core_tx_3;
    end
    else if((CH0_PROTOCOL!="CUSTOMERIZEDx2" && CH0_PROTOCOL!="PCIEx2") && (CH2_PROTOCOL=="CUSTOMERIZEDx2" || CH2_PROTOCOL=="PCIEx2")) begin : BONDING_LANE23
        assign          i_p_tx0_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_tx1_clk_fr_core           = o_p_clk2core_tx_1; 
        assign          i_p_tx2_clk_fr_core           = o_p_clk2core_tx_2; 
        assign          i_p_tx3_clk_fr_core           = o_p_clk2core_tx_2; 
        assign          i_p_rx0_clk_fr_core           = (CH0_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_0 : o_p_clk2core_tx_0;
        assign          i_p_rx1_clk_fr_core           = (CH1_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_1 : o_p_clk2core_tx_1;
        assign          i_p_rx2_clk_fr_core           = (CH2_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_2 : o_p_clk2core_tx_2;
        assign          i_p_rx3_clk_fr_core           = (CH3_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_2 : o_p_clk2core_tx_2;
    end
    else if((CH0_PROTOCOL=="CUSTOMERIZEDx2" || CH0_PROTOCOL=="PCIEx2") && (CH2_PROTOCOL=="CUSTOMERIZEDx2" || CH2_PROTOCOL=="PCIEx2")) begin : BONDING_LANE01_23
        assign          i_p_tx0_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_tx1_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_tx2_clk_fr_core           = o_p_clk2core_tx_2; 
        assign          i_p_tx3_clk_fr_core           = o_p_clk2core_tx_2; 
        assign          i_p_rx0_clk_fr_core           = (CH0_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_0 : o_p_clk2core_tx_0;
        assign          i_p_rx1_clk_fr_core           = (CH1_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_0 : o_p_clk2core_tx_0;
        assign          i_p_rx2_clk_fr_core           = (CH2_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_2 : o_p_clk2core_tx_2;
        assign          i_p_rx3_clk_fr_core           = (CH3_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_2 : o_p_clk2core_tx_2;
    end
    else if(CH0_PROTOCOL=="TX_CUSTOMERIZEDx4") begin : TX_BONDING_LANE0123
        assign          i_p_tx0_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_tx1_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_tx2_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_tx3_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_rx0_clk_fr_core           = (CH0_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_0 : o_p_clk2core_tx_0;
        assign          i_p_rx1_clk_fr_core           = (CH1_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_1 : o_p_clk2core_tx_1;
        assign          i_p_rx2_clk_fr_core           = (CH2_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_2 : o_p_clk2core_tx_2;
        assign          i_p_rx3_clk_fr_core           = (CH3_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_3 : o_p_clk2core_tx_3;
    end
    else if(CH0_PROTOCOL=="TX_CUSTOMERIZEDx2" && (CH2_PROTOCOL!="CUSTOMERIZEDx2" && CH2_PROTOCOL!="PCIEx2" && CH2_PROTOCOL!="TX_CUSTOMERIZEDx2")) begin : TX_BONDING_LANE01
        assign          i_p_tx0_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_tx1_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_tx2_clk_fr_core           = o_p_clk2core_tx_2; 
        assign          i_p_tx3_clk_fr_core           = o_p_clk2core_tx_3; 
        assign          i_p_rx0_clk_fr_core           = (CH0_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_0 : o_p_clk2core_tx_0;
        assign          i_p_rx1_clk_fr_core           = (CH1_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_1 : o_p_clk2core_tx_1;
        assign          i_p_rx2_clk_fr_core           = (CH2_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_2 : o_p_clk2core_tx_2;
        assign          i_p_rx3_clk_fr_core           = (CH3_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_3 : o_p_clk2core_tx_3;         
    end
    else if((CH0_PROTOCOL!="CUSTOMERIZEDx2" && CH0_PROTOCOL!="PCIEx2" && CH0_PROTOCOL!="TX_CUSTOMERIZEDx2") && CH2_PROTOCOL=="TX_CUSTOMERIZEDx2") begin : TX_BONDING_LANE23
        assign          i_p_tx0_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_tx1_clk_fr_core           = o_p_clk2core_tx_1; 
        assign          i_p_tx2_clk_fr_core           = o_p_clk2core_tx_2; 
        assign          i_p_tx3_clk_fr_core           = o_p_clk2core_tx_2; 
        assign          i_p_rx0_clk_fr_core           = (CH0_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_0 : o_p_clk2core_tx_0;
        assign          i_p_rx1_clk_fr_core           = (CH1_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_1 : o_p_clk2core_tx_1;
        assign          i_p_rx2_clk_fr_core           = (CH2_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_2 : o_p_clk2core_tx_2;
        assign          i_p_rx3_clk_fr_core           = (CH3_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_3 : o_p_clk2core_tx_3;   
    end
    else if(CH0_PROTOCOL=="TX_CUSTOMERIZEDx2" && CH2_PROTOCOL=="TX_CUSTOMERIZEDx2") begin : TX_BONDING_LANE01_23
        assign          i_p_tx0_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_tx1_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_tx2_clk_fr_core           = o_p_clk2core_tx_2; 
        assign          i_p_tx3_clk_fr_core           = o_p_clk2core_tx_2;
        assign          i_p_rx0_clk_fr_core           = (CH0_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_0 : o_p_clk2core_tx_0;
        assign          i_p_rx1_clk_fr_core           = (CH1_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_1 : o_p_clk2core_tx_1;
        assign          i_p_rx2_clk_fr_core           = (CH2_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_2 : o_p_clk2core_tx_2;
        assign          i_p_rx3_clk_fr_core           = (CH3_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_3 : o_p_clk2core_tx_3;             
    end
    else begin : NO_BONDING
        assign          i_p_tx0_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_tx1_clk_fr_core           = o_p_clk2core_tx_1; 
        assign          i_p_tx2_clk_fr_core           = o_p_clk2core_tx_2; 
        assign          i_p_tx3_clk_fr_core           = o_p_clk2core_tx_3; 
        assign          i_p_rx0_clk_fr_core           = (CH0_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_0 : o_p_clk2core_tx_0;
        assign          i_p_rx1_clk_fr_core           = (CH1_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_1 : o_p_clk2core_tx_1;
        assign          i_p_rx2_clk_fr_core           = (CH2_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_2 : o_p_clk2core_tx_2;
        assign          i_p_rx3_clk_fr_core           = (CH3_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_3 : o_p_clk2core_tx_3;
    end
endgenerate

generate
    if(CH0_PROTOCOL=="PCIEx4") begin : PCIEx4
        assign          i_p_tx0_clk2_fr_core           = o_p_clk2core_rx_0;
        assign          i_p_tx1_clk2_fr_core           = o_p_clk2core_rx_0;
        assign          i_p_tx2_clk2_fr_core           = o_p_clk2core_rx_0;
        assign          i_p_tx3_clk2_fr_core           = o_p_clk2core_rx_0;
        assign          i_p_rx0_clk2_fr_core           = o_p_clk2core_rx_0;
        assign          i_p_rx1_clk2_fr_core           = o_p_clk2core_rx_0;
        assign          i_p_rx2_clk2_fr_core           = o_p_clk2core_rx_0;
        assign          i_p_rx3_clk2_fr_core           = o_p_clk2core_rx_0;
    end
    else if(CH0_PROTOCOL=="PCIEx2" && CH2_PROTOCOL!="PCIEx2")begin : PCIEx2_01
        assign          i_p_tx0_clk2_fr_core           = o_p_clk2core_rx_0;
        assign          i_p_tx1_clk2_fr_core           = o_p_clk2core_rx_0;
        assign          i_p_tx2_clk2_fr_core           = 1'b0;
        assign          i_p_tx3_clk2_fr_core           = 1'b0;
        assign          i_p_rx0_clk2_fr_core           = o_p_clk2core_rx_0;
        assign          i_p_rx1_clk2_fr_core           = o_p_clk2core_rx_0;
        assign          i_p_rx2_clk2_fr_core           = 1'b0;
        assign          i_p_rx3_clk2_fr_core           = 1'b0;
    end
    else if(CH0_PROTOCOL!="PCIEx2" && CH2_PROTOCOL=="PCIEx2") begin : PCIEx2_23
        assign          i_p_tx0_clk2_fr_core           = 1'b0;
        assign          i_p_tx1_clk2_fr_core           = 1'b0;
        assign          i_p_tx2_clk2_fr_core           = o_p_clk2core_rx_2;
        assign          i_p_tx3_clk2_fr_core           = o_p_clk2core_rx_2;
        assign          i_p_rx0_clk2_fr_core           = 1'b0;
        assign          i_p_rx1_clk2_fr_core           = 1'b0;
        assign          i_p_rx2_clk2_fr_core           = o_p_clk2core_rx_2;
        assign          i_p_rx3_clk2_fr_core           = o_p_clk2core_rx_2;
    end
    else if(CH0_PROTOCOL=="PCIEx2" && CH2_PROTOCOL=="PCIEx2") begin : PCIEx2_01_23
        assign          i_p_tx0_clk2_fr_core           = o_p_clk2core_rx_0;
        assign          i_p_tx1_clk2_fr_core           = o_p_clk2core_rx_0;
        assign          i_p_tx2_clk2_fr_core           = o_p_clk2core_rx_2;
        assign          i_p_tx3_clk2_fr_core           = o_p_clk2core_rx_2;
        assign          i_p_rx0_clk2_fr_core           = o_p_clk2core_rx_0;
        assign          i_p_rx1_clk2_fr_core           = o_p_clk2core_rx_0;
        assign          i_p_rx2_clk2_fr_core           = o_p_clk2core_rx_2;
        assign          i_p_rx3_clk2_fr_core           = o_p_clk2core_rx_2;
    end
    else begin : NO_PCIEx2x4 
        assign          i_p_tx0_clk2_fr_core           = o_p_clk2core_rx_0;
        assign          i_p_tx1_clk2_fr_core           = o_p_clk2core_rx_1;
        assign          i_p_tx2_clk2_fr_core           = o_p_clk2core_rx_2;
        assign          i_p_tx3_clk2_fr_core           = o_p_clk2core_rx_3;
        assign          i_p_rx0_clk2_fr_core           = o_p_clk2core_rx_0;
        assign          i_p_rx1_clk2_fr_core           = o_p_clk2core_rx_1;
        assign          i_p_rx2_clk2_fr_core           = o_p_clk2core_rx_2;
        assign          i_p_rx3_clk2_fr_core           = o_p_clk2core_rx_3;
    end
endgenerate


//Checker
wire  [79:0] o_rxd_0                       ; // output [39:0]
wire  [7:0]  o_rxk_0                       ; // output [3:0]
wire         o_rxd_vld_0                   ; // output         
wire  [2:0]  o_rxh_0                       ; // output [2:0]   
wire         o_rxh_vld_0                   ; // output         
wire         o_rxq_start_0                 ; // output         
wire  [2:0]  o_rxh_h_0                     ; // output [2:0]   
wire         o_rxd_vld_h_0                 ; // output         
wire         o_rxq_start_h_0               ; // output         
wire  [79:0] o_rxd_1                       ; // output [39:0]
wire  [7:0]  o_rxk_1                       ; // output [3:0]
wire         o_rxd_vld_1                   ; // output         
wire  [2:0]  o_rxh_1                       ; // output [2:0]   
wire         o_rxh_vld_1                   ; // output         
wire         o_rxq_start_1                 ; // output         
wire  [2:0]  o_rxh_h_1                     ; // output [2:0]   
wire         o_rxd_vld_h_1                 ; // output         
wire         o_rxq_start_h_1               ; // output         
wire  [79:0] o_rxd_2                       ; // output [39:0]
wire  [7:0]  o_rxk_2                       ; // output [3:0]
wire         o_rxd_vld_2                   ; // output         
wire  [2:0]  o_rxh_2                       ; // output [2:0]   
wire         o_rxh_vld_2                   ; // output         
wire         o_rxq_start_2                 ; // output         
wire  [2:0]  o_rxh_h_2                     ; // output [2:0]   
wire         o_rxd_vld_h_2                 ; // output         
wire         o_rxq_start_h_2               ; // output         
wire  [79:0] o_rxd_3                       ; // output [39:0]
wire  [7:0]  o_rxk_3                       ; // output [3:0]
wire         o_rxd_vld_3                   ; // output         
wire  [2:0]  o_rxh_3                       ; // output [2:0]   
wire         o_rxh_vld_3                   ; // output         
wire         o_rxq_start_3                 ; // output         
wire  [2:0]  o_rxh_h_3                     ; // output [2:0]   
wire         o_rxd_vld_h_3                 ; // output         
wire         o_rxq_start_h_3               ; // output         
wire         o_p_rxpcs_slip_0              ; 
wire         o_p_rxpcs_slip_1              ; 
wire         o_p_rxpcs_slip_2              ; 
wire         o_p_rxpcs_slip_3              ; 

Transceiver_10G_if U_INST_IF (
    
    .i_free_clk                    (i_free_clk                    ), // input                                                                  
    .i_hpll_wtchdg_clr             (i_hpll_wtchdg_clr             ), // input                                                                         
    .i_hpll_rst                    (i_hpll_rst                    ), // input                                                                 
    .i_hsst_fifo_clr_0             (i_hsst_fifo_clr_0             ), // input                           
    .i_loop_dbg_0                  (i_loop_dbg_0                  ), // input                                                                            
    .o_hpll_wtchdg_st              (o_hpll_wtchdg_st              ), // output [1:0]                                                                     
    .o_hpll_done                   (o_hpll_done                   ), // output                                                                   
    .o_txlane_done_0               (o_txlane_done_0               ), // output                                                                   
    .o_rxlane_done_0               (o_rxlane_done_0               ), // output                                                                 
    .o_p_clk2core_tx_0             (o_p_clk2core_tx_0             ), // output                                                               
    .i_p_tx0_clk_fr_core           (i_p_tx0_clk_fr_core           ), // input                                                                  
    .o_p_clk2core_rx_0             (o_p_clk2core_rx_0             ), // output                                                               
    .i_p_rx0_clk_fr_core           (i_p_rx0_clk_fr_core           ), // input                                                                   
    .o_p_refck2core_0              (o_p_refck2core_0              ), // output                                                                     
    .o_p_hpll_lock                 (o_p_hpll_lock                 ), // output                                                               
    .o_p_rx_sigdet_sta_0           (o_p_rx_sigdet_sta_0           ), // output                                                                
    .o_p_lx_cdr_align_0            (o_p_lx_cdr_align_0            ), // output                                                                  
    .i_p_rxpcs_slip_0              (o_p_rxpcs_slip_0              ), // input                                                               
    .i_p_pcs_nearend_loop_0        (1'b0                          ), // input                                                                      
    .i_p_pcs_farend_loop_0         (1'b0                          ), // input                                                                      
    .i_p_pma_nearend_ploop_0       (1'b0                          ), // input                                                                      
    .i_p_pma_nearend_sloop_0       (1'b0                          ), // input                                                                      
    .i_p_pma_farend_ploop_0        (1'b0                          ), // input                                                                    
    .i_p_cfg_clk                   (i_p_cfg_clk                   ), // input                                                                           
    .i_p_cfg_rst                   (i_p_cfg_rst                   ), // input                                                                           
    .i_p_cfg_psel                  (i_p_cfg_psel                  ), // input                                                                           
    .i_p_cfg_enable                (i_p_cfg_enable                ), // input                                                                           
    .i_p_cfg_write                 (i_p_cfg_write                 ), // input                                                                           
    .i_p_cfg_addr                  (i_p_cfg_addr                  ), // input  [15:0]                                                                   
    .i_p_cfg_wdata                 (i_p_cfg_wdata                 ), // input  [7:0]                                                                    
    .o_p_cfg_rdata                 (o_p_cfg_rdata                 ), // output [7:0]                                                                    
    .o_p_cfg_int                   (o_p_cfg_int                   ), // output                                                                          
    .o_p_cfg_ready                 (o_p_cfg_ready                 ), // output        
    .o_p_calib_done                (o_p_calib_done                ), // output                                                                      
    .i_p_l0rxn                     (i_p_l0rxn                     ), // input                                                                       
    .i_p_l0rxp                     (i_p_l0rxp                     ), // input                                                                       
    .o_p_l0txn                     (o_p_l0txn                     ), // output                                                                      
    .o_p_l0txp                     (o_p_l0txp                     ), // output                                                               
    .i_txd_0                       (i_txd_0                       ), // input  [63:0]         
    .i_txq_0                       (i_txq_0                       ), // input  [6:0]          
    .i_txh_0                       (i_txh_0                       ), // input  [2:0]                                                         
    .o_rxstatus_0                  (o_rxstatus_0                  ), // output [5:0]          
    .o_rxd_vld_0                   (o_rxd_vld_0                   ), // output                
    .o_rxd_vld_h_0                 (o_rxd_vld_h_0                 ), // output                
    .o_rxd_0                       (o_rxd_0[63:0]                 ), // output [63:0]         
    .o_rxh_0                       (o_rxh_0[2:0]                  ), // output [2:0]          
    .o_rxh_h_0                     (o_rxh_h_0[2:0]                ), // output [2:0]          
    .o_rxh_vld_0                   (o_rxh_vld_0                   ), // output                
    .o_rxh_vld_h_0                 (o_rxh_vld_h_0                 ), // output                
    .o_rxq_start_0                 (o_rxq_start_0                 ), // output               
    .o_rxq_start_h_0               (o_rxq_start_h_0               ), // output        
    .i_p_refckp_0                  (i_p_refckp_0                  ),        
    .i_p_refckn_0                  (i_p_refckn_0                  ) 
             
);


// ********************* Source of DUT *********************

wire           i_src_clk0                    ;
wire           i_src_clk1                    ;
wire           i_src_clk2                    ;
wire           i_src_clk3                    ;
wire           i_src_rstn                    = ~src_rst;
wire   [79:0]  o_txd_0                       ;
wire   [7:0]   o_txk_0                       ;
wire   [6:0]   o_txq_0                       ;
wire   [2:0]   o_txh_0                       ;
wire   [2:0]   o_txh_h_0                     ;
wire           o_tx_st_0                     ;//adapt to PCIE GEN3 128B130B protocol
wire           o_txd_vld_0                   ;
wire           o_tx_st_h_0                   ;
wire           o_txd_vld_h_0                 ;
wire   [79:0]  o_txd_1                       ;
wire   [7:0]   o_txk_1                       ;
wire   [6:0]   o_txq_1                       ;
wire   [2:0]   o_txh_1                       ;
wire   [2:0]   o_txh_h_1                     ;
wire           o_tx_st_1                     ;
wire           o_txd_vld_1                   ;
wire           o_tx_st_h_1                   ;
wire           o_txd_vld_h_1                 ;
wire   [79:0]  o_txd_2                       ;
wire   [7:0]   o_txk_2                       ;
wire   [6:0]   o_txq_2                       ;
wire   [2:0]   o_txh_2                       ;
wire   [2:0]   o_txh_h_2                     ;
wire           o_tx_st_2                     ;
wire           o_txd_vld_2                   ;
wire           o_tx_st_h_2                   ;
wire           o_txd_vld_h_2                 ;
wire   [79:0]  o_txd_3                       ;
wire   [7:0]   o_txk_3                       ;
wire   [6:0]   o_txq_3                       ;
wire   [2:0]   o_txh_3                       ;
wire   [2:0]   o_txh_h_3                     ;
wire           o_tx_st_3                     ;
wire           o_txd_vld_3                   ;
wire           o_tx_st_h_3                   ;
wire           o_txd_vld_h_3                 ;

assign i_src_clk0 = i_p_tx0_clk_fr_core        ; Transceiver_10G_src #(
    .TD_8BIT_ONLY_0   (TD_8BIT_ONLY_0   ), 
    .TD_10BIT_ONLY_0  (TD_10BIT_ONLY_0  ), 
    .TD_8B10B_8BIT_0  (TD_8B10B_8BIT_0  ), 
    .TD_16BIT_ONLY_0  (TD_16BIT_ONLY_0  ), 
    .TD_20BIT_ONLY_0  (TD_20BIT_ONLY_0  ), 
    .TD_8B10B_16BIT_0 (TD_8B10B_16BIT_0 ), 
    .TD_32BIT_ONLY_0  (TD_32BIT_ONLY_0  ), 
    .TD_40BIT_ONLY_0  (TD_40BIT_ONLY_0  ), 
    .TD_64BIT_ONLY_0  (TD_64BIT_ONLY_0  ), 
    .TD_80BIT_ONLY_0  (TD_80BIT_ONLY_0  ), 
    .TD_8B10B_32BIT_0 (TD_8B10B_32BIT_0 ), 
    .TD_8B10B_64BIT_0 (TD_8B10B_64BIT_0 ), 
    .TD_64B66B_16BIT_0(TD_64B66B_16BIT_0), 
    .TD_64B66B_32BIT_0(TD_64B66B_32BIT_0), 
    .TD_64B66B_64BIT_0(TD_64B66B_64BIT_0), 
    .TD_64B67B_16BIT_0(TD_64B67B_16BIT_0), 
    .TD_64B67B_32BIT_0(TD_64B67B_32BIT_0), 
    .TD_64B67B_64BIT_0(TD_64B67B_64BIT_0), 
    .TD_64B66B_CAUI_32BIT_0(TD_64B66B_CAUI_32BIT_0), 
    .TD_64B66B_CAUI_64BIT_0(TD_64B66B_CAUI_64BIT_0), 
    .TD_128B130B_32BIT_0(TD_128B130B_32BIT_0), 
    .TD_128B130B_64BIT_0(TD_128B130B_64BIT_0), 
    .TD_8BIT_ONLY_1   (TD_8BIT_ONLY_1   ), 
    .TD_10BIT_ONLY_1  (TD_10BIT_ONLY_1  ), 
    .TD_8B10B_8BIT_1  (TD_8B10B_8BIT_1  ), 
    .TD_16BIT_ONLY_1  (TD_16BIT_ONLY_1  ), 
    .TD_20BIT_ONLY_1  (TD_20BIT_ONLY_1  ), 
    .TD_8B10B_16BIT_1 (TD_8B10B_16BIT_1 ), 
    .TD_32BIT_ONLY_1  (TD_32BIT_ONLY_1  ), 
    .TD_40BIT_ONLY_1  (TD_40BIT_ONLY_1  ), 
    .TD_64BIT_ONLY_1  (TD_64BIT_ONLY_1  ), 
    .TD_80BIT_ONLY_1  (TD_80BIT_ONLY_1  ), 
    .TD_8B10B_32BIT_1 (TD_8B10B_32BIT_1 ), 
    .TD_8B10B_64BIT_1 (TD_8B10B_64BIT_1 ), 
    .TD_64B66B_16BIT_1(TD_64B66B_16BIT_1), 
    .TD_64B66B_32BIT_1(TD_64B66B_32BIT_1), 
    .TD_64B66B_64BIT_1(TD_64B66B_64BIT_1), 
    .TD_64B67B_16BIT_1(TD_64B67B_16BIT_1), 
    .TD_64B67B_32BIT_1(TD_64B67B_32BIT_1), 
    .TD_64B67B_64BIT_1(TD_64B67B_64BIT_1), 
    .TD_64B66B_CAUI_32BIT_1(TD_64B66B_CAUI_32BIT_1), 
    .TD_64B66B_CAUI_64BIT_1(TD_64B66B_CAUI_64BIT_1), 
    .TD_128B130B_32BIT_1(TD_128B130B_32BIT_1), 
    .TD_128B130B_64BIT_1(TD_128B130B_64BIT_1), 
    .TD_8BIT_ONLY_2   (TD_8BIT_ONLY_2   ), 
    .TD_10BIT_ONLY_2  (TD_10BIT_ONLY_2  ), 
    .TD_8B10B_8BIT_2  (TD_8B10B_8BIT_2  ), 
    .TD_16BIT_ONLY_2  (TD_16BIT_ONLY_2  ), 
    .TD_20BIT_ONLY_2  (TD_20BIT_ONLY_2  ), 
    .TD_8B10B_16BIT_2 (TD_8B10B_16BIT_2 ), 
    .TD_32BIT_ONLY_2  (TD_32BIT_ONLY_2  ), 
    .TD_40BIT_ONLY_2  (TD_40BIT_ONLY_2  ), 
    .TD_64BIT_ONLY_2  (TD_64BIT_ONLY_2  ), 
    .TD_80BIT_ONLY_2  (TD_80BIT_ONLY_2  ), 
    .TD_8B10B_32BIT_2 (TD_8B10B_32BIT_2 ), 
    .TD_8B10B_64BIT_2 (TD_8B10B_64BIT_2 ), 
    .TD_64B66B_16BIT_2(TD_64B66B_16BIT_2), 
    .TD_64B66B_32BIT_2(TD_64B66B_32BIT_2), 
    .TD_64B66B_64BIT_2(TD_64B66B_64BIT_2), 
    .TD_64B67B_16BIT_2(TD_64B67B_16BIT_2), 
    .TD_64B67B_32BIT_2(TD_64B67B_32BIT_2), 
    .TD_64B67B_64BIT_2(TD_64B67B_64BIT_2), 
    .TD_64B66B_CAUI_32BIT_2(TD_64B66B_CAUI_32BIT_2), 
    .TD_64B66B_CAUI_64BIT_2(TD_64B66B_CAUI_64BIT_2), 
    .TD_128B130B_32BIT_2(TD_128B130B_32BIT_2), 
    .TD_128B130B_64BIT_2(TD_128B130B_64BIT_2), 
    .TD_8BIT_ONLY_3   (TD_8BIT_ONLY_3   ), 
    .TD_10BIT_ONLY_3  (TD_10BIT_ONLY_3  ), 
    .TD_8B10B_8BIT_3  (TD_8B10B_8BIT_3  ), 
    .TD_16BIT_ONLY_3  (TD_16BIT_ONLY_3  ), 
    .TD_20BIT_ONLY_3  (TD_20BIT_ONLY_3  ), 
    .TD_8B10B_16BIT_3 (TD_8B10B_16BIT_3 ), 
    .TD_32BIT_ONLY_3  (TD_32BIT_ONLY_3  ), 
    .TD_40BIT_ONLY_3  (TD_40BIT_ONLY_3  ), 
    .TD_64BIT_ONLY_3  (TD_64BIT_ONLY_3  ), 
    .TD_80BIT_ONLY_3  (TD_80BIT_ONLY_3  ), 
    .TD_8B10B_32BIT_3 (TD_8B10B_32BIT_3 ),  
    .TD_8B10B_64BIT_3 (TD_8B10B_64BIT_3 ), 
    .TD_64B66B_16BIT_3(TD_64B66B_16BIT_3), 
    .TD_64B66B_32BIT_3(TD_64B66B_32BIT_3), 
    .TD_64B66B_64BIT_3(TD_64B66B_64BIT_3), 
    .TD_64B67B_16BIT_3(TD_64B67B_16BIT_3), 
    .TD_64B67B_32BIT_3(TD_64B67B_32BIT_3),
    .TD_64B67B_64BIT_3(TD_64B67B_64BIT_3), 
    .TD_64B66B_CAUI_32BIT_3(TD_64B66B_CAUI_32BIT_3), 
    .TD_64B66B_CAUI_64BIT_3(TD_64B66B_CAUI_64BIT_3), 
    .TD_128B130B_32BIT_3(TD_128B130B_32BIT_3),
    .TD_128B130B_64BIT_3(TD_128B130B_64BIT_3)  
) U_INST_IF_SRC (
    .i_src_clk0                    (i_src_clk0                    ), // input          
    .i_src_clk1                    (i_src_clk1                    ), // input          
    .i_src_clk2                    (i_src_clk2                    ), // input          
    .i_src_clk3                    (i_src_clk3                    ), // input          
    .i_src_rstn                    (i_src_rstn                    ), // input          
    .o_txd_0                       (o_txd_0                       ), // output [79:0]  
    .o_txk_0                       (o_txk_0                       ), // output [7:0]   
    .o_txq_0                       (o_txq_0                       ), // output [6:0]   
    .o_txh_0                       (o_txh_0                       ), // output [2:0]   
    .o_txh_h_0                     (o_txh_h_0                     ), // output [2:0]   
    .o_tx_st_0                     (o_tx_st_0                     ), // output
    .o_txd_vld_0                   (o_txd_vld_0                   ), // output
    .o_tx_st_h_0                   (o_tx_st_h_0                   ), // output
    .o_txd_vld_h_0                 (o_txd_vld_h_0                 ), // output
    .o_txd_1                       (o_txd_1                       ), // output [79:0]  
    .o_txk_1                       (o_txk_1                       ), // output [7:0]   
    .o_txq_1                       (o_txq_1                       ), // output [6:0]   
    .o_txh_1                       (o_txh_1                       ), // output [2:0]   
    .o_txh_h_1                     (o_txh_h_1                     ), // output [2:0]   
    .o_tx_st_1                     (o_tx_st_1                     ), // output
    .o_txd_vld_1                   (o_txd_vld_1                   ), // output
    .o_tx_st_h_1                   (o_tx_st_h_1                   ), // output
    .o_txd_vld_h_1                 (o_txd_vld_h_1                 ), // output
    .o_txd_2                       (o_txd_2                       ), // output [79:0]  
    .o_txk_2                       (o_txk_2                       ), // output [7:0]   
    .o_txq_2                       (o_txq_2                       ), // output [6:0]   
    .o_txh_2                       (o_txh_2                       ), // output [2:0]   
    .o_txh_h_2                     (o_txh_h_2                     ), // output [2:0]   
    .o_tx_st_2                     (o_tx_st_2                     ), // output
    .o_txd_vld_2                   (o_txd_vld_2                   ), // output
    .o_tx_st_h_2                   (o_tx_st_h_2                   ), // output
    .o_txd_vld_h_2                 (o_txd_vld_h_2                 ), // output
    .o_txd_3                       (o_txd_3                       ), // output [79:0]  
    .o_txk_3                       (o_txk_3                       ), // output [7:0]   
    .o_txq_3                       (o_txq_3                       ), // output [6:0]   
    .o_txh_3                       (o_txh_3                       ), // output [2:0]   
    .o_txh_h_3                     (o_txh_h_3                     ), // output [2:0]   
    .o_tx_st_3                     (o_tx_st_3                     ), // output
    .o_txd_vld_3                   (o_txd_vld_3                   ), // output
    .o_tx_st_h_3                   (o_tx_st_h_3                   ), // output
    .o_txd_vld_h_3                 (o_txd_vld_h_3                 )  // output
);


assign  i_txd_0                      = o_txd_0[63:0];
assign  i_txq_0                      = o_txq_0[6:0] ;
assign  i_txh_0                      = o_txh_0[2:0] ;
// ********************* Checker of DUT *********************

wire            i_chk_clk0                    ;
wire            i_chk_clk1                    ;
wire            i_chk_clk2                    ;
wire            i_chk_clk3                    ;
wire    [3:0]   i_chk_rstn                    ;
wire    [5:0]   i_rxstatus_0                  ;
wire    [79:0]  i_rxd_0                       ;
wire    [7:0]   i_rdisper_0                   ;
wire    [7:0]   i_rdecer_0                    ;
wire    [7:0]   i_rxk_0                       ; 
wire            i_rxd_vld_0                   ;
wire            i_rxd_vld_h_0                 ;
wire    [2:0]   i_rxh_0                       ;
wire            i_rxh_vld_0                   ;
wire            i_rxq_start_0                 ;
wire    [2:0]   i_rxh_h_0                     ;
wire            i_rxh_vld_h_0                 ;
wire            i_rxq_start_h_0               ;
wire    [2:0]   i_rxhc_0                      ;
wire            i_rxhc_vld_0                  ;
wire            i_rxq_startc_0                ;
wire    [2:0]   i_rxhc_h_0                    ;
wire            i_rxhc_vld_h_0                ;
wire            i_rxq_startc_h_0              ;
wire    [5:0]   i_rxstatus_1                  ;
wire    [79:0]  i_rxd_1                       ;
wire    [7:0]   i_rdisper_1                   ;
wire    [7:0]   i_rdecer_1                    ;
wire    [7:0]   i_rxk_1                       ; 
wire            i_rxd_vld_1                   ;
wire            i_rxd_vld_h_1                 ;
wire    [2:0]   i_rxh_1                       ;
wire            i_rxh_vld_1                   ;
wire            i_rxq_start_1                 ;
wire    [2:0]   i_rxh_h_1                     ;
wire            i_rxh_vld_h_1                 ;
wire            i_rxq_start_h_1               ;
wire    [2:0]   i_rxhc_1                      ;
wire            i_rxhc_vld_1                  ;
wire            i_rxq_startc_1                ;
wire    [2:0]   i_rxhc_h_1                    ;
wire            i_rxhc_vld_h_1                ;
wire            i_rxq_startc_h_1              ;
wire    [5:0]   i_rxstatus_2                  ;
wire    [79:0]  i_rxd_2                       ;
wire    [7:0]   i_rdisper_2                   ;
wire    [7:0]   i_rdecer_2                    ;
wire    [7:0]   i_rxk_2                       ; 
wire            i_rxd_vld_2                   ;
wire            i_rxd_vld_h_2                 ;
wire    [2:0]   i_rxh_2                       ;
wire            i_rxh_vld_2                   ;
wire            i_rxq_start_2                 ;
wire    [2:0]   i_rxh_h_2                     ;
wire            i_rxh_vld_h_2                 ;
wire            i_rxq_start_h_2               ;
wire    [2:0]   i_rxhc_2                      ;
wire            i_rxhc_vld_2                  ;
wire            i_rxq_startc_2                ;
wire    [2:0]   i_rxhc_h_2                    ;
wire            i_rxhc_vld_h_2                ;
wire            i_rxq_startc_h_2              ;
wire    [5:0]   i_rxstatus_3                  ;
wire    [79:0]  i_rxd_3                       ;
wire    [7:0]   i_rdisper_3                   ;
wire    [7:0]   i_rdecer_3                    ;
wire    [7:0]   i_rxk_3                       ; 
wire            i_rxd_vld_3                   ;
wire            i_rxd_vld_h_3                 ;
wire    [2:0]   i_rxh_3                       ;
wire            i_rxh_vld_3                   ;
wire            i_rxq_start_3                 ;
wire    [2:0]   i_rxh_h_3                     ;
wire            i_rxh_vld_h_3                 ;
wire            i_rxq_start_h_3               ;
wire    [2:0]   i_rxhc_3                      ;
wire            i_rxhc_vld_3                  ;
wire            i_rxq_startc_3                ;
wire    [2:0]   i_rxhc_h_3                    ;
wire            i_rxhc_vld_h_3                ;
wire            i_rxq_startc_h_3              ;


assign i_chk_clk0 = i_p_rx0_clk_fr_core         ;   

//Sync Check Module Reset Signal
ipm2t_hssthp_rst_sync_v1_0 chk_rstn_sync0 (.clk(i_chk_clk0), .rst_n(~chk_rst), .sig_async(1'b1), .sig_synced(i_chk_rstn[0]));
ipm2t_hssthp_rst_sync_v1_0 chk_rstn_sync1 (.clk(i_chk_clk1), .rst_n(~chk_rst), .sig_async(1'b1), .sig_synced(i_chk_rstn[1]));
ipm2t_hssthp_rst_sync_v1_0 chk_rstn_sync2 (.clk(i_chk_clk2), .rst_n(~chk_rst), .sig_async(1'b1), .sig_synced(i_chk_rstn[2]));
ipm2t_hssthp_rst_sync_v1_0 chk_rstn_sync3 (.clk(i_chk_clk3), .rst_n(~chk_rst), .sig_async(1'b1), .sig_synced(i_chk_rstn[3]));

Transceiver_10G_chk #(
    .RD_8BIT_ONLY_0   (RD_8BIT_ONLY_0   ), 
    .RD_10BIT_ONLY_0  (RD_10BIT_ONLY_0  ), 
    .RD_8B10B_8BIT_0  (RD_8B10B_8BIT_0  ), 
    .RD_16BIT_ONLY_0  (RD_16BIT_ONLY_0  ), 
    .RD_20BIT_ONLY_0  (RD_20BIT_ONLY_0  ), 
    .RD_8B10B_16BIT_0 (RD_8B10B_16BIT_0 ), 
    .RD_32BIT_ONLY_0  (RD_32BIT_ONLY_0  ), 
    .RD_40BIT_ONLY_0  (RD_40BIT_ONLY_0  ), 
    .RD_64BIT_ONLY_0  (RD_64BIT_ONLY_0  ), 
    .RD_80BIT_ONLY_0  (RD_80BIT_ONLY_0  ), 
    .RD_8B10B_32BIT_0 (RD_8B10B_32BIT_0 ), 
    .RD_8B10B_64BIT_0 (RD_8B10B_64BIT_0 ), 
    .RD_64B66B_16BIT_0(RD_64B66B_16BIT_0), 
    .RD_64B66B_32BIT_0(RD_64B66B_32BIT_0), 
    .RD_64B66B_64BIT_0(RD_64B66B_64BIT_0), 
    .RD_64B67B_16BIT_0(RD_64B67B_16BIT_0), 
    .RD_64B67B_32BIT_0(RD_64B67B_32BIT_0), 
    .RD_64B67B_64BIT_0(RD_64B67B_64BIT_0), 
    .RD_64B66B_CAUI_32BIT_0(RD_64B66B_CAUI_32BIT_0), 
    .RD_64B66B_CAUI_64BIT_0(RD_64B66B_CAUI_64BIT_0), 
    .RD_128B130B_32BIT_0(RD_128B130B_32BIT_0), 
    .RD_128B130B_64BIT_0(RD_128B130B_64BIT_0), 
    .RD_8BIT_ONLY_1   (RD_8BIT_ONLY_1   ), 
    .RD_10BIT_ONLY_1  (RD_10BIT_ONLY_1  ), 
    .RD_8B10B_8BIT_1  (RD_8B10B_8BIT_1  ), 
    .RD_16BIT_ONLY_1  (RD_16BIT_ONLY_1  ), 
    .RD_20BIT_ONLY_1  (RD_20BIT_ONLY_1  ), 
    .RD_8B10B_16BIT_1 (RD_8B10B_16BIT_1 ), 
    .RD_32BIT_ONLY_1  (RD_32BIT_ONLY_1  ), 
    .RD_40BIT_ONLY_1  (RD_40BIT_ONLY_1  ), 
    .RD_64BIT_ONLY_1  (RD_64BIT_ONLY_1  ), 
    .RD_80BIT_ONLY_1  (RD_80BIT_ONLY_1  ), 
    .RD_8B10B_32BIT_1 (RD_8B10B_32BIT_1 ), 
    .RD_8B10B_64BIT_1 (RD_8B10B_64BIT_1 ), 
    .RD_64B66B_16BIT_1(RD_64B66B_16BIT_1), 
    .RD_64B66B_32BIT_1(RD_64B66B_32BIT_1), 
    .RD_64B66B_64BIT_1(RD_64B66B_64BIT_1), 
    .RD_64B67B_16BIT_1(RD_64B67B_16BIT_1), 
    .RD_64B67B_32BIT_1(RD_64B67B_32BIT_1), 
    .RD_64B67B_64BIT_1(RD_64B67B_64BIT_1), 
    .RD_64B66B_CAUI_32BIT_1(RD_64B66B_CAUI_32BIT_1), 
    .RD_64B66B_CAUI_64BIT_1(RD_64B66B_CAUI_64BIT_1), 
    .RD_128B130B_32BIT_1(RD_128B130B_32BIT_1), 
    .RD_128B130B_64BIT_1(RD_128B130B_64BIT_1), 
    .RD_8BIT_ONLY_2   (RD_8BIT_ONLY_2   ), 
    .RD_10BIT_ONLY_2  (RD_10BIT_ONLY_2  ), 
    .RD_8B10B_8BIT_2  (RD_8B10B_8BIT_2  ), 
    .RD_16BIT_ONLY_2  (RD_16BIT_ONLY_2  ), 
    .RD_20BIT_ONLY_2  (RD_20BIT_ONLY_2  ), 
    .RD_8B10B_16BIT_2 (RD_8B10B_16BIT_2 ), 
    .RD_32BIT_ONLY_2  (RD_32BIT_ONLY_2  ), 
    .RD_40BIT_ONLY_2  (RD_40BIT_ONLY_2  ), 
    .RD_64BIT_ONLY_2  (RD_64BIT_ONLY_2  ), 
    .RD_80BIT_ONLY_2  (RD_80BIT_ONLY_2  ), 
    .RD_8B10B_32BIT_2 (RD_8B10B_32BIT_2 ), 
    .RD_8B10B_64BIT_2 (RD_8B10B_64BIT_2 ), 
    .RD_64B66B_16BIT_2(RD_64B66B_16BIT_2), 
    .RD_64B66B_32BIT_2(RD_64B66B_32BIT_2), 
    .RD_64B66B_64BIT_2(RD_64B66B_64BIT_2), 
    .RD_64B67B_16BIT_2(RD_64B67B_16BIT_2), 
    .RD_64B67B_32BIT_2(RD_64B67B_32BIT_2), 
    .RD_64B67B_64BIT_2(RD_64B67B_64BIT_2), 
    .RD_64B66B_CAUI_32BIT_2(RD_64B66B_CAUI_32BIT_2), 
    .RD_64B66B_CAUI_64BIT_2(RD_64B66B_CAUI_64BIT_2), 
    .RD_128B130B_32BIT_2(RD_128B130B_32BIT_2), 
    .RD_128B130B_64BIT_2(RD_128B130B_64BIT_2), 
    .RD_8BIT_ONLY_3   (RD_8BIT_ONLY_3   ), 
    .RD_10BIT_ONLY_3  (RD_10BIT_ONLY_3  ), 
    .RD_8B10B_8BIT_3  (RD_8B10B_8BIT_3  ), 
    .RD_16BIT_ONLY_3  (RD_16BIT_ONLY_3  ), 
    .RD_20BIT_ONLY_3  (RD_20BIT_ONLY_3  ), 
    .RD_8B10B_16BIT_3 (RD_8B10B_16BIT_3 ), 
    .RD_32BIT_ONLY_3  (RD_32BIT_ONLY_3  ), 
    .RD_40BIT_ONLY_3  (RD_40BIT_ONLY_3  ), 
    .RD_64BIT_ONLY_3  (RD_64BIT_ONLY_3  ), 
    .RD_80BIT_ONLY_3  (RD_80BIT_ONLY_3  ), 
    .RD_8B10B_32BIT_3 (RD_8B10B_32BIT_3 ), 
    .RD_8B10B_64BIT_3 (RD_8B10B_64BIT_3 ), 
    .RD_64B66B_16BIT_3(RD_64B66B_16BIT_3), 
    .RD_64B66B_32BIT_3(RD_64B66B_32BIT_3), 
    .RD_64B66B_64BIT_3(RD_64B66B_64BIT_3), 
    .RD_64B67B_16BIT_3(RD_64B67B_16BIT_3), 
    .RD_64B67B_32BIT_3(RD_64B67B_32BIT_3), 
    .RD_64B67B_64BIT_3(RD_64B67B_64BIT_3),  
    .RD_64B66B_CAUI_32BIT_3(RD_64B66B_CAUI_32BIT_3), 
    .RD_64B66B_CAUI_64BIT_3(RD_64B66B_CAUI_64BIT_3), 
    .RD_128B130B_32BIT_3(RD_128B130B_32BIT_3),
    .RD_128B130B_64BIT_3(RD_128B130B_64BIT_3)  
) U_INST_IF_CHK (
    .i_chk_clk0                    (i_chk_clk0                    ), // input           
    .i_chk_clk1                    (i_chk_clk1                    ), // input           
    .i_chk_clk2                    (i_chk_clk2                    ), // input           
    .i_chk_clk3                    (i_chk_clk3                    ), // input           
    .i_chk_rstn                    (i_chk_rstn                    ), // input  [3:0]          
    .i_rxstatus_0                  (i_rxstatus_0                  ), // input  [5:0]    
    .i_rxd_0                       (i_rxd_0                       ), // input  [79:0]   
    .i_rdisper_0                   (i_rdisper_0                   ), // input  [7:0]    
    .i_rdecer_0                    (i_rdecer_0                    ), // input  [7:0]    
    .i_rxk_0                       (i_rxk_0                       ), // input  [7:0]     
    .i_rxd_vld_0                   (i_rxd_vld_0                   ), // input 
    .i_rxd_vld_h_0                 (i_rxd_vld_h_0                 ), // input 
    .i_rxh_0                       (i_rxh_0                       ), // input  [2:0] 
    .i_rxh_vld_0                   (i_rxh_vld_0                   ), // input 
    .i_rxq_start_0                 (i_rxq_start_0                 ), // input 
    .i_rxh_h_0                     (i_rxh_h_0                     ), // input  [2:0] 
    .i_rxh_vld_h_0                 (i_rxh_vld_h_0                 ), // input 
    .i_rxq_start_h_0               (i_rxq_start_h_0               ), // input 
    .i_rxhc_0                      (i_rxhc_0                      ), // input  [2:0]
    .i_rxhc_vld_0                  (i_rxhc_vld_0                  ), // input
    .i_rxq_startc_0                (i_rxq_startc_0                ), // input
    .i_rxhc_h_0                    (i_rxhc_h_0                    ), // input  [2:0]
    .i_rxhc_vld_h_0                (i_rxhc_vld_h_0                ), // input
    .i_rxq_startc_h_0              (i_rxq_startc_h_0              ), // input
    .o_p_rxpcs_slip_0              (o_p_rxpcs_slip_0              ), // output
    .i_rxstatus_1                  (i_rxstatus_1                  ), // input  [5:0]    
    .i_rxd_1                       (i_rxd_1                       ), // input  [79:0]   
    .i_rdisper_1                   (i_rdisper_1                   ), // input  [7:0]    
    .i_rdecer_1                    (i_rdecer_1                    ), // input  [7:0]    
    .i_rxk_1                       (i_rxk_1                       ), // input  [7:0]     
    .i_rxd_vld_1                   (i_rxd_vld_1                   ), // input 
    .i_rxd_vld_h_1                 (i_rxd_vld_h_1                 ), // input 
    .i_rxh_1                       (i_rxh_1                       ), // input  [2:0] 
    .i_rxh_vld_1                   (i_rxh_vld_1                   ), // input 
    .i_rxq_start_1                 (i_rxq_start_1                 ), // input 
    .i_rxh_h_1                     (i_rxh_h_1                     ), // input  [2:0] 
    .i_rxh_vld_h_1                 (i_rxh_vld_h_1                 ), // input 
    .i_rxq_start_h_1               (i_rxq_start_h_1               ), // input 
    .i_rxhc_1                      (i_rxhc_1                      ), // input  [2:0]
    .i_rxhc_vld_1                  (i_rxhc_vld_1                  ), // input
    .i_rxq_startc_1                (i_rxq_startc_1                ), // input
    .i_rxhc_h_1                    (i_rxhc_h_1                    ), // input  [2:0]
    .i_rxhc_vld_h_1                (i_rxhc_vld_h_1                ), // input
    .i_rxq_startc_h_1              (i_rxq_startc_h_1              ), // input
    .o_p_rxpcs_slip_1              (o_p_rxpcs_slip_1              ), // output
    .i_rxstatus_2                  (i_rxstatus_2                  ), // input  [5:0]    
    .i_rxd_2                       (i_rxd_2                       ), // input  [79:0]   
    .i_rdisper_2                   (i_rdisper_2                   ), // input  [7:0]    
    .i_rdecer_2                    (i_rdecer_2                    ), // input  [7:0]    
    .i_rxk_2                       (i_rxk_2                       ), // input  [7:0]     
    .i_rxd_vld_2                   (i_rxd_vld_2                   ), // input 
    .i_rxd_vld_h_2                 (i_rxd_vld_h_2                 ), // input 
    .i_rxh_2                       (i_rxh_2                       ), // input  [2:0] 
    .i_rxh_vld_2                   (i_rxh_vld_2                   ), // input 
    .i_rxq_start_2                 (i_rxq_start_2                 ), // input 
    .i_rxh_h_2                     (i_rxh_h_2                     ), // input  [2:0] 
    .i_rxh_vld_h_2                 (i_rxh_vld_h_2                 ), // input 
    .i_rxq_start_h_2               (i_rxq_start_h_2               ), // input 
    .i_rxhc_2                      (i_rxhc_2                      ), // input  [2:0]
    .i_rxhc_vld_2                  (i_rxhc_vld_2                  ), // input
    .i_rxq_startc_2                (i_rxq_startc_2                ), // input
    .i_rxhc_h_2                    (i_rxhc_h_2                    ), // input  [2:0]
    .i_rxhc_vld_h_2                (i_rxhc_vld_h_2                ), // input
    .i_rxq_startc_h_2              (i_rxq_startc_h_2              ), // input
    .o_p_rxpcs_slip_2              (o_p_rxpcs_slip_2              ), // output
    .i_rxstatus_3                  (i_rxstatus_3                  ), // input  [5:0]    
    .i_rxd_3                       (i_rxd_3                       ), // input  [79:0]   
    .i_rdisper_3                   (i_rdisper_3                   ), // input  [7:0]    
    .i_rdecer_3                    (i_rdecer_3                    ), // input  [7:0]    
    .i_rxk_3                       (i_rxk_3                       ), // input  [7:0]   
    .i_rxd_vld_3                   (i_rxd_vld_3                   ), // input 
    .i_rxd_vld_h_3                 (i_rxd_vld_h_3                 ), // input 
    .i_rxh_3                       (i_rxh_3                       ), // input  [2:0] 
    .i_rxh_vld_3                   (i_rxh_vld_3                   ), // input 
    .i_rxq_start_3                 (i_rxq_start_3                 ), // input 
    .i_rxh_h_3                     (i_rxh_h_3                     ), // input  [2:0] 
    .i_rxh_vld_h_3                 (i_rxh_vld_h_3                 ), // input 
    .i_rxq_start_h_3               (i_rxq_start_h_3               ), // input 
    .i_rxhc_3                      (i_rxhc_3                      ), // input  [2:0]
    .i_rxhc_vld_3                  (i_rxhc_vld_3                  ), // input
    .i_rxq_startc_3                (i_rxq_startc_3                ), // input
    .i_rxhc_h_3                    (i_rxhc_h_3                    ), // input  [2:0]
    .i_rxhc_vld_h_3                (i_rxhc_vld_h_3                ), // input
    .i_rxq_startc_h_3              (i_rxq_startc_h_3              ), // input
    .o_p_rxpcs_slip_3              (o_p_rxpcs_slip_3              ), // output
    .o_pl_err                      (o_pl_err                      )  // output [3:0]    
);


assign i_rxstatus_0                  = o_rxstatus_0            ;
assign i_rxd_0                       = o_rxd_0[63:0]           ;
assign i_rxd_vld_0                   = o_rxd_vld_0             ;
assign i_rxd_vld_h_0                 = o_rxd_vld_h_0           ;
assign i_rxh_0                       = o_rxh_0                 ;
assign i_rxh_vld_0                   = o_rxh_vld_0             ;
assign i_rxq_start_0                 = o_rxq_start_0           ;
assign i_rxh_h_0                     = o_rxh_h_0               ;
assign i_rxh_vld_h_0                 = o_rxh_vld_h_0           ;
assign i_rxq_start_h_0               = o_rxq_start_h_0         ;

endmodule    
