
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

module Transceiver_10G_top (
);


// ********************* UI parameters *********************
localparam CH0_EN = "Fullduplex";
localparam CH1_EN = "DISABLE";
localparam CH2_EN = "DISABLE";
localparam CH3_EN = "DISABLE";
localparam CH0_PROTOCOL = "CUSTOMERIZEDx1";
localparam CH1_PROTOCOL = "CUSTOMERIZEDx1";
localparam CH2_PROTOCOL = "CUSTOMERIZEDx1";
localparam CH3_PROTOCOL = "CUSTOMERIZEDx1";
localparam CH0_PROTOCOL_DEFAULT = "FALSE";
localparam CH1_PROTOCOL_DEFAULT = "FALSE";
localparam CH2_PROTOCOL_DEFAULT = "FALSE";
localparam CH3_PROTOCOL_DEFAULT = "FALSE";
localparam CH0_TX_RATE = 10.3125;
localparam CH1_TX_RATE = 0.0;
localparam CH2_TX_RATE = 0.0;
localparam CH3_TX_RATE = 0.0;
localparam CH0_RX_RATE = 10.3125;
localparam CH1_RX_RATE = 0.0;
localparam CH2_RX_RATE = 0.0;
localparam CH3_RX_RATE = 0.0;
localparam CH0_TX_ENCODER = "64B66B_transparent";
localparam CH1_TX_ENCODER = "Bypassed";
localparam CH2_TX_ENCODER = "Bypassed";
localparam CH3_TX_ENCODER = "Bypassed";
localparam CH0_RX_DECODER = "64B66B_transparent";
localparam CH1_RX_DECODER = "Bypassed";
localparam CH2_RX_DECODER = "Bypassed";
localparam CH3_RX_DECODER = "Bypassed";
localparam CH0_TDATA_WIDTH = 64;
localparam CH1_TDATA_WIDTH = 20;
localparam CH2_TDATA_WIDTH = 20;
localparam CH3_TDATA_WIDTH = 20;
localparam CH0_RDATA_WIDTH = 64;
localparam CH1_RDATA_WIDTH = 20;
localparam CH2_RDATA_WIDTH = 20;
localparam CH3_RDATA_WIDTH = 20;
localparam CH0_TX_FABRIC_FEQ = 161.1328125;
localparam CH1_TX_FABRIC_FEQ = 0.0;
localparam CH2_TX_FABRIC_FEQ = 0.0;
localparam CH3_TX_FABRIC_FEQ = 0.0;
localparam CH0_RX_FABRIC_FEQ = 161.1328125;
localparam CH1_RX_FABRIC_FEQ = 0.0;
localparam CH2_RX_FABRIC_FEQ = 0.0;
localparam CH3_RX_FABRIC_FEQ = 0.0;
localparam CH0_TX_PLL_SEL = "HPLL";
localparam CH1_TX_PLL_SEL = "HPLL";
localparam CH2_TX_PLL_SEL = "HPLL";
localparam CH3_TX_PLL_SEL = "HPLL";
localparam CH0_RX_PLL_SEL = "HPLL";
localparam CH1_RX_PLL_SEL = "HPLL";
localparam CH2_RX_PLL_SEL = "HPLL";
localparam CH3_RX_PLL_SEL = "HPLL";
localparam HPLL_EN = "TRUE";
localparam HPLL_REF_SEL = "Diff_REFCK0";
localparam HPLL_FRQ_INDEX = 6;
localparam HPLL_REF_FRQ = 156.25;
localparam LPLL0_EN = "FALSE";
localparam LPLL1_EN = "FALSE";
localparam LPLL2_EN = "FALSE";
localparam LPLL3_EN = "FALSE";
localparam LPLL0_REF_SEL = "Diff_REFCK0";
localparam LPLL1_REF_SEL = "Diff_REFCK0";
localparam LPLL2_REF_SEL = "Diff_REFCK0";
localparam LPLL3_REF_SEL = "Diff_REFCK0";
localparam LPLL0_REF_FRQ = 330.0;
localparam LPLL1_REF_FRQ = 330.0;
localparam LPLL2_REF_FRQ = 330.0;
localparam LPLL3_REF_FRQ = 330.0;
localparam CH0_RXPCS_ALIGN = "Bypassed";
localparam CH1_RXPCS_ALIGN = "Bypassed";
localparam CH2_RXPCS_ALIGN = "Bypassed";
localparam CH3_RXPCS_ALIGN = "Bypassed";
localparam CH0_RXPCS_COMMA_SEL = "K28.5";
localparam CH1_RXPCS_COMMA_SEL = "K28.5";
localparam CH2_RXPCS_COMMA_SEL = "K28.5";
localparam CH3_RXPCS_COMMA_SEL = "K28.5";
localparam CH0_RXPCS_BONDING = "Bypassed";
localparam CH1_RXPCS_BONDING = "Bypassed";
localparam CH2_RXPCS_BONDING = "Bypassed";
localparam CH3_RXPCS_BONDING = "Bypassed";
localparam CH0_RXPCS_CTC = "Bypassed";
localparam CH1_RXPCS_CTC = "Bypassed";
localparam CH2_RXPCS_CTC = "Bypassed";
localparam CH3_RXPCS_CTC = "Bypassed";
localparam [9:0] CH0_RXPCS_COMMA_REG0 = 10'b0;
localparam [9:0] CH1_RXPCS_COMMA_REG0 = 10'b0;
localparam [9:0] CH2_RXPCS_COMMA_REG0 = 10'b0;
localparam [9:0] CH3_RXPCS_COMMA_REG0 = 10'b0;
localparam [9:0] CH0_RXPCS_COMMA_MASK = 10'b0;
localparam [9:0] CH1_RXPCS_COMMA_MASK = 10'b0;
localparam [9:0] CH2_RXPCS_COMMA_MASK = 10'b0;
localparam [9:0] CH3_RXPCS_COMMA_MASK = 10'b0;
localparam [9:0] CH0_RXPCS_SKIP_REG0 = 10'b00;
localparam [9:0] CH1_RXPCS_SKIP_REG0 = 10'b00;
localparam [9:0] CH2_RXPCS_SKIP_REG0 = 10'b00;
localparam [9:0] CH3_RXPCS_SKIP_REG0 = 10'b00;
localparam [9:0] CH0_RXPCS_SKIP_REG1 = 10'b00;
localparam [9:0] CH1_RXPCS_SKIP_REG1 = 10'b00;
localparam [9:0] CH2_RXPCS_SKIP_REG1 = 10'b00;
localparam [9:0] CH3_RXPCS_SKIP_REG1 = 10'b00;
localparam [9:0] CH0_RXPCS_SKIP_REG2 = 10'b00;
localparam [9:0] CH1_RXPCS_SKIP_REG2 = 10'b00;
localparam [9:0] CH2_RXPCS_SKIP_REG2 = 10'b00;
localparam [9:0] CH3_RXPCS_SKIP_REG2 = 10'b00;
localparam [9:0] CH0_RXPCS_SKIP_REG3 = 10'b00;
localparam [9:0] CH1_RXPCS_SKIP_REG3 = 10'b00;
localparam [9:0] CH2_RXPCS_SKIP_REG3 = 10'b00;
localparam [9:0] CH3_RXPCS_SKIP_REG3 = 10'b00;
localparam [7:0] CH0_RXPCS_A_REG = 8'b01111100;
localparam [7:0] CH1_RXPCS_A_REG = 8'b01111100;
localparam [7:0] CH2_RXPCS_A_REG = 8'b01111100;
localparam [7:0] CH3_RXPCS_A_REG = 8'b01111100;
localparam INNER_RST_EN = "TRUE";
localparam FREE_FRQ = 50.0;
localparam CH0_RXPCS_BONDING_RANGE = "80BIT";
localparam CH1_RXPCS_BONDING_RANGE = "80BIT";
localparam CH2_RXPCS_BONDING_RANGE = "80BIT";
localparam CH3_RXPCS_BONDING_RANGE = "80BIT";
localparam CH0_RXPMA_RTERM = 6;
localparam CH1_RXPMA_RTERM = 6;
localparam CH2_RXPMA_RTERM = 6;
localparam CH3_RXPMA_RTERM = 6;
localparam P_LX_TX_CKDIV_0 = 3;
localparam P_LX_TX_CKDIV_1 = 0;
localparam P_LX_TX_CKDIV_2 = 0;
localparam P_LX_TX_CKDIV_3 = 0;
localparam LX_RX_CKDIV_0 = 3;
localparam LX_RX_CKDIV_1 = 0;
localparam LX_RX_CKDIV_2 = 0;
localparam LX_RX_CKDIV_3 = 0;
localparam O_P_REFCK2CORE_0 = "TRUE";
localparam O_P_REFCK2CORE_1 = "FALSE";

// ********************* Clock and Reset *********************

reg rst;
initial
begin
 rst = 1;
    #10
 rst = 1;
    #20
 rst = 0;
end

reg src_rst;
initial
begin
    src_rst = 0;
    #10
    src_rst = 1;
    #30000
    src_rst = 0;
end

reg chk_rst;
initial
begin
    chk_rst = 0;
    #10
    chk_rst = 1;
    #60000
    chk_rst = 0;
end

reg clk_pll0;
initial
begin
clk_pll0 = 0;
if (HPLL_EN == "TRUE" && (HPLL_REF_SEL == "Diff_REFCK0" || HPLL_REF_SEL == "Diff_REFCK0_FR_LOWER" || HPLL_REF_SEL == "Diff_REFCK0_FR_UPPER"))
    forever #(500.0/HPLL_REF_FRQ) clk_pll0 = ~clk_pll0;
else if(LPLL0_EN == "TRUE" && (LPLL0_REF_SEL == "Diff_REFCK0" || LPLL0_REF_SEL == "Diff_REFCK0_FR_LOWER" || LPLL0_REF_SEL == "Diff_REFCK0_FR_UPPER"))
    forever #(500.0/LPLL0_REF_FRQ) clk_pll0 = ~clk_pll0;
else if(LPLL1_EN == "TRUE" && (LPLL1_REF_SEL == "Diff_REFCK0" || LPLL1_REF_SEL == "Diff_REFCK0_FR_LOWER" || LPLL1_REF_SEL == "Diff_REFCK0_FR_UPPER"))
    forever #(500.0/LPLL1_REF_FRQ) clk_pll0 = ~clk_pll0;
else if(LPLL2_EN == "TRUE" && (LPLL2_REF_SEL == "Diff_REFCK0" || LPLL2_REF_SEL == "Diff_REFCK0_FR_LOWER" || LPLL2_REF_SEL == "Diff_REFCK0_FR_UPPER"))
    forever #(500.0/LPLL2_REF_FRQ) clk_pll0 = ~clk_pll0;
else
    forever #(500.0/LPLL3_REF_FRQ) clk_pll0 = ~clk_pll0;
end

reg clk_pll1;
initial
begin
clk_pll1 = 0;
if (HPLL_EN == "TRUE" && (HPLL_REF_SEL == "Diff_REFCK1" || HPLL_REF_SEL == "Diff_REFCK1_FR_LOWER" || HPLL_REF_SEL == "Diff_REFCK1_FR_UPPER"))
    forever #(500.0/HPLL_REF_FRQ) clk_pll1 = ~clk_pll1;
else if(LPLL0_EN == "TRUE" && (LPLL0_REF_SEL == "Diff_REFCK1" || LPLL0_REF_SEL == "Diff_REFCK1_FR_LOWER" || LPLL0_REF_SEL == "Diff_REFCK1_FR_UPPER"))
    forever #(500.0/LPLL0_REF_FRQ) clk_pll1 = ~clk_pll1;
else if(LPLL1_EN == "TRUE" && (LPLL1_REF_SEL == "Diff_REFCK1" || LPLL1_REF_SEL == "Diff_REFCK1_FR_LOWER" || LPLL1_REF_SEL == "Diff_REFCK1_FR_UPPER"))
    forever #(500.0/LPLL1_REF_FRQ) clk_pll1 = ~clk_pll1;
else if(LPLL2_EN == "TRUE" && (LPLL2_REF_SEL == "Diff_REFCK1" || LPLL2_REF_SEL == "Diff_REFCK1_FR_LOWER" || LPLL2_REF_SEL == "Diff_REFCK1_FR_UPPER"))
    forever #(500.0/LPLL2_REF_FRQ) clk_pll1 = ~clk_pll1;
else
    forever #(500.0/LPLL3_REF_FRQ) clk_pll1 = ~clk_pll1;
end

reg clk_fabric;
initial
begin
    clk_fabric = 0;
if (HPLL_EN == "TRUE" && HPLL_REF_SEL == "Fabric_REFCK")
    forever #(500.0/HPLL_REF_FRQ) clk_fabric = ~clk_fabric;
else if (LPLL0_EN == "TRUE" && LPLL0_REF_SEL == "Fabric_REFCK")
    forever #(500.0/LPLL0_REF_FRQ) clk_fabric = ~clk_fabric;
else if (LPLL1_EN == "TRUE" && LPLL1_REF_SEL == "Fabric_REFCK")
    forever #(500.0/LPLL1_REF_FRQ) clk_fabric = ~clk_fabric;
else if (LPLL2_EN == "TRUE" && LPLL2_REF_SEL == "Fabric_REFCK")
    forever #(500.0/LPLL2_REF_FRQ) clk_fabric = ~clk_fabric;
else
    forever #(500.0/LPLL3_REF_FRQ) clk_fabric = ~clk_fabric;
end

reg free_clk;
initial
begin
    free_clk = 0;
    forever #(500.0/FREE_FRQ) free_clk = ~free_clk;
end

// ********************* DUT *********************


wire           i_free_clk                    = free_clk;          
wire           i_hpll_rst                    = rst;          
wire           i_lpll_rst_0                  = rst;          
wire           i_lpll_rst_1                  = rst;          
wire           i_lpll_rst_2                  = rst;          
wire           i_lpll_rst_3                  = rst;          
wire           i_hpll_wtchdg_clr             = 1'b0;          
wire           i_txlane_rst_0                = 1'b0;          
wire           i_txlane_rst_1                = 1'b0;          
wire           i_txlane_rst_2                = 1'b0;          
wire           i_txlane_rst_3                = 1'b0;          
wire           i_tx_pma_rst_0                = 1'b0;          
wire           i_tx_pma_rst_1                = 1'b0;          
wire           i_tx_pma_rst_2                = 1'b0;          
wire           i_tx_pma_rst_3                = 1'b0;          
wire           i_tx_pcs_rst_0                = 1'b0;          
wire           i_tx_pcs_rst_1                = 1'b0;          
wire           i_tx_pcs_rst_2                = 1'b0;          
wire           i_tx_pcs_rst_3                = 1'b0;          
wire           i_rxlane_rst_0                = 1'b0;          
wire           i_rxlane_rst_1                = 1'b0;          
wire           i_rxlane_rst_2                = 1'b0;          
wire           i_rxlane_rst_3                = 1'b0;          
wire           i_rx_pma_rst_0                = 1'b0;          
wire           i_rx_pma_rst_1                = 1'b0;          
wire           i_rx_pma_rst_2                = 1'b0;          
wire           i_rx_pma_rst_3                = 1'b0;          
wire           i_rx_pcs_rst_0                = 1'b0;          
wire           i_rx_pcs_rst_1                = 1'b0;          
wire           i_rx_pcs_rst_2                = 1'b0;          
wire           i_rx_pcs_rst_3                = 1'b0;          
wire           i_tx_rate_chng_0              = 1'b0;          
wire           i_tx_rate_chng_1              = 1'b0;          
wire           i_tx_rate_chng_2              = 1'b0;          
wire           i_tx_rate_chng_3              = 1'b0;          
wire   [1:0]   i_txckdiv_0                   = P_LX_TX_CKDIV_0;         
wire   [1:0]   i_txckdiv_1                   = P_LX_TX_CKDIV_1;         
wire   [1:0]   i_txckdiv_2                   = P_LX_TX_CKDIV_2;         
wire   [1:0]   i_txckdiv_3                   = P_LX_TX_CKDIV_3;         
wire           i_rx_rate_chng_0              = 1'b0;          
wire           i_rx_rate_chng_1              = 1'b0;          
wire           i_rx_rate_chng_2              = 1'b0;          
wire           i_rx_rate_chng_3              = 1'b0;          
wire   [1:0]   i_rxckdiv_0                   = LX_RX_CKDIV_0;         
wire   [1:0]   i_rxckdiv_1                   = LX_RX_CKDIV_1;         
wire   [1:0]   i_rxckdiv_2                   = LX_RX_CKDIV_2;         
wire   [1:0]   i_rxckdiv_3                   = LX_RX_CKDIV_3;         
wire           i_hsst_fifo_clr_0             = 1'b0;         
wire   [2:0]   i_loop_dbg_0                  = 3'b000;
wire           i_hsst_fifo_clr_1             = 1'b0;         
wire   [2:0]   i_loop_dbg_1                  = 3'b000;
wire           i_hsst_fifo_clr_2             = 1'b0;         
wire   [2:0]   i_loop_dbg_2                  = 3'b000;
wire           i_hsst_fifo_clr_3             = 1'b0;         
wire   [2:0]   i_loop_dbg_3                  = 3'b000;
wire   [1:0]   o_hpll_wtchdg_st              ;          
wire           o_hpll_done                   ;          
wire           o_lpll_done_0                 ;          
wire           o_lpll_done_1                 ;          
wire           o_lpll_done_2                 ;          
wire           o_lpll_done_3                 ;          
wire           o_txlane_done_0               ;          
wire           o_txlane_done_1               ;          
wire           o_txlane_done_2               ;          
wire           o_txlane_done_3               ;          
wire           o_tx_ckdiv_done_0             ;          
wire           o_tx_ckdiv_done_1             ;          
wire           o_tx_ckdiv_done_2             ;          
wire           o_tx_ckdiv_done_3             ;          
wire           o_rxlane_done_0               ;          
wire           o_rxlane_done_1               ;          
wire           o_rxlane_done_2               ;          
wire           o_rxlane_done_3               ;          
wire           o_rx_ckdiv_done_0             ;          
wire           o_rx_ckdiv_done_1             ;          
wire           o_rx_ckdiv_done_2             ;          
wire           o_rx_ckdiv_done_3             ;          
wire           i_p_hpllpowerdown             = 1'b0; // input           
wire           i_p_tx_lane_pd_clkpath_0      = 1'b0; // input           
wire           i_p_tx_lane_pd_clkpath_1      = 1'b0; // input           
wire           i_p_tx_lane_pd_clkpath_2      = 1'b0; // input           
wire           i_p_tx_lane_pd_clkpath_3      = 1'b0; // input           
wire           i_p_tx_lane_pd_piso_0         = 1'b0; // input           
wire           i_p_tx_lane_pd_piso_1         = 1'b0; // input           
wire           i_p_tx_lane_pd_piso_2         = 1'b0; // input           
wire           i_p_tx_lane_pd_piso_3         = 1'b0; // input           
wire           i_p_tx_lane_pd_driver_0       = 1'b0; // input           
wire           i_p_tx_lane_pd_driver_1       = 1'b0; // input           
wire           i_p_tx_lane_pd_driver_2       = 1'b0; // input           
wire           i_p_tx_lane_pd_driver_3       = 1'b0; // input           
wire           i_p_lane_pd_0                 = 1'b0; // input           
wire           i_p_lane_pd_1                 = 1'b0; // input           
wire           i_p_lane_pd_2                 = 1'b0; // input           
wire           i_p_lane_pd_3                 = 1'b0; // input           
wire           i_p_lane_rst_0                = 1'b0; // input           
wire           i_p_lane_rst_1                = 1'b0; // input           
wire           i_p_lane_rst_2                = 1'b0; // input           
wire           i_p_lane_rst_3                = 1'b0; // input           
wire           i_p_rx_lane_pd_0              = 1'b0; // input           
wire           i_p_rx_lane_pd_1              = 1'b0; // input           
wire           i_p_rx_lane_pd_2              = 1'b0; // input           
wire           i_p_rx_lane_pd_3              = 1'b0; // input           
wire           i_p_refckn_0                  = clk_pll0; 
wire           i_p_refckp_0                  = ~clk_pll0; 
wire           i_p_refckn_1                  = clk_pll1; 
wire           i_p_refckp_1                  = ~clk_pll1; 
wire           i_p_pll_ref_clk_0             = clk_fabric; 
wire           o_p_refck2core_0              ; 
wire           o_p_refck2core_1              ; 
wire           i_p_hpll_rst                  = rst; 
wire           i_p_tx_pma_rst_0              = rst; 
wire           i_p_tx_pma_rst_1              = rst; 
wire           i_p_tx_pma_rst_2              = rst; 
wire           i_p_tx_pma_rst_3              = rst; 
wire           i_p_pcs_tx_rst_0              = rst; 
wire           i_p_pcs_tx_rst_1              = rst; 
wire           i_p_pcs_tx_rst_2              = rst; 
wire           i_p_pcs_tx_rst_3              = rst; 
wire           i_p_rx_pll_rst_0              = rst; 
wire           i_p_rx_pll_rst_1              = rst; 
wire           i_p_rx_pll_rst_2              = rst; 
wire           i_p_rx_pll_rst_3              = rst; 
wire           i_p_rx_pma_rst_0              = rst; 
wire           i_p_rx_pma_rst_1              = rst; 
wire           i_p_rx_pma_rst_2              = rst; 
wire           i_p_rx_pma_rst_3              = rst; 
wire           i_p_pcs_rx_rst_0              = rst; 
wire           i_p_pcs_rx_rst_1              = rst; 
wire           i_p_pcs_rx_rst_2              = rst; 
wire           i_p_pcs_rx_rst_3              = rst; 
wire   [2:0]   i_p_lx_margin_ctl_0           = 3'b0; 
wire   [2:0]   i_p_lx_margin_ctl_1           = 3'b0; 
wire   [2:0]   i_p_lx_margin_ctl_2           = 3'b0; 
wire   [2:0]   i_p_lx_margin_ctl_3           = 3'b0; 
wire           i_p_lx_swing_ctl_0            = 1'b0; 
wire           i_p_lx_swing_ctl_1            = 1'b0; 
wire           i_p_lx_swing_ctl_2            = 1'b0; 
wire           i_p_lx_swing_ctl_3            = 1'b0; 
wire   [15:0]  i_p_lx_deemp_ctl_0            = 16'b0; 
wire   [15:0]  i_p_lx_deemp_ctl_1            = 16'b0; 
wire   [15:0]  i_p_lx_deemp_ctl_2            = 16'b0; 
wire   [15:0]  i_p_lx_deemp_ctl_3            = 16'b0; 
wire   [1:0]   i_p_tx_ckdiv_0                = P_LX_TX_CKDIV_0; 
wire   [1:0]   i_p_tx_ckdiv_1                = P_LX_TX_CKDIV_1; 
wire   [1:0]   i_p_tx_ckdiv_2                = P_LX_TX_CKDIV_2; 
wire   [1:0]   i_p_tx_ckdiv_3                = P_LX_TX_CKDIV_3; 
wire   [1:0]   i_p_lx_rx_ckdiv_0             = LX_RX_CKDIV_0; 
wire   [1:0]   i_p_lx_rx_ckdiv_1             = LX_RX_CKDIV_1; 
wire   [1:0]   i_p_lx_rx_ckdiv_2             = LX_RX_CKDIV_2; 
wire   [1:0]   i_p_lx_rx_ckdiv_3             = LX_RX_CKDIV_3; 
wire   [1:0]   i_p_lx_elecidle_en_0          = 2'b0; 
wire   [1:0]   i_p_lx_elecidle_en_1          = 2'b0; 
wire   [1:0]   i_p_lx_elecidle_en_2          = 2'b0; 
wire   [1:0]   i_p_lx_elecidle_en_3          = 2'b0; 
wire           o_p_hpll_lock                 ; 
wire           o_p_lpll_lock_0               ; 
wire           o_p_lpll_lock_1               ; 
wire           o_p_lpll_lock_2               ; 
wire           o_p_lpll_lock_3               ; 
wire           o_p_rx_sigdet_sta_0           ; 
wire           o_p_rx_sigdet_sta_1           ; 
wire           o_p_rx_sigdet_sta_2           ; 
wire           o_p_rx_sigdet_sta_3           ; 
wire           o_p_lx_cdr_align_0            ; 
wire           o_p_lx_cdr_align_1            ; 
wire           o_p_lx_cdr_align_2            ; 
wire           o_p_lx_cdr_align_3            ; 
wire   [1:0]   o_p_lx_oob_sta_0              ; 
wire   [1:0]   o_p_lx_oob_sta_1              ; 
wire   [1:0]   o_p_lx_oob_sta_2              ; 
wire   [1:0]   o_p_lx_oob_sta_3              ; 
wire           i_p_lx_rxdct_en_0             = 1'b0; 
wire           i_p_lx_rxdct_en_1             = 1'b0; 
wire           i_p_lx_rxdct_en_2             = 1'b0; 
wire           i_p_lx_rxdct_en_3             = 1'b0; 
wire           o_p_lx_rxdct_out_0            = 1'b0; 
wire           o_p_lx_rxdct_out_1            = 1'b0; 
wire           o_p_lx_rxdct_out_2            = 1'b0; 
wire           o_p_lx_rxdct_out_3            ; 
wire           o_p_lx_rxdct_done_0           ; 
wire           o_p_lx_rxdct_done_1           ; 
wire           o_p_lx_rxdct_done_2           ; 
wire           o_p_lx_rxdct_done_3           ; 
wire           o_p_pcs_lsm_synced_0          ; 
wire           o_p_pcs_lsm_synced_1          ; 
wire           o_p_pcs_lsm_synced_2          ; 
wire           o_p_pcs_lsm_synced_3          ; 
wire           o_p_pcs_rx_mcb_status_0       ; 
wire           o_p_pcs_rx_mcb_status_1       ; 
wire           o_p_pcs_rx_mcb_status_2       ; 
wire           o_p_pcs_rx_mcb_status_3       ; 
wire           i_p_cfg_rst                   = rst; 
wire           i_p_l0rxn                     ; 
wire           i_p_l0rxp                     ; 
wire           i_p_l1rxn                     ; 
wire           i_p_l1rxp                     ; 
wire           i_p_l2rxn                     ; 
wire           i_p_l2rxp                     ; 
wire           i_p_l3rxn                     ; 
wire           i_p_l3rxp                     ; 
wire           o_p_l0txn                     ; 
wire           o_p_l0txp                     ; 
wire           o_p_l1txn                     ; 
wire           o_p_l1txp                     ; 
wire           o_p_l2txn                     ; 
wire           o_p_l2txp                     ; 
wire           o_p_l3txn                     ; 
wire           o_p_l3txp                     ; 
wire   [3:0]   o_pl_err                      ;

Transceiver_10G_dut_top  U_DUT_TOP (
    
    .i_free_clk                    (i_free_clk                    ), // input                                                                           
    .i_hpll_rst                    (i_hpll_rst                    ), // input                                                                    
    .i_hpll_wtchdg_clr             (i_hpll_wtchdg_clr             ), // input                                                                   
    .i_hsst_fifo_clr_0             (i_hsst_fifo_clr_0             ), // input                           
    .i_loop_dbg_0                  (i_loop_dbg_0                  ), // input                                                                              
    .o_hpll_wtchdg_st              (o_hpll_wtchdg_st              ), // output [1:0]                                                                       
    .o_hpll_done                   (o_hpll_done                   ), // output                                                                     
    .o_txlane_done_0               (o_txlane_done_0               ), // output                                                                     
    .o_rxlane_done_0               (o_rxlane_done_0               ), // output                                                                      
    .i_p_refckn_0                  (i_p_refckn_0                  ), // input                                                                       
    .i_p_refckp_0                  (i_p_refckp_0                  ), // input                                                                     
    .o_p_refck2core_0              (o_p_refck2core_0              ), // output                                                                       
    .o_p_hpll_lock                 (o_p_hpll_lock                 ), // output                                                                 
    .o_p_rx_sigdet_sta_0           (o_p_rx_sigdet_sta_0           ), // output                                                                  
    .o_p_lx_cdr_align_0            (o_p_lx_cdr_align_0            ), // output                                                                            
    .i_p_cfg_clk                   (i_free_clk                    ), // input                                                                             
    .i_p_cfg_rst                   (i_p_cfg_rst                   ), // input                                                                             
    .i_p_cfg_psel                  (1'b0                          ), // input                                                                             
    .i_p_cfg_enable                (1'b0                          ), // input                                                                             
    .i_p_cfg_write                 (1'b0                          ), // input                                                                             
    .i_p_cfg_addr                  (16'b0                         ), // input  [15:0]                                                                     
    .i_p_cfg_wdata                 (8'b0                          ), // input  [7:0]                                                                      
    .o_p_cfg_rdata                 (                              ), // output [7:0]                                                                      
    .o_p_cfg_int                   (                              ), // output                                                                            
    .o_p_cfg_ready                 (                              ), // output                                                                        
    .i_p_l0rxn                     (i_p_l0rxn                     ), // input                                                                         
    .i_p_l0rxp                     (i_p_l0rxp                     ), // input                                                                         
    .o_p_l0txn                     (o_p_l0txn                     ), // output                                                                        
    .o_p_l0txp                     (o_p_l0txp                     ), // output                                                                        
    .o_rxstatus_0                  (                              ), // output [2:0]           
    .o_rdisper_0                   (                              ), // output [3:0]            
    .o_rdecer_0                    (                              ), // output [3:0]      
    .src_rst                       (src_rst                       ), // input                     
    .chk_rst                       (chk_rst                       ), // input                             
    .o_pl_err                      (o_pl_err                      )  // output [3:0]            
);





// ********************* Interface *********************


wire           i_free_clk_if                 = free_clk;                 
wire           i_hpll_rst_if                 = rst;                 
wire           i_lpll_rst_0_if               = rst;                 
wire           i_lpll_rst_1_if               = rst;                 
wire           i_lpll_rst_2_if               = rst;                 
wire           i_lpll_rst_3_if               = rst;                 
wire           i_hpll_wtchdg_clr_if          = 1'b0;                 
wire           i_hsst_fifo_clr_0_if          = 1'b0;         
wire   [2:0]   i_loop_dbg_0_if               = 3'b000;
wire           i_hsst_fifo_clr_1_if          = 1'b0;         
wire   [2:0]   i_loop_dbg_1_if               = 3'b000;
wire           i_hsst_fifo_clr_2_if          = 1'b0;         
wire   [2:0]   i_loop_dbg_2_if               = 3'b000;
wire           i_hsst_fifo_clr_3_if          = 1'b0;         
wire   [2:0]   i_loop_dbg_3_if               = 3'b000;
wire   [1:0]   o_hpll_wtchdg_st_if           ; 
wire           o_tx_ckdiv_done_0_if          ;          
wire           o_tx_ckdiv_done_1_if          ;          
wire           o_tx_ckdiv_done_2_if          ;          
wire           o_tx_ckdiv_done_3_if          ;          
wire           o_rx_ckdiv_done_0_if          ;          
wire           o_rx_ckdiv_done_1_if          ;          
wire           o_rx_ckdiv_done_2_if          ;          
wire           o_rx_ckdiv_done_3_if          ;          
wire           o_hpll_done_if                ; 
wire           o_lpll_done_0_if              ; 
wire           o_lpll_done_1_if              ; 
wire           o_lpll_done_2_if              ; 
wire           o_lpll_done_3_if              ; 
wire           o_txlane_done_0_if            ; 
wire           o_txlane_done_1_if            ; 
wire           o_txlane_done_2_if            ; 
wire           o_txlane_done_3_if            ; 
wire           o_rxlane_done_0_if            ; 
wire           o_rxlane_done_1_if            ; 
wire           o_rxlane_done_2_if            ; 
wire           o_rxlane_done_3_if            ; 
wire           i_p_refckn_0_if               = clk_pll0;        
wire           i_p_refckp_0_if               = ~clk_pll0;        
wire           i_p_refckn_1_if               = clk_pll1;        
wire           i_p_refckp_1_if               = ~clk_pll1;        
wire           i_p_pll_ref_clk_0_if          = clk_fabric;        
wire   [2:0]   i_p_lx_margin_ctl_0_if        = 3'b0; 
wire   [2:0]   i_p_lx_margin_ctl_1_if        = 3'b0; 
wire   [2:0]   i_p_lx_margin_ctl_2_if        = 3'b0; 
wire   [2:0]   i_p_lx_margin_ctl_3_if        = 3'b0; 
wire           i_p_lx_swing_ctl_0_if         = 1'b0; 
wire           i_p_lx_swing_ctl_1_if         = 1'b0; 
wire           i_p_lx_swing_ctl_2_if         = 1'b0; 
wire           i_p_lx_swing_ctl_3_if         = 1'b0; 
wire   [15:0]  i_p_lx_deemp_ctl_0_if         = 16'b0; 
wire   [15:0]  i_p_lx_deemp_ctl_1_if         = 16'b0; 
wire   [15:0]  i_p_lx_deemp_ctl_2_if         = 16'b0; 
wire   [15:0]  i_p_lx_deemp_ctl_3_if         = 16'b0; 
wire   [1:0]   i_p_lx_elecidle_en_0_if       ;
wire   [1:0]   i_p_lx_elecidle_en_1_if       ;
wire   [1:0]   i_p_lx_elecidle_en_2_if       ;
wire   [1:0]   i_p_lx_elecidle_en_3_if       ;
wire           o_p_hpll_lock_if              ;
wire           o_p_lpll_lock_0_if            ;
wire           o_p_lpll_lock_1_if            ;
wire           o_p_lpll_lock_2_if            ;
wire           o_p_lpll_lock_3_if            ;
wire           o_p_rx_sigdet_sta_0_if        ; 
wire           o_p_rx_sigdet_sta_1_if        ; 
wire           o_p_rx_sigdet_sta_2_if        ; 
wire           o_p_rx_sigdet_sta_3_if        ; 
wire           o_p_lx_cdr_align_0_if         ; 
wire           o_p_lx_cdr_align_1_if         ; 
wire           o_p_lx_cdr_align_2_if         ; 
wire           o_p_lx_cdr_align_3_if         ; 
wire   [1:0]   o_p_lx_oob_sta_0_if           ; 
wire   [1:0]   o_p_lx_oob_sta_1_if           ; 
wire   [1:0]   o_p_lx_oob_sta_2_if           ; 
wire   [1:0]   o_p_lx_oob_sta_3_if           ; 
wire           o_p_pcs_lsm_synced_0_if       ;        
wire           o_p_pcs_lsm_synced_1_if       ;        
wire           o_p_pcs_lsm_synced_2_if       ;        
wire           o_p_pcs_lsm_synced_3_if       ;        
wire           o_p_pcs_rx_mcb_status_0_if    ;        
wire           o_p_pcs_rx_mcb_status_1_if    ;        
wire           o_p_pcs_rx_mcb_status_2_if    ;        
wire           o_p_pcs_rx_mcb_status_3_if    ;        
wire           o_p_l0txn_if                  ; 
wire           o_p_l0txp_if                  ; 
wire           o_p_l1txn_if                  ; 
wire           o_p_l1txp_if                  ; 
wire           o_p_l2txn_if                  ; 
wire           o_p_l2txp_if                  ; 
wire           o_p_l3txn_if                  ; 
wire           o_p_l3txp_if                  ; 
wire           i_p_l0rxn_if                  ; 
wire           i_p_l0rxp_if                  ; 
wire           i_p_l1rxn_if                  ; 
wire           i_p_l1rxp_if                  ; 
wire           i_p_l2rxn_if                  ; 
wire           i_p_l2rxp_if                  ; 
wire           i_p_l3rxn_if                  ; 
wire           i_p_l3rxp_if                  ; 
wire   [3:0]   o_pl_err_if                   ;

Transceiver_10G_if_top  U_IF_TOP (
    
    .i_free_clk                    (i_free_clk_if                 ), // input                                                                          
    .i_hpll_rst                    (i_hpll_rst_if                 ), // input                                                                   
    .i_hpll_wtchdg_clr             (i_hpll_wtchdg_clr_if          ), // input                                                                  
    .i_hsst_fifo_clr_0             (i_hsst_fifo_clr_0_if          ), // input                           
    .i_loop_dbg_0                  (i_loop_dbg_0_if               ), // input                                                                             
    .o_hpll_wtchdg_st              (o_hpll_wtchdg_st_if           ), // output [1:0]                                                                      
    .o_hpll_done                   (o_hpll_done_if                ), // output                                                                    
    .o_txlane_done_0               (o_txlane_done_0_if            ), // output                                                                    
    .o_rxlane_done_0               (o_rxlane_done_0_if            ), // output                                                                     
    .i_p_refckn_0                  (i_p_refckn_0_if               ), // input                                                                      
    .i_p_refckp_0                  (i_p_refckp_0_if               ), // input                                                                    
    .o_p_refck2core_0              (                              ), // output                                                                      
    .o_p_hpll_lock                 (o_p_hpll_lock_if              ), // output                                                                
    .o_p_rx_sigdet_sta_0           (o_p_rx_sigdet_sta_0_if        ), // output                                                                 
    .o_p_lx_cdr_align_0            (o_p_lx_cdr_align_0_if         ), // output                                                                           
    .i_p_cfg_clk                   (i_free_clk_if                 ), // input                                                                            
    .i_p_cfg_rst                   (i_p_cfg_rst                   ), // input                                                                            
    .i_p_cfg_psel                  (1'b0                          ), // input                                                                            
    .i_p_cfg_enable                (1'b0                          ), // input                                                                            
    .i_p_cfg_write                 (1'b0                          ), // input                                                                            
    .i_p_cfg_addr                  (16'b0                         ), // input  [15:0]                                                                    
    .i_p_cfg_wdata                 (8'b0                          ), // input  [7:0]                                                                     
    .o_p_cfg_rdata                 (                              ), // output [7:0]                                                                     
    .o_p_cfg_int                   (                              ), // output                                                                           
    .o_p_cfg_ready                 (                              ), // output                                                                       
    .i_p_l0rxn                     (i_p_l0rxn_if                  ), // input                                                                        
    .i_p_l0rxp                     (i_p_l0rxp_if                  ), // input                                                                        
    .o_p_l0txn                     (o_p_l0txn_if                  ), // output                                                                       
    .o_p_l0txp                     (o_p_l0txp_if                  ), // output                                                                       
    .o_rxstatus_0                  (                              ), // output [2:0]          
    .o_rdisper_0                   (                              ), // output [3:0]           
    .o_rdecer_0                    (                              ), // output [3:0]      
    .src_rst                       (src_rst                       ), // input                        
    .chk_rst                       (chk_rst                       ), // input                  
    .o_pl_err                      (o_pl_err_if                   )  // output [3:0]           
);


assign         i_p_l0rxn                     = o_p_l0txn_if; 
assign         i_p_l0rxp                     = o_p_l0txp_if; 
assign         i_p_l0rxn_if                  = o_p_l0txn; 
assign         i_p_l0rxp_if                  = o_p_l0txp; 

endmodule    
