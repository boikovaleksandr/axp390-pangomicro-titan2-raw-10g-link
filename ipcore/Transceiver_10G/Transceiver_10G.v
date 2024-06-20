
///////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2019 PANGO MICROSYSTEMS, INC
// ALL RIGHTS REVERVED.
//
// THE SOURCE CODE CONTAINED HEREIN IS PROPRIETARY TO PANGO MICROSYSTEMS, INC.
// IT SHALL NOT BE REPRODUCED OR DISCLOSED IN WHOLE OR IN PART OR USED BY
// PARTIES WITHOUT WRITTEN AUTHORIZATION FROM THE OWNER.
//
////////////////////////////////////////////////////////////////////////////////
//
// Library:
// Filename:
////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/100fs

module Transceiver_10G (
    
    input          i_free_clk                    ,
    input          i_hpll_rst                    ,
    input          i_hpll_wtchdg_clr             ,
    input          i_hsst_fifo_clr_0             ,          
    input  [2:0]   i_loop_dbg_0                  ,
    output [1:0]   o_hpll_wtchdg_st              ,
    output         o_hpll_done                   ,
    output         o_txlane_done_0               ,
    output         o_rxlane_done_0               ,
    output         o_p_clk2core_tx_0             ,
    input          i_p_tx0_clk_fr_core           ,
    output         o_p_clk2core_rx_0             ,
    input          i_p_rx0_clk_fr_core           ,
    output         o_p_refck2core_0              ,
    output         o_p_hpll_lock                 ,
    output         o_p_rx_sigdet_sta_0           ,
    output         o_p_lx_cdr_align_0            ,
    input          i_p_rxpcs_slip_0              ,
    input          i_p_pcs_nearend_loop_0        ,
    input          i_p_pcs_farend_loop_0         ,
    input          i_p_pma_nearend_ploop_0       ,
    input          i_p_pma_nearend_sloop_0       ,
    input          i_p_pma_farend_ploop_0        ,
    input          i_p_cfg_clk                   ,
    input          i_p_cfg_rst                   ,
    input          i_p_cfg_psel                  ,
    input          i_p_cfg_enable                ,
    input          i_p_cfg_write                 ,
    input  [15:0]  i_p_cfg_addr                  ,
    input  [7:0]   i_p_cfg_wdata                 ,
    output [7:0]   o_p_cfg_rdata                 ,
    output         o_p_cfg_int                   ,
    output         o_p_cfg_ready                 ,
    output         o_p_calib_done                ,
    input          i_p_l0rxn                     ,
    input          i_p_l0rxp                     ,
    output         o_p_l0txn                     ,
    output         o_p_l0txp                     ,
    input  [63:0]  i_txd_0                       ,
    input  [6:0]   i_txq_0                       ,
    input  [2:0]   i_txh_0                       ,
    output [5:0]   o_rxstatus_0                  ,
    output         o_rxd_vld_0                   ,
    output         o_rxd_vld_h_0                 ,
    output [63:0]  o_rxd_0                       ,
    output [2:0]   o_rxh_0                       ,
    output [2:0]   o_rxh_h_0                     ,
    output         o_rxh_vld_0                   ,
    output         o_rxh_vld_h_0                 ,
    output         o_rxq_start_0                 ,
    output         o_rxq_start_h_0               ,
    input          i_p_refckp_0                  ,        
                 input          i_p_refckn_0      
             
);
localparam HPLL_VCO = 10312.5;
localparam LPLL0_VCO = 2400.0;
localparam LPLL1_VCO = 2400.0;
localparam LPLL2_VCO = 2400.0;
localparam LPLL3_VCO = 2400.0;

//-- wire INNER RESET & HSST  ---//
wire            P_HPLL_READY            ; // output wire                    
wire            P_LPLL_READY_0          ; // output wire                    
wire            P_LPLL_READY_1          ; // output wire                    
wire            P_LPLL_READY_2          ; // output wire                    
wire            P_LPLL_READY_3          ; // output wire                    
wire            P_RX_SIGDET_STATUS_0    ; // output wire                    
wire            P_RX_SIGDET_STATUS_1    ; // output wire                    
wire            P_RX_SIGDET_STATUS_2    ; // output wire                    
wire            P_RX_SIGDET_STATUS_3    ; // output wire                    
wire            P_LX_CDR_ALIGN_0        ; // output wire                    
wire            P_LX_CDR_ALIGN_1        ; // output wire                    
wire            P_LX_CDR_ALIGN_2        ; // output wire                    
wire            P_LX_CDR_ALIGN_3        ; // output wire                    
wire            P_PCS_LSM_SYNCED_0      ; // output wire                    
wire            P_PCS_LSM_SYNCED_1      ; // output wire                    
wire            P_PCS_LSM_SYNCED_2      ; // output wire                    
wire            P_PCS_LSM_SYNCED_3      ; // output wire                    
wire            P_PCS_RX_MCB_STATUS_0   ; // output wire                    
wire            P_PCS_RX_MCB_STATUS_1   ; // output wire                    
wire            P_PCS_RX_MCB_STATUS_2   ; // output wire                    
wire            P_PCS_RX_MCB_STATUS_3   ; // output wire                    
wire            P_HPLL_POWERDOWN        ; // output wire                    
wire            P_COM_POWERDOWN         ; // output wire                    
wire            P_HPLL_RST              ; // output wire                    
wire            P_HPLL_VCO_CALIB_EN     ; // output wire                    
wire            P_REFCLK_DIV_SYNC       ; // output wire                    
wire            P_HPLL_DIV_SYNC         ; // output wire                    
wire            P_TX_SYNC               ; // output wire                    
wire            P_TX_RATE_CHANGE_ON     ; // output wire                   
wire            P_LPLL_POWERDOWN_0      ; // output wire                    
wire            P_LPLL_POWERDOWN_1      ; // output wire                    
wire            P_LPLL_POWERDOWN_2      ; // output wire                    
wire            P_LPLL_POWERDOWN_3      ; // output wire                    
wire            P_LPLL_RST_0            ; // output wire                    
wire            P_LPLL_RST_1            ; // output wire                    
wire            P_LPLL_RST_2            ; // output wire                    
wire            P_LPLL_RST_3            ; // output wire                    
wire            P_LANE_POWERDOWN_0      ; // output wire                    
wire            P_LANE_POWERDOWN_1      ; // output wire                    
wire            P_LANE_POWERDOWN_2      ; // output wire                    
wire            P_LANE_POWERDOWN_3      ; // output wire                    
wire            P_LANE_RST_0            ; // output wire                    
wire            P_LANE_RST_1            ; // output wire                    
wire            P_LANE_RST_2            ; // output wire                    
wire            P_LANE_RST_3            ; // output wire                    
wire            P_TX_LANE_POWERDOWN_0   ; // output wire                    
wire            P_TX_LANE_POWERDOWN_1   ; // output wire                    
wire            P_TX_LANE_POWERDOWN_2   ; // output wire                    
wire            P_TX_LANE_POWERDOWN_3   ; // output wire                    
wire            P_TX_PMA_RST_0          ; // output wire                    
wire            P_TX_PMA_RST_1          ; // output wire                    
wire            P_TX_PMA_RST_2          ; // output wire                    
wire            P_TX_PMA_RST_3          ; // output wire                    
wire            P_PCS_TX_RST_0          ; // output wire                    
wire            P_PCS_TX_RST_1          ; // output wire                    
wire            P_PCS_TX_RST_2          ; // output wire                    
wire            P_PCS_TX_RST_3          ; // output wire                    
wire    [1 : 0] P_TX_RATE_0             ; // output wire    [1 : 0]         
wire    [1 : 0] P_TX_RATE_1             ; // output wire    [1 : 0]         
wire    [1 : 0] P_TX_RATE_2             ; // output wire    [1 : 0]         
wire    [1 : 0] P_TX_RATE_3             ; // output wire    [1 : 0]         
wire            P_RX_LANE_POWERDOWN_0   ; // output wire                    
wire            P_RX_LANE_POWERDOWN_1   ; // output wire                    
wire            P_RX_LANE_POWERDOWN_2   ; // output wire                    
wire            P_RX_LANE_POWERDOWN_3   ; // output wire                    
wire            P_RX_PMA_RST_0          ; // output wire                    
wire            P_RX_PMA_RST_1          ; // output wire                    
wire            P_RX_PMA_RST_2          ; // output wire                    
wire            P_RX_PMA_RST_3          ; // output wire                    
wire            P_PCS_RX_RST_0          ; // output wire                    
wire            P_PCS_RX_RST_1          ; // output wire                    
wire            P_PCS_RX_RST_2          ; // output wire                    
wire            P_PCS_RX_RST_3          ; // output wire                    
wire    [1 : 0] P_RX_RATE_0             ; // output wire    [1 : 0]          
wire    [1 : 0] P_RX_RATE_1             ; // output wire    [1 : 0]         
wire    [1 : 0] P_RX_RATE_2             ; // output wire    [1 : 0]         
wire    [1 : 0] P_RX_RATE_3             ; // output wire    [1 : 0]         
wire            i_force_rxfsm_det_0     ; // input  wire                    
wire            i_force_rxfsm_det_1     ; // input  wire                    
wire            i_force_rxfsm_det_2     ; // input  wire                    
wire            i_force_rxfsm_det_3     ; // input  wire                    
wire            i_force_rxfsm_cdr_0     ; // input  wire                    
wire            i_force_rxfsm_cdr_1     ; // input  wire                    
wire            i_force_rxfsm_cdr_2     ; // input  wire                    
wire            i_force_rxfsm_cdr_3     ; // input  wire                    
wire            i_force_rxfsm_lsm_0     ; // input  wire                    
wire            i_force_rxfsm_lsm_1     ; // input  wire                    
wire            i_force_rxfsm_lsm_2     ; // input  wire                    
wire            i_force_rxfsm_lsm_3     ; // input  wire                    
wire            i_p_blk_align_ctrl_0    =1'b1; // input  wire                    
wire            i_p_blk_align_ctrl_1    =1'b1; // input  wire                    
wire            i_p_blk_align_ctrl_2    =1'b1; // input  wire                    
wire            i_p_blk_align_ctrl_3    =1'b1; // input  wire 
  

//config HSSTHP work at DEF/LEQ mode

wire            P_RX_DFE_RST_0          =1'b1; 
wire            P_RX_LEQ_RST_0          =1'b0;
wire            P_RX_DFE_EN_0           =1'b0;
wire            P_RX_T1_DFE_EN_0        =1'b0;
wire            P_RX_T2_DFE_EN_0        =1'b0;
wire            P_RX_T3_DFE_EN_0        =1'b0;
wire            P_RX_T4_DFE_EN_0        =1'b0;
wire            P_RX_T5_DFE_EN_0        =1'b0;
wire            P_RX_T6_DFE_EN_0        =1'b0;
wire            P_RX_DFE_RST_1          =1'b1; 
wire            P_RX_LEQ_RST_1          =1'b0;
wire            P_RX_DFE_EN_1           =1'b0;
wire            P_RX_T1_DFE_EN_1        =1'b0;
wire            P_RX_T2_DFE_EN_1        =1'b0;
wire            P_RX_T3_DFE_EN_1        =1'b0;
wire            P_RX_T4_DFE_EN_1        =1'b0;
wire            P_RX_T5_DFE_EN_1        =1'b0;
wire            P_RX_T6_DFE_EN_1        =1'b0;
wire            P_RX_DFE_RST_2          =1'b1; 
wire            P_RX_LEQ_RST_2          =1'b0;
wire            P_RX_DFE_EN_2           =1'b0;
wire            P_RX_T1_DFE_EN_2        =1'b0;
wire            P_RX_T2_DFE_EN_2        =1'b0;
wire            P_RX_T3_DFE_EN_2        =1'b0;
wire            P_RX_T4_DFE_EN_2        =1'b0;
wire            P_RX_T5_DFE_EN_2        =1'b0;
wire            P_RX_T6_DFE_EN_2        =1'b0;
wire            P_RX_DFE_RST_3          =1'b1; 
wire            P_RX_LEQ_RST_3          =1'b0;
wire            P_RX_DFE_EN_3           =1'b0;
wire            P_RX_T1_DFE_EN_3        =1'b0;
wire            P_RX_T2_DFE_EN_3        =1'b0;
wire            P_RX_T3_DFE_EN_3        =1'b0;
wire            P_RX_T4_DFE_EN_3        =1'b0;
wire            P_RX_T5_DFE_EN_3        =1'b0;
wire            P_RX_T6_DFE_EN_3        =1'b0;
wire         i_lpll_rst_0                  = 1'b1;
wire         i_lpll_rst_1                  = 1'b1;
wire         i_lpll_rst_2                  = 1'b1;
wire         i_lpll_rst_3                  = 1'b1;
wire         i_p_pll_ref_clk_0             = 1'b0;
wire         i_txlane_rst_0                = 1'b0;
wire         i_txlane_rst_1                = 1'b0;
wire         i_txlane_rst_2                = 1'b0;
wire         i_txlane_rst_3                = 1'b0;
wire         i_tx_pma_rst_0                = 1'b0;
wire         i_tx_pma_rst_1                = 1'b0;
wire         i_tx_pma_rst_2                = 1'b0;
wire         i_tx_pma_rst_3                = 1'b0;
wire         i_tx_pcs_rst_0                = 1'b0;
wire         i_tx_pcs_rst_1                = 1'b0;
wire         i_tx_pcs_rst_2                = 1'b0;
wire         i_tx_pcs_rst_3                = 1'b0;
wire         i_rxlane_rst_0                = 1'b0;
wire         i_rxlane_rst_1                = 1'b0;
wire         i_rxlane_rst_2                = 1'b0;
wire         i_rxlane_rst_3                = 1'b0;
wire         i_rx_pma_rst_0                = 1'b0;
wire         i_rx_pma_rst_1                = 1'b0;
wire         i_rx_pma_rst_2                = 1'b0;
wire         i_rx_pma_rst_3                = 1'b0;
wire         i_rx_pcs_rst_0                = 1'b0;
wire         i_rx_pcs_rst_1                = 1'b0;
wire         i_rx_pcs_rst_2                = 1'b0;
wire         i_rx_pcs_rst_3                = 1'b0;
wire         i_tx_rate_chng_0              = 1'b0;
wire         i_tx_rate_chng_1              = 1'b0;
wire         i_tx_rate_chng_2              = 1'b0;
wire         i_tx_rate_chng_3              = 1'b0;
wire [1:0]   i_txckdiv_0                   = 2'b0;
wire [1:0]   i_txckdiv_1                   = 2'b0;
wire [1:0]   i_txckdiv_2                   = 2'b0;
wire [1:0]   i_txckdiv_3                   = 2'b0;
wire         i_rx_rate_chng_0              = 1'b0;
wire         i_rx_rate_chng_1              = 1'b0;
wire         i_rx_rate_chng_2              = 1'b0;
wire         i_rx_rate_chng_3              = 1'b0;
wire [1:0]   i_rxckdiv_0                   = 2'b0;
wire [1:0]   i_rxckdiv_1                   = 2'b0;
wire [1:0]   i_rxckdiv_2                   = 2'b0;
wire [1:0]   i_rxckdiv_3                   = 2'b0;
assign       i_force_rxfsm_det_0           = i_loop_dbg_0[0];
assign       i_force_rxfsm_cdr_0           = i_loop_dbg_0[1];
assign       i_force_rxfsm_lsm_0           = i_loop_dbg_0[2];
wire         i_hsst_fifo_clr_1             = 1'b0;         
assign       i_force_rxfsm_det_1           = 1'b0;
assign       i_force_rxfsm_cdr_1           = 1'b0;
assign       i_force_rxfsm_lsm_1           = 1'b0;
wire         i_hsst_fifo_clr_2             = 1'b0;         
assign       i_force_rxfsm_det_2           = 1'b0;
assign       i_force_rxfsm_cdr_2           = 1'b0;
assign       i_force_rxfsm_lsm_2           = 1'b0;
wire         i_hsst_fifo_clr_3             = 1'b0;         
assign       i_force_rxfsm_det_3           = 1'b0;
assign       i_force_rxfsm_cdr_3           = 1'b0;
assign       i_force_rxfsm_lsm_3           = 1'b0;
wire         o_lpll_done_0                 ;
wire         o_lpll_done_1                 ;
wire         o_lpll_done_2                 ;
wire         o_lpll_done_3                 ;
wire  [1:0]  o_lpll_wtchdg_st_0            ;
wire  [1:0]  o_lpll_wtchdg_st_1            ;
wire  [1:0]  o_lpll_wtchdg_st_2            ;
wire  [1:0]  o_lpll_wtchdg_st_3            ;
wire         o_txlane_done_1               ;
wire         o_txlane_done_2               ;
wire         o_txlane_done_3               ;
wire         o_tx_ckdiv_done_0             ;
wire         o_tx_ckdiv_done_1             ;
wire         o_tx_ckdiv_done_2             ;
wire         o_tx_ckdiv_done_3             ;
wire         o_rxlane_done_1               ;
wire         o_rxlane_done_2               ;
wire         o_rxlane_done_3               ;
wire         o_rx_ckdiv_done_0             ;
wire         o_rx_ckdiv_done_1             ;
wire         o_rx_ckdiv_done_2             ;
wire         o_rx_ckdiv_done_3             ;
wire         i_p_com_hpllpowerdown         = 1'b0;
wire         i_p_hpllpowerdown             = 1'b0;
wire         i_p_hpll_rst                  = 1'b0;
wire         i_p_hpll_vco_calib_en         = 1'b0;
wire         i_p_refclk_div_sync           = 1'b0;
wire         i_p_hpll_div_sync             = 1'b0;
wire          i_p_lpllpowerdown_0          = 1'b0;
wire          i_p_lpllpowerdown_1          = 1'b0;
wire          i_p_lpllpowerdown_2          = 1'b0;
wire          i_p_lpllpowerdown_3          = 1'b0;
wire          i_p_lpll_rst_0               = 1'b0;
wire          i_p_lpll_rst_1               = 1'b0;
wire          i_p_lpll_rst_2               = 1'b0;
wire          i_p_lpll_rst_3               = 1'b0;
wire         i_lpll_wtchdg_clr_0           = 1'b0;
wire         i_lpll_wtchdg_clr_1           = 1'b0;
wire         i_lpll_wtchdg_clr_2           = 1'b0;
wire         i_lpll_wtchdg_clr_3           = 1'b0;
wire         i_p_lane_pd_0                 = 1'b0;  
wire         i_p_lane_pd_1                 = 1'b0;
wire         i_p_lane_pd_2                 = 1'b0;
wire         i_p_lane_pd_3                 = 1'b0;
wire         i_p_lane_rst_0                = 1'b0;  
wire         i_p_lane_rst_1                = 1'b0;
wire         i_p_lane_rst_2                = 1'b0;
wire         i_p_lane_rst_3                = 1'b0;
wire         i_p_tx_lane_pd_0              = 1'b1;
wire         i_p_tx_lane_pd_1              = 1'b1;
wire         i_p_tx_lane_pd_2              = 1'b1;
wire         i_p_tx_lane_pd_3              = 1'b1;
wire         i_p_rx_lane_pd_0              = 1'b1;
wire         i_p_rx_lane_pd_1              = 1'b1;
wire         i_p_rx_lane_pd_2              = 1'b1;
wire         i_p_rx_lane_pd_3              = 1'b1;
wire         i_p_tx_pma_rst_0              = 1'b1;
wire         i_p_tx_pma_rst_1              = 1'b1;
wire         i_p_tx_pma_rst_2              = 1'b1;
wire         i_p_tx_pma_rst_3              = 1'b1;
wire         i_p_pcs_tx_rst_0              = 1'b1;
wire         i_p_pcs_tx_rst_1              = 1'b1;
wire         i_p_pcs_tx_rst_2              = 1'b1;
wire         i_p_pcs_tx_rst_3              = 1'b1;
wire         i_p_rx_pma_rst_0              = 1'b1;
wire         i_p_rx_pma_rst_1              = 1'b1;
wire         i_p_rx_pma_rst_2              = 1'b1;
wire         i_p_rx_pma_rst_3              = 1'b1;
wire         i_p_pcs_rx_rst_0              = 1'b1;
wire         i_p_pcs_rx_rst_1              = 1'b1;
wire         i_p_pcs_rx_rst_2              = 1'b1;
wire         i_p_pcs_rx_rst_3              = 1'b1;             
wire         o_p_clk2core_tx_1             ;             
wire         o_p_clk2core_tx_2             ;             
wire         o_p_clk2core_tx_3             ;
wire         i_p_tx1_clk_fr_core           = 1'b0;
wire         i_p_tx2_clk_fr_core           = 1'b0;
wire         i_p_tx3_clk_fr_core           = 1'b0;
wire         i_p_tx0_clk2_fr_core          = 1'b0;
wire         i_p_tx1_clk2_fr_core          = 1'b0;
wire         i_p_tx2_clk2_fr_core          = 1'b0;
wire         i_p_tx3_clk2_fr_core          = 1'b0;
wire         i_pll_lock_tx_0               = 1'b1;
wire         i_pll_lock_tx_1               = 1'b1;
wire         i_pll_lock_tx_2               = 1'b1;
wire         i_pll_lock_tx_3               = 1'b1;
wire         i_p_pll_tx_sel_0              ;
wire         i_p_pll_tx_sel_1              ;
wire         i_p_pll_tx_sel_2              ;
wire         i_p_pll_tx_sel_3              ;
assign       i_p_pll_tx_sel_0                = 1'b0;
assign       i_p_pll_tx_sel_1                = 1'b0;
assign       i_p_pll_tx_sel_2                = 1'b0;
assign       i_p_pll_tx_sel_3                = 1'b0;          
wire         o_p_clk2core_rx_1             ;          
wire         o_p_clk2core_rx_2             ;          
wire         o_p_clk2core_rx_3             ;
wire         i_p_rx1_clk_fr_core           = 1'b0;
wire         i_p_rx2_clk_fr_core           = 1'b0;
wire         i_p_rx3_clk_fr_core           = 1'b0;
wire         i_p_rx0_clk2_fr_core          = 1'b0;
wire         i_p_rx1_clk2_fr_core          = 1'b0;
wire         i_p_rx2_clk2_fr_core          = 1'b0;
wire         i_p_rx3_clk2_fr_core          = 1'b0;
wire         i_pll_lock_rx_0               = 1'b1;
wire         i_pll_lock_rx_1               = 1'b1;
wire         i_pll_lock_rx_2               = 1'b1;
wire         i_pll_lock_rx_3               = 1'b1;
wire         i_p_pll_rx_sel_0              ;
wire         i_p_pll_rx_sel_1              ;
wire         i_p_pll_rx_sel_2              ;
wire         i_p_pll_rx_sel_3              ;
assign       i_p_pll_rx_sel_0                = 1'b0;
assign       i_p_pll_rx_sel_1                = 1'b0;
assign       i_p_pll_rx_sel_2                = 1'b0;
assign       i_p_pll_rx_sel_3                = 1'b0;
wire         o_p_refck2core_1              ;
wire [2:0]   i_p_lx_margin_ctl_0           = 3'b0;
wire [2:0]   i_p_lx_margin_ctl_1           = 3'b0;
wire [2:0]   i_p_lx_margin_ctl_2           = 3'b0;
wire [2:0]   i_p_lx_margin_ctl_3           = 3'b0;
wire         i_p_lx_swing_ctl_0            = 1'b0;
wire         i_p_lx_swing_ctl_1            = 1'b0;
wire         i_p_lx_swing_ctl_2            = 1'b0;
wire         i_p_lx_swing_ctl_3            = 1'b0;
wire [15:0]  i_p_lx_deemp_ctl_0            = 16'b0;
wire [15:0]  i_p_lx_deemp_ctl_1            = 16'b0;
wire [15:0]  i_p_lx_deemp_ctl_2            = 16'b0;
wire [15:0]  i_p_lx_deemp_ctl_3            = 16'b0;
wire  [1:0]   i_p_tx_deemp_post_sel_0      =2'b0;
wire  [1:0]   i_p_tx_deemp_post_sel_1      =2'b0;
wire  [1:0]   i_p_tx_deemp_post_sel_2      =2'b0;
wire  [1:0]   i_p_tx_deemp_post_sel_3      =2'b0;
wire         i_p_rx_highz_0                =1'b0;
wire         i_p_rx_highz_1                =1'b0;
wire         i_p_rx_highz_2                =1'b0;
wire         i_p_rx_highz_3                =1'b0;
wire         i_p_lane_sync_0               =1'b0;
wire         i_p_rate_change_tclk_on_0     =1'b1;
wire [1:0]   i_p_tx_ckdiv_0                = 3;
wire [1:0]   i_p_tx_ckdiv_1                = 0;
wire [1:0]   i_p_tx_ckdiv_2                = 0;
wire [1:0]   i_p_tx_ckdiv_3                = 0;
wire [1:0]   i_p_lx_rx_ckdiv_0             = 3;
wire [1:0]   i_p_lx_rx_ckdiv_1             = 3;
wire [1:0]   i_p_lx_rx_ckdiv_2             = 3;
wire [1:0]   i_p_lx_rx_ckdiv_3             = 3;
wire [1:0]   i_p_lx_elecidle_en_0          = 2'b0;
wire [1:0]   i_p_lx_elecidle_en_1          = 2'b0;
wire [1:0]   i_p_lx_elecidle_en_2          = 2'b0;
wire [1:0]   i_p_lx_elecidle_en_3          = 2'b0;
assign       o_p_hpll_lock                 = P_HPLL_READY;
assign       o_p_rx_sigdet_sta_0           = P_RX_SIGDET_STATUS_0;
assign       o_p_lx_cdr_align_0            = P_LX_CDR_ALIGN_0;
wire [1:0]   o_p_lx_oob_sta_0              ;
wire [1:0]   o_p_lx_oob_sta_1              ;
wire [1:0]   o_p_lx_oob_sta_2              ;
wire [1:0]   o_p_lx_oob_sta_3              ;
wire         i_p_lx_rxdct_en_0             = 1'b0;
wire         i_p_lx_rxdct_en_1             = 1'b0;
wire         i_p_lx_rxdct_en_2             = 1'b0;
wire         i_p_lx_rxdct_en_3             = 1'b0;
wire         o_p_lx_rxdct_out_0            ;
wire         o_p_lx_rxdct_out_1            ;
wire         o_p_lx_rxdct_out_2            ;
wire         o_p_lx_rxdct_out_3            ;
wire         i_p_rxpcs_slip_1              = 1'b0;
wire         i_p_rxpcs_slip_2              = 1'b0;
wire         i_p_rxpcs_slip_3              = 1'b0;
wire         i_p_pcs_word_align_en_0       = 1'b0;
wire         i_p_pcs_word_align_en_1       = 1'b0;
wire         i_p_pcs_word_align_en_2       = 1'b0;
wire         i_p_pcs_word_align_en_3       = 1'b0;
wire         i_p_pcs_mcb_ext_en_0          = 1'b0;
wire         i_p_pcs_mcb_ext_en_1          = 1'b0;
wire         i_p_pcs_mcb_ext_en_2          = 1'b0;
wire         i_p_pcs_mcb_ext_en_3          = 1'b0;
wire         i_p_pcs_nearend_loop_1        = 1'b0;
wire         i_p_pcs_farend_loop_1         = 1'b0;
wire         i_p_pma_nearend_ploop_1       = 1'b0;
wire         i_p_pma_nearend_sloop_1       = 1'b0;
wire         i_p_pma_farend_ploop_1        = 1'b0;
wire         i_p_pcs_nearend_loop_2        = 1'b0;
wire         i_p_pcs_farend_loop_2         = 1'b0;
wire         i_p_pma_nearend_ploop_2       = 1'b0;
wire         i_p_pma_nearend_sloop_2       = 1'b0;
wire         i_p_pma_farend_ploop_2        = 1'b0;
wire         i_p_pcs_nearend_loop_3        = 1'b0;
wire         i_p_pcs_farend_loop_3         = 1'b0;
wire         i_p_pma_nearend_ploop_3       = 1'b0;
wire         i_p_pma_nearend_sloop_3       = 1'b0;
wire         i_p_pma_farend_ploop_3        = 1'b0;
wire         i_p_rx_polarity_invert_0      = 1'b0;
wire         i_p_rx_polarity_invert_1      = 1'b0;
wire         i_p_rx_polarity_invert_2      = 1'b0;
wire         i_p_rx_polarity_invert_3      = 1'b0;
wire         i_p_tx_beacon_en_0            = 1'b0;
wire         i_p_tx_beacon_en_1            = 1'b0;
wire         i_p_tx_beacon_en_2            = 1'b0;
wire         i_p_tx_beacon_en_3            = 1'b0;
wire         o_p_l1txn                     ;
wire         o_p_l1txp                     ;
wire         i_rx_data_sel_en_0            = 1'b0;
wire         i_rx_data_sel_en_1            = 1'b0;
wire         i_rx_data_sel_en_2            = 1'b0;
wire         i_rx_data_sel_en_3            = 1'b0;
wire  [1:0]  i_p_rx_data_sel_0             = 2'b0;
wire  [1:0]  i_p_rx_data_sel_1             = 2'b0;
wire  [1:0]  i_p_rx_data_sel_2             = 2'b0;
wire  [1:0]  i_p_rx_data_sel_3             = 2'b0;
wire [87:0]  i_p_tdata_0                   = {3'b0,i_txd_0[63:56],3'b0,i_txd_0[55:48],3'b0,i_txd_0[47:40],3'b0,i_txd_0[39:32],
                                              i_txh_0[2:0],i_txd_0[31:24],2'b0,i_txq_0[6],i_txd_0[23:16],i_txq_0[5:3],i_txd_0[15:8],i_txq_0[2:0],i_txd_0[7:0]};
wire [87:0]  i_p_tdata_1                   = 88'b0;
wire [87:0]  i_p_tdata_2                   = 88'b0;
wire [87:0]  i_p_tdata_3                   = 88'b0;

wire [87:0]  o_p_rdata_0                   ;
wire [5:0]   P_RXSTATUS_0                  ;
wire         P_RXDVLD_0                    ;
wire         P_RXDVLD_H_0                  ;

assign       o_rxstatus_0                  = P_RXSTATUS_0;
assign       o_rxd_vld_0                   = P_RXDVLD_0;
assign       o_rxd_vld_h_0                 = P_RXDVLD_H_0;
assign       o_rxd_0                       = {o_p_rdata_0[84:77],o_p_rdata_0[73:66],o_p_rdata_0[62:55],o_p_rdata_0[51:44],o_p_rdata_0[40:33],o_p_rdata_0[29:22],o_p_rdata_0[18:11],o_p_rdata_0[7:0]};
assign       o_rxh_0                       = o_p_rdata_0[32:30];
assign       o_rxh_h_0                     = o_p_rdata_0[76:74];
assign       o_rxh_vld_0                   = o_p_rdata_0[41];
assign       o_rxh_vld_h_0                 = o_p_rdata_0[85];
assign       o_rxq_start_0                 = o_p_rdata_0[42];
assign       o_rxq_start_h_0               = o_p_rdata_0[86];
wire [87:0]  o_p_rdata_1                   ;
wire [5:0]   P_RXSTATUS_1                  ;
wire         P_RXDVLD_1                    ;
wire         P_RXDVLD_H_1                  ;

wire [87:0]  o_p_rdata_2                   ;
wire [5:0]   P_RXSTATUS_2                  ;
wire         P_RXDVLD_2                    ;
wire         P_RXDVLD_H_2                  ;

wire [87:0]  o_p_rdata_3                   ;
wire [5:0]   P_RXSTATUS_3                  ;
wire         P_RXDVLD_3                    ;
wire         P_RXDVLD_H_3                  ;


ipm2t_hssthp_rst_v1_8a#(
    
    .INNER_RST_EN                  ("TRUE"                   ),  //TRUE: HSST Reset Auto Control, FALSE: HSST Reset Control by User
    
    .FREE_CLOCK_FREQ               (50.0                     ),  //Unit is MHz, free clock  freq from GUI Freq: 10~100MHz
    
    .CH0_TX_ENABLE                 ("TRUE"                   ),  //TRUE:lane0 TX Reset Logic used, FALSE: lane0 TX Reset Logic remove
    
    .CH1_TX_ENABLE                 ("FALSE"                   ),  //TRUE:lane1 TX Reset Logic used, FALSE: lane1 TX Reset Logic remove
    
    .CH2_TX_ENABLE                 ("FALSE"                   ),  //TRUE:lane2 TX Reset Logic used, FALSE: lane2 TX Reset Logic remove
    
    .CH3_TX_ENABLE                 ("FALSE"                   ),  //TRUE:lane3 TX Reset Logic used, FALSE: lane3 TX Reset Logic remove
    
    .CH0_RX_ENABLE                 ("TRUE"                   ),  //TRUE:lane0 RX Reset Logic used, FALSE: lane0 RX Reset Logic remove
    
    .CH1_RX_ENABLE                 ("FALSE"                   ),  //TRUE:lane1 RX Reset Logic used, FALSE: lane1 RX Reset Logic remove
    
    .CH2_RX_ENABLE                 ("FALSE"                   ),  //TRUE:lane2 RX Reset Logic used, FALSE: lane2 RX Reset Logic remove
    
    .CH3_RX_ENABLE                 ("FALSE"                   ),  //TRUE:lane3 RX Reset Logic used, FALSE: lane3 RX Reset Logic remove
    
    .CH0_TX_MULT_LANE_MODE         (1                     ), //Lane0 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    
    .CH1_TX_MULT_LANE_MODE         (1                     ), //Lane1 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    
    .CH2_TX_MULT_LANE_MODE         (1                     ), //Lane2 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    
    .CH3_TX_MULT_LANE_MODE         (1                     ), //Lane3 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    
    .CH0_RX_MULT_LANE_MODE         (1                     ), //Lane0 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    
    .CH1_RX_MULT_LANE_MODE         (1                     ), //Lane1 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    
    .CH2_RX_MULT_LANE_MODE         (1                     ), //Lane2 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    
    .CH3_RX_MULT_LANE_MODE         (1                     ), //Lane3 --> 1: Singel Lane 2:Two Lane 4:Four Lane    
    
    .PCS_CH0_BYPASS_WORD_ALIGN     ("TRUE"                   ), //TRUE: Lane0 Bypass Comma Alignment or OUTSIDE Mode, FALSE: Lane0 Enable Comma Alignment
    
    .PCS_CH1_BYPASS_WORD_ALIGN     ("TRUE"                   ), //TRUE: Lane0 Bypass Comma Alignment or OUTSIDE Mode, FALSE: Lane1 Enable Comma Alignment
    
    .PCS_CH2_BYPASS_WORD_ALIGN     ("TRUE"                   ), //TRUE: Lane1 Bypass Comma Alignment or OUTSIDE Mode, FALSE: Lane2 Enable Comma Alignment
    
    .PCS_CH3_BYPASS_WORD_ALIGN     ("TRUE"                   ), //TRUE: Lane2 Bypass Comma Alignment or OUTSIDE Mode, FALSE: Lane3 Enable Comma Alignment
    
    .PCS_CH0_BYPASS_BONDING        ("TRUE"                   ), //TRUE: Lane3 Bypass Channel Bonding, FALSE: Lane0 No Bypass Channel Bonding
    
    .PCS_CH1_BYPASS_BONDING        ("TRUE"                   ), //TRUE: Lane1 Bypass Channel Bonding, FALSE: Lane1 No Bypass Channel Bonding
    
    .PCS_CH2_BYPASS_BONDING        ("TRUE"                   ), //TRUE: Lane2 Bypass Channel Bonding, FALSE: Lane2 No Bypass Channel Bonding
    
    .PCS_CH3_BYPASS_BONDING        ("TRUE"                   ), //TRUE: Lane3 Bypass Channel Bonding, FALSE: Lane3 No Bypass Channel Bonding
    
    .PCS_CH0_BYPASS_CTC            ("TRUE"                   ), //TRUE: Lane0 Bypass CTC, FALSE: Lane0 No Bypass CTC
    
    .PCS_CH1_BYPASS_CTC            ("TRUE"                   ), //TRUE: Lane1 Bypass CTC, FALSE: Lane1 No Bypass CTC
    
    .PCS_CH2_BYPASS_CTC            ("TRUE"                   ), //TRUE: Lane2 Bypass CTC, FALSE: Lane2 No Bypass CTC
    
    .PCS_CH3_BYPASS_CTC            ("TRUE"                   ), //TRUE: Lane3 Bypass CTC, FALSE: Lane3 No Bypass CTC
    
    .P_LX_TX_CKDIV_0               (3                     ), //TX initial clock division value
    
    .P_LX_TX_CKDIV_1               (0                     ), //TX initial clock division value
    
    .P_LX_TX_CKDIV_2               (0                     ), //TX initial clock division value
    
    .P_LX_TX_CKDIV_3               (0                     ), //TX initial clock division value
    
    .CH0_LPLL_USE                  ("FALSE"                   ), //Lane0 --> 1:LPLL enable  0:LPLL disable
    
    .CH1_LPLL_USE                  ("FALSE"                   ), //Lane1 --> 1:LPLL enable  0:LPLL disable
    
    .CH2_LPLL_USE                  ("FALSE"                   ), //Lane2 --> 1:LPLL enable  0:LPLL disable
    
    .CH3_LPLL_USE                  ("FALSE"                   ), //Lane3 --> 1:LPLL enable  0:LPLL disable
    
    .HPLL_USE                      ("TRUE"                   ), //HPLL enable
    
    .CH0_TX_PLL_SEL                ("HPLL"                   ), //"HPLL": Tx Channel select HPLL "LPLL": Tx Channel select LPLL
    
    .CH1_TX_PLL_SEL                ("HPLL"                   ), //"HPLL": Tx Channel select HPLL "LPLL": Tx Channel select LPLL
    
    .CH2_TX_PLL_SEL                ("HPLL"                   ), //"HPLL": Tx Channel select HPLL "LPLL": Tx Channel select LPLL
    
    .CH3_TX_PLL_SEL                ("HPLL"                   ), //"HPLL": Tx Channel select HPLL "LPLL": Tx Channel select LPLL
    
    .CH0_RX_PLL_SEL                ("HPLL"                   ), //"HPLL": Rx Channel select HPLL "LPLL": Rx Channel select LPLL
    
    .CH1_RX_PLL_SEL                ("HPLL"                   ), //"HPLL": Rx Channel select HPLL "LPLL": Rx Channel select LPLL
    
    .CH2_RX_PLL_SEL                ("HPLL"                   ), //"HPLL": Rx Channel select HPLL "LPLL": Rx Channel select LPLL
    
    .CH3_RX_PLL_SEL                ("HPLL"                   ), //"HPLL": Rx Channel select HPLL "LPLL": Rx Channel select LPLL
    
    .LX_RX_CKDIV_0                 (3                     ), //RX initial clock division value
    
    .LX_RX_CKDIV_1                 (0                     ), //RX initial clock division value
    
    .LX_RX_CKDIV_2                 (0                     ), //RX initial clock division value
    
    .LX_RX_CKDIV_3                 (0                     ), //RX initial clock division value
    .MULTHPLL_BONDING              ("FALSE"                ), //enable two quad bonding
    
    .SINGLEHPLL_BONDING            ("FALSE"                   ), //enable one quad bonding
    .PCS_TX_CLK_EXPLL_USE_CH0      ("FALSE"                ),
    .PCS_TX_CLK_EXPLL_USE_CH1      ("FALSE"                ),
    .PCS_TX_CLK_EXPLL_USE_CH2      ("FALSE"                ),
    .PCS_TX_CLK_EXPLL_USE_CH3      ("FALSE"                ),
    .PCS_RX_CLK_EXPLL_USE_CH0      ("FALSE"                ),
    .PCS_RX_CLK_EXPLL_USE_CH1      ("FALSE"                ),
    .PCS_RX_CLK_EXPLL_USE_CH2      ("FALSE"                ),
    .PCS_RX_CLK_EXPLL_USE_CH3      ("FALSE"                ),
    
    .CH0_TX_RATE                   (10.3125                     ),
    .CH1_TX_RATE                   (0.0                     ),
    .CH2_TX_RATE                   (0.0                     ),
    .CH3_TX_RATE                   (0.0                     ),
    .CH0_RX_RATE                   (10.3125                     ),
    .CH1_RX_RATE                   (0.0                     ),
    .CH2_RX_RATE                   (0.0                     ),
    .CH3_RX_RATE                   (0.0                     ),
    .CH0_RXPCS_ALIGN_TIMER         (65535                    ),
    .CH1_RXPCS_ALIGN_TIMER         (65535                    ),
    .CH2_RXPCS_ALIGN_TIMER         (65535                    ),
    .CH3_RXPCS_ALIGN_TIMER         (65535                    ),
    .CH0_BOND_WTCHDG_CNTR1_WIDTH   (14                       ),
    .CH2_BOND_WTCHDG_CNTR1_WIDTH   (14                       ),
    .CH0_BOND_WTCHDG_CNTR2_WIDTH   (14                       ),
    .CH2_BOND_WTCHDG_CNTR2_WIDTH   (14                       ) 
) U_IPM2T_HSSTHP_RST (
    //BOTH NEED
    .i_pll_lock_tx_0               (i_pll_lock_tx_0               ), // input  wire                   
    .i_pll_lock_tx_1               (i_pll_lock_tx_1               ), // input  wire                   
    .i_pll_lock_tx_2               (i_pll_lock_tx_2               ), // input  wire                   
    .i_pll_lock_tx_3               (i_pll_lock_tx_3               ), // input  wire                   
    .i_pll_lock_rx_0               (i_pll_lock_rx_0               ), // input  wire                   
    .i_pll_lock_rx_1               (i_pll_lock_rx_1               ), // input  wire                   
    .i_pll_lock_rx_2               (i_pll_lock_rx_2               ), // input  wire                   
    .i_pll_lock_rx_3               (i_pll_lock_rx_3               ), // input  wire                   
    .i_pll_tx_sel_0                (i_p_pll_tx_sel_0              ), // input  wire                   
    .i_pll_tx_sel_1                (i_p_pll_tx_sel_1              ), // input  wire                   
    .i_pll_tx_sel_2                (i_p_pll_tx_sel_2              ), // input  wire                   
    .i_pll_tx_sel_3                (i_p_pll_tx_sel_3              ), // input  wire                   
    .i_pll_rx_sel_0                (i_p_pll_rx_sel_0              ), // input  wire                   
    .i_pll_rx_sel_1                (i_p_pll_rx_sel_1              ), // input  wire                   
    .i_pll_rx_sel_2                (i_p_pll_rx_sel_2              ), // input  wire                   
    .i_pll_rx_sel_3                (i_p_pll_rx_sel_3              ), // input  wire                   
    .i_rx_data_sel_en_0            (i_rx_data_sel_en_0            ), // input  wire                   
    .i_rx_data_sel_en_1            (i_rx_data_sel_en_1            ), // input  wire                   
    .i_rx_data_sel_en_2            (i_rx_data_sel_en_2            ), // input  wire                   
    .i_rx_data_sel_en_3            (i_rx_data_sel_en_3            ), // input  wire                   
    .i_rx_data_sel_0               (i_p_rx_data_sel_0             ), // [1:0] input  wire                   
    .i_rx_data_sel_1               (i_p_rx_data_sel_1             ), // [1:0] input  wire                   
    .i_rx_data_sel_2               (i_p_rx_data_sel_2             ), // [1:0] input  wire                   
    .i_rx_data_sel_3               (i_p_rx_data_sel_3             ), // [1:0] input  wire                   
    //--- User Side ---
    //INNER_RST_EN is TRUE 
    .i_free_clk                    (i_free_clk                    ), // input  wire                    
    .i_hpll_rst                    (i_hpll_rst                    ), // input  wire                    
    .i_lpll_rst_0                  (i_lpll_rst_0                  ), // input  wire                    
    .i_lpll_rst_1                  (i_lpll_rst_1                  ), // input  wire                    
    .i_lpll_rst_2                  (i_lpll_rst_2                  ), // input  wire                    
    .i_lpll_rst_3                  (i_lpll_rst_3                  ), // input  wire                    
    .i_wtchdg_clr_hpll             (i_hpll_wtchdg_clr             ), // input  wire                    
    .i_wtchdg_clr_lpll_0           (i_lpll_wtchdg_clr_0           ), // input  wire                    
    .i_wtchdg_clr_lpll_1           (i_lpll_wtchdg_clr_1           ), // input  wire                    
    .i_wtchdg_clr_lpll_2           (i_lpll_wtchdg_clr_2           ), // input  wire                    
    .i_wtchdg_clr_lpll_3           (i_lpll_wtchdg_clr_3           ), // input  wire                    
    .i_txlane_rst_0                (i_txlane_rst_0                ), // input  wire                    
    .i_txlane_rst_1                (i_txlane_rst_1                ), // input  wire                    
    .i_txlane_rst_2                (i_txlane_rst_2                ), // input  wire                    
    .i_txlane_rst_3                (i_txlane_rst_3                ), // input  wire                    
    .i_tx_pma_rst_0                (i_tx_pma_rst_0                ), // input  wire                    
    .i_tx_pma_rst_1                (i_tx_pma_rst_1                ), // input  wire                    
    .i_tx_pma_rst_2                (i_tx_pma_rst_2                ), // input  wire                    
    .i_tx_pma_rst_3                (i_tx_pma_rst_3                ), // input  wire                    
    .i_tx_pcs_rst_0                (i_tx_pcs_rst_0                ), // input  wire                    
    .i_tx_pcs_rst_1                (i_tx_pcs_rst_1                ), // input  wire                    
    .i_tx_pcs_rst_2                (i_tx_pcs_rst_2                ), // input  wire                    
    .i_tx_pcs_rst_3                (i_tx_pcs_rst_3                ), // input  wire                    
    .i_rxlane_rst_0                (i_rxlane_rst_0                ), // input  wire                    
    .i_rxlane_rst_1                (i_rxlane_rst_1                ), // input  wire                    
    .i_rxlane_rst_2                (i_rxlane_rst_2                ), // input  wire                    
    .i_rxlane_rst_3                (i_rxlane_rst_3                ), // input  wire                    
    .i_rx_pma_rst_0                (i_rx_pma_rst_0                ), // input  wire                    
    .i_rx_pma_rst_1                (i_rx_pma_rst_1                ), // input  wire                    
    .i_rx_pma_rst_2                (i_rx_pma_rst_2                ), // input  wire                    
    .i_rx_pma_rst_3                (i_rx_pma_rst_3                ), // input  wire                    
    .i_rx_pcs_rst_0                (i_rx_pcs_rst_0                ), // input  wire                    
    .i_rx_pcs_rst_1                (i_rx_pcs_rst_1                ), // input  wire                    
    .i_rx_pcs_rst_2                (i_rx_pcs_rst_2                ), // input  wire                    
    .i_rx_pcs_rst_3                (i_rx_pcs_rst_3                ), // input  wire                    
    .i_tx_rate_chng_0              (i_tx_rate_chng_0              ), // input  wire
    .i_tx_rate_chng_1              (i_tx_rate_chng_1              ), // input  wire
    .i_tx_rate_chng_2              (i_tx_rate_chng_2              ), // input  wire
    .i_tx_rate_chng_3              (i_tx_rate_chng_3              ), // input  wire
    .i_rx_rate_chng_0              (i_rx_rate_chng_0              ), // input  wire                    
    .i_rx_rate_chng_1              (i_rx_rate_chng_1              ), // input  wire                    
    .i_rx_rate_chng_2              (i_rx_rate_chng_2              ), // input  wire                    
    .i_rx_rate_chng_3              (i_rx_rate_chng_3              ), // input  wire                    
    .i_txckdiv_0                   (i_txckdiv_0                   ), // input  wire    [1 : 0]         
    .i_txckdiv_1                   (i_txckdiv_1                   ), // input  wire    [1 : 0]         
    .i_txckdiv_2                   (i_txckdiv_2                   ), // input  wire    [1 : 0]         
    .i_txckdiv_3                   (i_txckdiv_3                   ), // input  wire    [1 : 0]         
    .i_rxckdiv_0                   (i_rxckdiv_0                   ), // input  wire    [1 : 0]         
    .i_rxckdiv_1                   (i_rxckdiv_1                   ), // input  wire    [1 : 0]         
    .i_rxckdiv_2                   (i_rxckdiv_2                   ), // input  wire    [1 : 0]         
    .i_rxckdiv_3                   (i_rxckdiv_3                   ), // input  wire    [1 : 0]         
    
    .i_bond_wtchdg_clr             (1'b0                          ), // input  wire
    .i_hssthp_fifo_clr_0           (i_hsst_fifo_clr_0             ), // input  wire                    
    .i_hssthp_fifo_clr_1           (i_hsst_fifo_clr_1             ), // input  wire                    
    .i_hssthp_fifo_clr_2           (i_hsst_fifo_clr_2             ), // input  wire                    
    .i_hssthp_fifo_clr_3           (i_hsst_fifo_clr_3             ), // input  wire         
    .i_force_rxfsm_det_0           (i_force_rxfsm_det_0           ), // input  wire                   Debug signal for loopback mode
    .i_force_rxfsm_lsm_0           (i_force_rxfsm_lsm_0           ), // input  wire                   Debug signal for loopback mode
    .i_force_rxfsm_cdr_0           (i_force_rxfsm_cdr_0           ), // input  wire                   Debug signal for loopback mode
    .i_force_rxfsm_det_1           (i_force_rxfsm_det_1           ), // input  wire                   Debug signal for loopback mode
    .i_force_rxfsm_lsm_1           (i_force_rxfsm_lsm_1           ), // input  wire                   Debug signal for loopback mode
    .i_force_rxfsm_cdr_1           (i_force_rxfsm_cdr_1           ), // input  wire                   Debug signal for loopback mode
    .i_force_rxfsm_det_2           (i_force_rxfsm_det_2           ), // input  wire                   Debug signal for loopback mode
    .i_force_rxfsm_lsm_2           (i_force_rxfsm_lsm_2           ), // input  wire                   Debug signal for loopback mode
    .i_force_rxfsm_cdr_2           (i_force_rxfsm_cdr_2           ), // input  wire                   Debug signal for loopback mode
    .i_force_rxfsm_det_3           (i_force_rxfsm_det_3           ), // input  wire                   Debug signal for loopback mode
    .i_force_rxfsm_lsm_3           (i_force_rxfsm_lsm_3           ), // input  wire                   Debug signal for loopback mode
    .i_force_rxfsm_cdr_3           (i_force_rxfsm_cdr_3           ), // input  wire                   Debug signal for loopback mode
    .o_wtchdg_st_hpll              (o_hpll_wtchdg_st              ), // output wire    [1 : 0]         
    .o_wtchdg_st_lpll_0            (o_lpll_wtchdg_st_0            ), // output wire    [1 : 0] 
    .o_wtchdg_st_lpll_1            (o_lpll_wtchdg_st_1            ), // output wire    [1 : 0] 
    .o_wtchdg_st_lpll_2            (o_lpll_wtchdg_st_2            ), // output wire    [1 : 0] 
    .o_wtchdg_st_lpll_3            (o_lpll_wtchdg_st_3            ), // output wire    [1 : 0] 
    .o_hpll_done                   (o_hpll_done                   ), // output wire                    
    .o_lpll_done_0                 (o_lpll_done_0                 ), // output wire                    
    .o_lpll_done_1                 (o_lpll_done_1                 ), // output wire                    
    .o_lpll_done_2                 (o_lpll_done_2                 ), // output wire                    
    .o_lpll_done_3                 (o_lpll_done_3                 ), // output wire                    
    .o_txlane_done_0               (o_txlane_done_0               ), // output wire                    
    .o_txlane_done_1               (o_txlane_done_1               ), // output wire                    
    .o_txlane_done_2               (o_txlane_done_2               ), // output wire                    
    .o_txlane_done_3               (o_txlane_done_3               ), // output wire                    
    .o_tx_ckdiv_done_0             (o_tx_ckdiv_done_0             ), // output wire                    
    .o_tx_ckdiv_done_1             (o_tx_ckdiv_done_1             ), // output wire                    
    .o_tx_ckdiv_done_2             (o_tx_ckdiv_done_2             ), // output wire                    
    .o_tx_ckdiv_done_3             (o_tx_ckdiv_done_3             ), // output wire                    
    .o_rxlane_done_0               (o_rxlane_done_0               ), // output wire                    
    .o_rxlane_done_1               (o_rxlane_done_1               ), // output wire                    
    .o_rxlane_done_2               (o_rxlane_done_2               ), // output wire                    
    .o_rxlane_done_3               (o_rxlane_done_3               ), // output wire                    
    .o_rx_ckdiv_done_0             (o_rx_ckdiv_done_0             ), // output wire                    
    .o_rx_ckdiv_done_1             (o_rx_ckdiv_done_1             ), // output wire                    
    .o_rx_ckdiv_done_2             (o_rx_ckdiv_done_2             ), // output wire                    
    .o_rx_ckdiv_done_3             (o_rx_ckdiv_done_3             ), // output wire                    
    //INNER_RST_EN is FALSE
    .i_f_com_powerdown             (i_p_com_hpllpowerdown         ), // input  wire                   
    .i_f_hpll_powerdown            (i_p_hpllpowerdown             ), // input  wire                   
    .i_f_hpll_rst                  (i_p_hpll_rst                  ), // input  wire                   
    .i_f_hpll_vco_calib_en         (i_p_hpll_vco_calib_en         ), // input  wire                   
    .i_f_refclk_div_sync           (i_p_refclk_div_sync           ), // input  wire                   
    .i_f_hpll_div_sync             (i_p_hpll_div_sync             ), // input  wire                   
    .i_f_tx_sync                   (i_p_lane_sync_0               ), // input  wire                   
    .i_f_tx_rate_change_on         (i_p_rate_change_tclk_on_0     ), // input  wire                   
    .i_f_lpll_powerdown_0          (i_p_lpllpowerdown_0           ),
    .i_f_lpll_rst_0                (i_p_lpll_rst_0                ),
    .i_f_lane_powerdown_0          (i_p_lane_pd_0                 ),
    .i_f_tx_rate_0                 (i_p_tx_ckdiv_0                ),
    .i_f_lane_rst_0                (i_p_lane_rst_0                ),
    .i_f_tx_pma_rst_0              (i_p_tx_pma_rst_0              ),
    .i_f_pcs_tx_rst_0              (i_p_pcs_tx_rst_0              ),
    .i_f_tx_lane_powerdown_0       (i_p_tx_lane_pd_0              ),
    .i_f_pma_rx_pd_0               (i_p_rx_lane_pd_0              ),
    .i_f_pcs_rx_rst_0              (i_p_pcs_rx_rst_0              ),
    .i_f_rx_pma_rst_0              (i_p_rx_pma_rst_0              ),
    .i_f_rx_rate_0                 (i_p_lx_rx_ckdiv_0             ),
    .i_f_lpll_powerdown_1          (i_p_lpllpowerdown_1           ),
    .i_f_lpll_rst_1                (i_p_lpll_rst_1                ),
    .i_f_lane_powerdown_1          (i_p_lane_pd_1                 ),
    .i_f_tx_rate_1                 (i_p_tx_ckdiv_1                ),
    .i_f_lane_rst_1                (i_p_lane_rst_1                ),
    .i_f_tx_pma_rst_1              (i_p_tx_pma_rst_1              ),
    .i_f_pcs_tx_rst_1              (i_p_pcs_tx_rst_1              ),
    .i_f_tx_lane_powerdown_1       (i_p_tx_lane_pd_1              ),
    .i_f_pma_rx_pd_1               (i_p_rx_lane_pd_1              ),
    .i_f_pcs_rx_rst_1              (i_p_pcs_rx_rst_1              ),
    .i_f_rx_pma_rst_1              (i_p_rx_pma_rst_1              ),
    .i_f_rx_rate_1                 (i_p_lx_rx_ckdiv_1             ),
    .i_f_lpll_powerdown_2          (i_p_lpllpowerdown_2           ),
    .i_f_lpll_rst_2                (i_p_lpll_rst_2                ),
    .i_f_lane_powerdown_2          (i_p_lane_pd_2                 ),
    .i_f_tx_rate_2                 (i_p_tx_ckdiv_2                ),
    .i_f_lane_rst_2                (i_p_lane_rst_2                ),
    .i_f_tx_pma_rst_2              (i_p_tx_pma_rst_2              ),
    .i_f_pcs_tx_rst_2              (i_p_pcs_tx_rst_2              ),
    .i_f_tx_lane_powerdown_2       (i_p_tx_lane_pd_2              ),
    .i_f_pma_rx_pd_2               (i_p_rx_lane_pd_2              ),
    .i_f_pcs_rx_rst_2              (i_p_pcs_rx_rst_2              ),
    .i_f_rx_pma_rst_2              (i_p_rx_pma_rst_2              ),
    .i_f_rx_rate_2                 (i_p_lx_rx_ckdiv_2             ),
    .i_f_lpll_powerdown_3          (i_p_lpllpowerdown_3           ),
    .i_f_lpll_rst_3                (i_p_lpll_rst_3                ),
    .i_f_lane_powerdown_3          (i_p_lane_pd_3                 ),
    .i_f_tx_rate_3                 (i_p_tx_ckdiv_3                ),
    .i_f_lane_rst_3                (i_p_lane_rst_3                ),
    .i_f_tx_pma_rst_3              (i_p_tx_pma_rst_3              ),
    .i_f_pcs_tx_rst_3              (i_p_pcs_tx_rst_3              ),
    .i_f_tx_lane_powerdown_3       (i_p_tx_lane_pd_3              ),
    .i_f_pma_rx_pd_3               (i_p_rx_lane_pd_3              ),
    .i_f_pcs_rx_rst_3              (i_p_pcs_rx_rst_3              ),
    .i_f_rx_pma_rst_3              (i_p_rx_pma_rst_3              ),
    .i_f_rx_rate_3                 (i_p_lx_rx_ckdiv_3             ),

    //--- Hsst Side ---
    .HPLL_READY_0                  (P_HPLL_READY                  ), // input  wire                    
    .HPLL_READY_1                  (1'b0                          ), // input  wire                    
    .LPLL_READY_0                  (P_LPLL_READY_0                ), // input  wire                    
    .LPLL_READY_1                  (P_LPLL_READY_1                ), // input  wire                    
    .LPLL_READY_2                  (P_LPLL_READY_2                ), // input  wire                    
    .LPLL_READY_3                  (P_LPLL_READY_3                ), // input  wire                    
    .P_RX_SIGDET_STATUS_0          (P_RX_SIGDET_STATUS_0          ), // input  wire                    
    .P_RX_SIGDET_STATUS_1          (P_RX_SIGDET_STATUS_1          ), // input  wire                    
    .P_RX_SIGDET_STATUS_2          (P_RX_SIGDET_STATUS_2          ), // input  wire                    
    .P_RX_SIGDET_STATUS_3          (P_RX_SIGDET_STATUS_3          ), // input  wire                    
    .P_RX_READY_0                  (P_LX_CDR_ALIGN_0              ), // input  wire                    
    .P_RX_READY_1                  (P_LX_CDR_ALIGN_1              ), // input  wire                    
    .P_RX_READY_2                  (P_LX_CDR_ALIGN_2              ), // input  wire                    
    .P_RX_READY_3                  (P_LX_CDR_ALIGN_3              ), // input  wire                    
    .P_PCS_LSM_SYNCED_0            (P_PCS_LSM_SYNCED_0            ), // input  wire             
    .P_PCS_LSM_SYNCED_1            (P_PCS_LSM_SYNCED_1            ), // input  wire             
    .P_PCS_LSM_SYNCED_2            (P_PCS_LSM_SYNCED_2            ), // input  wire             
    .P_PCS_LSM_SYNCED_3            (P_PCS_LSM_SYNCED_3            ), // input  wire             
    .P_PCS_RX_MCB_STATUS_0         (P_PCS_RX_MCB_STATUS_0         ), // input  wire          
    .P_PCS_RX_MCB_STATUS_1         (P_PCS_RX_MCB_STATUS_1         ), // input  wire          
    .P_PCS_RX_MCB_STATUS_2         (P_PCS_RX_MCB_STATUS_2         ), // input  wire          
    .P_PCS_RX_MCB_STATUS_3         (P_PCS_RX_MCB_STATUS_3         ), // input  wire          
    .P_COM_POWERDOWN               (P_COM_POWERDOWN               ), // output wire                    
    .P_HPLL_POWERDOWN              (P_HPLL_POWERDOWN              ), // output wire                    
    .P_HPLL_RST                    (P_HPLL_RST                    ), // output wire                    
    .P_HPLL_VCO_CALIB_EN           (P_HPLL_VCO_CALIB_EN           ), // output wire                    
    .P_REFCLK_DIV_SYNC             (P_REFCLK_DIV_SYNC             ), // output wire
    .P_HPLL_DIV_SYNC               (P_HPLL_DIV_SYNC               ), // output wire
    .P_TX_SYNC                     (P_TX_SYNC                     ), // output wire
    .P_TX_RATE_CHANGE_ON           (P_TX_RATE_CHANGE_ON           ), // output wire
    .P_LPLL_POWERDOWN_0            (P_LPLL_POWERDOWN_0            ), // output wire
    .P_LPLL_POWERDOWN_1            (P_LPLL_POWERDOWN_1            ), // output wire
    .P_LPLL_POWERDOWN_2            (P_LPLL_POWERDOWN_2            ), // output wire
    .P_LPLL_POWERDOWN_3            (P_LPLL_POWERDOWN_3            ), // output wire
    .P_LPLL_RST_0                  (P_LPLL_RST_0                  ), // output wire
    .P_LPLL_RST_1                  (P_LPLL_RST_1                  ), // output wire
    .P_LPLL_RST_2                  (P_LPLL_RST_2                  ), // output wire
    .P_LPLL_RST_3                  (P_LPLL_RST_3                  ), // output wire
    .P_LANE_POWERDOWN_0            (P_LANE_POWERDOWN_0            ), // output wire
    .P_LANE_POWERDOWN_1            (P_LANE_POWERDOWN_1            ), // output wire
    .P_LANE_POWERDOWN_2            (P_LANE_POWERDOWN_2            ), // output wire
    .P_LANE_POWERDOWN_3            (P_LANE_POWERDOWN_3            ), // output wire
    .P_LANE_RST_0                  (P_LANE_RST_0                  ), // output wire
    .P_LANE_RST_1                  (P_LANE_RST_1                  ), // output wire
    .P_LANE_RST_2                  (P_LANE_RST_2                  ), // output wire
    .P_LANE_RST_3                  (P_LANE_RST_3                  ), // output wire
    .P_TX_LANE_POWERDOWN_0         (P_TX_LANE_POWERDOWN_0         ), // output wire                    
    .P_TX_LANE_POWERDOWN_1         (P_TX_LANE_POWERDOWN_1         ), // output wire                    
    .P_TX_LANE_POWERDOWN_2         (P_TX_LANE_POWERDOWN_2         ), // output wire                    
    .P_TX_LANE_POWERDOWN_3         (P_TX_LANE_POWERDOWN_3         ), // output wire                    
    .P_TX_PMA_RST_0                (P_TX_PMA_RST_0                ), // output wire                    
    .P_TX_PMA_RST_1                (P_TX_PMA_RST_1                ), // output wire                    
    .P_TX_PMA_RST_2                (P_TX_PMA_RST_2                ), // output wire                    
    .P_TX_PMA_RST_3                (P_TX_PMA_RST_3                ), // output wire                    
    .P_PCS_TX_RST_0                (P_PCS_TX_RST_0                ),
    .P_PCS_TX_RST_1                (P_PCS_TX_RST_1                ),
    .P_PCS_TX_RST_2                (P_PCS_TX_RST_2                ),
    .P_PCS_TX_RST_3                (P_PCS_TX_RST_3                ),
    .P_TX_RATE_0                   (P_TX_RATE_0                   ), // output wire    [1 : 0]       
    .P_TX_RATE_1                   (P_TX_RATE_1                   ), // output wire    [1 : 0]       
    .P_TX_RATE_2                   (P_TX_RATE_2                   ), // output wire    [1 : 0]       
    .P_TX_RATE_3                   (P_TX_RATE_3                   ), // output wire    [1 : 0]       
    .P_PMA_RX_PD_0                 (P_RX_LANE_POWERDOWN_0         ),
    .P_PMA_RX_PD_1                 (P_RX_LANE_POWERDOWN_1         ),
    .P_PMA_RX_PD_2                 (P_RX_LANE_POWERDOWN_2         ),
    .P_PMA_RX_PD_3                 (P_RX_LANE_POWERDOWN_3         ),
    .P_RX_PMA_RST_0                (P_RX_PMA_RST_0                ),
    .P_RX_PMA_RST_1                (P_RX_PMA_RST_1                ),
    .P_RX_PMA_RST_2                (P_RX_PMA_RST_2                ),
    .P_RX_PMA_RST_3                (P_RX_PMA_RST_3                ),
    .P_PCS_RX_RST_0                (P_PCS_RX_RST_0                ),
    .P_PCS_RX_RST_1                (P_PCS_RX_RST_1                ),
    .P_PCS_RX_RST_2                (P_PCS_RX_RST_2                ),
    .P_PCS_RX_RST_3                (P_PCS_RX_RST_3                ),
    .P_RX_RATE_0                   (P_RX_RATE_0                   ), // output wire    [1 : 0]         
    .P_RX_RATE_1                   (P_RX_RATE_1                   ), // output wire    [1 : 0]        
    .P_RX_RATE_2                   (P_RX_RATE_2                   ), // output wire    [1 : 0]        
    .P_RX_RATE_3                   (P_RX_RATE_3                   )  // output wire    [1 : 0]       
);

ipm2t_hssthp_Transceiver_10G_wrapper_v1_8a #(
    //--------Global Parameter--------//
    
    .HPLL_EN                           ("TRUE"                       ),//TRUE, FALSE; for HPLL enable
    
    .CHANNEL0_EN                       ("TRUE"                       ),//TRUE, FALSE; for Channel0 enable
    
    .CHANNEL1_EN                       ("FALSE"                       ),//TRUE, FALSE; for Channel1 enable
    
    .CHANNEL2_EN                       ("FALSE"                       ),//TRUE, FALSE; for Channel2 enable
    
    .CHANNEL3_EN                       ("FALSE"                       ),//TRUE, FALSE; for Channel3 enable
    
    .CH0_TX_MULT_LANE_MODE             (1                         ),//Lane0 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    
    .CH1_TX_MULT_LANE_MODE             (1                         ),//Lane1 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    
    .CH2_TX_MULT_LANE_MODE             (1                         ),//Lane2 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    
    .CH3_TX_MULT_LANE_MODE             (1                         ),//Lane3 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    
    .CH0_RX_MULT_LANE_MODE             (1                         ),//Lane0 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    
    .CH1_RX_MULT_LANE_MODE             (1                         ),//Lane1 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    
    .CH2_RX_MULT_LANE_MODE             (1                         ),//Lane2 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    
    .CH3_RX_MULT_LANE_MODE             (1                         ),//Lane3 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    
    .REFCLK_PAD0_EN                    ("TRUE"                       ),//TRUE, FALSE; for REFCLK_PAD0 enable
    
    .REFCLK_PAD1_EN                    ("FALSE"                       ),//TRUE, FALSE; for REFCLK_PAD1 enable
    
    .PMA_REG_HPLL_REFCLK_SEL           ("REFERENCE_CLOCK_0"                       ),//"REFERENCE_CLOCK_0" "REFERENCE_CLOCK_1" "REFERENCE_CLOCK_0_FROM_UPPER_HSST" "REFERENCE_CLOCK_1_FROM_UPPER_HSST" "REFERENCE_CLOCK_1_FROM_LOWER_HSST" "REFERENCE_CLOCK_1_FROM_FABRIC"
    
    .PMA_REG_LANE0_PLL_REFCLK_SEL      ("REFERENCE_CLOCK_0"                       ),//"REFERENCE_CLOCK_0" "REFERENCE_CLOCK_1" "REFERENCE_CLOCK_0_FROM_UPPER_HSST" "REFERENCE_CLOCK_1_FROM_UPPER_HSST" "REFERENCE_CLOCK_1_FROM_LOWER_HSST" "REFERENCE_CLOCK_1_FROM_FABRIC"
    
    .PMA_REG_LANE1_PLL_REFCLK_SEL      ("REFERENCE_CLOCK_0"                       ),//"REFERENCE_CLOCK_0" "REFERENCE_CLOCK_1" "REFERENCE_CLOCK_0_FROM_UPPER_HSST" "REFERENCE_CLOCK_1_FROM_UPPER_HSST" "REFERENCE_CLOCK_1_FROM_LOWER_HSST" "REFERENCE_CLOCK_1_FROM_FABRIC"
    
    .PMA_REG_LANE2_PLL_REFCLK_SEL      ("REFERENCE_CLOCK_0"                       ),//"REFERENCE_CLOCK_0" "REFERENCE_CLOCK_1" "REFERENCE_CLOCK_0_FROM_UPPER_HSST" "REFERENCE_CLOCK_1_FROM_UPPER_HSST" "REFERENCE_CLOCK_1_FROM_LOWER_HSST" "REFERENCE_CLOCK_1_FROM_FABRIC"
    
    .PMA_REG_LANE3_PLL_REFCLK_SEL      ("REFERENCE_CLOCK_0"                       ) //"REFERENCE_CLOCK_0" "REFERENCE_CLOCK_1" "REFERENCE_CLOCK_0_FROM_UPPER_HSST" "REFERENCE_CLOCK_1_FROM_UPPER_HSST" "REFERENCE_CLOCK_1_FROM_LOWER_HSST" "REFERENCE_CLOCK_1_FROM_FABRIC"
) U_GTP_HSSTHP_WRAPPER (

    //APB
    .p_cfg_clk                         (i_p_cfg_clk                  ), // input          
    .p_cfg_rst                         (i_p_cfg_rst                  ), // input          
    .p_cfg_psel                        (i_p_cfg_psel                 ), // input          
    .p_cfg_enable                      (i_p_cfg_enable               ), // input          
    .p_cfg_write                       (i_p_cfg_write                ), // input          
    .p_cfg_addr                        (i_p_cfg_addr                 ), // input  [15:0]  
    .p_cfg_wdata                       (i_p_cfg_wdata                ), // input  [7:0]   
    .p_cfg_rdata                       (o_p_cfg_rdata                ), // output [7:0]   
    .p_cfg_int                         (o_p_cfg_int                  ), // output         
    .p_cfg_ready                       (o_p_cfg_ready                ), // output         
    .p_fabric_refclk                   (i_p_pll_ref_clk_0            ), // input     
    .p_calib_done                      (o_p_calib_done               ), // output   
    //HPLL
    .P_COM_POWERDOWN                   (P_COM_POWERDOWN              ), // input          
    .P_HPLL_POWERDOWN                  (P_HPLL_POWERDOWN             ), // input          
    .P_HPLL_RST                        (P_HPLL_RST                   ), // input          
    .P_TX_SYNC                         (P_TX_SYNC                    ), // input 
    .P_TX_RATE_CHANGE_ON_0             (P_TX_RATE_CHANGE_ON          ), // input
    .P_TX_RATE_CHANGE_ON_1             (1'b1                         ), // input to be done
    .P_HPLL_DIV_SYNC                   (P_HPLL_DIV_SYNC              ), // input
    .P_REFCLK_DIV_SYNC                 (P_REFCLK_DIV_SYNC            ), // input
    .P_HPLL_VCO_CALIB_EN               (P_HPLL_VCO_CALIB_EN          ), // input
    .P_HPLL_DIV_CHANGE                 (1'b0                         ), // input

    .P_REFCK2CORE_0                    (o_p_refck2core_0             ), // output         
    .P_REFCK2CORE_1                    (o_p_refck2core_1             ), // output         
    .P_HPLL_READY                      (P_HPLL_READY                 ), // output         
    
    .PAD_REFCLKN_0                     (i_p_refckn_0                 ),// input                  
    .PAD_REFCLKP_0                     (i_p_refckp_0                 ),// input                                               
    .PAD_REFCLKN_1                     (                             ),// input                  
    .PAD_REFCLKP_1                     (                             ),// input 
    .P_LANE_POWERDOWN_0                (P_LANE_POWERDOWN_0           ), // input               
    .P_LANE_RST_0                      (P_LANE_RST_0                 ), // input               
    .P_TX_PMA_RST_0                    (P_TX_PMA_RST_0               ), // input               
    .P_TX_LANE_POWERDOWN_0             (P_TX_LANE_POWERDOWN_0        ), // input               
    .P_RX_LANE_POWERDOWN_0             (P_RX_LANE_POWERDOWN_0        ), // input               
    .P_TCLK2FABRIC_0                   (o_p_clk2core_tx_0            ), // output
    .P_TX_CLK_FR_CORE_0                (i_p_tx0_clk_fr_core          ), // input          
    .P_TCLK2_FR_CORE_0                 (i_p_tx0_clk2_fr_core         ), // input          
    .P_RCLK2FABRIC_0                   (o_p_clk2core_rx_0            ), // output
    .P_RXSTATUS_0                      (P_RXSTATUS_0                 ), // output
    .P_RX_CLK_FR_CORE_0                (i_p_rx0_clk_fr_core          ), // input          
    .P_RCLK2_FR_CORE_0                 (i_p_rx0_clk2_fr_core         ), // input          
    .P_RX_PMA_RST_0                    (P_RX_PMA_RST_0               ), // input          
    .P_PCS_TX_RST_0                    (P_PCS_TX_RST_0               ), // input          
    .P_PCS_RX_RST_0                    (P_PCS_RX_RST_0               ), // input          
    .P_EXT_BRIDGE_PCS_RST_0            (1'b0                         ), // input          
    .P_TX_MARGIN_0                     (i_p_lx_margin_ctl_0          ), // input  [2:0]   
    .P_TX_SWING_0                      (i_p_lx_swing_ctl_0           ), // input          
    .P_TX_DEEMP_0                      (i_p_lx_deemp_ctl_0           ), // input  [15:0]  
    .P_TX_DEEMP_POST_SEL_0             (i_p_tx_deemp_post_sel_0      ), // input  [1:0]  
    .P_BLK_ALIGN_CTRL_0                (i_p_blk_align_ctrl_0         ), // input    
    .P_TX_ENC_TYPE_0                   (1'b0                         ), // input    
    .P_RX_DEC_TYPE_0                   (1'b0                         ), // input    
    .P_PCS_PRBS_EN_0                   (1'b0                         ), // input    
    .P_RX_PRBS_ERROR_0                 (                             ), // output    
    .P_RX_EYE_RST_0                    (1'b0                         ), // input    
    .P_RX_EYE_EN_0                     (1'b0                         ), // input    
    
    .P_RX_EYE_TAP_0                    (8'b0                         ), // input     
    .P_RX_PIC_EYE_0                    (8'b0                         ), // input    
    .P_RX_PIC_FASTLOCK_0               (8'b0                         ), // input    
    .P_RX_PIC_FASTLOCK_STROBE_0        (1'b0                         ), // input    
    .P_EM_RD_TRIGGER_0                 (1'b0                         ), // input    
    .P_EM_MODE_CTRL_0                  (2'b0                         ), // input    
    .P_EM_ERROR_CNT_0                  (                             ), // output    
    .P_RX_SLIP_RST_0                   (1'b0                         ), // input    
    .P_RX_SLIP_EN_0                    (1'b1                         ), // input    
    .P_LPLL_POWERDOWN_0                (P_LPLL_POWERDOWN_0           ), // input    
    .P_LPLL_RST_0                      (P_LPLL_RST_0                 ), // input    
    .P_LPLL_READY_0                    (P_LPLL_READY_0               ), // output 
    .P_TX_LS_DATA_0                    (1'b0                         ), // input    
    .P_TX_PIC_EN_0                     (1'b0                         ), // input    
    .P_TX_BUSWIDTH_0                   (3'b0                         ), // input    
    .P_TX_FREERUN_BUSWIDTH_0           (3'b011                       ), // input    
    .P_RX_BUSWIDTH_0                   (3'b0                         ), // input    
    .P_RX_HIGHZ_0                      (i_p_rx_highz_0               ), // input 
    .P_RX_DFE_RST_0                    (P_RX_DFE_RST_0               ), // input
    .P_RX_LEQ_RST_0                    (P_RX_LEQ_RST_0               ), // input 
    .P_RX_DFE_EN_0                     (P_RX_DFE_EN_0                ), // input
    .P_RX_T1_DFE_EN_0                  (P_RX_T1_DFE_EN_0             ), // input
    .P_RX_T2_DFE_EN_0                  (P_RX_T2_DFE_EN_0             ), // input
    .P_RX_T3_DFE_EN_0                  (P_RX_T3_DFE_EN_0             ), // input
    .P_RX_T4_DFE_EN_0                  (P_RX_T4_DFE_EN_0             ), // input
    .P_RX_T5_DFE_EN_0                  (P_RX_T5_DFE_EN_0             ), // input
    .P_RX_T6_DFE_EN_0                  (P_RX_T6_DFE_EN_0             ), // input
    .P_RX_T1_EN_0                      (1'b1                         ), // input
    .P_RX_CDRX_EN_0                    (1'b1                         ), // input
    .P_RX_SLIDING_EN_0                 (1'b0                         ), // input
    .P_RX_SLIDING_RST_0                (1'b0                         ), // input
    .P_RX_SLICER_DCCAL_EN_0            (1'b1                         ), // input
    .P_RX_SLICER_DCCAL_RST_0           (1'b0                         ), // input
    .P_RX_CTLE_DCCAL_EN_0              (1'b1                         ), // input
    .P_RX_CTLE_DCCAL_RST_0             (~P_LX_CDR_ALIGN_0            ), // input
    
    .P_PCS_WORD_ALIGN_EN_0             (i_p_pcs_word_align_en_0      ), // input
    .P_RX_POLARITY_INVERT_0            (i_p_rx_polarity_invert_0     ), // input 
    .P_PCS_MCB_EXT_EN_0                (i_p_pcs_mcb_ext_en_0         ), // input             
    .P_PCS_NEAREND_LOOP_0              (i_p_pcs_nearend_loop_0       ), // input             
    .P_PCS_FAREND_LOOP_0               (i_p_pcs_farend_loop_0        ), // input             
    .P_PMA_NEAREND_PLOOP_0             (i_p_pma_nearend_ploop_0      ), // input             
    .P_PMA_NEAREND_SLOOP_0             (i_p_pma_nearend_sloop_0      ), // input             
    .P_PMA_FAREND_PLOOP_0              (i_p_pma_farend_ploop_0       ), // input             
    .P_TX_BEACON_EN_0                  (i_p_tx_beacon_en_0           ), // input              
    .P_PCS_BIT_SLIP_0                  (i_p_rxpcs_slip_0             ), // input              
    .P_TX_RATE_0                       (P_TX_RATE_0                  ), // input  [1:0]   
    .P_RX_RATE_0                       (P_RX_RATE_0                  ), // input  [1:0]   
    .P_RX_SIGDET_STATUS_0              (P_RX_SIGDET_STATUS_0         ), // output         
    .P_RX_READY_0                      (P_LX_CDR_ALIGN_0             ), // output         
    .P_RX_SATA_COMINIT_0               (o_p_lx_oob_sta_0[0]          ), // output         
    .P_RX_SATA_COMWAKE_0               (o_p_lx_oob_sta_0[1]          ), // output         
    .P_TX_RXDET_REQ_0                  (i_p_lx_rxdct_en_0            ), // input       
    .P_TX_RXDET_STATUS_0               (o_p_lx_rxdct_out_0           ), // output         
    .P_PCS_LSM_SYNCED_0                (P_PCS_LSM_SYNCED_0           ), // output  
    .P_PCS_RX_MCB_STATUS_0             (P_PCS_RX_MCB_STATUS_0        ), // output   
    
    .P_TDATA_0                         (i_p_tdata_0                  ), // input  [87:0]  
    .P_PCIE_EI_H_0                     (i_p_lx_elecidle_en_0[1]      ), // input  [87:0]  
    .P_PCIE_EI_L_0                     (i_p_lx_elecidle_en_0[0]      ), // input  [87:0]  
    .P_RDATA_0                         (o_p_rdata_0                  ), // output [87:0]  
    .P_RXDVLD_0                        (P_RXDVLD_0                   ), // output 
    .P_RXDVLD_H_0                      (P_RXDVLD_H_0                 ), // output 
    
    .P_RX_SDN_0                        (i_p_l0rxn                    ),
    .P_RX_SDP_0                        (i_p_l0rxp                    ), 
    .P_TX_SDN_0                        (o_p_l0txn                    ), // output         
    .P_TX_SDP_0                        (o_p_l0txp                    ), // output         
    .P_LANE_POWERDOWN_1                (P_LANE_POWERDOWN_1           ), // input               
    .P_LANE_RST_1                      (P_LANE_RST_1                 ), // input               
    .P_TX_PMA_RST_1                    (P_TX_PMA_RST_1               ), // input               
    .P_TX_LANE_POWERDOWN_1             (P_TX_LANE_POWERDOWN_1        ), // input               
    .P_RX_LANE_POWERDOWN_1             (P_RX_LANE_POWERDOWN_1        ), // input               
    .P_TCLK2FABRIC_1                   (o_p_clk2core_tx_1            ), // output
    .P_TX_CLK_FR_CORE_1                (i_p_tx1_clk_fr_core          ), // input          
    .P_TCLK2_FR_CORE_1                 (i_p_tx1_clk2_fr_core         ), // input          
    .P_RCLK2FABRIC_1                   (o_p_clk2core_rx_1            ), // output
    .P_RXSTATUS_1                      (P_RXSTATUS_1                 ), // output
    .P_RX_CLK_FR_CORE_1                (i_p_rx1_clk_fr_core          ), // input          
    .P_RCLK2_FR_CORE_1                 (i_p_rx1_clk2_fr_core         ), // input          
    .P_RX_PMA_RST_1                    (P_RX_PMA_RST_1               ), // input          
    .P_PCS_TX_RST_1                    (P_PCS_TX_RST_1               ), // input          
    .P_PCS_RX_RST_1                    (P_PCS_RX_RST_1               ), // input          
    .P_EXT_BRIDGE_PCS_RST_1            (1'b0                         ), // input          
    .P_TX_MARGIN_1                     (i_p_lx_margin_ctl_1          ), // input  [2:0]   
    .P_TX_SWING_1                      (i_p_lx_swing_ctl_1           ), // input          
    .P_TX_DEEMP_1                      (i_p_lx_deemp_ctl_1           ), // input  [15:0]  
    .P_TX_DEEMP_POST_SEL_1             (i_p_tx_deemp_post_sel_1      ), // input  [1:0]  
    .P_BLK_ALIGN_CTRL_1                (i_p_blk_align_ctrl_1         ), // input    
    .P_TX_ENC_TYPE_1                   (1'b0                         ), // input    
    .P_RX_DEC_TYPE_1                   (1'b0                         ), // input    
    .P_PCS_PRBS_EN_1                   (1'b0                         ), // input    
    .P_RX_PRBS_ERROR_1                 (                             ), // output    
    .P_RX_EYE_RST_1                    (1'b0                         ), // input    
    .P_RX_EYE_EN_1                     (1'b0                         ), // input    
    
    .P_RX_EYE_TAP_1                    (8'b0                         ), // input     
    .P_RX_PIC_EYE_1                    (8'b0                         ), // input    
    .P_RX_PIC_FASTLOCK_1               (8'b0                         ), // input    
    .P_RX_PIC_FASTLOCK_STROBE_1        (1'b0                         ), // input    
    .P_EM_RD_TRIGGER_1                 (1'b0                         ), // input    
    .P_EM_MODE_CTRL_1                  (2'b0                         ), // input    
    .P_EM_ERROR_CNT_1                  (                             ), // output    
    .P_RX_SLIP_RST_1                   (1'b0                         ), // input    
    .P_RX_SLIP_EN_1                    (1'b1                         ), // input    
    .P_LPLL_POWERDOWN_1                (P_LPLL_POWERDOWN_1           ), // input    
    .P_LPLL_RST_1                      (P_LPLL_RST_1                 ), // input    
    .P_LPLL_READY_1                    (P_LPLL_READY_1               ), // output 
    .P_TX_LS_DATA_1                    (1'b0                         ), // input    
    .P_TX_PIC_EN_1                     (1'b0                         ), // input    
    .P_TX_BUSWIDTH_1                   (3'b0                         ), // input    
    .P_TX_FREERUN_BUSWIDTH_1           (3'b011                       ), // input    
    .P_RX_BUSWIDTH_1                   (3'b0                         ), // input    
    .P_RX_HIGHZ_1                      (i_p_rx_highz_1               ), // input 
    .P_RX_DFE_RST_1                    (P_RX_DFE_RST_1               ), // input
    .P_RX_LEQ_RST_1                    (P_RX_LEQ_RST_1               ), // input 
    .P_RX_DFE_EN_1                     (P_RX_DFE_EN_1                ), // input
    .P_RX_T1_DFE_EN_1                  (P_RX_T1_DFE_EN_1             ), // input
    .P_RX_T2_DFE_EN_1                  (P_RX_T2_DFE_EN_1             ), // input
    .P_RX_T3_DFE_EN_1                  (P_RX_T3_DFE_EN_1             ), // input
    .P_RX_T4_DFE_EN_1                  (P_RX_T4_DFE_EN_1             ), // input
    .P_RX_T5_DFE_EN_1                  (P_RX_T5_DFE_EN_1             ), // input
    .P_RX_T6_DFE_EN_1                  (P_RX_T6_DFE_EN_1             ), // input
    .P_RX_T1_EN_1                      (1'b1                         ), // input
    .P_RX_CDRX_EN_1                    (1'b1                         ), // input
    .P_RX_SLIDING_EN_1                 (1'b0                         ), // input
    .P_RX_SLIDING_RST_1                (1'b0                         ), // input
    .P_RX_SLICER_DCCAL_EN_1            (1'b1                         ), // input
    .P_RX_SLICER_DCCAL_RST_1           (1'b0                         ), // input
    .P_RX_CTLE_DCCAL_EN_1              (1'b1                         ), // input
    .P_RX_CTLE_DCCAL_RST_1             (~P_LX_CDR_ALIGN_1            ), // input
    
    .P_PCS_WORD_ALIGN_EN_1             (i_p_pcs_word_align_en_1      ), // input
    .P_RX_POLARITY_INVERT_1            (i_p_rx_polarity_invert_1     ), // input 
    .P_PCS_MCB_EXT_EN_1                (i_p_pcs_mcb_ext_en_1         ), // input             
    .P_PCS_NEAREND_LOOP_1              (i_p_pcs_nearend_loop_1       ), // input             
    .P_PCS_FAREND_LOOP_1               (i_p_pcs_farend_loop_1        ), // input             
    .P_PMA_NEAREND_PLOOP_1             (i_p_pma_nearend_ploop_1      ), // input             
    .P_PMA_NEAREND_SLOOP_1             (i_p_pma_nearend_sloop_1      ), // input             
    .P_PMA_FAREND_PLOOP_1              (i_p_pma_farend_ploop_1       ), // input             
    .P_TX_BEACON_EN_1                  (i_p_tx_beacon_en_1           ), // input              
    .P_PCS_BIT_SLIP_1                  (i_p_rxpcs_slip_1             ), // input              
    .P_TX_RATE_1                       (P_TX_RATE_1                  ), // input  [1:0]   
    .P_RX_RATE_1                       (P_RX_RATE_1                  ), // input  [1:0]   
    .P_RX_SIGDET_STATUS_1              (P_RX_SIGDET_STATUS_1         ), // output         
    .P_RX_READY_1                      (P_LX_CDR_ALIGN_1             ), // output         
    .P_RX_SATA_COMINIT_1               (o_p_lx_oob_sta_1[0]          ), // output         
    .P_RX_SATA_COMWAKE_1               (o_p_lx_oob_sta_1[1]          ), // output         
    .P_TX_RXDET_REQ_1                  (i_p_lx_rxdct_en_1            ), // input       
    .P_TX_RXDET_STATUS_1               (o_p_lx_rxdct_out_1           ), // output         
    .P_PCS_LSM_SYNCED_1                (P_PCS_LSM_SYNCED_1           ), // output  
    .P_PCS_RX_MCB_STATUS_1             (P_PCS_RX_MCB_STATUS_1        ), // output   
    
    .P_TDATA_1                         (i_p_tdata_1                  ), // input  [87:0]  
    .P_PCIE_EI_H_1                     (i_p_lx_elecidle_en_1[1]      ), // input  [87:0]  
    .P_PCIE_EI_L_1                     (i_p_lx_elecidle_en_1[0]      ), // input  [87:0]  
    .P_RDATA_1                         (o_p_rdata_1                  ), // output [87:0]  
    .P_RXDVLD_1                        (P_RXDVLD_1                   ), // output
    .P_RXDVLD_H_1                      (P_RXDVLD_H_1                 ), // output 
     
    .P_TX_SDN_1                        (o_p_l1txn                    ), // output         
    .P_TX_SDP_1                        (o_p_l1txp                    ), // output         
    .P_LANE_POWERDOWN_2                (P_LANE_POWERDOWN_2           ), // input               
    .P_LANE_RST_2                      (P_LANE_RST_2                 ), // input               
    .P_TX_PMA_RST_2                    (P_TX_PMA_RST_2               ), // input               
    .P_TX_LANE_POWERDOWN_2             (P_TX_LANE_POWERDOWN_2        ), // input               
    .P_RX_LANE_POWERDOWN_2             (P_RX_LANE_POWERDOWN_2        ), // input               
    .P_TCLK2FABRIC_2                   (o_p_clk2core_tx_2            ), // output
    .P_TX_CLK_FR_CORE_2                (i_p_tx2_clk_fr_core          ), // input          
    .P_TCLK2_FR_CORE_2                 (i_p_tx2_clk2_fr_core         ), // input          
    .P_RCLK2FABRIC_2                   (o_p_clk2core_rx_2            ), // output
    .P_RXSTATUS_2                      (P_RXSTATUS_2                 ), // output
    .P_RX_CLK_FR_CORE_2                (i_p_rx2_clk_fr_core          ), // input          
    .P_RCLK2_FR_CORE_2                 (i_p_rx2_clk2_fr_core         ), // input          
    .P_RX_PMA_RST_2                    (P_RX_PMA_RST_2               ), // input          
    .P_PCS_TX_RST_2                    (P_PCS_TX_RST_2               ), // input          
    .P_PCS_RX_RST_2                    (P_PCS_RX_RST_2               ), // input          
    .P_EXT_BRIDGE_PCS_RST_2            (1'b0                         ), // input          
    .P_TX_MARGIN_2                     (i_p_lx_margin_ctl_2          ), // input  [2:0]   
    .P_TX_SWING_2                      (i_p_lx_swing_ctl_2           ), // input          
    .P_TX_DEEMP_2                      (i_p_lx_deemp_ctl_2           ), // input  [15:0]  
    .P_TX_DEEMP_POST_SEL_2             (i_p_tx_deemp_post_sel_2      ), // input  [1:0]  
    .P_BLK_ALIGN_CTRL_2                (i_p_blk_align_ctrl_2         ), // input    
    .P_TX_ENC_TYPE_2                   (1'b0                         ), // input    
    .P_RX_DEC_TYPE_2                   (1'b0                         ), // input    
    .P_PCS_PRBS_EN_2                   (1'b0                         ), // input    
    .P_RX_PRBS_ERROR_2                 (                             ), // output    
    .P_RX_EYE_RST_2                    (1'b0                         ), // input    
    .P_RX_EYE_EN_2                     (1'b0                         ), // input    
    
    .P_RX_EYE_TAP_2                    (8'b0                         ), // input     
    .P_RX_PIC_EYE_2                    (8'b0                         ), // input    
    .P_RX_PIC_FASTLOCK_2               (8'b0                         ), // input    
    .P_RX_PIC_FASTLOCK_STROBE_2        (1'b0                         ), // input    
    .P_EM_RD_TRIGGER_2                 (1'b0                         ), // input    
    .P_EM_MODE_CTRL_2                  (2'b0                         ), // input    
    .P_EM_ERROR_CNT_2                  (                             ), // output    
    .P_RX_SLIP_RST_2                   (1'b0                         ), // input    
    .P_RX_SLIP_EN_2                    (1'b1                         ), // input    
    .P_LPLL_POWERDOWN_2                (P_LPLL_POWERDOWN_2           ), // input    
    .P_LPLL_RST_2                      (P_LPLL_RST_2                 ), // input    
    .P_LPLL_READY_2                    (P_LPLL_READY_2               ), // output 
    .P_TX_LS_DATA_2                    (1'b0                         ), // input    
    .P_TX_PIC_EN_2                     (1'b0                         ), // input    
    .P_TX_BUSWIDTH_2                   (3'b0                         ), // input    
    .P_TX_FREERUN_BUSWIDTH_2           (3'b011                       ), // input    
    .P_RX_BUSWIDTH_2                   (3'b0                         ), // input    
    .P_RX_HIGHZ_2                      (i_p_rx_highz_2               ), // input 
    .P_RX_DFE_RST_2                    (P_RX_DFE_RST_2               ), // input
    .P_RX_LEQ_RST_2                    (P_RX_LEQ_RST_2               ), // input 
    .P_RX_DFE_EN_2                     (P_RX_DFE_EN_2                ), // input
    .P_RX_T1_DFE_EN_2                  (P_RX_T1_DFE_EN_2             ), // input
    .P_RX_T2_DFE_EN_2                  (P_RX_T2_DFE_EN_2             ), // input
    .P_RX_T3_DFE_EN_2                  (P_RX_T3_DFE_EN_2             ), // input
    .P_RX_T4_DFE_EN_2                  (P_RX_T4_DFE_EN_2             ), // input
    .P_RX_T5_DFE_EN_2                  (P_RX_T5_DFE_EN_2             ), // input
    .P_RX_T6_DFE_EN_2                  (P_RX_T6_DFE_EN_2             ), // input
    .P_RX_T1_EN_2                      (1'b1                         ), // input
    .P_RX_CDRX_EN_2                    (1'b1                         ), // input
    .P_RX_SLIDING_EN_2                 (1'b0                         ), // input
    .P_RX_SLIDING_RST_2                (1'b0                         ), // input
    .P_RX_SLICER_DCCAL_EN_2            (1'b1                         ), // input
    .P_RX_SLICER_DCCAL_RST_2           (1'b0                         ), // input
    .P_RX_CTLE_DCCAL_EN_2              (1'b1                         ), // input
    .P_RX_CTLE_DCCAL_RST_2             (~P_LX_CDR_ALIGN_2            ), // input
    
    .P_PCS_WORD_ALIGN_EN_2             (i_p_pcs_word_align_en_2      ), // input
    .P_RX_POLARITY_INVERT_2            (i_p_rx_polarity_invert_2     ), // input 
    .P_PCS_MCB_EXT_EN_2                (i_p_pcs_mcb_ext_en_2         ), // input             
    .P_PCS_NEAREND_LOOP_2              (i_p_pcs_nearend_loop_2       ), // input             
    .P_PCS_FAREND_LOOP_2               (i_p_pcs_farend_loop_2        ), // input             
    .P_PMA_NEAREND_PLOOP_2             (i_p_pma_nearend_ploop_2      ), // input             
    .P_PMA_NEAREND_SLOOP_2             (i_p_pma_nearend_sloop_2      ), // input             
    .P_PMA_FAREND_PLOOP_2              (i_p_pma_farend_ploop_2       ), // input             
    .P_TX_BEACON_EN_2                  (i_p_tx_beacon_en_2           ), // input              
    .P_PCS_BIT_SLIP_2                  (i_p_rxpcs_slip_2             ), // input              
    .P_TX_RATE_2                       (P_TX_RATE_2                  ), // input  [1:0]   
    .P_RX_RATE_2                       (P_RX_RATE_2                  ), // input  [1:0]   
    .P_RX_SIGDET_STATUS_2              (P_RX_SIGDET_STATUS_2         ), // output         
    .P_RX_READY_2                      (P_LX_CDR_ALIGN_2             ), // output         
    .P_RX_SATA_COMINIT_2               (o_p_lx_oob_sta_2[0]          ), // output         
    .P_RX_SATA_COMWAKE_2               (o_p_lx_oob_sta_2[1]          ), // output         
    .P_TX_RXDET_REQ_2                  (i_p_lx_rxdct_en_2            ), // input       
    .P_TX_RXDET_STATUS_2               (o_p_lx_rxdct_out_2           ), // output         
    .P_PCS_LSM_SYNCED_2                (P_PCS_LSM_SYNCED_2           ), // output  
    .P_PCS_RX_MCB_STATUS_2             (P_PCS_RX_MCB_STATUS_2        ), // output   
    
    .P_TDATA_2                         (i_p_tdata_2                  ), // input  [87:0]  
    .P_PCIE_EI_H_2                     (i_p_lx_elecidle_en_2[1]      ), // input  [87:0]  
    .P_PCIE_EI_L_2                     (i_p_lx_elecidle_en_2[0]      ), // input  [87:0]  
    .P_RDATA_2                         (o_p_rdata_2                  ), // output [87:0]  
    .P_RXDVLD_2                        (P_RXDVLD_2                   ), // output  
    .P_RXDVLD_H_2                      (P_RXDVLD_H_2                 ), // output 
     
    .P_TX_SDN_2                        (o_p_l2txn                    ), // output         
    .P_TX_SDP_2                        (o_p_l2txp                    ), // output         
    .P_LANE_POWERDOWN_3                (P_LANE_POWERDOWN_3           ), // input               
    .P_LANE_RST_3                      (P_LANE_RST_3                 ), // input               
    .P_TX_PMA_RST_3                    (P_TX_PMA_RST_3               ), // input               
    .P_TX_LANE_POWERDOWN_3             (P_TX_LANE_POWERDOWN_3        ), // input               
    .P_RX_LANE_POWERDOWN_3             (P_RX_LANE_POWERDOWN_3        ), // input               
    .P_TCLK2FABRIC_3                   (o_p_clk2core_tx_3            ), // output
    .P_TX_CLK_FR_CORE_3                (i_p_tx3_clk_fr_core          ), // input          
    .P_TCLK2_FR_CORE_3                 (i_p_tx3_clk2_fr_core         ), // input          
    .P_RCLK2FABRIC_3                   (o_p_clk2core_rx_3            ), // output
    .P_RXSTATUS_3                      (P_RXSTATUS_3                 ), // output
    .P_RX_CLK_FR_CORE_3                (i_p_rx3_clk_fr_core          ), // input          
    .P_RCLK2_FR_CORE_3                 (i_p_rx3_clk2_fr_core         ), // input          
    .P_RX_PMA_RST_3                    (P_RX_PMA_RST_3               ), // input          
    .P_PCS_TX_RST_3                    (P_PCS_TX_RST_3               ), // input          
    .P_PCS_RX_RST_3                    (P_PCS_RX_RST_3               ), // input          
    .P_EXT_BRIDGE_PCS_RST_3            (1'b0                         ), // input          
    .P_TX_MARGIN_3                     (i_p_lx_margin_ctl_3          ), // input  [2:0]   
    .P_TX_SWING_3                      (i_p_lx_swing_ctl_3           ), // input          
    .P_TX_DEEMP_3                      (i_p_lx_deemp_ctl_3           ), // input  [15:0]  
    .P_TX_DEEMP_POST_SEL_3             (i_p_tx_deemp_post_sel_3      ), // input  [1:0]  
    .P_BLK_ALIGN_CTRL_3                (i_p_blk_align_ctrl_3         ), // input    
    .P_TX_ENC_TYPE_3                   (1'b0                         ), // input    
    .P_RX_DEC_TYPE_3                   (1'b0                         ), // input    
    .P_PCS_PRBS_EN_3                   (1'b0                         ), // input    
    .P_RX_PRBS_ERROR_3                 (                             ), // output    
    .P_RX_EYE_RST_3                    (1'b0                         ), // input    
    .P_RX_EYE_EN_3                     (1'b0                         ), // input    
    
    .P_RX_EYE_TAP_3                    (8'b0                         ), // input     
    .P_RX_PIC_EYE_3                    (8'b0                         ), // input    
    .P_RX_PIC_FASTLOCK_3               (8'b0                         ), // input    
    .P_RX_PIC_FASTLOCK_STROBE_3        (1'b0                         ), // input    
    .P_EM_RD_TRIGGER_3                 (1'b0                         ), // input    
    .P_EM_MODE_CTRL_3                  (2'b0                         ), // input    
    .P_EM_ERROR_CNT_3                  (                             ), // output    
    .P_RX_SLIP_RST_3                   (1'b0                         ), // input    
    .P_RX_SLIP_EN_3                    (1'b1                         ), // input    
    .P_LPLL_POWERDOWN_3                (P_LPLL_POWERDOWN_3           ), // input    
    .P_LPLL_RST_3                      (P_LPLL_RST_3                 ), // input    
    .P_LPLL_READY_3                    (P_LPLL_READY_3               ), // output 
    .P_TX_LS_DATA_3                    (1'b0                         ), // input    
    .P_TX_PIC_EN_3                     (1'b0                         ), // input    
    .P_TX_BUSWIDTH_3                   (3'b0                         ), // input    
    .P_TX_FREERUN_BUSWIDTH_3           (3'b011                       ), // input    
    .P_RX_BUSWIDTH_3                   (3'b0                         ), // input    
    .P_RX_HIGHZ_3                      (i_p_rx_highz_3               ), // input 
    .P_RX_DFE_RST_3                    (P_RX_DFE_RST_3               ), // input
    .P_RX_LEQ_RST_3                    (P_RX_LEQ_RST_3               ), // input 
    .P_RX_DFE_EN_3                     (P_RX_DFE_EN_3                ), // input
    .P_RX_T1_DFE_EN_3                  (P_RX_T1_DFE_EN_3             ), // input
    .P_RX_T2_DFE_EN_3                  (P_RX_T2_DFE_EN_3             ), // input
    .P_RX_T3_DFE_EN_3                  (P_RX_T3_DFE_EN_3             ), // input
    .P_RX_T4_DFE_EN_3                  (P_RX_T4_DFE_EN_3             ), // input
    .P_RX_T5_DFE_EN_3                  (P_RX_T5_DFE_EN_3             ), // input
    .P_RX_T6_DFE_EN_3                  (P_RX_T6_DFE_EN_3             ), // input
    .P_RX_T1_EN_3                      (1'b1                         ), // input
    .P_RX_CDRX_EN_3                    (1'b1                         ), // input
    .P_RX_SLIDING_EN_3                 (1'b0                         ), // input
    .P_RX_SLIDING_RST_3                (1'b0                         ), // input
    .P_RX_SLICER_DCCAL_EN_3            (1'b1                         ), // input
    .P_RX_SLICER_DCCAL_RST_3           (1'b0                         ), // input
    .P_RX_CTLE_DCCAL_EN_3              (1'b1                         ), // input
    .P_RX_CTLE_DCCAL_RST_3             (~P_LX_CDR_ALIGN_3            ), // input
    
    .P_PCS_WORD_ALIGN_EN_3             (i_p_pcs_word_align_en_3      ), // input
    .P_RX_POLARITY_INVERT_3            (i_p_rx_polarity_invert_3     ), // input 
    .P_PCS_MCB_EXT_EN_3                (i_p_pcs_mcb_ext_en_3         ), // input             
    .P_PCS_NEAREND_LOOP_3              (i_p_pcs_nearend_loop_3       ), // input             
    .P_PCS_FAREND_LOOP_3               (i_p_pcs_farend_loop_3        ), // input             
    .P_PMA_NEAREND_PLOOP_3             (i_p_pma_nearend_ploop_3      ), // input             
    .P_PMA_NEAREND_SLOOP_3             (i_p_pma_nearend_sloop_3      ), // input             
    .P_PMA_FAREND_PLOOP_3              (i_p_pma_farend_ploop_3       ), // input             
    .P_TX_BEACON_EN_3                  (i_p_tx_beacon_en_3           ), // input              
    .P_PCS_BIT_SLIP_3                  (i_p_rxpcs_slip_3             ), // input              
    .P_TX_RATE_3                       (P_TX_RATE_3                  ), // input  [1:0]   
    .P_RX_RATE_3                       (P_RX_RATE_3                  ), // input  [1:0]   
    .P_RX_SIGDET_STATUS_3              (P_RX_SIGDET_STATUS_3         ), // output         
    .P_RX_READY_3                      (P_LX_CDR_ALIGN_3             ), // output         
    .P_RX_SATA_COMINIT_3               (o_p_lx_oob_sta_3[0]          ), // output         
    .P_RX_SATA_COMWAKE_3               (o_p_lx_oob_sta_3[1]          ), // output         
    .P_TX_RXDET_REQ_3                  (i_p_lx_rxdct_en_3            ), // input         
    .P_TX_RXDET_STATUS_3               (o_p_lx_rxdct_out_3           ), // output
    .P_PCS_LSM_SYNCED_3                (P_PCS_LSM_SYNCED_3           ), // output  
    .P_PCS_RX_MCB_STATUS_3             (P_PCS_RX_MCB_STATUS_3        ), // output   
    
    .P_TDATA_3                         (i_p_tdata_3                  ), // input  [87:0]  
    .P_PCIE_EI_H_3                     (i_p_lx_elecidle_en_3[1]      ), // input  [87:0]  
    .P_PCIE_EI_L_3                     (i_p_lx_elecidle_en_3[0]      ), // input  [87:0]  
    .P_RDATA_3                         (o_p_rdata_3                  ), // output [87:0]  
    .P_RXDVLD_3                        (P_RXDVLD_3                   ), // output
    .P_RXDVLD_H_3                      (P_RXDVLD_H_3                 ), // output 
     
    .P_TX_SDN_3                        (o_p_l3txn                    ), // output         
    .P_TX_SDP_3                        (o_p_l3txp                    )  // output         
);

endmodule    
