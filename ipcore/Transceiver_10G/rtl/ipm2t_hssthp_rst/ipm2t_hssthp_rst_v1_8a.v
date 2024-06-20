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
module  ipm2t_hssthp_rst_v1_8a#(
    parameter INNER_RST_EN                 = "TRUE"       , //TRUE: HSST Reset Auto Control, FALSE: HSST Reset Control by User
    parameter FREE_CLOCK_FREQ              = 100          , //Unit is MHz, free clock  freq from GUI Freq: 0~200MHz
    parameter CH0_TX_ENABLE                = "TRUE"       , //TRUE:lane0 TX Reset Logic used, FALSE: lane0 TX Reset Logic remove
    parameter CH1_TX_ENABLE                = "TRUE"       , //TRUE:lane1 TX Reset Logic used, FALSE: lane1 TX Reset Logic remove
    parameter CH2_TX_ENABLE                = "TRUE"       , //TRUE:lane2 TX Reset Logic used, FALSE: lane2 TX Reset Logic remove
    parameter CH3_TX_ENABLE                = "TRUE"       , //TRUE:lane3 TX Reset Logic used, FALSE: lane3 TX Reset Logic remove
    parameter CH0_RX_ENABLE                = "TRUE"       , //TRUE:lane0 RX Reset Logic used, FALSE: lane0 RX Reset Logic remove
    parameter CH1_RX_ENABLE                = "TRUE"       , //TRUE:lane1 RX Reset Logic used, FALSE: lane1 RX Reset Logic remove
    parameter CH2_RX_ENABLE                = "TRUE"       , //TRUE:lane2 RX Reset Logic used, FALSE: lane2 RX Reset Logic remove
    parameter CH3_RX_ENABLE                = "TRUE"       , //TRUE:lane3 RX Reset Logic used, FALSE: lane3 RX Reset Logic remove
    parameter CH0_TX_MULT_LANE_MODE        = 1            , //Lane0 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    parameter CH1_TX_MULT_LANE_MODE        = 1            , //Lane1 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    parameter CH2_TX_MULT_LANE_MODE        = 1            , //Lane2 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    parameter CH3_TX_MULT_LANE_MODE        = 1            , //Lane3 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    parameter CH0_RX_MULT_LANE_MODE        = 1            , //Lane0 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    parameter CH1_RX_MULT_LANE_MODE        = 1            , //Lane1 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    parameter CH2_RX_MULT_LANE_MODE        = 1            , //Lane2 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    parameter CH3_RX_MULT_LANE_MODE        = 1            , //Lane3 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    parameter PCS_CH0_BYPASS_WORD_ALIGN    = "FALSE"      , //TRUE: Lane0 Bypass Word Alignment, FALSE: Lane0 No Bypass Word Alignment
    parameter PCS_CH1_BYPASS_WORD_ALIGN    = "FALSE"      , //TRUE: Lane1 Bypass Word Alignment, FALSE: Lane1 No Bypass Word Alignment
    parameter PCS_CH2_BYPASS_WORD_ALIGN    = "FALSE"      , //TRUE: Lane2 Bypass Word Alignment, FALSE: Lane2 No Bypass Word Alignment
    parameter PCS_CH3_BYPASS_WORD_ALIGN    = "FALSE"      , //TRUE: Lane3 Bypass Word Alignment, FALSE: Lane3 No Bypass Word Alignment
    parameter PCS_CH0_BYPASS_BONDING       = "FALSE"      , //TRUE: Lane0 Bypass Channel Bonding, FALSE: Lane0 No Bypass Channel Bonding
    parameter PCS_CH1_BYPASS_BONDING       = "FALSE"      , //TRUE: Lane1 Bypass Channel Bonding, FALSE: Lane1 No Bypass Channel Bonding
    parameter PCS_CH2_BYPASS_BONDING       = "FALSE"      , //TRUE: Lane2 Bypass Channel Bonding, FALSE: Lane2 No Bypass Channel Bonding
    parameter PCS_CH3_BYPASS_BONDING       = "FALSE"      , //TRUE: Lane3 Bypass Channel Bonding, FALSE: Lane3 No Bypass Channel Bonding
    parameter PCS_CH0_BYPASS_CTC           = "TRUE"       , //TRUE: Lane0 Bypass CTC, FALSE: Lane0 No Bypass CTC
    parameter PCS_CH1_BYPASS_CTC           = "TRUE"       , //TRUE: Lane1 Bypass CTC, FALSE: Lane1 No Bypass CTC
    parameter PCS_CH2_BYPASS_CTC           = "TRUE"       , //TRUE: Lane2 Bypass CTC, FALSE: Lane2 No Bypass CTC
    parameter PCS_CH3_BYPASS_CTC           = "TRUE"       , //TRUE: Lane3 Bypass CTC, FALSE: Lane3 No Bypass CTC
    parameter P_LX_TX_CKDIV_0              =  0           , //TX initial clock division value
    parameter P_LX_TX_CKDIV_1              =  0           , //TX initial clock division value
    parameter P_LX_TX_CKDIV_2              =  0           , //TX initial clock division value
    parameter P_LX_TX_CKDIV_3              =  0           , //TX initial clock division value
    parameter HPLL_USE                     =  1           , // 1:enable HPLL 0: disable HPLL
    parameter LX_RX_CKDIV_0                =  0           , //RX initial clock division value
    parameter LX_RX_CKDIV_1                =  0           , //RX initial clock division value
    parameter LX_RX_CKDIV_2                =  0           , //RX initial clock division value
    parameter LX_RX_CKDIV_3                =  0           , //RX initial clock division value
    parameter MULTHPLL_BONDING             = "TRUE"       , //two quad bonding
    parameter SINGLEHPLL_BONDING           = "TRUE"       , //one quad bonding
    parameter CH0_LPLL_USE                 = "TRUE"       ,
    parameter CH1_LPLL_USE                 = "TRUE"       ,
    parameter CH2_LPLL_USE                 = "TRUE"       ,
    parameter CH3_LPLL_USE                 = "TRUE"       ,
    parameter CH0_TX_PLL_SEL               = "HPLL"       ,//"HPLL": Tx Channel select HPLL "LPLL": Tx Channel select LPLL
    parameter CH1_TX_PLL_SEL               = "HPLL"       ,//"HPLL": Tx Channel select HPLL "LPLL": Tx Channel select LPLL
    parameter CH2_TX_PLL_SEL               = "HPLL"       ,//"HPLL": Tx Channel select HPLL "LPLL": Tx Channel select LPLL
    parameter CH3_TX_PLL_SEL               = "HPLL"       ,//"HPLL": Tx Channel select HPLL "LPLL": Tx Channel select LPLL
    parameter CH0_RX_PLL_SEL               = "HPLL"       ,//"HPLL": Rx Channel select HPLL "LPLL": Rx Channel select LPLL
    parameter CH1_RX_PLL_SEL               = "HPLL"       ,//"HPLL": Rx Channel select HPLL "LPLL": Rx Channel select LPLL
    parameter CH2_RX_PLL_SEL               = "HPLL"       ,//"HPLL": Rx Channel select HPLL "LPLL": Rx Channel select LPLL
    parameter CH3_RX_PLL_SEL               = "HPLL"       ,//"HPLL": Rx Channel select HPLL "LPLL": Rx Channel select LPLL
    parameter PCS_TX_CLK_EXPLL_USE_CH0     = "FALSE"      ,//Tx LANE0 TRUE: use external PLL, FALSE: Not use external PLL
    parameter PCS_TX_CLK_EXPLL_USE_CH1     = "FALSE"      ,//Tx LANE1 TRUE: use external PLL, FALSE: Not use external PLL
    parameter PCS_TX_CLK_EXPLL_USE_CH2     = "FALSE"      ,//Tx LANE2 TRUE: use external PLL, FALSE: Not use external PLL
    parameter PCS_TX_CLK_EXPLL_USE_CH3     = "FALSE"      ,//Tx LANE3 TRUE: use external PLL, FALSE: Not use external PLL
    parameter PCS_RX_CLK_EXPLL_USE_CH0     = "FALSE"      ,//Rx LANE0 TRUE: use external PLL, FALSE: Not use external PLL
    parameter PCS_RX_CLK_EXPLL_USE_CH1     = "FALSE"      ,//Rx LANE1 TRUE: use external PLL, FALSE: Not use external PLL
    parameter PCS_RX_CLK_EXPLL_USE_CH2     = "FALSE"      ,//Rx LANE2 TRUE: use external PLL, FALSE: Not use external PLL
    parameter PCS_RX_CLK_EXPLL_USE_CH3     = "FALSE"      ,//Rx LANE3 TRUE: use external PLL, FALSE: Not use external PLL
    parameter CH0_TX_RATE                  = 1.25         ,
    parameter CH1_TX_RATE                  = 1.25         ,
    parameter CH2_TX_RATE                  = 1.25         ,
    parameter CH3_TX_RATE                  = 1.25         ,
    parameter CH0_RX_RATE                  = 1.25         ,
    parameter CH1_RX_RATE                  = 1.25         ,
    parameter CH2_RX_RATE                  = 1.25         ,
    parameter CH3_RX_RATE                  = 1.25         ,
    parameter CH0_RXPCS_ALIGN_TIMER        = 65535        ,
    parameter CH1_RXPCS_ALIGN_TIMER        = 65535        ,
    parameter CH2_RXPCS_ALIGN_TIMER        = 65535        ,
    parameter CH3_RXPCS_ALIGN_TIMER        = 65535        ,
    parameter CH0_BOND_WTCHDG_CNTR1_WIDTH  = 14           ,    
    parameter CH2_BOND_WTCHDG_CNTR1_WIDTH  = 14           ,    
    parameter CH0_BOND_WTCHDG_CNTR2_WIDTH  = 14           , 
    parameter CH2_BOND_WTCHDG_CNTR2_WIDTH  = 14           
    
)(
    //BOTH NEED
    input  wire                   i_pll_lock_tx_0         ,
    input  wire                   i_pll_lock_tx_1         ,
    input  wire                   i_pll_lock_tx_2         ,
    input  wire                   i_pll_lock_tx_3         ,
    input  wire                   i_pll_lock_rx_0         ,
    input  wire                   i_pll_lock_rx_1         ,
    input  wire                   i_pll_lock_rx_2         ,
    input  wire                   i_pll_lock_rx_3         ,
    input  wire                   i_rx_pma_rst_0          ,
    input  wire                   i_rx_pma_rst_1          ,
    input  wire                   i_rx_pma_rst_2          ,
    input  wire                   i_rx_pma_rst_3          ,
    input  wire                   i_rx_pcs_rst_0          ,
    input  wire                   i_rx_pcs_rst_1          ,
    input  wire                   i_rx_pcs_rst_2          ,
    input  wire                   i_rx_pcs_rst_3          ,
    input  wire                   i_pll_tx_sel_0          ,
    input  wire                   i_pll_tx_sel_1          ,
    input  wire                   i_pll_tx_sel_2          ,
    input  wire                   i_pll_tx_sel_3          ,
    input  wire                   i_pll_rx_sel_0          ,
    input  wire                   i_pll_rx_sel_1          ,
    input  wire                   i_pll_rx_sel_2          ,
    input  wire                   i_pll_rx_sel_3          ,
    input  wire                   i_rx_data_sel_en_0      ,
    input  wire                   i_rx_data_sel_en_1      ,
    input  wire                   i_rx_data_sel_en_2      ,
    input  wire                   i_rx_data_sel_en_3      ,
    input  wire    [1 :0]         i_rx_data_sel_0         ,
    input  wire    [1 :0]         i_rx_data_sel_1         ,
    input  wire    [1 :0]         i_rx_data_sel_2         ,
    input  wire    [1 :0]         i_rx_data_sel_3         ,
    //--- User Side ---
    //INNER_RST_EN is TRUE 
    input  wire                   i_free_clk              ,
    input  wire                   i_lpll_rst_0            ,
    input  wire                   i_lpll_rst_1            ,
    input  wire                   i_lpll_rst_2            ,
    input  wire                   i_lpll_rst_3            ,
    input  wire                   i_hpll_rst              ,
    input  wire                   i_wtchdg_clr_lpll_0     ,
    input  wire                   i_wtchdg_clr_lpll_1     ,
    input  wire                   i_wtchdg_clr_lpll_2     ,
    input  wire                   i_wtchdg_clr_lpll_3     ,
    input  wire                   i_wtchdg_clr_hpll       ,
    input  wire                   i_txlane_rst_0          ,
    input  wire                   i_txlane_rst_1          ,
    input  wire                   i_txlane_rst_2          ,
    input  wire                   i_txlane_rst_3          ,
    input  wire                   i_rxlane_rst_0          ,
    input  wire                   i_rxlane_rst_1          ,
    input  wire                   i_rxlane_rst_2          ,
    input  wire                   i_rxlane_rst_3          ,
    input  wire                   i_tx_rate_chng_0        ,
    input  wire                   i_tx_rate_chng_1        ,
    input  wire                   i_tx_rate_chng_2        ,
    input  wire                   i_tx_rate_chng_3        ,
    input  wire                   i_rx_rate_chng_0        ,
    input  wire                   i_rx_rate_chng_1        ,
    input  wire                   i_rx_rate_chng_2        ,
    input  wire                   i_rx_rate_chng_3        ,
    input  wire    [1 : 0]        i_txckdiv_0             ,
    input  wire    [1 : 0]        i_txckdiv_1             ,
    input  wire    [1 : 0]        i_txckdiv_2             ,
    input  wire    [1 : 0]        i_txckdiv_3             ,
    input  wire    [1 : 0]        i_rxckdiv_0             ,
    input  wire    [1 : 0]        i_rxckdiv_1             ,
    input  wire    [1 : 0]        i_rxckdiv_2             ,
    input  wire    [1 : 0]        i_rxckdiv_3             ,
    input  wire                   i_tx_pma_rst_0          ,
    input  wire                   i_tx_pma_rst_1          ,
    input  wire                   i_tx_pma_rst_2          ,
    input  wire                   i_tx_pma_rst_3          ,
    input  wire                   i_tx_pcs_rst_0          ,
    input  wire                   i_tx_pcs_rst_1          ,
    input  wire                   i_tx_pcs_rst_2          ,
    input  wire                   i_tx_pcs_rst_3          ,
    input  wire                   i_bond_wtchdg_clr       ,
    input  wire                   i_hssthp_fifo_clr_0     ,
    input  wire                   i_hssthp_fifo_clr_1     ,
    input  wire                   i_hssthp_fifo_clr_2     ,
    input  wire                   i_hssthp_fifo_clr_3     ,
    input  wire                   i_force_rxfsm_det_0     ,//Debug signal for loopback mode
    input  wire                   i_force_rxfsm_det_1     ,//Debug signal for loopback mode
    input  wire                   i_force_rxfsm_det_2     ,//Debug signal for loopback mode
    input  wire                   i_force_rxfsm_det_3     ,//Debug signal for loopback mode
    input  wire                   i_force_rxfsm_lsm_0     ,//Debug signal for loopback mode
    input  wire                   i_force_rxfsm_lsm_1     ,//Debug signal for loopback mode
    input  wire                   i_force_rxfsm_lsm_2     ,//Debug signal for loopback mode
    input  wire                   i_force_rxfsm_lsm_3     ,//Debug signal for loopback mode
    input  wire                   i_force_rxfsm_cdr_0     ,//Debug signal for loopback mode
    input  wire                   i_force_rxfsm_cdr_1     ,//Debug signal for loopback mode
    input  wire                   i_force_rxfsm_cdr_2     ,//Debug signal for loopback mode
    input  wire                   i_force_rxfsm_cdr_3     ,//Debug signal for loopback mode
    output wire    [1 : 0]        o_wtchdg_st_hpll        ,
    output wire    [1 : 0]        o_wtchdg_st_lpll_0      ,
    output wire    [1 : 0]        o_wtchdg_st_lpll_1      ,
    output wire    [1 : 0]        o_wtchdg_st_lpll_2      ,
    output wire    [1 : 0]        o_wtchdg_st_lpll_3      ,
    output wire                   o_hpll_done             ,
    output wire                   o_lpll_done_0           ,
    output wire                   o_lpll_done_1           ,
    output wire                   o_lpll_done_2           ,
    output wire                   o_lpll_done_3           ,
    output wire                   o_txlane_done_0         ,
    output wire                   o_txlane_done_1         ,
    output wire                   o_txlane_done_2         ,
    output wire                   o_txlane_done_3         ,
    output wire                   o_tx_ckdiv_done_0       ,
    output wire                   o_tx_ckdiv_done_1       ,
    output wire                   o_tx_ckdiv_done_2       ,
    output wire                   o_tx_ckdiv_done_3       ,
    output wire                   o_rxlane_done_0         ,
    output wire                   o_rxlane_done_1         ,
    output wire                   o_rxlane_done_2         ,
    output wire                   o_rxlane_done_3         ,
    output wire                   o_rx_ckdiv_done_0       ,
    output wire                   o_rx_ckdiv_done_1       ,
    output wire                   o_rx_ckdiv_done_2       ,
    output wire                   o_rx_ckdiv_done_3       ,
    //INNER_RST_EN is FALSE
    //1 quad
    input  wire                   i_f_com_powerdown       ,
    input  wire                   i_f_hpll_rst            ,
    input  wire                   i_f_hpll_powerdown      ,
    input  wire                   i_f_hpll_vco_calib_en   ,
    input  wire                   i_f_refclk_div_sync     ,
    input  wire                   i_f_hpll_div_sync       ,
    input  wire                   i_f_tx_sync             ,
    input  wire                   i_f_tx_rate_change_on   ,
    input  wire                   i_f_lpll_powerdown_0    ,
    input  wire                   i_f_lpll_rst_0          ,
    input  wire                   i_f_lane_powerdown_0    ,
    input  wire           [1:0]   i_f_tx_rate_0           ,
    input  wire                   i_f_lane_rst_0          ,
    input  wire                   i_f_tx_pma_rst_0        ,
    input  wire                   i_f_pcs_tx_rst_0        ,
    input  wire                   i_f_tx_lane_powerdown_0 ,
    input  wire                   i_f_pma_rx_pd_0         ,
    input  wire                   i_f_pcs_rx_rst_0        ,
    input  wire                   i_f_rx_pma_rst_0        ,
    input  wire           [1:0]   i_f_rx_rate_0           ,

    input  wire                   i_f_lpll_powerdown_1    ,
    input  wire                   i_f_lpll_rst_1          ,
    input  wire                   i_f_lane_powerdown_1    ,
    input  wire                   i_f_lane_rst_1          ,
    input  wire                   i_f_tx_pma_rst_1        ,
    input  wire                   i_f_tx_lane_powerdown_1 ,
    input  wire                   i_f_pcs_tx_rst_1        ,
    input  wire           [1:0]   i_f_tx_rate_1           ,
    input  wire                   i_f_pma_rx_pd_1         ,
    input  wire                   i_f_pcs_rx_rst_1        ,
    input  wire                   i_f_rx_pma_rst_1        ,
    input  wire           [1:0]   i_f_rx_rate_1           ,
    input  wire                   i_f_lpll_powerdown_2    ,
    input  wire                   i_f_lpll_rst_2          ,
    input  wire                   i_f_lane_powerdown_2    ,
    input  wire                   i_f_lane_rst_2          ,
    input  wire                   i_f_tx_pma_rst_2        ,
    input  wire                   i_f_tx_lane_powerdown_2 ,
    input  wire                   i_f_pcs_tx_rst_2        ,
    input  wire           [1:0]   i_f_tx_rate_2           ,
    input  wire                   i_f_pma_rx_pd_2         ,
    input  wire                   i_f_pcs_rx_rst_2        ,
    input  wire                   i_f_rx_pma_rst_2        ,
    input  wire           [1:0]   i_f_rx_rate_2           ,
    input  wire                   i_f_lpll_powerdown_3    ,
    input  wire                   i_f_lpll_rst_3          ,
    input  wire                   i_f_lane_powerdown_3    ,
    input  wire                   i_f_lane_rst_3          ,
    input  wire                   i_f_tx_pma_rst_3        ,
    input  wire                   i_f_tx_lane_powerdown_3 ,
    input  wire                   i_f_pcs_tx_rst_3        ,
    input  wire           [1:0]   i_f_tx_rate_3           ,
    input  wire                   i_f_pma_rx_pd_3         ,
    input  wire                   i_f_pcs_rx_rst_3        ,
    input  wire                   i_f_rx_pma_rst_3        ,
    input  wire           [1:0]   i_f_rx_rate_3           ,             
    
    //--- Hsst Side ---
    input  wire                   HPLL_READY_0            ,
    input  wire                   HPLL_READY_1            ,
    input  wire                   LPLL_READY_0            ,
    input  wire                   LPLL_READY_1            ,
    input  wire                   LPLL_READY_2            ,
    input  wire                   LPLL_READY_3            ,
    input  wire                   P_RX_SIGDET_STATUS_0    ,
    input  wire                   P_RX_SIGDET_STATUS_1    ,
    input  wire                   P_RX_SIGDET_STATUS_2    ,
    input  wire                   P_RX_SIGDET_STATUS_3    ,
    input  wire                   P_RX_READY_0            ,
    input  wire                   P_RX_READY_1            ,
    input  wire                   P_RX_READY_2            ,
    input  wire                   P_RX_READY_3            ,
    input  wire                   P_PCS_LSM_SYNCED_0      ,
    input  wire                   P_PCS_LSM_SYNCED_1      ,
    input  wire                   P_PCS_LSM_SYNCED_2      ,
    input  wire                   P_PCS_LSM_SYNCED_3      ,
    input  wire                   P_PCS_RX_MCB_STATUS_0   ,
    input  wire                   P_PCS_RX_MCB_STATUS_1   ,
    input  wire                   P_PCS_RX_MCB_STATUS_2   ,
    input  wire                   P_PCS_RX_MCB_STATUS_3   ,
    output wire                   P_COM_POWERDOWN         ,
    output wire                   P_HPLL_POWERDOWN        ,
    output wire                   P_HPLL_RST              ,
    output wire                   P_HPLL_VCO_CALIB_EN     ,
    output wire                   P_REFCLK_DIV_SYNC       ,
    output wire                   P_HPLL_DIV_SYNC         ,
    output wire                   P_TX_SYNC               ,
    output wire                   P_TX_RATE_CHANGE_ON     ,
    output wire                   P_LPLL_POWERDOWN_0      ,
    output wire                   P_LPLL_POWERDOWN_1      ,
    output wire                   P_LPLL_POWERDOWN_2      ,
    output wire                   P_LPLL_POWERDOWN_3      ,
    output wire                   P_LPLL_RST_0            ,
    output wire                   P_LPLL_RST_1            ,
    output wire                   P_LPLL_RST_2            ,
    output wire                   P_LPLL_RST_3            ,
    output wire                   P_LANE_POWERDOWN_0      ,
    output wire                   P_LANE_POWERDOWN_1      ,
    output wire                   P_LANE_POWERDOWN_2      ,
    output wire                   P_LANE_POWERDOWN_3      ,
    output wire                   P_LANE_RST_0            ,
    output wire                   P_LANE_RST_1            ,
    output wire                   P_LANE_RST_2            ,
    output wire                   P_LANE_RST_3            ,
    output wire                   P_TX_PMA_RST_0          ,
    output wire                   P_TX_PMA_RST_1          ,
    output wire                   P_TX_PMA_RST_2          ,
    output wire                   P_TX_PMA_RST_3          ,
    output wire     [1:0]         P_TX_RATE_0             ,
    output wire     [1:0]         P_TX_RATE_1             ,
    output wire     [1:0]         P_TX_RATE_2             ,
    output wire     [1:0]         P_TX_RATE_3             ,
    output wire                   P_PCS_TX_RST_0          ,
    output wire                   P_PCS_TX_RST_1          ,
    output wire                   P_PCS_TX_RST_2          ,
    output wire                   P_PCS_TX_RST_3          ,
    output wire                   P_TX_LANE_POWERDOWN_0   ,
    output wire                   P_TX_LANE_POWERDOWN_1   ,
    output wire                   P_TX_LANE_POWERDOWN_2   ,
    output wire                   P_TX_LANE_POWERDOWN_3   ,
    output wire                   P_PMA_RX_PD_0           ,
    output wire                   P_PMA_RX_PD_1           ,
    output wire                   P_PMA_RX_PD_2           ,
    output wire                   P_PMA_RX_PD_3           ,
    output wire                   P_PCS_RX_RST_0          ,
    output wire                   P_PCS_RX_RST_1          ,
    output wire                   P_PCS_RX_RST_2          ,
    output wire                   P_PCS_RX_RST_3          ,
    output wire                   P_RX_PMA_RST_0          ,
    output wire                   P_RX_PMA_RST_1          ,
    output wire                   P_RX_PMA_RST_2          ,
    output wire                   P_RX_PMA_RST_3          ,
    output wire        [1:0]      P_RX_RATE_0             ,
    output wire        [1:0]      P_RX_RATE_1             ,
    output wire        [1:0]      P_RX_RATE_2             ,
    output wire        [1:0]      P_RX_RATE_3             
);


//****************************************************************************//
//                      Internal Signal                                       //
//****************************************************************************//
//CTC Enable, TX/RX Reused Same Rate Change Port
wire       p_rx_rate_chng_0;
wire       p_rx_rate_chng_1;
wire       p_rx_rate_chng_2;
wire       p_rx_rate_chng_3;
wire [1:0] p_rxckdiv_0;
wire [1:0] p_rxckdiv_1;
wire [1:0] p_rxckdiv_2;
wire [1:0] p_rxckdiv_3;
wire       p_rx_pma_rst_0;
wire       p_rx_pma_rst_1;
wire       p_rx_pma_rst_2;
wire       p_rx_pma_rst_3;
wire       tx_sync_hpll   ;
wire       lane_sync_0    ;
wire       lane_sync_1    ;
wire       lane_sync_2    ;
wire       lane_sync_3    ;
wire       rate_change_on_0    ;
wire       rate_change_on_1    ;
wire       rate_change_on_2    ;
wire       rate_change_on_3    ;
wire       p_rate_change_tclk_on_1;
//****************************************************************************//
//                      Sequential and Logic                                  //
//****************************************************************************//
assign   p_rx_rate_chng_0 = (CH0_TX_ENABLE=="TRUE" && PCS_CH0_BYPASS_CTC=="FALSE") ? i_tx_rate_chng_0 : i_rx_rate_chng_0;
assign   p_rx_rate_chng_1 = (CH1_TX_ENABLE=="TRUE" && PCS_CH1_BYPASS_CTC=="FALSE") ? i_tx_rate_chng_1 : i_rx_rate_chng_1;
assign   p_rx_rate_chng_2 = (CH2_TX_ENABLE=="TRUE" && PCS_CH2_BYPASS_CTC=="FALSE") ? i_tx_rate_chng_2 : i_rx_rate_chng_2;
assign   p_rx_rate_chng_3 = (CH3_TX_ENABLE=="TRUE" && PCS_CH3_BYPASS_CTC=="FALSE") ? i_tx_rate_chng_3 : i_rx_rate_chng_3;
assign   p_rxckdiv_0      = (CH0_TX_ENABLE=="TRUE" && PCS_CH0_BYPASS_CTC=="FALSE") ? {i_txckdiv_0} : {i_rxckdiv_0};
assign   p_rxckdiv_1      = (CH1_TX_ENABLE=="TRUE" && PCS_CH1_BYPASS_CTC=="FALSE") ? {i_txckdiv_1} : {i_rxckdiv_1};
assign   p_rxckdiv_2      = (CH2_TX_ENABLE=="TRUE" && PCS_CH2_BYPASS_CTC=="FALSE") ? {i_txckdiv_2} : {i_rxckdiv_2};
assign   p_rxckdiv_3      = (CH3_TX_ENABLE=="TRUE" && PCS_CH3_BYPASS_CTC=="FALSE") ? {i_txckdiv_3} : {i_rxckdiv_3};

generate if (HPLL_USE=="TRUE"&&INNER_RST_EN=="TRUE" ) begin : RST_WITH_HPLL
    ipm2t_hssthp_rst_hpll_v1_3#(
        .FREE_CLOCK_FREQ               (FREE_CLOCK_FREQ             ),
        .SINGLEHPLL_BONDING            (SINGLEHPLL_BONDING          ),
        .MULTHPLL_BONDING              (MULTHPLL_BONDING            )
    ) hssthp_rst_hpll (
        .clk                           (i_free_clk                  ),//I
        .i_hpll_rst                    (i_hpll_rst                  ),//I
        .HPLL_READY_0                  (HPLL_READY_0                ),//I
        .HPLL_READY_1                  (HPLL_READY_1                ),//I
        .i_wtchdg_clr_hpll             (i_wtchdg_clr_hpll           ),//I
        .o_wtchdg_st_hpll              (o_wtchdg_st_hpll            ),//O
        .o_hpll_done                   (o_hpll_done                 ),//O
        .P_HPLL_POWERDOWN              (P_HPLL_POWERDOWN            ),//O
        .P_HPLL_RST                    (P_HPLL_RST                  ),//O
        .P_HPLL_VCO_CALIB_EN           (P_HPLL_VCO_CALIB_EN         ),//O
        .P_REFCLK_DIV_SYNC             (P_REFCLK_DIV_SYNC           ),//O
        .tx_sync_hpll                  (tx_sync_hpll                ),//O
        .P_HPLL_DIV_SYNC               (P_HPLL_DIV_SYNC             )
    );
    assign P_COM_POWERDOWN = 1'b0                   ;
end
else begin: RST_WITHOUT_HPLL
assign o_wtchdg_st_hpll     = 2'b0                  ;
assign o_hpll_done          = 1'b0                  ;
assign tx_sync_hpll         = 1'b0                  ;
assign P_COM_POWERDOWN      = i_f_com_powerdown     ;
assign P_HPLL_POWERDOWN     = i_f_hpll_powerdown    ;
assign P_HPLL_VCO_CALIB_EN  = i_f_hpll_vco_calib_en ;
assign P_REFCLK_DIV_SYNC    = i_f_refclk_div_sync   ;
assign P_HPLL_DIV_SYNC      = i_f_hpll_div_sync     ;
assign P_HPLL_RST           = i_f_hpll_rst          ;
end
endgenerate

generate
if(INNER_RST_EN=="TRUE") begin : AUTO_MODE
    ipm2t_hssthp_rst_lpll_v1_1#(
        .FREE_CLOCK_FREQ                (FREE_CLOCK_FREQ            ),
        .CH0_LPLL_USE                   (CH0_LPLL_USE               ),
        .CH1_LPLL_USE                   (CH1_LPLL_USE               ),
        .CH2_LPLL_USE                   (CH2_LPLL_USE               ),
        .CH3_LPLL_USE                   (CH3_LPLL_USE               )
    )   hssthp_rst_lpll   (
        .clk                           (i_free_clk                  ),//I
        .i_lpll_rst_0                  (i_lpll_rst_0                ),//I
        .i_lpll_rst_1                  (i_lpll_rst_1                ),//I
        .i_lpll_rst_2                  (i_lpll_rst_2                ),//I
        .i_lpll_rst_3                  (i_lpll_rst_3                ),//I
        .LPLL_READY_0                  (LPLL_READY_0                ),//I
        .LPLL_READY_1                  (LPLL_READY_1                ),//I
        .LPLL_READY_2                  (LPLL_READY_2                ),//I
        .LPLL_READY_3                  (LPLL_READY_3                ),//I
        .i_wtchdg_clr_lpll_0           (i_wtchdg_clr_lpll_0         ),//I
        .i_wtchdg_clr_lpll_1           (i_wtchdg_clr_lpll_1         ),//I
        .i_wtchdg_clr_lpll_2           (i_wtchdg_clr_lpll_2         ),//I
        .i_wtchdg_clr_lpll_3           (i_wtchdg_clr_lpll_3         ),//I
        .o_wtchdg_st_lpll_0            (o_wtchdg_st_lpll_0          ),//I
        .o_wtchdg_st_lpll_1            (o_wtchdg_st_lpll_1          ),//I
        .o_wtchdg_st_lpll_2            (o_wtchdg_st_lpll_2          ),//I
        .o_wtchdg_st_lpll_3            (o_wtchdg_st_lpll_3          ),//I
        .o_lpll_done_0                 (o_lpll_done_0               ),//O
        .o_lpll_done_1                 (o_lpll_done_1               ),//O
        .o_lpll_done_2                 (o_lpll_done_2               ),//O
        .o_lpll_done_3                 (o_lpll_done_3               ),//O
        .LPLL_POWERDOWN_0              (P_LPLL_POWERDOWN_0          ),//O
        .LPLL_POWERDOWN_1              (P_LPLL_POWERDOWN_1          ),//O
        .LPLL_POWERDOWN_2              (P_LPLL_POWERDOWN_2          ),//O
        .LPLL_POWERDOWN_3              (P_LPLL_POWERDOWN_3          ),//O
        .LPLL_RST_0                    (P_LPLL_RST_0                ),//O
        .LPLL_RST_1                    (P_LPLL_RST_1                ),//O
        .LPLL_RST_2                    (P_LPLL_RST_2                ),//O
        .LPLL_RST_3                    (P_LPLL_RST_3                )//O
        );


    ipm2t_hssthp_rst_tx_v1_5#(
        .FREE_CLOCK_FREQ                (FREE_CLOCK_FREQ            ),
        .CH0_TX_ENABLE                  (CH0_TX_ENABLE              ),
        .CH1_TX_ENABLE                  (CH1_TX_ENABLE              ),
        .CH2_TX_ENABLE                  (CH2_TX_ENABLE              ),
        .CH3_TX_ENABLE                  (CH3_TX_ENABLE              ),
        .CH0_MULT_LANE_MODE             (CH0_TX_MULT_LANE_MODE      ),
        .CH1_MULT_LANE_MODE             (CH1_TX_MULT_LANE_MODE      ),
        .CH2_MULT_LANE_MODE             (CH2_TX_MULT_LANE_MODE      ),
        .CH3_MULT_LANE_MODE             (CH3_TX_MULT_LANE_MODE      ),
        .P_LX_TX_CKDIV_0                (P_LX_TX_CKDIV_0            ),
        .P_LX_TX_CKDIV_1                (P_LX_TX_CKDIV_1            ),
        .P_LX_TX_CKDIV_2                (P_LX_TX_CKDIV_2            ),
        .P_LX_TX_CKDIV_3                (P_LX_TX_CKDIV_3            ),
        .CH0_TX_PLL_SEL                 (CH0_TX_PLL_SEL             ),
        .CH1_TX_PLL_SEL                 (CH1_TX_PLL_SEL             ),
        .CH2_TX_PLL_SEL                 (CH2_TX_PLL_SEL             ),
        .CH3_TX_PLL_SEL                 (CH3_TX_PLL_SEL             ),
        .PCS_TX_CLK_EXPLL_USE_CH0       (PCS_TX_CLK_EXPLL_USE_CH0   ),
        .PCS_TX_CLK_EXPLL_USE_CH1       (PCS_TX_CLK_EXPLL_USE_CH1   ),
        .PCS_TX_CLK_EXPLL_USE_CH2       (PCS_TX_CLK_EXPLL_USE_CH2   ),
        .PCS_TX_CLK_EXPLL_USE_CH3       (PCS_TX_CLK_EXPLL_USE_CH3   )
    ) hssthp_rst_tx (
        .clk                            (i_free_clk                 ),//I
        .i_txlane_rst_0                 (i_txlane_rst_0             ),//I
        .i_txlane_rst_1                 (i_txlane_rst_1             ),//I
        .i_txlane_rst_2                 (i_txlane_rst_2             ),//I
        .i_txlane_rst_3                 (i_txlane_rst_3             ),//I
        .i_lpll_done_0                  (o_lpll_done_0              ),//I
        .i_lpll_done_1                  (o_lpll_done_1              ),//I
        .i_lpll_done_2                  (o_lpll_done_2              ),//I
        .i_lpll_done_3                  (o_lpll_done_3              ),//I
        .i_hpll_done                    (o_hpll_done                ),//I
        .i_tx_rate_chng_0               (i_tx_rate_chng_0           ),//I
        .i_tx_rate_chng_1               (i_tx_rate_chng_1           ),//I
        .i_tx_rate_chng_2               (i_tx_rate_chng_2           ),//I
        .i_tx_rate_chng_3               (i_tx_rate_chng_3           ),//I
        .i_pll_lock_tx_0                (i_pll_lock_tx_0            ),//I
        .i_pll_lock_tx_1                (i_pll_lock_tx_1            ),//I
        .i_pll_lock_tx_2                (i_pll_lock_tx_2            ),//I
        .i_pll_lock_tx_3                (i_pll_lock_tx_3            ),//I
        .i_pll_tx_sel_0                 (i_pll_tx_sel_0             ),//I
        .i_pll_tx_sel_1                 (i_pll_tx_sel_1             ),//I
        .i_pll_tx_sel_2                 (i_pll_tx_sel_2             ),//I
        .i_pll_tx_sel_3                 (i_pll_tx_sel_3             ),//I
        .i_txckdiv_0                    (i_txckdiv_0                ),//I
        .i_txckdiv_1                    (i_txckdiv_1                ),//I
        .i_txckdiv_2                    (i_txckdiv_2                ),//I
        .i_txckdiv_3                    (i_txckdiv_3                ),//I
        .i_tx_pma_rst_0                 (i_tx_pma_rst_0             ),//I
        .i_tx_pma_rst_1                 (i_tx_pma_rst_1             ),//I
        .i_tx_pma_rst_2                 (i_tx_pma_rst_2             ),//I
        .i_tx_pma_rst_3                 (i_tx_pma_rst_3             ),//I
        .i_tx_pcs_rst_0                 (i_tx_pcs_rst_0             ),//I
        .i_tx_pcs_rst_1                 (i_tx_pcs_rst_1             ),//I
        .i_tx_pcs_rst_2                 (i_tx_pcs_rst_2             ),//I
        .i_tx_pcs_rst_3                 (i_tx_pcs_rst_3             ),//I
        .o_txlane_done_0                (o_txlane_done_0            ),//O
        .o_txlane_done_1                (o_txlane_done_1            ),//O
        .o_txlane_done_2                (o_txlane_done_2            ),//O
        .o_txlane_done_3                (o_txlane_done_3            ),//O
        .o_txckdiv_done_0               (o_tx_ckdiv_done_0          ),//O
        .o_txckdiv_done_1               (o_tx_ckdiv_done_1          ),//O
        .o_txckdiv_done_2               (o_tx_ckdiv_done_2          ),//O
        .o_txckdiv_done_3               (o_tx_ckdiv_done_3          ),//O
        .TX_PMA_RST_0                   (P_TX_PMA_RST_0             ),//O
        .TX_PMA_RST_1                   (P_TX_PMA_RST_1             ),//O
        .TX_PMA_RST_2                   (P_TX_PMA_RST_2             ),//O
        .TX_PMA_RST_3                   (P_TX_PMA_RST_3             ),//O
        .TX_RATE_0                      (P_TX_RATE_0                ),//O
        .TX_RATE_1                      (P_TX_RATE_1                ),//O
        .TX_RATE_2                      (P_TX_RATE_2                ),//O
        .TX_RATE_3                      (P_TX_RATE_3                ),//O
        .PCS_TX_RST_0                   (P_PCS_TX_RST_0             ),//O
        .PCS_TX_RST_1                   (P_PCS_TX_RST_1             ),//O
        .PCS_TX_RST_2                   (P_PCS_TX_RST_2             ),//O
        .PCS_TX_RST_3                   (P_PCS_TX_RST_3             ),//O
        .TX_LANE_POWERDOWN_0            (P_TX_LANE_POWERDOWN_0      ),//O
        .TX_LANE_POWERDOWN_1            (P_TX_LANE_POWERDOWN_1      ),//O
        .TX_LANE_POWERDOWN_2            (P_TX_LANE_POWERDOWN_2      ),//O
        .TX_LANE_POWERDOWN_3            (P_TX_LANE_POWERDOWN_3      ),//O
        .lane_sync_0                    (lane_sync_0                ),//O
        .lane_sync_1                    (lane_sync_1                ),//O
        .lane_sync_2                    (lane_sync_2                ),//O
        .lane_sync_3                    (lane_sync_3                ),//O
        .rate_change_on_0               (rate_change_on_0           ),//O
        .rate_change_on_1               (rate_change_on_1           ),//O
        .rate_change_on_2               (rate_change_on_2           ),//O
        .rate_change_on_3               (rate_change_on_3           )//O
    );
    
    ipm2t_hssthp_rst_rx_v1_5b#(
        .FREE_CLOCK_FREQ                (FREE_CLOCK_FREQ            ),  
        .CH0_RX_ENABLE                  (CH0_RX_ENABLE              ), 
        .CH1_RX_ENABLE                  (CH1_RX_ENABLE              ), 
        .CH2_RX_ENABLE                  (CH2_RX_ENABLE              ), 
        .CH3_RX_ENABLE                  (CH3_RX_ENABLE              ), 
        .CH0_MULT_LANE_MODE             (CH0_RX_MULT_LANE_MODE      ), 
        .CH1_MULT_LANE_MODE             (CH1_RX_MULT_LANE_MODE      ), 
        .CH2_MULT_LANE_MODE             (CH2_RX_MULT_LANE_MODE      ), 
        .CH3_MULT_LANE_MODE             (CH3_RX_MULT_LANE_MODE      ), 
        .PCS_CH0_BYPASS_WORD_ALIGN      (PCS_CH0_BYPASS_WORD_ALIGN  ),
        .PCS_CH1_BYPASS_WORD_ALIGN      (PCS_CH1_BYPASS_WORD_ALIGN  ),
        .PCS_CH2_BYPASS_WORD_ALIGN      (PCS_CH2_BYPASS_WORD_ALIGN  ),
        .PCS_CH3_BYPASS_WORD_ALIGN      (PCS_CH3_BYPASS_WORD_ALIGN  ),
        .PCS_CH0_BYPASS_BONDING         (PCS_CH0_BYPASS_BONDING     ),  
        .PCS_CH1_BYPASS_BONDING         (PCS_CH1_BYPASS_BONDING     ),   
        .PCS_CH2_BYPASS_BONDING         (PCS_CH2_BYPASS_BONDING     ),  
        .PCS_CH3_BYPASS_BONDING         (PCS_CH3_BYPASS_BONDING     ),  
        .PCS_CH0_BYPASS_CTC             (PCS_CH0_BYPASS_CTC         ),      
        .PCS_CH1_BYPASS_CTC             (PCS_CH1_BYPASS_CTC         ),      
        .PCS_CH2_BYPASS_CTC             (PCS_CH2_BYPASS_CTC         ),       
        .PCS_CH3_BYPASS_CTC             (PCS_CH3_BYPASS_CTC         ),
        .LX_RX_CKDIV_0                  (LX_RX_CKDIV_0              ),
        .LX_RX_CKDIV_1                  (LX_RX_CKDIV_1              ),
        .LX_RX_CKDIV_2                  (LX_RX_CKDIV_2              ),
        .LX_RX_CKDIV_3                  (LX_RX_CKDIV_3              ),
        .CH0_RX_PLL_SEL                 (CH0_RX_PLL_SEL             ),
        .CH1_RX_PLL_SEL                 (CH1_RX_PLL_SEL             ),
        .CH2_RX_PLL_SEL                 (CH2_RX_PLL_SEL             ),
        .CH3_RX_PLL_SEL                 (CH3_RX_PLL_SEL             ),
        .CH0_RX_RATE                    (CH0_RX_RATE                ),
        .CH1_RX_RATE                    (CH1_RX_RATE                ),
        .CH2_RX_RATE                    (CH2_RX_RATE                ),
        .CH3_RX_RATE                    (CH3_RX_RATE                ),
        .PCS_RX_CLK_EXPLL_USE_CH0       (PCS_RX_CLK_EXPLL_USE_CH0   ),
        .PCS_RX_CLK_EXPLL_USE_CH1       (PCS_RX_CLK_EXPLL_USE_CH1   ),
        .PCS_RX_CLK_EXPLL_USE_CH2       (PCS_RX_CLK_EXPLL_USE_CH2   ),
        .PCS_RX_CLK_EXPLL_USE_CH3       (PCS_RX_CLK_EXPLL_USE_CH3   ),
        .CH0_RXPCS_ALIGN_TIMER          (CH0_RXPCS_ALIGN_TIMER      ),
        .CH1_RXPCS_ALIGN_TIMER          (CH1_RXPCS_ALIGN_TIMER      ),
        .CH2_RXPCS_ALIGN_TIMER          (CH2_RXPCS_ALIGN_TIMER      ),
        .CH3_RXPCS_ALIGN_TIMER          (CH3_RXPCS_ALIGN_TIMER      ),
        .CH0_BOND_WTCHDG_CNTR1_WIDTH    (CH0_BOND_WTCHDG_CNTR1_WIDTH),
        .CH2_BOND_WTCHDG_CNTR1_WIDTH    (CH2_BOND_WTCHDG_CNTR1_WIDTH),
        .CH0_BOND_WTCHDG_CNTR2_WIDTH    (CH0_BOND_WTCHDG_CNTR2_WIDTH),
        .CH2_BOND_WTCHDG_CNTR2_WIDTH    (CH2_BOND_WTCHDG_CNTR2_WIDTH) 
        
    ) hssthp_rst_rx (
        .clk                            (i_free_clk                 ),//I
        .i_hssthp_fifo_clr_0            (i_hssthp_fifo_clr_0        ),//I
        .i_hssthp_fifo_clr_1            (i_hssthp_fifo_clr_1        ),//I
        .i_hssthp_fifo_clr_2            (i_hssthp_fifo_clr_2        ),//I
        .i_hssthp_fifo_clr_3            (i_hssthp_fifo_clr_3        ),//I
        .i_lpll_done_0                  (o_lpll_done_0              ),//I
        .i_lpll_done_1                  (o_lpll_done_1              ),//I
        .i_lpll_done_2                  (o_lpll_done_2              ),//I
        .i_lpll_done_3                  (o_lpll_done_3              ),//I
        .i_hpll_done                    (o_hpll_done                ),//I
        .i_rxlane_rst_0                 (i_rxlane_rst_0             ),//I
        .i_rxlane_rst_1                 (i_rxlane_rst_1             ),//I
        .i_rxlane_rst_2                 (i_rxlane_rst_2             ),//I
        .i_rxlane_rst_3                 (i_rxlane_rst_3             ),//I
        .i_rx_rate_chng_0               (p_rx_rate_chng_0           ),//I
        .i_rx_rate_chng_1               (p_rx_rate_chng_1           ),//I
        .i_rx_rate_chng_2               (p_rx_rate_chng_2           ),//I
        .i_rx_rate_chng_3               (p_rx_rate_chng_3           ),//I
        .i_rxckdiv_0                    (p_rxckdiv_0                ),//I
        .i_rxckdiv_1                    (p_rxckdiv_1                ),//I
        .i_rxckdiv_2                    (p_rxckdiv_2                ),//I
        .i_rxckdiv_3                    (p_rxckdiv_3                ),//I
        .i_force_rxfsm_det_0            (i_force_rxfsm_det_0        ),//I
        .i_force_rxfsm_det_1            (i_force_rxfsm_det_1        ),//I
        .i_force_rxfsm_det_2            (i_force_rxfsm_det_2        ),//I
        .i_force_rxfsm_det_3            (i_force_rxfsm_det_3        ),//I
        .i_force_rxfsm_lsm_0            (i_force_rxfsm_lsm_0        ),//I
        .i_force_rxfsm_lsm_1            (i_force_rxfsm_lsm_1        ),//I
        .i_force_rxfsm_lsm_2            (i_force_rxfsm_lsm_2        ),//I
        .i_force_rxfsm_lsm_3            (i_force_rxfsm_lsm_3        ),//I
        .i_force_rxfsm_cdr_0            (i_force_rxfsm_cdr_0        ),//I
        .i_force_rxfsm_cdr_1            (i_force_rxfsm_cdr_1        ),//I
        .i_force_rxfsm_cdr_2            (i_force_rxfsm_cdr_2        ),//I
        .i_force_rxfsm_cdr_3            (i_force_rxfsm_cdr_3        ),//I
        .i_tx_ckdiv_done_0              (o_tx_ckdiv_done_0          ),//O
        .i_tx_ckdiv_done_1              (o_tx_ckdiv_done_1          ),//O
        .i_tx_ckdiv_done_2              (o_tx_ckdiv_done_2          ),//O
        .i_tx_ckdiv_done_3              (o_tx_ckdiv_done_3          ),//O
        .i_bond_wtchdg_clr              (i_bond_wtchdg_clr          ),//I
        .i_pll_lock_rx_0                (i_pll_lock_rx_0            ),//I
        .i_pll_lock_rx_1                (i_pll_lock_rx_1            ),//I
        .i_pll_lock_rx_2                (i_pll_lock_rx_2            ),//I
        .i_pll_lock_rx_3                (i_pll_lock_rx_3            ),//I
        .i_rx_pma_rst_0                 (i_rx_pma_rst_0             ),//I
        .i_rx_pma_rst_1                 (i_rx_pma_rst_1             ),//I
        .i_rx_pma_rst_2                 (i_rx_pma_rst_2             ),//I
        .i_rx_pma_rst_3                 (i_rx_pma_rst_3             ),//I
        .i_rx_pcs_rst_0                 (i_rx_pcs_rst_0             ),//I
        .i_rx_pcs_rst_1                 (i_rx_pcs_rst_1             ),//I
        .i_rx_pcs_rst_2                 (i_rx_pcs_rst_2             ),//I
        .i_rx_pcs_rst_3                 (i_rx_pcs_rst_3             ),//I
        .i_pll_rx_sel_0                 (i_pll_rx_sel_0             ),//I
        .i_pll_rx_sel_1                 (i_pll_rx_sel_1             ),//I
        .i_pll_rx_sel_2                 (i_pll_rx_sel_2             ),//I
        .i_pll_rx_sel_3                 (i_pll_rx_sel_3             ),//I
        .i_rx_data_sel_en_0             (i_rx_data_sel_en_0         ),//I
        .i_rx_data_sel_en_1             (i_rx_data_sel_en_1         ),//I
        .i_rx_data_sel_en_2             (i_rx_data_sel_en_2         ),//I
        .i_rx_data_sel_en_3             (i_rx_data_sel_en_3         ),//I
        .i_rx_data_sel_0                (i_rx_data_sel_0            ),//I
        .i_rx_data_sel_1                (i_rx_data_sel_1            ),//I
        .i_rx_data_sel_2                (i_rx_data_sel_2            ),//I
        .i_rx_data_sel_3                (i_rx_data_sel_3            ),//I
        .P_RX_SIGDET_STATUS_0           (P_RX_SIGDET_STATUS_0       ),//I
        .P_RX_SIGDET_STATUS_1           (P_RX_SIGDET_STATUS_1       ),//I
        .P_RX_SIGDET_STATUS_2           (P_RX_SIGDET_STATUS_2       ),//I
        .P_RX_SIGDET_STATUS_3           (P_RX_SIGDET_STATUS_3       ),//I
        .P_RX_READY_0                   (P_RX_READY_0               ),//I
        .P_RX_READY_1                   (P_RX_READY_1               ),//I
        .P_RX_READY_2                   (P_RX_READY_2               ),//I
        .P_RX_READY_3                   (P_RX_READY_3               ),//I
        .P_PCS_LSM_SYNCED_0             (P_PCS_LSM_SYNCED_0         ),//I
        .P_PCS_LSM_SYNCED_1             (P_PCS_LSM_SYNCED_1         ),//I
        .P_PCS_LSM_SYNCED_2             (P_PCS_LSM_SYNCED_2         ),//I
        .P_PCS_LSM_SYNCED_3             (P_PCS_LSM_SYNCED_3         ),//I
        .P_PCS_RX_MCB_STATUS_0          (P_PCS_RX_MCB_STATUS_0      ),//I
        .P_PCS_RX_MCB_STATUS_1          (P_PCS_RX_MCB_STATUS_1      ),//I
        .P_PCS_RX_MCB_STATUS_2          (P_PCS_RX_MCB_STATUS_2      ),//I
        .P_PCS_RX_MCB_STATUS_3          (P_PCS_RX_MCB_STATUS_3      ),//I
        .PMA_RX_PD_0                    (P_PMA_RX_PD_0              ),//O
        .PMA_RX_PD_1                    (P_PMA_RX_PD_1              ),//O
        .PMA_RX_PD_2                    (P_PMA_RX_PD_2              ),//O
        .PMA_RX_PD_3                    (P_PMA_RX_PD_3              ),//O
        .P_PCS_RX_RST_0                 (P_PCS_RX_RST_0             ),//O
        .P_PCS_RX_RST_1                 (P_PCS_RX_RST_1             ),//O
        .P_PCS_RX_RST_2                 (P_PCS_RX_RST_2             ),//O
        .P_PCS_RX_RST_3                 (P_PCS_RX_RST_3             ),//O
        .RX_RATE_0                      (P_RX_RATE_0                ),//O
        .RX_RATE_1                      (P_RX_RATE_1                ),//O
        .RX_RATE_2                      (P_RX_RATE_2                ),//O
        .RX_RATE_3                      (P_RX_RATE_3                ),//O
        .RX_PMA_RST_0                   (P_RX_PMA_RST_0             ),//O
        .RX_PMA_RST_1                   (P_RX_PMA_RST_1             ),//O
        .RX_PMA_RST_2                   (P_RX_PMA_RST_2             ),//O
        .RX_PMA_RST_3                   (P_RX_PMA_RST_3             ),//O
        .o_rxckdiv_done_0               (o_rx_ckdiv_done_0          ),//O
        .o_rxckdiv_done_1               (o_rx_ckdiv_done_1          ),//O
        .o_rxckdiv_done_2               (o_rx_ckdiv_done_2          ),//O
        .o_rxckdiv_done_3               (o_rx_ckdiv_done_3          ),//O
        .o_rxlane_done_0                (o_rxlane_done_0            ),//O
        .o_rxlane_done_1                (o_rxlane_done_1            ),//O
        .o_rxlane_done_2                (o_rxlane_done_2            ),//O
        .o_rxlane_done_3                (o_rxlane_done_3            )//O
    );
assign P_TX_SYNC = lane_sync_0||lane_sync_1||lane_sync_2||lane_sync_3 ;
assign P_TX_RATE_CHANGE_ON = rate_change_on_0&&rate_change_on_1&&rate_change_on_2&&rate_change_on_3 ;
assign P_LANE_POWERDOWN_0 = 1'b0 ;
assign P_LANE_POWERDOWN_1 = 1'b0 ;
assign P_LANE_POWERDOWN_2 = 1'b0 ;
assign P_LANE_POWERDOWN_3 = 1'b0 ;
assign P_LANE_RST_0 = 1'b0 ;
assign P_LANE_RST_1 = 1'b0 ;
assign P_LANE_RST_2 = 1'b0 ;
assign P_LANE_RST_3 = 1'b0 ;
end
else begin : USER_MODE
    assign o_wtchdg_st_lpll_0      = 2'b0                  ;
    assign o_wtchdg_st_lpll_1      = 2'b0                  ;
    assign o_wtchdg_st_lpll_2      = 2'b0                  ;
    assign o_wtchdg_st_lpll_3      = 2'b0                  ;
    assign o_lpll_done_0           = 1'b0                  ;
    assign o_lpll_done_1           = 1'b0                  ;
    assign o_lpll_done_2           = 1'b0                  ;
    assign o_lpll_done_3           = 1'b0                  ;
    assign o_txlane_done_0         = 1'b0                  ;
    assign o_txlane_done_1         = 1'b0                  ;
    assign o_txlane_done_2         = 1'b0                  ;
    assign o_txlane_done_3         = 1'b0                  ;
    assign o_tx_ckdiv_done_0       = 1'b0                  ;
    assign o_tx_ckdiv_done_1       = 1'b0                  ;
    assign o_tx_ckdiv_done_2       = 1'b0                  ;
    assign o_tx_ckdiv_done_3       = 1'b0                  ;
    assign o_rxlane_done_0         = 1'b0                  ;
    assign o_rxlane_done_1         = 1'b0                  ;
    assign o_rxlane_done_2         = 1'b0                  ;
    assign o_rxlane_done_3         = 1'b0                  ;
    assign o_rx_ckdiv_done_0       = 1'b0                  ;
    assign o_rx_ckdiv_done_1       = 1'b0                  ;
    assign o_rx_ckdiv_done_2       = 1'b0                  ;
    assign o_rx_ckdiv_done_3       = 1'b0                  ;
    //Direct To HSST
    assign P_TX_SYNC            = i_f_tx_sync              ;
    assign P_TX_RATE_CHANGE_ON  = i_f_tx_rate_change_on    ;
    assign P_LPLL_POWERDOWN_0   = i_f_lpll_powerdown_0     ;
    assign P_LPLL_POWERDOWN_1   = i_f_lpll_powerdown_1     ;
    assign P_LPLL_POWERDOWN_2   = i_f_lpll_powerdown_2     ;
    assign P_LPLL_POWERDOWN_3   = i_f_lpll_powerdown_3     ;
    assign P_LPLL_RST_0         = i_f_lpll_rst_0           ;
    assign P_LPLL_RST_1         = i_f_lpll_rst_1           ;
    assign P_LPLL_RST_2         = i_f_lpll_rst_2           ;
    assign P_LPLL_RST_3         = i_f_lpll_rst_3           ;
    assign P_LANE_POWERDOWN_0   = i_f_lane_powerdown_0     ;
    assign P_LANE_POWERDOWN_1   = i_f_lane_powerdown_1     ;
    assign P_LANE_POWERDOWN_2   = i_f_lane_powerdown_2     ;
    assign P_LANE_POWERDOWN_3   = i_f_lane_powerdown_3     ;
    assign P_LANE_RST_0         = i_f_lane_rst_0           ;
    assign P_LANE_RST_1         = i_f_lane_rst_1           ;
    assign P_LANE_RST_2         = i_f_lane_rst_2           ;
    assign P_LANE_RST_3         = i_f_lane_rst_3           ;
    assign P_TX_RATE_0          = i_f_tx_rate_0            ;
    assign P_TX_RATE_1          = i_f_tx_rate_1            ;
    assign P_TX_RATE_2          = i_f_tx_rate_2            ;
    assign P_TX_RATE_3          = i_f_tx_rate_3            ;
    assign P_PCS_TX_RST_0       = i_f_pcs_tx_rst_0         ;
    assign P_PCS_TX_RST_1       = i_f_pcs_tx_rst_1         ;
    assign P_PCS_TX_RST_2       = i_f_pcs_tx_rst_2         ;
    assign P_PCS_TX_RST_3       = i_f_pcs_tx_rst_3         ;
    assign P_TX_LANE_POWERDOWN_0= i_f_tx_lane_powerdown_0  ;
    assign P_TX_LANE_POWERDOWN_1= i_f_tx_lane_powerdown_1  ;
    assign P_TX_LANE_POWERDOWN_2= i_f_tx_lane_powerdown_2  ;
    assign P_TX_LANE_POWERDOWN_3= i_f_tx_lane_powerdown_3  ;
    assign P_PMA_RX_PD_0        = i_f_pma_rx_pd_0          ;
    assign P_PMA_RX_PD_1        = i_f_pma_rx_pd_1          ;
    assign P_PMA_RX_PD_2        = i_f_pma_rx_pd_2          ;
    assign P_PMA_RX_PD_3        = i_f_pma_rx_pd_3          ;
    assign P_PCS_RX_RST_0       = i_f_pcs_rx_rst_0         ;
    assign P_PCS_RX_RST_1       = i_f_pcs_rx_rst_1         ;
    assign P_PCS_RX_RST_2       = i_f_pcs_rx_rst_2         ;
    assign P_PCS_RX_RST_3       = i_f_pcs_rx_rst_3         ;
    assign P_RX_PMA_RST_0       = i_f_rx_pma_rst_0         ;
    assign P_RX_PMA_RST_1       = i_f_rx_pma_rst_1         ;
    assign P_RX_PMA_RST_2       = i_f_rx_pma_rst_2         ;
    assign P_RX_PMA_RST_3       = i_f_rx_pma_rst_3         ;
    assign P_RX_RATE_0          = i_f_rx_rate_0            ;
    assign P_RX_RATE_1          = i_f_rx_rate_1            ;
    assign P_RX_RATE_2          = i_f_rx_rate_2            ;
    assign P_RX_RATE_3          = i_f_rx_rate_3            ;
    assign P_TX_PMA_RST_0       = i_f_tx_pma_rst_0         ;
    assign P_TX_PMA_RST_1       = i_f_tx_pma_rst_1         ;
    assign P_TX_PMA_RST_2       = i_f_tx_pma_rst_2         ;
    assign P_TX_PMA_RST_3       = i_f_tx_pma_rst_3         ;
    assign P_HPLL_RST           = i_f_hpll_rst             ;
end
endgenerate

endmodule
