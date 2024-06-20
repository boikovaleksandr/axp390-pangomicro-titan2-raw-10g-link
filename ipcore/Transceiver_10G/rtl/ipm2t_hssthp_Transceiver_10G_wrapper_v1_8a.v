
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

module ipm2t_hssthp_Transceiver_10G_wrapper_v1_8a#(
    //--------Global Parameter--------//
    
    parameter            HPLL_EN                       = "TRUE"              ,//TRUE, FALSE; for HPLL enable
    
    parameter            CHANNEL0_EN                   = "TRUE"              ,//TRUE, FALSE; for Channel0 enable
    
    parameter            CHANNEL1_EN                   = "FALSE"              ,//TRUE, FALSE; for Channel1 enable
    
    parameter            CHANNEL2_EN                   = "FALSE"              ,//TRUE, FALSE; for Channel2 enable
    
    parameter            CHANNEL3_EN                   = "FALSE"              ,//TRUE, FALSE; for Channel3 enable
    
    parameter            CH0_TX_MULT_LANE_MODE         = 1                ,//Lane0 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    
    parameter            CH0_RX_MULT_LANE_MODE         = 1                ,//Lane0 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    
    parameter            CH1_TX_MULT_LANE_MODE         = 1                ,//Lane0 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    
    parameter            CH1_RX_MULT_LANE_MODE         = 1                ,//Lane0 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    
    parameter            CH2_TX_MULT_LANE_MODE         = 1                ,//Lane0 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    
    parameter            CH2_RX_MULT_LANE_MODE         = 1                ,//Lane0 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    
    parameter            CH3_TX_MULT_LANE_MODE         = 1                ,//Lane0 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    
    parameter            CH3_RX_MULT_LANE_MODE         = 1                ,//Lane0 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    
    parameter            REFCLK_PAD0_EN                = "TRUE"              ,//TRUE, FALSE; for REFCLK_PAD0 enable
    
    parameter            REFCLK_PAD1_EN                = "FALSE"              ,//TRUE, FALSE; for REFCLK_PAD1 enable
    
    parameter            PMA_REG_HPLL_REFCLK_SEL       = "REFERENCE_CLOCK_0"  ,//HPLL  REFCLK Selection
    
    parameter            PMA_REG_LANE0_PLL_REFCLK_SEL  = "REFERENCE_CLOCK_0"  ,//LPLL0 REFCLK Selection
    
    parameter            PMA_REG_LANE1_PLL_REFCLK_SEL  = "REFERENCE_CLOCK_0"  ,//LPLL1 REFCLK Selection
    
    parameter            PMA_REG_LANE2_PLL_REFCLK_SEL  = "REFERENCE_CLOCK_0"  ,//LPLL2 REFCLK Selection
    
    parameter            PMA_REG_LANE3_PLL_REFCLK_SEL  = "REFERENCE_CLOCK_0"   //LPLL3 REFCLK Selection
)(
    //--------fabric Port--------//
    input  wire             p_cfg_clk                                         ,//input               
    input  wire             p_cfg_rst                                         ,//input               
    input  wire             p_cfg_psel                                        ,//input               
    input  wire             p_cfg_enable                                      ,//input               
    input  wire             p_cfg_write                                       ,//input               
    input  wire [15:0]      p_cfg_addr                                        ,//input [15:0]        
    input  wire [7:0]       p_cfg_wdata                                       ,//input [7:0]     
    output wire             p_cfg_ready                                       ,//output              
    output wire [7:0]       p_cfg_rdata                                       ,//output [7:0]        
    output wire             p_cfg_int                                         ,//output     
    input  wire             p_fabric_refclk                                   ,//input     
    output wire             p_calib_done                                      ,//output     
    //----------HPLL Port----------//
    
     //PAD
    input  wire             PAD_REFCLKN_0                                      ,//input
    input  wire             PAD_REFCLKP_0                                      ,//input
    input  wire             PAD_REFCLKN_1                                      ,//input
    input  wire             PAD_REFCLKP_1                                      ,//input
    //SRB
    input  wire             P_COM_POWERDOWN                                    ,//input
    input  wire             P_HPLL_POWERDOWN                                   ,//input
    input  wire             P_HPLL_RST                                         ,//input
    input  wire             P_TX_SYNC                                          ,//input
    input  wire             P_TX_RATE_CHANGE_ON_0                              ,//input
    input  wire             P_TX_RATE_CHANGE_ON_1                              ,//input
    input  wire             P_HPLL_DIV_SYNC                                    ,//input
    input  wire             P_REFCLK_DIV_SYNC                                  ,//input
    input  wire             P_HPLL_VCO_CALIB_EN                                ,//input
    output wire             P_REFCK2CORE_0                                     ,//output
    output wire             P_REFCK2CORE_1                                     ,//output
    output wire             P_HPLL_READY                                       ,//output
    input  wire             P_HPLL_DIV_CHANGE                                  ,//input
    //--------CHANNEL0 Port--------//
     //PAD
    input  wire             P_RX_SDN_0                                         ,//input
    input  wire             P_RX_SDP_0                                         ,//input
    output wire             P_TX_SDN_0                                         ,//output
    output wire             P_TX_SDP_0                                         ,//output
     //SRB                                                                                                  
    input  wire             P_RX_CLK_FR_CORE_0                                 ,//input
    input  wire             P_RCLK2_FR_CORE_0                                  ,//input
    input  wire             P_TX_CLK_FR_CORE_0                                 ,//input
    input  wire             P_TCLK2_FR_CORE_0                                  ,//input
    input  wire             P_PCS_RX_RST_0                                     ,//input
    input  wire             P_PCS_TX_RST_0                                     ,//input
    input  wire             P_EXT_BRIDGE_PCS_RST_0                             ,//input
    input  wire [87:0]      P_TDATA_0                                          ,//input  [87:0]
    input  wire             P_PCIE_EI_H_0                                      ,//input
    input  wire             P_PCIE_EI_L_0                                      ,//input
    input  wire [15:0]      P_TX_DEEMP_0                                       ,//input  [15:0]
    input  wire [1:0]       P_TX_DEEMP_POST_SEL_0                              ,//input  [1:0]
    input  wire             P_BLK_ALIGN_CTRL_0                                 ,//input
    input  wire             P_TX_ENC_TYPE_0                                    ,//input
    input  wire             P_RX_DEC_TYPE_0                                    ,//input
    input  wire             P_PCS_BIT_SLIP_0                                   ,//input
    input  wire             P_PCS_WORD_ALIGN_EN_0                              ,//input
    input  wire             P_RX_POLARITY_INVERT_0                             ,//input
    input  wire             P_PCS_MCB_EXT_EN_0                                 ,//input
    input  wire             P_PCS_NEAREND_LOOP_0                               ,//input
    input  wire             P_PCS_FAREND_LOOP_0                                ,//input
    input  wire             P_PMA_NEAREND_PLOOP_0                              ,//input
    input  wire             P_PMA_NEAREND_SLOOP_0                              ,//input
    input  wire             P_PMA_FAREND_PLOOP_0                               ,//input
    input  wire             P_PCS_PRBS_EN_0                                    ,//input
    output wire             P_RX_PRBS_ERROR_0                                  ,//output
    output wire             P_PCS_RX_MCB_STATUS_0                              ,//output
    output wire             P_PCS_LSM_SYNCED_0                                 ,//output
    output wire [87:0]      P_RDATA_0                                          ,//output [87:0]
    output wire             P_RXDVLD_0                                         ,//output
    output wire             P_RXDVLD_H_0                                       ,//output
    output wire [5:0]       P_RXSTATUS_0                                       ,//output [5:0]
    output wire             P_RCLK2FABRIC_0                                    ,//output
    output wire             P_TCLK2FABRIC_0                                    ,//output
    input  wire             P_LANE_POWERDOWN_0                                 ,//input
    input  wire             P_LANE_RST_0                                       ,//input
    input  wire             P_RX_LANE_POWERDOWN_0                              ,//input
    input  wire             P_RX_PMA_RST_0                                     ,//input
    input  wire             P_RX_EYE_RST_0                                     ,//input
    input  wire             P_RX_EYE_EN_0                                      ,//input
    input  wire [7:0]       P_RX_EYE_TAP_0                                     ,//input  [7:0]
    input  wire [7:0]       P_RX_PIC_EYE_0                                     ,//input  [7:0]
    input  wire [7:0]       P_RX_PIC_FASTLOCK_0                                ,//input  [7:0]
    input  wire             P_RX_PIC_FASTLOCK_STROBE_0                         ,//input
    input  wire             P_EM_RD_TRIGGER_0                                  ,//input
    input  wire [1:0]       P_EM_MODE_CTRL_0                                   ,//input  [1:0]
    output wire [2:0]       P_EM_ERROR_CNT_0                                   ,//output [2:0]
    input  wire             P_RX_SLIP_RST_0                                    ,//input
    input  wire             P_RX_SLIP_EN_0                                     ,//input
    input  wire             P_LPLL_POWERDOWN_0                                 ,//input
    input  wire             P_LPLL_RST_0                                       ,//input
    output wire             P_LPLL_READY_0                                     ,//output
    output wire             P_RX_SIGDET_STATUS_0                               ,//output
    output wire             P_RX_SATA_COMINIT_0                                ,//output
    output wire             P_RX_SATA_COMWAKE_0                                ,//output
    output wire             P_RX_READY_0                                       ,//output
    input  wire             P_TX_LS_DATA_0                                     ,//input
    input  wire             P_TX_BEACON_EN_0                                   ,//input
    input  wire             P_TX_SWING_0                                       ,//input
    input  wire             P_TX_RXDET_REQ_0                                   ,//input
    output wire             P_TX_RXDET_STATUS_0                                ,//output
    input  wire [1:0]       P_TX_RATE_0                                        ,//input  [1:0]
    input  wire [2:0]       P_TX_BUSWIDTH_0                                    ,//input  [2:0]
    input  wire [2:0]       P_TX_FREERUN_BUSWIDTH_0                            ,//input  [2:0]
    input  wire [2:0]       P_TX_MARGIN_0                                      ,//input  [2:0]
    input  wire             P_TX_PMA_RST_0                                     ,//input
    input  wire             P_TX_LANE_POWERDOWN_0                              ,//input
    input  wire             P_TX_PIC_EN_0                                      ,//input
    input  wire [1:0]       P_RX_RATE_0                                        ,//input  [1:0]
    input  wire [2:0]       P_RX_BUSWIDTH_0                                    ,//input  [2:0]
    input  wire             P_RX_HIGHZ_0                                       ,//input
    input  wire             P_RX_DFE_RST_0                                     ,//input
    input  wire             P_RX_LEQ_RST_0                                     ,//input
    input  wire             P_RX_DFE_EN_0                                      ,//input
    input  wire             P_RX_T1_DFE_EN_0                                   ,//input
    input  wire             P_RX_T2_DFE_EN_0                                   ,//input
    input  wire             P_RX_T3_DFE_EN_0                                   ,//input
    input  wire             P_RX_T4_DFE_EN_0                                   ,//input
    input  wire             P_RX_T5_DFE_EN_0                                   ,//input
    input  wire             P_RX_T6_DFE_EN_0                                   ,//input
    input  wire             P_RX_T1_EN_0                                       ,//input
    input  wire             P_RX_CDRX_EN_0                                     ,//input
    input  wire             P_RX_SLIDING_EN_0                                  ,//input
    input  wire             P_RX_SLIDING_RST_0                                 ,//input
    input  wire             P_RX_SLICER_DCCAL_EN_0                             ,//input
    input  wire             P_RX_SLICER_DCCAL_RST_0                            ,//input
    input  wire             P_RX_CTLE_DCCAL_EN_0                               ,//input
    input  wire             P_RX_CTLE_DCCAL_RST_0                              ,//input
    //--------CHANNEL1 Port--------//
     //PAD
    input  wire             P_RX_SDN_1                                         ,//input
    input  wire             P_RX_SDP_1                                         ,//input
    output wire             P_TX_SDN_1                                         ,//output
    output wire             P_TX_SDP_1                                         ,//output
     //SRB                                                                                                  
    input  wire             P_RX_CLK_FR_CORE_1                                 ,//input
    input  wire             P_RCLK2_FR_CORE_1                                  ,//input
    input  wire             P_TX_CLK_FR_CORE_1                                 ,//input
    input  wire             P_TCLK2_FR_CORE_1                                  ,//input
    input  wire             P_PCS_RX_RST_1                                     ,//input
    input  wire             P_PCS_TX_RST_1                                     ,//input
    input  wire             P_EXT_BRIDGE_PCS_RST_1                             ,//input
    input  wire [87:0]      P_TDATA_1                                          ,//input  [87:0]
    input  wire             P_PCIE_EI_H_1                                      ,//input
    input  wire             P_PCIE_EI_L_1                                      ,//input
    input  wire [15:0]      P_TX_DEEMP_1                                       ,//input  [15:0]
    input  wire [1:0]       P_TX_DEEMP_POST_SEL_1                              ,//input  [1:0]
    input  wire             P_BLK_ALIGN_CTRL_1                                 ,//input
    input  wire             P_TX_ENC_TYPE_1                                    ,//input
    input  wire             P_RX_DEC_TYPE_1                                    ,//input
    input  wire             P_PCS_BIT_SLIP_1                                   ,//input
    input  wire             P_PCS_WORD_ALIGN_EN_1                              ,//input
    input  wire             P_RX_POLARITY_INVERT_1                             ,//input
    input  wire             P_PCS_MCB_EXT_EN_1                                 ,//input
    input  wire             P_PCS_NEAREND_LOOP_1                               ,//input
    input  wire             P_PCS_FAREND_LOOP_1                                ,//input
    input  wire             P_PMA_NEAREND_PLOOP_1                              ,//input
    input  wire             P_PMA_NEAREND_SLOOP_1                              ,//input
    input  wire             P_PMA_FAREND_PLOOP_1                               ,//input
    input  wire             P_PCS_PRBS_EN_1                                    ,//input
    output wire             P_RX_PRBS_ERROR_1                                  ,//output
    output wire             P_PCS_RX_MCB_STATUS_1                              ,//output
    output wire             P_PCS_LSM_SYNCED_1                                 ,//output
    output wire [87:0]      P_RDATA_1                                          ,//output [87:0]
    output wire             P_RXDVLD_1                                         ,//output
    output wire             P_RXDVLD_H_1                                       ,//output
    output wire [5:0]       P_RXSTATUS_1                                       ,//output [5:0]
    output wire             P_RCLK2FABRIC_1                                    ,//output
    output wire             P_TCLK2FABRIC_1                                    ,//output
    input wire              P_LANE_POWERDOWN_1                                 ,//input
    input wire              P_LANE_RST_1                                       ,//input
    input wire              P_RX_LANE_POWERDOWN_1                              ,//input
    input wire              P_RX_PMA_RST_1                                     ,//input
    input wire              P_RX_EYE_RST_1                                     ,//input
    input wire              P_RX_EYE_EN_1                                      ,//input
    input wire [7:0]        P_RX_EYE_TAP_1                                     ,//input  [7:0]
    input wire [7:0]        P_RX_PIC_EYE_1                                     ,//input  [7:0]
    input wire [7:0]        P_RX_PIC_FASTLOCK_1                                ,//input  [7:0]
    input wire              P_RX_PIC_FASTLOCK_STROBE_1                         ,//input
    input wire              P_EM_RD_TRIGGER_1                                  ,//input
    input wire [1:0]        P_EM_MODE_CTRL_1                                   ,//input  [1:0]
    output wire [2:0]       P_EM_ERROR_CNT_1                                   ,//output [2:0]
    input  wire             P_RX_SLIP_RST_1                                    ,//input
    input  wire             P_RX_SLIP_EN_1                                     ,//input
    input  wire             P_LPLL_POWERDOWN_1                                 ,//input
    input  wire             P_LPLL_RST_1                                       ,//input
    output wire             P_LPLL_READY_1                                     ,//output
    output wire             P_RX_SIGDET_STATUS_1                               ,//output
    output wire             P_RX_SATA_COMINIT_1                                ,//output
    output wire             P_RX_SATA_COMWAKE_1                                ,//output
    output wire             P_RX_READY_1                                       ,//output
    input  wire             P_TX_LS_DATA_1                                     ,//input
    input  wire             P_TX_BEACON_EN_1                                   ,//input
    input  wire             P_TX_SWING_1                                       ,//input
    input  wire             P_TX_RXDET_REQ_1                                   ,//input
    output wire             P_TX_RXDET_STATUS_1                                ,//output
    input  wire [1:0]       P_TX_RATE_1                                        ,//input  [1:0]
    input  wire [2:0]       P_TX_BUSWIDTH_1                                    ,//input  [2:0]
    input  wire [2:0]       P_TX_FREERUN_BUSWIDTH_1                            ,//input  [2:0]
    input  wire [2:0]       P_TX_MARGIN_1                                      ,//input  [2:0]
    input  wire             P_TX_PMA_RST_1                                     ,//input
    input  wire             P_TX_LANE_POWERDOWN_1                              ,//input
    input  wire             P_TX_PIC_EN_1                                      ,//input
    input  wire [1:0]       P_RX_RATE_1                                        ,//input  [1:0]
    input  wire [2:0]       P_RX_BUSWIDTH_1                                    ,//input  [2:0]
    input  wire             P_RX_HIGHZ_1                                       ,//input
    input  wire             P_RX_DFE_RST_1                                     ,//input
    input  wire             P_RX_LEQ_RST_1                                     ,//input
    input  wire             P_RX_DFE_EN_1                                      ,//input
    input  wire             P_RX_T1_DFE_EN_1                                   ,//input
    input  wire             P_RX_T2_DFE_EN_1                                   ,//input
    input  wire             P_RX_T3_DFE_EN_1                                   ,//input
    input  wire             P_RX_T4_DFE_EN_1                                   ,//input
    input  wire             P_RX_T5_DFE_EN_1                                   ,//input
    input  wire             P_RX_T6_DFE_EN_1                                   ,//input
    input  wire             P_RX_T1_EN_1                                       ,//input
    input  wire             P_RX_CDRX_EN_1                                     ,//input
    input  wire             P_RX_SLIDING_EN_1                                  ,//input
    input  wire             P_RX_SLIDING_RST_1                                 ,//input
    input  wire             P_RX_SLICER_DCCAL_EN_1                             ,//input
    input  wire             P_RX_SLICER_DCCAL_RST_1                            ,//input
    input  wire             P_RX_CTLE_DCCAL_EN_1                               ,//input
    input  wire             P_RX_CTLE_DCCAL_RST_1                              ,//input
    //--------CHANNEL2 Port--------//
     //PAD
    input  wire             P_RX_SDN_2                                         ,//input
    input  wire             P_RX_SDP_2                                         ,//input
    output wire             P_TX_SDN_2                                         ,//output
    output wire             P_TX_SDP_2                                         ,//output
     //SRB                                                                                                  
    input  wire             P_RX_CLK_FR_CORE_2                                 ,//input
    input  wire             P_RCLK2_FR_CORE_2                                  ,//input
    input  wire             P_TX_CLK_FR_CORE_2                                 ,//input
    input  wire             P_TCLK2_FR_CORE_2                                  ,//input
    input  wire             P_PCS_RX_RST_2                                     ,//input
    input  wire             P_PCS_TX_RST_2                                     ,//input
    input  wire             P_EXT_BRIDGE_PCS_RST_2                             ,//input
    input  wire [87:0]      P_TDATA_2                                          ,//input  [87:0]
    input  wire             P_PCIE_EI_H_2                                      ,//input
    input  wire             P_PCIE_EI_L_2                                      ,//input
    input  wire [15:0]      P_TX_DEEMP_2                                       ,//input  [15:0]
    input  wire [1:0]       P_TX_DEEMP_POST_SEL_2                              ,//input  [1:0]
    input  wire             P_BLK_ALIGN_CTRL_2                                 ,//input
    input  wire             P_TX_ENC_TYPE_2                                    ,//input
    input  wire             P_RX_DEC_TYPE_2                                    ,//input
    input  wire             P_PCS_BIT_SLIP_2                                   ,//input
    input  wire             P_PCS_WORD_ALIGN_EN_2                              ,//input
    input  wire             P_RX_POLARITY_INVERT_2                             ,//input
    input  wire             P_PCS_MCB_EXT_EN_2                                 ,//input
    input  wire             P_PCS_NEAREND_LOOP_2                               ,//input
    input  wire             P_PCS_FAREND_LOOP_2                                ,//input
    input  wire             P_PMA_NEAREND_PLOOP_2                              ,//input
    input  wire             P_PMA_NEAREND_SLOOP_2                              ,//input
    input  wire             P_PMA_FAREND_PLOOP_2                               ,//input
    input  wire             P_PCS_PRBS_EN_2                                    ,//input
    output wire             P_RX_PRBS_ERROR_2                                  ,//output
    output wire             P_PCS_RX_MCB_STATUS_2                              ,//output
    output wire             P_PCS_LSM_SYNCED_2                                 ,//output
    output wire [87:0]      P_RDATA_2                                          ,//output [87:0]
    output wire             P_RXDVLD_2                                         ,//output
    output wire             P_RXDVLD_H_2                                       ,//output
    output wire [5:0]       P_RXSTATUS_2                                       ,//output [5:0]
    output wire             P_RCLK2FABRIC_2                                    ,//output
    output wire             P_TCLK2FABRIC_2                                    ,//output
    input wire              P_LANE_POWERDOWN_2                                 ,//input
    input wire              P_LANE_RST_2                                       ,//input
    input wire              P_RX_LANE_POWERDOWN_2                              ,//input
    input wire              P_RX_PMA_RST_2                                     ,//input
    input wire              P_RX_EYE_RST_2                                     ,//input
    input wire              P_RX_EYE_EN_2                                      ,//input
    input wire [7:0]        P_RX_EYE_TAP_2                                     ,//input  [7:0]
    input wire [7:0]        P_RX_PIC_EYE_2                                     ,//input  [7:0]
    input wire [7:0]        P_RX_PIC_FASTLOCK_2                                ,//input  [7:0]
    input wire              P_RX_PIC_FASTLOCK_STROBE_2                         ,//input
    input wire              P_EM_RD_TRIGGER_2                                  ,//input
    input wire [1:0]        P_EM_MODE_CTRL_2                                   ,//input  [1:0]
    output wire [2:0]       P_EM_ERROR_CNT_2                                   ,//output [2:0]
    input  wire             P_RX_SLIP_RST_2                                    ,//input
    input  wire             P_RX_SLIP_EN_2                                     ,//input
    input  wire             P_LPLL_POWERDOWN_2                                 ,//input
    input  wire             P_LPLL_RST_2                                       ,//input
    output wire             P_LPLL_READY_2                                     ,//output
    output wire             P_RX_SIGDET_STATUS_2                               ,//output
    output wire             P_RX_SATA_COMINIT_2                                ,//output
    output wire             P_RX_SATA_COMWAKE_2                                ,//output
    output wire             P_RX_READY_2                                       ,//output
    input  wire             P_TX_LS_DATA_2                                     ,//input
    input  wire             P_TX_BEACON_EN_2                                   ,//input
    input  wire             P_TX_SWING_2                                       ,//input
    input  wire             P_TX_RXDET_REQ_2                                   ,//input
    output wire             P_TX_RXDET_STATUS_2                                ,//output
    input  wire [1:0]       P_TX_RATE_2                                        ,//input  [1:0]
    input  wire [2:0]       P_TX_BUSWIDTH_2                                    ,//input  [2:0]
    input  wire [2:0]       P_TX_FREERUN_BUSWIDTH_2                            ,//input  [2:0]
    input  wire [2:0]       P_TX_MARGIN_2                                      ,//input  [2:0]
    input  wire             P_TX_PMA_RST_2                                     ,//input
    input  wire             P_TX_LANE_POWERDOWN_2                              ,//input
    input  wire             P_TX_PIC_EN_2                                      ,//input
    input  wire [1:0]       P_RX_RATE_2                                        ,//input  [1:0]
    input  wire [2:0]       P_RX_BUSWIDTH_2                                    ,//input  [2:0]
    input  wire             P_RX_HIGHZ_2                                       ,//input
    input  wire             P_RX_DFE_RST_2                                     ,//input
    input  wire             P_RX_LEQ_RST_2                                     ,//input
    input  wire             P_RX_DFE_EN_2                                      ,//input
    input  wire             P_RX_T1_DFE_EN_2                                   ,//input
    input  wire             P_RX_T2_DFE_EN_2                                   ,//input
    input  wire             P_RX_T3_DFE_EN_2                                   ,//input
    input  wire             P_RX_T4_DFE_EN_2                                   ,//input
    input  wire             P_RX_T5_DFE_EN_2                                   ,//input
    input  wire             P_RX_T6_DFE_EN_2                                   ,//input
    input  wire             P_RX_T1_EN_2                                       ,//input
    input  wire             P_RX_CDRX_EN_2                                     ,//input
    input  wire             P_RX_SLIDING_EN_2                                  ,//input
    input  wire             P_RX_SLIDING_RST_2                                 ,//input
    input  wire             P_RX_SLICER_DCCAL_EN_2                             ,//input
    input  wire             P_RX_SLICER_DCCAL_RST_2                            ,//input
    input  wire             P_RX_CTLE_DCCAL_EN_2                               ,//input
    input  wire             P_RX_CTLE_DCCAL_RST_2                              ,//input
    //--------CHANNEL3 Port--------//
     //PAD
    input  wire             P_RX_SDN_3                                         ,//input
    input  wire             P_RX_SDP_3                                         ,//input
    output wire             P_TX_SDN_3                                         ,//output
    output wire             P_TX_SDP_3                                         ,//output
     //SRB                                                                                                  
    input  wire             P_RX_CLK_FR_CORE_3                                 ,//input
    input  wire             P_RCLK2_FR_CORE_3                                  ,//input
    input  wire             P_TX_CLK_FR_CORE_3                                 ,//input
    input  wire             P_TCLK2_FR_CORE_3                                  ,//input
    input  wire             P_PCS_RX_RST_3                                     ,//input
    input  wire             P_PCS_TX_RST_3                                     ,//input
    input  wire             P_EXT_BRIDGE_PCS_RST_3                             ,//input
    input  wire [87:0]      P_TDATA_3                                          ,//input  [87:0]
    input  wire             P_PCIE_EI_H_3                                      ,//input
    input  wire             P_PCIE_EI_L_3                                      ,//input
    input  wire [15:0]      P_TX_DEEMP_3                                       ,//input  [15:0]
    input  wire [1:0]       P_TX_DEEMP_POST_SEL_3                              ,//input  [1:0]
    input  wire             P_BLK_ALIGN_CTRL_3                                 ,//input
    input  wire             P_TX_ENC_TYPE_3                                    ,//input
    input  wire             P_RX_DEC_TYPE_3                                    ,//input
    input  wire             P_PCS_BIT_SLIP_3                                   ,//input
    input  wire             P_PCS_WORD_ALIGN_EN_3                              ,//input
    input  wire             P_RX_POLARITY_INVERT_3                             ,//input
    input  wire             P_PCS_MCB_EXT_EN_3                                 ,//input
    input  wire             P_PCS_NEAREND_LOOP_3                               ,//input
    input  wire             P_PCS_FAREND_LOOP_3                                ,//input
    input  wire             P_PMA_NEAREND_PLOOP_3                              ,//input
    input  wire             P_PMA_NEAREND_SLOOP_3                              ,//input
    input  wire             P_PMA_FAREND_PLOOP_3                               ,//input
    input  wire             P_PCS_PRBS_EN_3                                    ,//input
    output wire             P_RX_PRBS_ERROR_3                                  ,//output
    output wire             P_PCS_RX_MCB_STATUS_3                              ,//output
    output wire             P_PCS_LSM_SYNCED_3                                 ,//output
    output wire [87:0]      P_RDATA_3                                          ,//output [87:0]
    output wire             P_RXDVLD_3                                         ,//output
    output wire             P_RXDVLD_H_3                                       ,//output
    output wire [5:0]       P_RXSTATUS_3                                       ,//output [5:0]
    output wire             P_RCLK2FABRIC_3                                    ,//output
    output wire             P_TCLK2FABRIC_3                                    ,//output
    input wire              P_LANE_POWERDOWN_3                                 ,//input
    input wire              P_LANE_RST_3                                       ,//input
    input wire              P_RX_LANE_POWERDOWN_3                              ,//input
    input wire              P_RX_PMA_RST_3                                     ,//input
    input wire              P_RX_EYE_RST_3                                     ,//input
    input wire              P_RX_EYE_EN_3                                      ,//input
    input wire [7:0]        P_RX_EYE_TAP_3                                     ,//input  [7:0]
    input wire [7:0]        P_RX_PIC_EYE_3                                     ,//input  [7:0]
    input wire [7:0]        P_RX_PIC_FASTLOCK_3                                ,//input  [7:0]
    input wire              P_RX_PIC_FASTLOCK_STROBE_3                         ,//input
    input wire              P_EM_RD_TRIGGER_3                                  ,//input
    input wire [1:0]        P_EM_MODE_CTRL_3                                   ,//input  [1:0]
    output wire [2:0]       P_EM_ERROR_CNT_3                                   ,//output [2:0]
    input  wire             P_RX_SLIP_RST_3                                    ,//input
    input  wire             P_RX_SLIP_EN_3                                     ,//input
    input  wire             P_LPLL_POWERDOWN_3                                 ,//input
    input  wire             P_LPLL_RST_3                                       ,//input
    output wire             P_LPLL_READY_3                                     ,//output
    output wire             P_RX_SIGDET_STATUS_3                               ,//output
    output wire             P_RX_SATA_COMINIT_3                                ,//output
    output wire             P_RX_SATA_COMWAKE_3                                ,//output
    output wire             P_RX_READY_3                                       ,//output
    input  wire             P_TX_LS_DATA_3                                     ,//input
    input  wire             P_TX_BEACON_EN_3                                   ,//input
    input  wire             P_TX_SWING_3                                       ,//input
    input  wire             P_TX_RXDET_REQ_3                                   ,//input
    output wire             P_TX_RXDET_STATUS_3                                ,//output
    input  wire [1:0]       P_TX_RATE_3                                        ,//input  [1:0]
    input  wire [2:0]       P_TX_BUSWIDTH_3                                    ,//input  [2:0]
    input  wire [2:0]       P_TX_FREERUN_BUSWIDTH_3                            ,//input  [2:0]
    input  wire [2:0]       P_TX_MARGIN_3                                      ,//input  [2:0]
    input  wire             P_TX_PMA_RST_3                                     ,//input
    input  wire             P_TX_LANE_POWERDOWN_3                              ,//input
    input  wire             P_TX_PIC_EN_3                                      ,//input
    input  wire [1:0]       P_RX_RATE_3                                        ,//input  [1:0]
    input  wire [2:0]       P_RX_BUSWIDTH_3                                    ,//input  [2:0]
    input  wire             P_RX_HIGHZ_3                                       ,//input
    input  wire             P_RX_DFE_RST_3                                     ,//input
    input  wire             P_RX_LEQ_RST_3                                     ,//input
    input  wire             P_RX_DFE_EN_3                                      ,//input
    input  wire             P_RX_T1_DFE_EN_3                                   ,//input
    input  wire             P_RX_T2_DFE_EN_3                                   ,//input
    input  wire             P_RX_T3_DFE_EN_3                                   ,//input
    input  wire             P_RX_T4_DFE_EN_3                                   ,//input
    input  wire             P_RX_T5_DFE_EN_3                                   ,//input
    input  wire             P_RX_T6_DFE_EN_3                                   ,//input
    input  wire             P_RX_T1_EN_3                                       ,//input
    input  wire             P_RX_CDRX_EN_3                                     ,//input
    input  wire             P_RX_SLIDING_EN_3                                  ,//input
    input  wire             P_RX_SLIDING_RST_3                                 ,//input
    input  wire             P_RX_SLICER_DCCAL_EN_3                             ,//input
    input  wire             P_RX_SLICER_DCCAL_RST_3                            ,//input
    input  wire             P_RX_CTLE_DCCAL_EN_3                               ,//input
    input  wire             P_RX_CTLE_DCCAL_RST_3                               //input
);

//--------BUFDS Wire--------//
wire             REFCLK_OUTP_0                                      ;
wire             REFCLK_OUTP_1                                      ;

//--------HPLL Wire--------//
wire             P_CFG_RST_HPLL                                     ;
wire             P_CFG_CLK_HPLL                                     ;
wire             P_CFG_PSEL_HPLL                                    ;
wire             P_CFG_ENABLE_HPLL                                  ;
wire             P_CFG_WRITE_HPLL                                   ;
wire [11:0]      P_CFG_ADDR_HPLL                                    ;
wire [7:0]       P_CFG_WDATA_HPLL                                   ;
wire             P_CFG_READY_HPLL                                   ;
wire [7:0]       P_CFG_RDATA_HPLL                                   ;
wire             P_CFG_INT_HPLL                                     ;
wire             PMA_HPLL_READY_O                                   ;
wire             PMA_HPLL_REFCLK_O                                  ;
wire             PMA_TX_SYNC_HPLL_O                                 ;
wire             REFCLK_TO_TX_SYNC_I                                ;
wire             REFCLK_TO_REFCLK_SYNC_I                            ;
wire             REFCLK_TO_DIV_SYNC_I                               ;
wire             TX_SYNC_REFSYNC_O                                  ;
wire             REFCLK_SYNC_REFSYNC_O                              ;
wire             DIV_SYNC_REFSYNC_O                                 ;
wire             ANA_TX_SYNC_I                                      ;
wire             ANA_HPLL_REFCLK_SYNC_I                             ;
wire             ANA_HPLL_DIV_SYNC_I                                ; 
wire             PMA_HPLL_CK0                                       ;
wire             PMA_HPLL_CK90                                      ;
wire             PMA_HPLL_CK180                                     ;
wire             PMA_HPLL_CK270                                     ;


//--------Channel0 Wire--------//
wire             P_CFG_RST_0                                        ;
wire             P_CFG_CLK_0                                        ;
wire             P_CFG_PSEL_0                                       ;      
wire             P_CFG_ENABLE_0                                     ;
wire             P_CFG_WRITE_0                                      ;
wire [11:0]      P_CFG_ADDR_0                                       ;
wire [7:0]       P_CFG_WDATA_0                                      ;
wire             P_CFG_READY_0                                      ;
wire [7:0]       P_CFG_RDATA_0                                      ;
wire             P_CFG_INT_0                                        ;
wire [24:0]      LANE_COUT_BUS_FORWARD_0                            ;
wire [1:0]       LANE_COUT_BUS_BACKWARD_0                           ;
wire [24:0]      LANE_CIN_BUS_FORWARD_0                             ;
wire [1:0]       LANE_CIN_BUS_BACKWARD_0                            ;
wire             PCS_RX_MCB_STATUS_0                                ;
wire             P_LPLL_REFCLK_IN_0                                 ;
wire             PMA_HPLL_CK0_0                                     ;
wire             PMA_HPLL_CK90_0                                    ;
wire             PMA_HPLL_CK180_0                                   ;
wire             PMA_HPLL_CK270_0                                   ;
wire             PMA_HPLL_READY_IN_0                                ;
wire             PMA_HPLL_REFCLK_IN_0                               ;
wire             PMA_TX_SYNC_HPLL_IN_0                              ;
wire             PMA_TX_SYNC_0                                      ;
wire             PMA_TX_RATE_CHANGE_ON_0_0                          ;
wire             PMA_TX_RATE_CHANGE_ON_1_0                          ;
wire             P_RX_LS_DATA_0                                     ;//output
wire [19:0]      P_TEST_STATUS_0                                    ;//output [19:0]
wire             P_CA_ALIGN_RX_0                                    ;//output
wire             P_CA_ALIGN_TX_0                                    ;//output

//--------Channel1 Wire--------//
wire             P_CFG_RST_1                                        ;
wire             P_CFG_CLK_1                                        ;
wire             P_CFG_PSEL_1                                       ;      
wire             P_CFG_ENABLE_1                                     ;
wire             P_CFG_WRITE_1                                      ;
wire [11:0]      P_CFG_ADDR_1                                       ;
wire [7:0]       P_CFG_WDATA_1                                      ;
wire             P_CFG_READY_1                                      ;
wire [7:0]       P_CFG_RDATA_1                                      ;
wire             P_CFG_INT_1                                        ;
wire [24:0]      LANE_COUT_BUS_FORWARD_1                            ;
wire [1:0]       LANE_COUT_BUS_BACKWARD_1                           ;
wire [24:0]      LANE_CIN_BUS_FORWARD_1                             ;
wire [1:0]       LANE_CIN_BUS_BACKWARD_1                            ;
wire             PCS_RX_MCB_STATUS_1                                ;
wire             P_LPLL_REFCLK_IN_1                                 ;
wire             PMA_HPLL_CK0_1                                     ;
wire             PMA_HPLL_CK90_1                                    ;
wire             PMA_HPLL_CK180_1                                   ;
wire             PMA_HPLL_CK270_1                                   ;
wire             PMA_HPLL_READY_IN_1                                ;
wire             PMA_HPLL_REFCLK_IN_1                               ;
wire             PMA_TX_SYNC_HPLL_IN_1                              ;
wire             PMA_TX_SYNC_1                                      ;
wire             PMA_TX_RATE_CHANGE_ON_0_1                          ;
wire             PMA_TX_RATE_CHANGE_ON_1_1                          ;
wire             P_RX_LS_DATA_1                                     ;//output
wire [19:0]      P_TEST_STATUS_1                                    ;//output [19:0]
wire             P_CA_ALIGN_RX_1                                    ;//output
wire             P_CA_ALIGN_TX_1                                    ;//output

//--------Channel2 Wire--------//
wire             P_CFG_RST_2                                        ;
wire             P_CFG_CLK_2                                        ;
wire             P_CFG_PSEL_2                                       ;      
wire             P_CFG_ENABLE_2                                     ;
wire             P_CFG_WRITE_2                                      ;
wire [11:0]      P_CFG_ADDR_2                                       ;
wire [7:0]       P_CFG_WDATA_2                                      ;
wire             P_CFG_READY_2                                      ;
wire [7:0]       P_CFG_RDATA_2                                      ;
wire             P_CFG_INT_2                                        ;
wire [24:0]      LANE_COUT_BUS_FORWARD_2                            ;
wire [1:0]       LANE_COUT_BUS_BACKWARD_2                           ;
wire [24:0]      LANE_CIN_BUS_FORWARD_2                             ;
wire [1:0]       LANE_CIN_BUS_BACKWARD_2                            ;
wire             PCS_RX_MCB_STATUS_2                                ;
wire             P_LPLL_REFCLK_IN_2                                 ;
wire             PMA_HPLL_CK0_2                                     ;
wire             PMA_HPLL_CK90_2                                    ;
wire             PMA_HPLL_CK180_2                                   ;
wire             PMA_HPLL_CK270_2                                   ;
wire             PMA_HPLL_READY_IN_2                                ;
wire             PMA_HPLL_REFCLK_IN_2                               ;
wire             PMA_TX_SYNC_HPLL_IN_2                              ;
wire             PMA_TX_SYNC_2                                      ;
wire             PMA_TX_RATE_CHANGE_ON_0_2                          ;
wire             PMA_TX_RATE_CHANGE_ON_1_2                          ;
wire             P_RX_LS_DATA_2                                     ;//output
wire [19:0]      P_TEST_STATUS_2                                    ;//output [19:0]
wire             P_CA_ALIGN_RX_2                                    ;//output
wire             P_CA_ALIGN_TX_2                                    ;//output

//--------Channel3 Wire--------//
wire             P_CFG_RST_3                                        ;
wire             P_CFG_CLK_3                                        ;
wire             P_CFG_PSEL_3                                       ;      
wire             P_CFG_ENABLE_3                                     ;
wire             P_CFG_WRITE_3                                      ;
wire [11:0]      P_CFG_ADDR_3                                       ;
wire [7:0]       P_CFG_WDATA_3                                      ;
wire             P_CFG_READY_3                                      ;
wire [7:0]       P_CFG_RDATA_3                                      ;
wire             P_CFG_INT_3                                        ;
wire [24:0]      LANE_COUT_BUS_FORWARD_3                            ;
wire [1:0]       LANE_CIN_BUS_BACKWARD_3                            ;
wire [24:0]      LANE_CIN_BUS_FORWARD_3                             ;
wire [1:0]       LANE_COUT_BUS_BACKWARD_3                           ;
wire             PCS_RX_MCB_STATUS_3                                ;
wire             P_LPLL_REFCLK_IN_3                                 ;
wire             PMA_HPLL_CK0_3                                     ;
wire             PMA_HPLL_CK90_3                                    ;
wire             PMA_HPLL_CK180_3                                   ;
wire             PMA_HPLL_CK270_3                                   ;
wire             PMA_HPLL_READY_IN_3                                ;
wire             PMA_HPLL_REFCLK_IN_3                               ;
wire             PMA_TX_SYNC_HPLL_IN_3                              ;
wire             PMA_TX_SYNC_3                                      ;
wire             PMA_TX_RATE_CHANGE_ON_0_3                          ;
wire             PMA_TX_RATE_CHANGE_ON_1_3                          ;
wire             P_RX_LS_DATA_3                                     ;//output
wire [19:0]      P_TEST_STATUS_3                                    ;//output [19:0]
wire             P_CA_ALIGN_RX_3                                    ;//output
wire             P_CA_ALIGN_TX_3                                    ;//output

//HPLL

assign             P_HPLL_REFCLK_I                                  = PMA_REG_HPLL_REFCLK_SEL == "REFERENCE_CLOCK_0" ?  REFCLK_OUTP_0 :
                                                                      PMA_REG_HPLL_REFCLK_SEL == "REFERENCE_CLOCK_1" ?  REFCLK_OUTP_1 : 
                                                                      PMA_REG_HPLL_REFCLK_SEL == "REFERENCE_CLOCK_1_FROM_FABRIC" ?  p_fabric_refclk :  REFCLK_OUTP_0;
assign             REFCLK_TO_TX_SYNC_I                              = 1'b0; 
assign             REFCLK_TO_REFCLK_SYNC_I                          = 1'b0; 
assign             REFCLK_TO_DIV_SYNC_I                             = 1'b0; 
assign             ANA_TX_SYNC_I                                    = P_TX_SYNC     ;
assign             ANA_HPLL_REFCLK_SYNC_I                           = 1'b0          ;
assign             ANA_HPLL_DIV_SYNC_I                              = 1'b0          ; 

//HPLL Clock and Signal Connect to Channel0/1/2/3
//channel0
assign             PMA_HPLL_CK0_0                                   = PMA_HPLL_CK0              ;
assign             PMA_HPLL_CK90_0                                  = PMA_HPLL_CK90             ;
assign             PMA_HPLL_CK180_0                                 = PMA_HPLL_CK180            ;
assign             PMA_HPLL_CK270_0                                 = PMA_HPLL_CK270            ;
assign             PMA_HPLL_READY_IN_0                              = PMA_HPLL_READY_O          ;
assign             PMA_HPLL_REFCLK_IN_0                             = PMA_HPLL_REFCLK_O         ;
assign             PMA_TX_SYNC_HPLL_IN_0                            = PMA_TX_SYNC_HPLL_O        ;
assign             PMA_TX_RATE_CHANGE_ON_0_0                        = P_TX_RATE_CHANGE_ON_0     ;
assign             PMA_TX_RATE_CHANGE_ON_1_0                        = P_TX_RATE_CHANGE_ON_1     ;
assign             PMA_TX_SYNC_0                                    = P_TX_SYNC                 ;

assign             P_LPLL_REFCLK_IN_0                               = PMA_REG_LANE0_PLL_REFCLK_SEL == "REFERENCE_CLOCK_0" ?  REFCLK_OUTP_0 :
                                                                      PMA_REG_LANE0_PLL_REFCLK_SEL == "REFERENCE_CLOCK_1" ?  REFCLK_OUTP_1 : 
                                                                      PMA_REG_LANE0_PLL_REFCLK_SEL == "REFERENCE_CLOCK_1_FROM_FABRIC" ?  p_fabric_refclk :  REFCLK_OUTP_0;
//channel1
assign             PMA_HPLL_CK0_1                                   = PMA_HPLL_CK0              ;
assign             PMA_HPLL_CK90_1                                  = PMA_HPLL_CK90             ;
assign             PMA_HPLL_CK180_1                                 = PMA_HPLL_CK180            ;
assign             PMA_HPLL_CK270_1                                 = PMA_HPLL_CK270            ;
assign             PMA_HPLL_READY_IN_1                              = PMA_HPLL_READY_O          ;
assign             PMA_HPLL_REFCLK_IN_1                             = PMA_HPLL_REFCLK_O         ;
assign             PMA_TX_SYNC_HPLL_IN_1                            = PMA_TX_SYNC_HPLL_O        ;
assign             PMA_TX_RATE_CHANGE_ON_0_1                        = P_TX_RATE_CHANGE_ON_0     ;
assign             PMA_TX_RATE_CHANGE_ON_1_1                        = P_TX_RATE_CHANGE_ON_1     ;
assign             PMA_TX_SYNC_1                                    = P_TX_SYNC                 ;

assign             P_LPLL_REFCLK_IN_1                               = PMA_REG_LANE1_PLL_REFCLK_SEL == "REFERENCE_CLOCK_0" ?  REFCLK_OUTP_0 :
                                                                      PMA_REG_LANE1_PLL_REFCLK_SEL == "REFERENCE_CLOCK_1" ?  REFCLK_OUTP_1 : 
                                                                      PMA_REG_LANE1_PLL_REFCLK_SEL == "REFERENCE_CLOCK_1_FROM_FABRIC" ?  p_fabric_refclk :  REFCLK_OUTP_0;

//channel2
assign             PMA_HPLL_CK0_2                                   = PMA_HPLL_CK0              ;
assign             PMA_HPLL_CK90_2                                  = PMA_HPLL_CK90             ;
assign             PMA_HPLL_CK180_2                                 = PMA_HPLL_CK180            ;
assign             PMA_HPLL_CK270_2                                 = PMA_HPLL_CK270            ;
assign             PMA_HPLL_READY_IN_2                              = PMA_HPLL_READY_O          ;
assign             PMA_HPLL_REFCLK_IN_2                             = PMA_HPLL_REFCLK_O         ;
assign             PMA_TX_SYNC_HPLL_IN_2                            = PMA_TX_SYNC_HPLL_O        ;
assign             PMA_TX_RATE_CHANGE_ON_0_2                        = P_TX_RATE_CHANGE_ON_0     ;
assign             PMA_TX_RATE_CHANGE_ON_1_2                        = P_TX_RATE_CHANGE_ON_1     ;
assign             PMA_TX_SYNC_2                                    = P_TX_SYNC                 ;

assign             P_LPLL_REFCLK_IN_2                               = PMA_REG_LANE2_PLL_REFCLK_SEL == "REFERENCE_CLOCK_0" ?  REFCLK_OUTP_0 :
                                                                      PMA_REG_LANE2_PLL_REFCLK_SEL == "REFERENCE_CLOCK_1" ?  REFCLK_OUTP_1 : 
                                                                      PMA_REG_LANE2_PLL_REFCLK_SEL == "REFERENCE_CLOCK_1_FROM_FABRIC" ?  p_fabric_refclk :  REFCLK_OUTP_0;

//channel3
assign             PMA_HPLL_CK0_3                                   = PMA_HPLL_CK0              ;
assign             PMA_HPLL_CK90_3                                  = PMA_HPLL_CK90             ;
assign             PMA_HPLL_CK180_3                                 = PMA_HPLL_CK180            ;
assign             PMA_HPLL_CK270_3                                 = PMA_HPLL_CK270            ;
assign             PMA_HPLL_READY_IN_3                              = PMA_HPLL_READY_O          ;
assign             PMA_HPLL_REFCLK_IN_3                             = PMA_HPLL_REFCLK_O         ;
assign             PMA_TX_SYNC_HPLL_IN_3                            = PMA_TX_SYNC_HPLL_O        ;
assign             PMA_TX_RATE_CHANGE_ON_0_3                        = P_TX_RATE_CHANGE_ON_0     ;
assign             PMA_TX_RATE_CHANGE_ON_1_3                        = P_TX_RATE_CHANGE_ON_1     ;
assign             PMA_TX_SYNC_3                                    = P_TX_SYNC                 ;

assign             P_LPLL_REFCLK_IN_3                               = PMA_REG_LANE3_PLL_REFCLK_SEL == "REFERENCE_CLOCK_0" ?  REFCLK_OUTP_0 :
                                                                      PMA_REG_LANE3_PLL_REFCLK_SEL == "REFERENCE_CLOCK_1" ?  REFCLK_OUTP_1 : 
                                                                      PMA_REG_LANE3_PLL_REFCLK_SEL == "REFERENCE_CLOCK_1_FROM_FABRIC" ?  p_fabric_refclk :  REFCLK_OUTP_0;
//Process CIN & COUT FOR channel bonding
generate
if(CH0_TX_MULT_LANE_MODE==4) begin : LANE_0124_TXBONDING
    assign LANE_CIN_BUS_FORWARD_1[24:21]  = LANE_COUT_BUS_FORWARD_0[24:21];//LANE0 >> LANE1
    assign LANE_CIN_BUS_FORWARD_2[24:21]  = LANE_COUT_BUS_FORWARD_1[24:21];//LANE1 >> LANE2
    assign LANE_CIN_BUS_FORWARD_3[24:21]  = LANE_COUT_BUS_FORWARD_2[24:21];//LANE1 >> LANE2
end
else if(CH0_TX_MULT_LANE_MODE==2 && CH2_TX_MULT_LANE_MODE==2) begin:LANE_01_23_TXBONDING
    assign LANE_CIN_BUS_FORWARD_1[24:21]  = LANE_COUT_BUS_FORWARD_0[24:21];//LANE0 >> LANE1
    assign LANE_CIN_BUS_FORWARD_3[24:21]  = LANE_COUT_BUS_FORWARD_2[24:21];//LANE2 >> LANE3   
end
else if(CH0_TX_MULT_LANE_MODE==2 && CH2_TX_MULT_LANE_MODE==1) begin:LANE_01_TXBONDING
    assign LANE_CIN_BUS_FORWARD_1[24:21]  = LANE_COUT_BUS_FORWARD_0[24:21];//LANE0 >> LANE1
end
else if(CH0_TX_MULT_LANE_MODE==1 && CH2_TX_MULT_LANE_MODE==2) begin:LANE_23_TXBONDING
    assign LANE_CIN_BUS_FORWARD_3[24:21]  = LANE_COUT_BUS_FORWARD_2[24:21];//LANE2 >> LANE3
end
endgenerate

generate
if(CH0_RX_MULT_LANE_MODE==4) begin: LANE_0123_RXBONDING
    assign LANE_CIN_BUS_FORWARD_1[20:0]  = LANE_COUT_BUS_FORWARD_0[20:0];//LANE0 >> LANE1
    assign LANE_CIN_BUS_FORWARD_2[20:0]  = LANE_COUT_BUS_FORWARD_1[20:0];//LANE1 >> LANE2
    assign LANE_CIN_BUS_FORWARD_3[20:0]  = LANE_COUT_BUS_FORWARD_2[20:0];//LANE2 >> LANE3
    assign LANE_CIN_BUS_BACKWARD_0 = LANE_COUT_BUS_BACKWARD_1 ;//LANE1 >> LANE0
    assign LANE_CIN_BUS_BACKWARD_1 = LANE_COUT_BUS_BACKWARD_2 ;//LANE2 >> LANE1
    assign LANE_CIN_BUS_BACKWARD_2 = LANE_COUT_BUS_BACKWARD_3 ;//LANE3 >> LANE2
    assign LANE_CIN_BUS_BACKWARD_3 = 2'b11 ;//LANE3 input tie 2'b11
    assign P_PCS_RX_MCB_STATUS_0   = PCS_RX_MCB_STATUS_0;
    assign P_PCS_RX_MCB_STATUS_1   = PCS_RX_MCB_STATUS_0;
    assign P_PCS_RX_MCB_STATUS_2   = PCS_RX_MCB_STATUS_0;
    assign P_PCS_RX_MCB_STATUS_3   = PCS_RX_MCB_STATUS_0;
end
else if(CH0_RX_MULT_LANE_MODE==2 && CH2_RX_MULT_LANE_MODE==2) begin:LANE_01_23_RXBONDING
    assign LANE_CIN_BUS_FORWARD_1[20:0]  = LANE_COUT_BUS_FORWARD_0[20:0];//LANE0 >> LANE1
    assign LANE_CIN_BUS_FORWARD_3[20:0]  = LANE_COUT_BUS_FORWARD_2[20:0];//LANE2 >> LANE3
    assign LANE_CIN_BUS_BACKWARD_0 = LANE_COUT_BUS_BACKWARD_1 ;//LANE1 >> LANE0
    assign LANE_CIN_BUS_BACKWARD_1 = 2'b11 ;//LANE1 cin tie 2'b11
    assign LANE_CIN_BUS_BACKWARD_2 = LANE_COUT_BUS_BACKWARD_3 ;//LANE3 >> LANE2
    assign LANE_CIN_BUS_BACKWARD_3 = 2'b11 ;//LANE3 cin tie 2'b11
    assign P_PCS_RX_MCB_STATUS_0   = PCS_RX_MCB_STATUS_0;
    assign P_PCS_RX_MCB_STATUS_1   = PCS_RX_MCB_STATUS_0;
    assign P_PCS_RX_MCB_STATUS_2   = PCS_RX_MCB_STATUS_2;
    assign P_PCS_RX_MCB_STATUS_3   = PCS_RX_MCB_STATUS_2;
end
else if(CH0_RX_MULT_LANE_MODE==2 && CH2_RX_MULT_LANE_MODE==1) begin:LANE_01_RXBONDING
    assign LANE_CIN_BUS_FORWARD_1[20:0]  = LANE_COUT_BUS_FORWARD_0[20:0];//LANE0 >> LANE1
    assign LANE_CIN_BUS_BACKWARD_0 = LANE_COUT_BUS_BACKWARD_1 ;//LANE1 >> LANE0
    assign LANE_CIN_BUS_BACKWARD_1 = 2'b11 ;//LANE1 cin tie 2'b11
    assign P_PCS_RX_MCB_STATUS_0   = PCS_RX_MCB_STATUS_0;
    assign P_PCS_RX_MCB_STATUS_1   = PCS_RX_MCB_STATUS_0;
    assign P_PCS_RX_MCB_STATUS_2   = PCS_RX_MCB_STATUS_2;
    assign P_PCS_RX_MCB_STATUS_3   = PCS_RX_MCB_STATUS_3;
end
else if(CH0_RX_MULT_LANE_MODE==1 && CH2_RX_MULT_LANE_MODE==2) begin:LANE_23_RXBONDING
    assign LANE_CIN_BUS_FORWARD_3[20:0]  = LANE_COUT_BUS_FORWARD_2[20:0];//LANE2 >> LANE3
    assign LANE_CIN_BUS_BACKWARD_2 = LANE_COUT_BUS_BACKWARD_3 ;//LANE3 >> LANE2
    assign LANE_CIN_BUS_BACKWARD_3 = 2'b11 ;//LANE3 cin tie 2'b11
    assign P_PCS_RX_MCB_STATUS_0   = PCS_RX_MCB_STATUS_0;
    assign P_PCS_RX_MCB_STATUS_1   = PCS_RX_MCB_STATUS_1;
    assign P_PCS_RX_MCB_STATUS_2   = PCS_RX_MCB_STATUS_2;
    assign P_PCS_RX_MCB_STATUS_3   = PCS_RX_MCB_STATUS_2;
end
else begin:LANE_NO_BONDING
    assign P_PCS_RX_MCB_STATUS_0   = PCS_RX_MCB_STATUS_0;
    assign P_PCS_RX_MCB_STATUS_1   = PCS_RX_MCB_STATUS_1;
    assign P_PCS_RX_MCB_STATUS_2   = PCS_RX_MCB_STATUS_2;
    assign P_PCS_RX_MCB_STATUS_3   = PCS_RX_MCB_STATUS_3;
end
endgenerate


//--------APB bridge instance--------//
ipm2t_hssthp_apb_bridge_v1_0 U_APB_BRIDGE (
    //---------Fabric Port---------//
    .p_cfg_clk                                        (p_cfg_clk                  ),//input               
    .p_cfg_rst                                        (p_cfg_rst                  ),//input               
    .p_cfg_psel                                       (p_cfg_psel                 ),//input               
    .p_cfg_enable                                     (p_cfg_enable               ),//input               
    .p_cfg_write                                      (p_cfg_write                ),//input               
    .p_cfg_addr                                       (p_cfg_addr                 ),//input [15:0]        
    .p_cfg_wdata                                      (p_cfg_wdata                ),//input [7:0]     
    .p_cfg_ready                                      (p_cfg_ready                ),//output              
    .p_cfg_rdata                                      (p_cfg_rdata                ),//output [7:0]        
    .p_cfg_int                                        (p_cfg_int                  ),//output     
    //----------HPLL Port----------//
    .P_CFG_READY_HPLL                                 (P_CFG_READY_HPLL           ),//input      
    .P_CFG_RDATA_HPLL                                 (P_CFG_RDATA_HPLL           ),//input [7:0]
    .P_CFG_INT_HPLL                                   (P_CFG_INT_HPLL             ),//input   
    .P_CFG_RST_HPLL                                   (P_CFG_RST_HPLL             ),//output       
    .P_CFG_CLK_HPLL                                   (P_CFG_CLK_HPLL             ),//output       
    .P_CFG_PSEL_HPLL                                  (P_CFG_PSEL_HPLL            ),//output       
    .P_CFG_ENABLE_HPLL                                (P_CFG_ENABLE_HPLL          ),//output       
    .P_CFG_WRITE_HPLL                                 (P_CFG_WRITE_HPLL           ),//output       
    .P_CFG_ADDR_HPLL                                  (P_CFG_ADDR_HPLL            ),//output [11:0]
    .P_CFG_WDATA_HPLL                                 (P_CFG_WDATA_HPLL           ),//output [7:0] 
    //--------CHANNEL0 Port--------//
    .P_CFG_READY_0                                    (P_CFG_READY_0              ),//input                    
    .P_CFG_RDATA_0                                    (P_CFG_RDATA_0              ),//input [7:0]              
    .P_CFG_INT_0                                      (P_CFG_INT_0                ),//input               
    .P_CFG_CLK_0                                      (P_CFG_CLK_0                ),//output                   
    .P_CFG_RST_0                                      (P_CFG_RST_0                ),//output                   
    .P_CFG_PSEL_0                                     (P_CFG_PSEL_0               ),//output                   
    .P_CFG_ENABLE_0                                   (P_CFG_ENABLE_0             ),//output                   
    .P_CFG_WRITE_0                                    (P_CFG_WRITE_0              ),//output                   
    .P_CFG_ADDR_0                                     (P_CFG_ADDR_0               ),//output [11:0]            
    .P_CFG_WDATA_0                                    (P_CFG_WDATA_0              ),//output [7:0]         
    //--------CHANNEL1 Port--------//
    .P_CFG_READY_1                                    (P_CFG_READY_1              ),//input                    
    .P_CFG_RDATA_1                                    (P_CFG_RDATA_1              ),//input [7:0]              
    .P_CFG_INT_1                                      (P_CFG_INT_1                ),//input               
    .P_CFG_CLK_1                                      (P_CFG_CLK_1                ),//output                   
    .P_CFG_RST_1                                      (P_CFG_RST_1                ),//output                   
    .P_CFG_PSEL_1                                     (P_CFG_PSEL_1               ),//output                   
    .P_CFG_ENABLE_1                                   (P_CFG_ENABLE_1             ),//output                   
    .P_CFG_WRITE_1                                    (P_CFG_WRITE_1              ),//output                   
    .P_CFG_ADDR_1                                     (P_CFG_ADDR_1               ),//output [11:0]            
    .P_CFG_WDATA_1                                    (P_CFG_WDATA_1              ),//output [7:0]         
    //--------CHANNEL2 Port--------//
    .P_CFG_READY_2                                    (P_CFG_READY_2              ),//input                    
    .P_CFG_RDATA_2                                    (P_CFG_RDATA_2              ),//input [7:0]              
    .P_CFG_INT_2                                      (P_CFG_INT_2                ),//input               
    .P_CFG_CLK_2                                      (P_CFG_CLK_2                ),//output                   
    .P_CFG_RST_2                                      (P_CFG_RST_2                ),//output                   
    .P_CFG_PSEL_2                                     (P_CFG_PSEL_2               ),//output                   
    .P_CFG_ENABLE_2                                   (P_CFG_ENABLE_2             ),//output                   
    .P_CFG_WRITE_2                                    (P_CFG_WRITE_2              ),//output                   
    .P_CFG_ADDR_2                                     (P_CFG_ADDR_2               ),//output [11:0]            
    .P_CFG_WDATA_2                                    (P_CFG_WDATA_2              ),//output [7:0]         
    //--------CHANNEL3 Port--------//
    .P_CFG_READY_3                                    (P_CFG_READY_3              ),//input                    
    .P_CFG_RDATA_3                                    (P_CFG_RDATA_3              ),//input [7:0]              
    .P_CFG_INT_3                                      (P_CFG_INT_3                ),//input               
    .P_CFG_CLK_3                                      (P_CFG_CLK_3                ),//output                   
    .P_CFG_RST_3                                      (P_CFG_RST_3                ),//output                   
    .P_CFG_PSEL_3                                     (P_CFG_PSEL_3               ),//output                   
    .P_CFG_ENABLE_3                                   (P_CFG_ENABLE_3             ),//output                   
    .P_CFG_WRITE_3                                    (P_CFG_WRITE_3              ),//output                   
    .P_CFG_ADDR_3                                     (P_CFG_ADDR_3               ),//output [11:0]            
    .P_CFG_WDATA_3                                    (P_CFG_WDATA_3              ) //output [7:0]         
);


generate
if (REFCLK_PAD0_EN == "TRUE") begin:REFCLK0_ENABLE
ipm2t_hssthp_Transceiver_10G_bufds_wrapper_v1_0 U_BUFDS_0 (
    //input ports
    .COM_POWERDOWN                                   (P_COM_POWERDOWN           ),
    .PAD_REFCLKP                                     (PAD_REFCLKP_0             ),
    .PAD_REFCLKN                                     (PAD_REFCLKN_0             ),
    //output ports
    .REFCLK_OUTP                                     (REFCLK_OUTP_0             ),
    .PMA_REFCLK_TO_FABRIC                            (P_REFCK2CORE_0            )
);
end
else begin:REFCLK0_NULL
    assign REFCLK_OUTP_0  = 1'b0;
    assign P_REFCK2CORE_0 = 1'b0;
end
endgenerate

generate
if (REFCLK_PAD1_EN == "TRUE") begin:REFCLK1_ENABLE
ipm2t_hssthp_Transceiver_10G_bufds_wrapper_v1_0 U_BUFDS_1 (
    //input ports
    .COM_POWERDOWN                                   (P_COM_POWERDOWN           ),
    .PAD_REFCLKP                                     (PAD_REFCLKP_1             ),
    .PAD_REFCLKN                                     (PAD_REFCLKN_1             ),
    //output ports
    .REFCLK_OUTP                                     (REFCLK_OUTP_1             ),
    .PMA_REFCLK_TO_FABRIC                            (P_REFCK2CORE_1            )
);
end
else begin:REFCLK1_NULL
    assign REFCLK_OUTP_1  = 1'b0;
    assign P_REFCK2CORE_1 = 1'b0;
end
endgenerate

//--------HPLL instance--------//
generate
if(HPLL_EN == "TRUE") begin:HPLL_ENABLE

    ipm2t_hssthp_Transceiver_10G_hpll_wrapper_v1_6 U_HPLL_WRAP (

    //PAD
    .P_HPLL_REFCLK_I                                 (P_HPLL_REFCLK_I                      ),//input
     //SRB
    
    .p_calib_en                                      (1'b1                                 ),//input
    .p_calib_done                                    (p_calib_done                         ),//output
    .P_CFG_RST_HPLL                                  (P_CFG_RST_HPLL                       ),//input
    .P_CFG_CLK_HPLL                                  (P_CFG_CLK_HPLL                       ),//input
    .P_CFG_PSEL_HPLL                                 (P_CFG_PSEL_HPLL                      ),//input
    .P_CFG_ENABLE_HPLL                               (P_CFG_ENABLE_HPLL                    ),//input
    .P_CFG_WRITE_HPLL                                (P_CFG_WRITE_HPLL                     ),//input
    .P_CFG_ADDR_HPLL                                 (P_CFG_ADDR_HPLL                      ),//input  [11:0]
    .P_CFG_WDATA_HPLL                                (P_CFG_WDATA_HPLL                     ),//input  [7:0]
    .P_CFG_READY_HPLL                                (P_CFG_READY_HPLL                     ),//output
    .P_CFG_RDATA_HPLL                                (P_CFG_RDATA_HPLL                     ),//output [7:0]
    .P_CFG_INT_HPLL                                  (P_CFG_INT_HPLL                       ),//output
    .P_HPLL_POWERDOWN                                (P_HPLL_POWERDOWN                     ),//input
    .P_HPLL_RST                                      (P_HPLL_RST                           ),//input
    .P_TX_SYNC                                       (P_TX_SYNC                            ),//input
    .P_HPLL_DIV_SYNC                                 (P_HPLL_DIV_SYNC                      ),//input
    .P_REFCLK_DIV_SYNC                               (P_REFCLK_DIV_SYNC                    ),//input
    .P_HPLL_VCO_CALIB_EN                             (P_HPLL_VCO_CALIB_EN                  ),//input
    .P_HPLL_READY                                    (P_HPLL_READY                         ),//output
    .P_HPLL_DIV_CHANGE                               (P_HPLL_DIV_CHANGE                    ),//input
    .PMA_HPLL_READY_O                                (PMA_HPLL_READY_O                     ),//output
    .PMA_HPLL_REFCLK_O                               (PMA_HPLL_REFCLK_O                    ),//output
    .PMA_TX_SYNC_HPLL_O                              (PMA_TX_SYNC_HPLL_O                   ),//output
    .REFCLK_TO_TX_SYNC_I                             (REFCLK_TO_TX_SYNC_I                  ),//input
    .REFCLK_TO_REFCLK_SYNC_I                         (REFCLK_TO_REFCLK_SYNC_I              ),//input
    .REFCLK_TO_DIV_SYNC_I                            (REFCLK_TO_DIV_SYNC_I                 ),//input
    .TX_SYNC_REFSYNC_O                               (TX_SYNC_REFSYNC_O                    ),//output
    .REFCLK_SYNC_REFSYNC_O                           (REFCLK_SYNC_REFSYNC_O                ),//output
    .DIV_SYNC_REFSYNC_O                              (DIV_SYNC_REFSYNC_O                   ),//output
    .ANA_TX_SYNC_I                                   (ANA_TX_SYNC_I                        ),//output
    .ANA_HPLL_REFCLK_SYNC_I                          (ANA_HPLL_REFCLK_SYNC_I               ),//input
    .ANA_HPLL_DIV_SYNC_I                             (ANA_HPLL_DIV_SYNC_I                  ),//input
    .PMA_HPLL_CK0                                    (PMA_HPLL_CK0                         ),//output
    .PMA_HPLL_CK90                                   (PMA_HPLL_CK90                        ),//output
    .PMA_HPLL_CK180                                  (PMA_HPLL_CK180                       ),//output
    .PMA_HPLL_CK270                                  (PMA_HPLL_CK270                       ) //output
);
end
else begin:HPLL_NULL
    assign      p_calib_done                       = 1'b1;
    assign      P_CFG_READY_HPLL                   = 1'b1; 
    assign      P_CFG_RDATA_HPLL                   = 8'b0; 
    assign      P_CFG_INT_HPLL                     = 1'b0; 
    assign      P_HPLL_READY                       = 1'b0; 
    assign      PMA_HPLL_READY_O                   = 1'b0; 
    assign      PMA_HPLL_REFCLK_O                  = 1'b0; 
    assign      PMA_TX_SYNC_HPLL_O                 = 1'b0; 
    assign      TX_SYNC_REFSYNC_O                  = 1'b0; 
    assign      REFCLK_SYNC_REFSYNC_O              = 1'b0; 
    assign      DIV_SYNC_REFSYNC_O                 = 1'b0; 
    assign      PMA_HPLL_CK0                       = 1'b0; 
    assign      PMA_HPLL_CK90                      = 1'b0; 
    assign      PMA_HPLL_CK180                     = 1'b0; 
    assign      PMA_HPLL_CK270                     = 1'b0; 
end
endgenerate

//--------CHANNEL0 instance--------//
generate
if(CHANNEL0_EN == "TRUE") begin:CHANNEL0_ENABLE
ipm2t_hssthp_Transceiver_10G_lane0_wrapper_v1_5 U_LANE0_WRAP (
     //PAD
    .P_RX_SDN                                        (P_RX_SDN_0                                             ),//input
    .P_RX_SDP                                        (P_RX_SDP_0                                             ),//input
    .P_TX_SDN                                        (P_TX_SDN_0                                             ),//output
    .P_TX_SDP                                        (P_TX_SDP_0                                             ),//output
     //SRB                                                                                                  
    .P_RX_CLK_FR_CORE                                (P_RX_CLK_FR_CORE_0                                     ),//input
    .P_RCLK2_FR_CORE                                 (P_RCLK2_FR_CORE_0                                      ),//input
    .P_TX_CLK_FR_CORE                                (P_TX_CLK_FR_CORE_0                                     ),//input
    .P_TCLK2_FR_CORE                                 (P_TCLK2_FR_CORE_0                                      ),//input
    .P_PCS_RX_RST                                    (P_PCS_RX_RST_0                                         ),//input
    .P_PCS_TX_RST                                    (P_PCS_TX_RST_0                                         ),//input
    .P_EXT_BRIDGE_PCS_RST                            (P_EXT_BRIDGE_PCS_RST_0                                 ),//input
    .P_CFG_RST                                       (P_CFG_RST_0                                            ),//input        
    .P_CFG_CLK                                       (P_CFG_CLK_0                                            ),//input        
    .P_CFG_PSEL                                      (P_CFG_PSEL_0                                           ),//input              
    .P_CFG_ENABLE                                    (P_CFG_ENABLE_0                                         ),//input        
    .P_CFG_WRITE                                     (P_CFG_WRITE_0                                          ),//input        
    .P_CFG_ADDR                                      (P_CFG_ADDR_0                                           ),//input  [11:0]
    .P_CFG_WDATA                                     (P_CFG_WDATA_0                                          ),//input  [7:0] 
    .P_CFG_READY                                     (P_CFG_READY_0                                          ),//output
    .P_CFG_RDATA                                     (P_CFG_RDATA_0                                          ),//output [7:0]
    .P_CFG_INT                                       (P_CFG_INT_0                                            ),//output
    .LANE_COUT_BUS_FORWARD                           (LANE_COUT_BUS_FORWARD_0                                ),//output [24:0]
    .LANE_COUT_BUS_BACKWARD                          (LANE_COUT_BUS_BACKWARD_0                               ),//output [1:0]
    .LANE_CIN_BUS_FORWARD                            (LANE_CIN_BUS_FORWARD_0                                 ),//input  [24:0]
    .LANE_CIN_BUS_BACKWARD                           (LANE_CIN_BUS_BACKWARD_0                                ),//input  [1:0]
    .P_TDATA                                         (P_TDATA_0                                              ),//input  [87:0]
    .P_PCIE_EI_H                                     (P_PCIE_EI_H_0                                          ),//input
    .P_PCIE_EI_L                                     (P_PCIE_EI_L_0                                          ),//input
    .P_TX_DEEMP                                      (P_TX_DEEMP_0                                           ),//input  [15:0]
    .P_TX_DEEMP_POST_SEL                             (P_TX_DEEMP_POST_SEL_0                                  ),//input  [1:0]
    .P_BLK_ALIGN_CTRL                                (P_BLK_ALIGN_CTRL_0                                     ),//input
    .P_TX_ENC_TYPE                                   (P_TX_ENC_TYPE_0                                        ),//input
    .P_RX_DEC_TYPE                                   (P_RX_DEC_TYPE_0                                        ),//input
    .P_PCS_BIT_SLIP                                  (P_PCS_BIT_SLIP_0                                       ),//input
    .P_PCS_WORD_ALIGN_EN                             (P_PCS_WORD_ALIGN_EN_0                                  ),//input
    .P_RX_POLARITY_INVERT                            (P_RX_POLARITY_INVERT_0                                 ),//input
    .P_PCS_MCB_EXT_EN                                (P_PCS_MCB_EXT_EN_0                                     ),//input
    .P_PCS_NEAREND_LOOP                              (P_PCS_NEAREND_LOOP_0                                   ),//input
    .P_PCS_FAREND_LOOP                               (P_PCS_FAREND_LOOP_0                                    ),//input
    .P_PMA_NEAREND_PLOOP                             (P_PMA_NEAREND_PLOOP_0                                  ),//input
    .P_PMA_NEAREND_SLOOP                             (P_PMA_NEAREND_SLOOP_0                                  ),//input
    .P_PMA_FAREND_PLOOP                              (P_PMA_FAREND_PLOOP_0                                   ),//input
    .P_PCS_PRBS_EN                                   (P_PCS_PRBS_EN_0                                        ),//input
    .P_RX_PRBS_ERROR                                 (P_RX_PRBS_ERROR_0                                      ),//output
    .P_PCS_RX_MCB_STATUS                             (PCS_RX_MCB_STATUS_0                                    ),//output
    .P_PCS_LSM_SYNCED                                (P_PCS_LSM_SYNCED_0                                     ),//output
    .P_RDATA                                         (P_RDATA_0                                              ),//output [87:0]
    .P_RXDVLD                                        (P_RXDVLD_0                                             ),//output
    .P_RXDVLD_H                                      (P_RXDVLD_H_0                                           ),//output
    .P_RXSTATUS                                      (P_RXSTATUS_0                                           ),//output [5:0]
    .P_RCLK2FABRIC                                   (P_RCLK2FABRIC_0                                        ),//output
    .P_TCLK2FABRIC                                   (P_TCLK2FABRIC_0                                        ),//output
    .P_LANE_POWERDOWN                                (P_LANE_POWERDOWN_0                                     ),//input
    .P_LANE_RST                                      (P_LANE_RST_0                                           ),//input
    .P_RX_LANE_POWERDOWN                             (P_RX_LANE_POWERDOWN_0                                  ),//input
    .P_RX_PMA_RST                                    (P_RX_PMA_RST_0                                         ),//input
    .P_RX_DFE_RST                                    (P_RX_DFE_RST_0                                         ),//input
    .P_RX_LEQ_RST                                    (P_RX_LEQ_RST_0                                         ),//input
    .P_RX_SLIDING_RST                                (P_RX_SLIDING_RST_0                                     ),//input
    .P_RX_DFE_EN                                     (P_RX_DFE_EN_0                                          ),//input
    .P_RX_T1_EN                                      (P_RX_T1_EN_0                                           ),//input
    .P_RX_CDRX_EN                                    (P_RX_CDRX_EN_0                                         ),//input
    .P_RX_T1_DFE_EN                                  (P_RX_T1_DFE_EN_0                                       ),//input
    .P_RX_T2_DFE_EN                                  (P_RX_T2_DFE_EN_0                                       ),//input
    .P_RX_T3_DFE_EN                                  (P_RX_T3_DFE_EN_0                                       ),//input
    .P_RX_T4_DFE_EN                                  (P_RX_T4_DFE_EN_0                                       ),//input
    .P_RX_T5_DFE_EN                                  (P_RX_T5_DFE_EN_0                                       ),//input
    .P_RX_T6_DFE_EN                                  (P_RX_T6_DFE_EN_0                                       ),//input
    .P_RX_SLIDING_EN                                 (P_RX_SLIDING_EN_0                                      ),//input
    .P_RX_EYE_RST                                    (P_RX_EYE_RST_0                                         ),//input
    .P_RX_EYE_EN                                     (P_RX_EYE_EN_0                                          ),//input
    .P_RX_EYE_TAP                                    (P_RX_EYE_TAP_0                                         ),//input [7:0]
    .P_RX_PIC_EYE                                    (P_RX_PIC_EYE_0                                         ),//input [7:0]
    .P_RX_PIC_FASTLOCK                               (P_RX_PIC_FASTLOCK_0                                    ),//input [7:0]
    .P_RX_PIC_FASTLOCK_STROBE                        (P_RX_PIC_FASTLOCK_STROBE_0                             ),//input
    .P_EM_RD_TRIGGER                                 (P_EM_RD_TRIGGER_0                                      ),//input
    .P_EM_MODE_CTRL                                  (P_EM_MODE_CTRL_0                                       ),//input  [1:0]
    .P_EM_ERROR_CNT                                  (P_EM_ERROR_CNT_0                                       ),//output [2:0]
    .P_RX_CTLE_DCCAL_RST                             (P_RX_CTLE_DCCAL_RST_0                                  ),//input
    .P_RX_SLICER_DCCAL_RST                           (P_RX_SLICER_DCCAL_RST_0                                ),//input
    .P_RX_SLICER_DCCAL_EN                            (P_RX_SLICER_DCCAL_EN_0                                 ),//input
    .P_RX_CTLE_DCCAL_EN                              (P_RX_CTLE_DCCAL_EN_0                                   ),//input
    .P_RX_SLIP_RST                                   (P_RX_SLIP_RST_0                                        ),//input
    .P_RX_SLIP_EN                                    (P_RX_SLIP_EN_0                                         ),//input
    .P_LPLL_POWERDOWN                                (P_LPLL_POWERDOWN_0                                     ),//input
    .P_LPLL_RST                                      (P_LPLL_RST_0                                           ),//input
    .P_LPLL_READY                                    (P_LPLL_READY_0                                         ),//output
    .P_LPLL_REFCLK_IN                                (P_LPLL_REFCLK_IN_0                                     ),//input
    .P_RX_SIGDET_STATUS                              (P_RX_SIGDET_STATUS_0                                   ),//output
    .P_RX_SATA_COMINIT                               (P_RX_SATA_COMINIT_0                                    ),//output
    .P_RX_SATA_COMWAKE                               (P_RX_SATA_COMWAKE_0                                    ),//output
    .P_RX_LS_DATA                                    (P_RX_LS_DATA_0                                         ),//output
    .P_RX_READY                                      (P_RX_READY_0                                           ),//output
    .P_TEST_STATUS                                   (P_TEST_STATUS_0                                        ),//output [19:0]
    .P_TX_LS_DATA                                    (P_TX_LS_DATA_0                                         ),//input
    .P_TX_BEACON_EN                                  (P_TX_BEACON_EN_0                                       ),//input
    .P_TX_SWING                                      (P_TX_SWING_0                                           ),//input
    .P_TX_RXDET_REQ                                  (P_TX_RXDET_REQ_0                                       ),//input
    .P_TX_RXDET_STATUS                               (P_TX_RXDET_STATUS_0                                    ),//output
    .P_TX_RATE                                       (P_TX_RATE_0                                            ),//input  [1:0]
    .P_TX_BUSWIDTH                                   (P_TX_BUSWIDTH_0                                        ),//input  [2:0]
    .P_TX_FREERUN_BUSWIDTH                           (P_TX_FREERUN_BUSWIDTH_0                                ),//input  [2:0]
    .P_TX_MARGIN                                     (P_TX_MARGIN_0                                          ),//input  [2:0]
    .P_TX_PMA_RST                                    (P_TX_PMA_RST_0                                         ),//input
    .P_TX_LANE_POWERDOWN                             (P_TX_LANE_POWERDOWN_0                                  ),//input
    .P_TX_PIC_EN                                     (P_TX_PIC_EN_0                                          ),//input
    .P_RX_RATE                                       (P_RX_RATE_0                                            ),//input  [1:0]
    .P_RX_BUSWIDTH                                   (P_RX_BUSWIDTH_0                                        ),//input  [2:0]
    .P_RX_HIGHZ                                      (P_RX_HIGHZ_0                                           ),//input
    .P_CA_ALIGN_RX                                   (P_CA_ALIGN_RX_0                                        ),//output
    .P_CA_ALIGN_TX                                   (P_CA_ALIGN_TX_0                                        ),//output
    .PMA_HPLL_CK0                                    (PMA_HPLL_CK0_0                                         ),//input
    .PMA_HPLL_CK90                                   (PMA_HPLL_CK90_0                                        ),//input
    .PMA_HPLL_CK180                                  (PMA_HPLL_CK180_0                                       ),//input
    .PMA_HPLL_CK270                                  (PMA_HPLL_CK270_0                                       ),//input
    .PMA_HPLL_READY_IN                               (PMA_HPLL_READY_IN_0                                    ),//input
    .PMA_HPLL_REFCLK_IN                              (PMA_HPLL_REFCLK_IN_0                                   ),//input
    .PMA_TX_SYNC_HPLL_IN                             (PMA_TX_SYNC_HPLL_IN_0                                  ),//input
    .P_TX_RATE_CHANGE_ON_0                           (PMA_TX_RATE_CHANGE_ON_0_0                              ),//input
    .P_TX_RATE_CHANGE_ON_1                           (PMA_TX_RATE_CHANGE_ON_1_0                              ),//input
    .P_TX_SYNC                                       (PMA_TX_SYNC_0                                          ) //input
);
end
else begin:CHANNEL0_NULL //output default value to be done
    assign      P_TX_SDN_0                      = 1'b0 ;//output              
    assign      P_TX_SDP_0                      = 1'b0 ;//output              
    assign      P_RX_PRBS_ERROR_0               = 1'b0 ;//output
    assign      P_RXDVLD_0                      = 1'b0 ;//output
    assign      P_RXDVLD_H_0                    = 1'b0 ;//output
    assign      P_RXSTATUS_0                    = 6'b0 ;//output [5:0]
    assign      P_EM_ERROR_CNT_0                = 3'b0 ;//output [2:0]
    assign      P_PCS_LSM_SYNCED_0              = 1'b0 ;//output              
    assign      P_CFG_READY_0                   = 1'b1 ;//output              
    assign      P_CFG_RDATA_0                   = 8'b0 ;//output [7:0]        
    assign      P_CFG_INT_0                     = 1'b0 ;//output              
    assign      P_RDATA_0                       = 88'b0;//output [87:0]       
    assign      P_RCLK2FABRIC_0                 = 1'b0 ;//output              
    assign      P_TCLK2FABRIC_0                 = 1'b0 ;//output              
    assign      P_RX_SIGDET_STATUS_0            = 1'b0 ;//output              
    assign      P_RX_SATA_COMINIT_0             = 1'b0 ;//output              
    assign      P_RX_SATA_COMWAKE_0             = 1'b0 ;//output              
    assign      P_RX_LS_DATA_0                  = 1'b0 ;//output              
    assign      P_RX_READY_0                    = 1'b0 ;//output              
    assign      P_TEST_STATUS_0                 = 20'b0;//output [19:0]       
    assign      P_TX_RXDET_STATUS_0             = 1'b0 ;//output              
    assign      P_CA_ALIGN_RX_0                 = 1'b0 ;//output              
    assign      P_CA_ALIGN_TX_0                 = 1'b0 ;//output              
    assign      PCS_RX_MCB_STATUS_0             = 1'b0 ;//output              
    assign      LANE_COUT_BUS_FORWARD_0         = 25'b0;//output [24:0]
    assign      LANE_COUT_BUS_BACKWARD_0        = 2'b11;//output              
end
endgenerate

//--------CHANNEL1 instance--------//
generate
if(CHANNEL1_EN == "TRUE") begin:CHANNEL1_ENABLE
ipm2t_hssthp_Transceiver_10G_lane1_wrapper_v1_5 U_LANE1_WRAP (
     //PAD
    .P_RX_SDN                                        (P_RX_SDN_1                                             ),//input
    .P_RX_SDP                                        (P_RX_SDP_1                                             ),//input
    .P_TX_SDN                                        (P_TX_SDN_1                                             ),//output
    .P_TX_SDP                                        (P_TX_SDP_1                                             ),//output
     //SRB                                                                                                  
    .P_RX_CLK_FR_CORE                                (P_RX_CLK_FR_CORE_1                                     ),//input
    .P_RCLK2_FR_CORE                                 (P_RCLK2_FR_CORE_1                                      ),//input
    .P_TX_CLK_FR_CORE                                (P_TX_CLK_FR_CORE_1                                     ),//input
    .P_TCLK2_FR_CORE                                 (P_TCLK2_FR_CORE_1                                      ),//input
    .P_PCS_RX_RST                                    (P_PCS_RX_RST_1                                         ),//input
    .P_PCS_TX_RST                                    (P_PCS_TX_RST_1                                         ),//input
    .P_EXT_BRIDGE_PCS_RST                            (P_EXT_BRIDGE_PCS_RST_1                                 ),//input
    .P_CFG_RST                                       (P_CFG_RST_1                                            ),//input        
    .P_CFG_CLK                                       (P_CFG_CLK_1                                            ),//input        
    .P_CFG_PSEL                                      (P_CFG_PSEL_1                                           ),//input              
    .P_CFG_ENABLE                                    (P_CFG_ENABLE_1                                         ),//input        
    .P_CFG_WRITE                                     (P_CFG_WRITE_1                                          ),//input        
    .P_CFG_ADDR                                      (P_CFG_ADDR_1                                           ),//input  [11:0]
    .P_CFG_WDATA                                     (P_CFG_WDATA_1                                          ),//input  [7:0] 
    .P_CFG_READY                                     (P_CFG_READY_1                                          ),//output
    .P_CFG_RDATA                                     (P_CFG_RDATA_1                                          ),//output [7:0]
    .P_CFG_INT                                       (P_CFG_INT_1                                            ),//output
    .LANE_COUT_BUS_FORWARD                           (LANE_COUT_BUS_FORWARD_1                                ),//output [24:0]
    .LANE_COUT_BUS_BACKWARD                          (LANE_COUT_BUS_BACKWARD_1                               ),//output [1:0]
    .LANE_CIN_BUS_FORWARD                            (LANE_CIN_BUS_FORWARD_1                                 ),//input  [24:0]
    .LANE_CIN_BUS_BACKWARD                           (LANE_CIN_BUS_BACKWARD_1                                ),//input  [1:0]
    .P_TDATA                                         (P_TDATA_1                                              ),//input  [87:0]
    .P_PCIE_EI_H                                     (P_PCIE_EI_H_1                                          ),//input
    .P_PCIE_EI_L                                     (P_PCIE_EI_L_1                                          ),//input
    .P_TX_DEEMP                                      (P_TX_DEEMP_1                                           ),//input  [15:0]
    .P_TX_DEEMP_POST_SEL                             (P_TX_DEEMP_POST_SEL_1                                  ),//input  [1:0]
    .P_BLK_ALIGN_CTRL                                (P_BLK_ALIGN_CTRL_1                                     ),//input
    .P_TX_ENC_TYPE                                   (P_TX_ENC_TYPE_1                                        ),//input
    .P_RX_DEC_TYPE                                   (P_RX_DEC_TYPE_1                                        ),//input
    .P_PCS_BIT_SLIP                                  (P_PCS_BIT_SLIP_1                                       ),//input
    .P_PCS_WORD_ALIGN_EN                             (P_PCS_WORD_ALIGN_EN_1                                  ),//input
    .P_RX_POLARITY_INVERT                            (P_RX_POLARITY_INVERT_1                                 ),//input
    .P_PCS_MCB_EXT_EN                                (P_PCS_MCB_EXT_EN_1                                     ),//input
    .P_PCS_NEAREND_LOOP                              (P_PCS_NEAREND_LOOP_1                                   ),//input
    .P_PCS_FAREND_LOOP                               (P_PCS_FAREND_LOOP_1                                    ),//input
    .P_PMA_NEAREND_PLOOP                             (P_PMA_NEAREND_PLOOP_1                                  ),//input
    .P_PMA_NEAREND_SLOOP                             (P_PMA_NEAREND_SLOOP_1                                  ),//input
    .P_PMA_FAREND_PLOOP                              (P_PMA_FAREND_PLOOP_1                                   ),//input
    .P_PCS_PRBS_EN                                   (P_PCS_PRBS_EN_1                                        ),//input
    .P_RX_PRBS_ERROR                                 (P_RX_PRBS_ERROR_1                                      ),//output
    .P_PCS_RX_MCB_STATUS                             (PCS_RX_MCB_STATUS_1                                    ),//output
    .P_PCS_LSM_SYNCED                                (P_PCS_LSM_SYNCED_1                                     ),//output
    .P_RDATA                                         (P_RDATA_1                                              ),//output [87:0]
    .P_RXDVLD                                        (P_RXDVLD_1                                             ),//output
    .P_RXDVLD_H                                      (P_RXDVLD_H_1                                           ),//output
    .P_RXSTATUS                                      (P_RXSTATUS_1                                           ),//output [5:0]
    .P_RCLK2FABRIC                                   (P_RCLK2FABRIC_1                                        ),//output
    .P_TCLK2FABRIC                                   (P_TCLK2FABRIC_1                                        ),//output
    .P_LANE_POWERDOWN                                (P_LANE_POWERDOWN_1                                     ),//input
    .P_LANE_RST                                      (P_LANE_RST_1                                           ),//input
    .P_RX_LANE_POWERDOWN                             (P_RX_LANE_POWERDOWN_1                                  ),//input
    .P_RX_PMA_RST                                    (P_RX_PMA_RST_1                                         ),//input
    .P_RX_DFE_RST                                    (P_RX_DFE_RST_1                                         ),//input
    .P_RX_LEQ_RST                                    (P_RX_LEQ_RST_1                                         ),//input
    .P_RX_SLIDING_RST                                (P_RX_SLIDING_RST_1                                     ),//input
    .P_RX_DFE_EN                                     (P_RX_DFE_EN_1                                          ),//input
    .P_RX_T1_EN                                      (P_RX_T1_EN_1                                           ),//input
    .P_RX_CDRX_EN                                    (P_RX_CDRX_EN_1                                         ),//input
    .P_RX_T1_DFE_EN                                  (P_RX_T1_DFE_EN_1                                       ),//input
    .P_RX_T2_DFE_EN                                  (P_RX_T2_DFE_EN_1                                       ),//input
    .P_RX_T3_DFE_EN                                  (P_RX_T3_DFE_EN_1                                       ),//input
    .P_RX_T4_DFE_EN                                  (P_RX_T4_DFE_EN_1                                       ),//input
    .P_RX_T5_DFE_EN                                  (P_RX_T5_DFE_EN_1                                       ),//input
    .P_RX_T6_DFE_EN                                  (P_RX_T6_DFE_EN_1                                       ),//input
    .P_RX_SLIDING_EN                                 (P_RX_SLIDING_EN_1                                      ),//input
    .P_RX_EYE_RST                                    (P_RX_EYE_RST_1                                         ),//input
    .P_RX_EYE_EN                                     (P_RX_EYE_EN_1                                          ),//input
    .P_RX_EYE_TAP                                    (P_RX_EYE_TAP_1                                         ),//input [7:0]
    .P_RX_PIC_EYE                                    (P_RX_PIC_EYE_1                                         ),//input [7:0]
    .P_RX_PIC_FASTLOCK                               (P_RX_PIC_FASTLOCK_1                                    ),//input [7:0]
    .P_RX_PIC_FASTLOCK_STROBE                        (P_RX_PIC_FASTLOCK_STROBE_1                             ),//input
    .P_EM_RD_TRIGGER                                 (P_EM_RD_TRIGGER_1                                      ),//input
    .P_EM_MODE_CTRL                                  (P_EM_MODE_CTRL_1                                       ),//input  [1:0]
    .P_EM_ERROR_CNT                                  (P_EM_ERROR_CNT_1                                       ),//output [2:0]
    .P_RX_CTLE_DCCAL_RST                             (P_RX_CTLE_DCCAL_RST_1                                  ),//input
    .P_RX_SLICER_DCCAL_RST                           (P_RX_SLICER_DCCAL_RST_1                                ),//input
    .P_RX_SLICER_DCCAL_EN                            (P_RX_SLICER_DCCAL_EN_1                                 ),//input
    .P_RX_CTLE_DCCAL_EN                              (P_RX_CTLE_DCCAL_EN_1                                   ),//input
    .P_RX_SLIP_RST                                   (P_RX_SLIP_RST_1                                        ),//input
    .P_RX_SLIP_EN                                    (P_RX_SLIP_EN_1                                         ),//input
    .P_LPLL_POWERDOWN                                (P_LPLL_POWERDOWN_1                                     ),//input
    .P_LPLL_RST                                      (P_LPLL_RST_1                                           ),//input
    .P_LPLL_READY                                    (P_LPLL_READY_1                                         ),//output
    .P_LPLL_REFCLK_IN                                (P_LPLL_REFCLK_IN_1                                     ),//input
    .P_RX_SIGDET_STATUS                              (P_RX_SIGDET_STATUS_1                                   ),//output
    .P_RX_SATA_COMINIT                               (P_RX_SATA_COMINIT_1                                    ),//output
    .P_RX_SATA_COMWAKE                               (P_RX_SATA_COMWAKE_1                                    ),//output
    .P_RX_LS_DATA                                    (P_RX_LS_DATA_1                                         ),//output
    .P_RX_READY                                      (P_RX_READY_1                                           ),//output
    .P_TEST_STATUS                                   (P_TEST_STATUS_1                                        ),//output [19:0]
    .P_TX_LS_DATA                                    (P_TX_LS_DATA_1                                         ),//input
    .P_TX_BEACON_EN                                  (P_TX_BEACON_EN_1                                       ),//input
    .P_TX_SWING                                      (P_TX_SWING_1                                           ),//input
    .P_TX_RXDET_REQ                                  (P_TX_RXDET_REQ_1                                       ),//input
    .P_TX_RXDET_STATUS                               (P_TX_RXDET_STATUS_1                                    ),//output
    .P_TX_RATE                                       (P_TX_RATE_1                                            ),//input  [1:0]
    .P_TX_BUSWIDTH                                   (P_TX_BUSWIDTH_1                                        ),//input  [2:0]
    .P_TX_FREERUN_BUSWIDTH                           (P_TX_FREERUN_BUSWIDTH_1                                ),//input  [2:0]
    .P_TX_MARGIN                                     (P_TX_MARGIN_1                                          ),//input  [2:0]
    .P_TX_PMA_RST                                    (P_TX_PMA_RST_1                                         ),//input
    .P_TX_LANE_POWERDOWN                             (P_TX_LANE_POWERDOWN_1                                  ),//input
    .P_TX_PIC_EN                                     (P_TX_PIC_EN_1                                          ),//input
    .P_RX_RATE                                       (P_RX_RATE_1                                            ),//input  [1:0]
    .P_RX_BUSWIDTH                                   (P_RX_BUSWIDTH_1                                        ),//input  [2:0]
    .P_RX_HIGHZ                                      (P_RX_HIGHZ_1                                           ),//input
    .P_CA_ALIGN_RX                                   (P_CA_ALIGN_RX_1                                        ),//output
    .P_CA_ALIGN_TX                                   (P_CA_ALIGN_TX_1                                        ),//output
    .PMA_HPLL_CK0                                    (PMA_HPLL_CK0_1                                         ),//input
    .PMA_HPLL_CK90                                   (PMA_HPLL_CK90_1                                        ),//input
    .PMA_HPLL_CK180                                  (PMA_HPLL_CK180_1                                       ),//input
    .PMA_HPLL_CK270                                  (PMA_HPLL_CK270_1                                       ),//input
    .PMA_HPLL_READY_IN                               (PMA_HPLL_READY_IN_1                                    ),//input
    .PMA_HPLL_REFCLK_IN                              (PMA_HPLL_REFCLK_IN_1                                   ),//input
    .PMA_TX_SYNC_HPLL_IN                             (PMA_TX_SYNC_HPLL_IN_1                                  ),//input
    .P_TX_RATE_CHANGE_ON_0                           (PMA_TX_RATE_CHANGE_ON_0_1                              ),//input
    .P_TX_RATE_CHANGE_ON_1                           (PMA_TX_RATE_CHANGE_ON_1_1                              ),//input
    .P_TX_SYNC                                       (PMA_TX_SYNC_1                                          ) //input
);
end
else begin:CHANNEL1_NULL //output default value to be done
    assign      P_TX_SDN_1                      = 1'b0 ;//output              
    assign      P_TX_SDP_1                      = 1'b0 ;//output              
    assign      P_RX_PRBS_ERROR_1               = 1'b0 ;//output
    assign      P_RXDVLD_1                      = 1'b0 ;//output
    assign      P_RXDVLD_H_1                    = 1'b0 ;//output
    assign      P_RXSTATUS_1                    = 6'b0 ;//output [5:0]
    assign      P_EM_ERROR_CNT_1                = 3'b0 ;//output [2:0]
    assign      P_PCS_LSM_SYNCED_1              = 1'b0 ;//output              
    assign      P_CFG_READY_1                   = 1'b1 ;//output              
    assign      P_CFG_RDATA_1                   = 8'b0 ;//output [7:0]        
    assign      P_CFG_INT_1                     = 1'b0 ;//output              
    assign      P_RDATA_1                       = 88'b0;//output [87:0]       
    assign      P_RCLK2FABRIC_1                 = 1'b0 ;//output              
    assign      P_TCLK2FABRIC_1                 = 1'b0 ;//output              
    assign      P_RX_SIGDET_STATUS_1            = 1'b0 ;//output              
    assign      P_RX_SATA_COMINIT_1             = 1'b0 ;//output              
    assign      P_RX_SATA_COMWAKE_1             = 1'b0 ;//output              
    assign      P_RX_LS_DATA_1                  = 1'b0 ;//output              
    assign      P_RX_READY_1                    = 1'b0 ;//output              
    assign      P_TEST_STATUS_1                 = 20'b0;//output [19:0]       
    assign      P_TX_RXDET_STATUS_1             = 1'b0 ;//output              
    assign      P_CA_ALIGN_RX_1                 = 1'b0 ;//output              
    assign      P_CA_ALIGN_TX_1                 = 1'b0 ;//output              
    assign      PCS_RX_MCB_STATUS_1             = 1'b0 ;//output              
    assign      LANE_COUT_BUS_FORWARD_1         = 25'b0;//output [25:0]
    assign      LANE_COUT_BUS_BACKWARD_0        = 2'b11;//output              
end
endgenerate

//--------CHANNEL2 instance--------//
generate
if(CHANNEL2_EN == "TRUE") begin:CHANNEL2_ENABLE
ipm2t_hssthp_Transceiver_10G_lane2_wrapper_v1_5 U_LANE2_WRAP (
     //PAD
    .P_RX_SDN                                        (P_RX_SDN_2                                             ),//input
    .P_RX_SDP                                        (P_RX_SDP_2                                             ),//input
    .P_TX_SDN                                        (P_TX_SDN_2                                             ),//output
    .P_TX_SDP                                        (P_TX_SDP_2                                             ),//output
     //SRB                                                                                                  
    .P_RX_CLK_FR_CORE                                (P_RX_CLK_FR_CORE_2                                     ),//input
    .P_RCLK2_FR_CORE                                 (P_RCLK2_FR_CORE_2                                      ),//input
    .P_TX_CLK_FR_CORE                                (P_TX_CLK_FR_CORE_2                                     ),//input
    .P_TCLK2_FR_CORE                                 (P_TCLK2_FR_CORE_2                                      ),//input
    .P_PCS_RX_RST                                    (P_PCS_RX_RST_2                                         ),//input
    .P_PCS_TX_RST                                    (P_PCS_TX_RST_2                                         ),//input
    .P_EXT_BRIDGE_PCS_RST                            (P_EXT_BRIDGE_PCS_RST_2                                 ),//input
    .P_CFG_RST                                       (P_CFG_RST_2                                            ),//input        
    .P_CFG_CLK                                       (P_CFG_CLK_2                                            ),//input        
    .P_CFG_PSEL                                      (P_CFG_PSEL_2                                           ),//input              
    .P_CFG_ENABLE                                    (P_CFG_ENABLE_2                                         ),//input        
    .P_CFG_WRITE                                     (P_CFG_WRITE_2                                          ),//input        
    .P_CFG_ADDR                                      (P_CFG_ADDR_2                                           ),//input  [11:0]
    .P_CFG_WDATA                                     (P_CFG_WDATA_2                                          ),//input  [7:0] 
    .P_CFG_READY                                     (P_CFG_READY_2                                          ),//output
    .P_CFG_RDATA                                     (P_CFG_RDATA_2                                          ),//output [7:0]
    .P_CFG_INT                                       (P_CFG_INT_2                                            ),//output
    .LANE_COUT_BUS_FORWARD                           (LANE_COUT_BUS_FORWARD_2                                ),//output [24:0]
    .LANE_COUT_BUS_BACKWARD                          (LANE_COUT_BUS_BACKWARD_2                               ),//output [1:0]
    .LANE_CIN_BUS_FORWARD                            (LANE_CIN_BUS_FORWARD_2                                 ),//input  [24:0]
    .LANE_CIN_BUS_BACKWARD                           (LANE_CIN_BUS_BACKWARD_2                                ),//input  [1:0]
    .P_TDATA                                         (P_TDATA_2                                              ),//input  [87:0]
    .P_PCIE_EI_H                                     (P_PCIE_EI_H_2                                          ),//input
    .P_PCIE_EI_L                                     (P_PCIE_EI_L_2                                          ),//input
    .P_TX_DEEMP                                      (P_TX_DEEMP_2                                           ),//input  [15:0]
    .P_TX_DEEMP_POST_SEL                             (P_TX_DEEMP_POST_SEL_2                                  ),//input  [1:0]
    .P_BLK_ALIGN_CTRL                                (P_BLK_ALIGN_CTRL_2                                     ),//input
    .P_TX_ENC_TYPE                                   (P_TX_ENC_TYPE_2                                        ),//input
    .P_RX_DEC_TYPE                                   (P_RX_DEC_TYPE_2                                        ),//input
    .P_PCS_BIT_SLIP                                  (P_PCS_BIT_SLIP_2                                       ),//input
    .P_PCS_WORD_ALIGN_EN                             (P_PCS_WORD_ALIGN_EN_2                                  ),//input
    .P_RX_POLARITY_INVERT                            (P_RX_POLARITY_INVERT_2                                 ),//input
    .P_PCS_MCB_EXT_EN                                (P_PCS_MCB_EXT_EN_2                                     ),//input
    .P_PCS_NEAREND_LOOP                              (P_PCS_NEAREND_LOOP_2                                   ),//input
    .P_PCS_FAREND_LOOP                               (P_PCS_FAREND_LOOP_2                                    ),//input
    .P_PMA_NEAREND_PLOOP                             (P_PMA_NEAREND_PLOOP_2                                  ),//input
    .P_PMA_NEAREND_SLOOP                             (P_PMA_NEAREND_SLOOP_2                                  ),//input
    .P_PMA_FAREND_PLOOP                              (P_PMA_FAREND_PLOOP_2                                   ),//input
    .P_PCS_PRBS_EN                                   (P_PCS_PRBS_EN_2                                        ),//input
    .P_RX_PRBS_ERROR                                 (P_RX_PRBS_ERROR_2                                      ),//output
    .P_PCS_RX_MCB_STATUS                             (PCS_RX_MCB_STATUS_2                                    ),//output
    .P_PCS_LSM_SYNCED                                (P_PCS_LSM_SYNCED_2                                     ),//output
    .P_RDATA                                         (P_RDATA_2                                              ),//output [87:0]
    .P_RXDVLD                                        (P_RXDVLD_2                                             ),//output
    .P_RXDVLD_H                                      (P_RXDVLD_H_2                                           ),//output
    .P_RXSTATUS                                      (P_RXSTATUS_2                                           ),//output [5:0]
    .P_RCLK2FABRIC                                   (P_RCLK2FABRIC_2                                        ),//output
    .P_TCLK2FABRIC                                   (P_TCLK2FABRIC_2                                        ),//output
    .P_LANE_POWERDOWN                                (P_LANE_POWERDOWN_2                                     ),//input
    .P_LANE_RST                                      (P_LANE_RST_2                                           ),//input
    .P_RX_LANE_POWERDOWN                             (P_RX_LANE_POWERDOWN_2                                  ),//input
    .P_RX_PMA_RST                                    (P_RX_PMA_RST_2                                         ),//input
    .P_RX_DFE_RST                                    (P_RX_DFE_RST_2                                         ),//input
    .P_RX_LEQ_RST                                    (P_RX_LEQ_RST_2                                         ),//input
    .P_RX_SLIDING_RST                                (P_RX_SLIDING_RST_2                                     ),//input
    .P_RX_DFE_EN                                     (P_RX_DFE_EN_2                                          ),//input
    .P_RX_T1_EN                                      (P_RX_T1_EN_2                                           ),//input
    .P_RX_CDRX_EN                                    (P_RX_CDRX_EN_2                                         ),//input
    .P_RX_T1_DFE_EN                                  (P_RX_T1_DFE_EN_2                                       ),//input
    .P_RX_T2_DFE_EN                                  (P_RX_T2_DFE_EN_2                                       ),//input
    .P_RX_T3_DFE_EN                                  (P_RX_T3_DFE_EN_2                                       ),//input
    .P_RX_T4_DFE_EN                                  (P_RX_T4_DFE_EN_2                                       ),//input
    .P_RX_T5_DFE_EN                                  (P_RX_T5_DFE_EN_2                                       ),//input
    .P_RX_T6_DFE_EN                                  (P_RX_T6_DFE_EN_2                                       ),//input
    .P_RX_SLIDING_EN                                 (P_RX_SLIDING_EN_2                                      ),//input
    .P_RX_EYE_RST                                    (P_RX_EYE_RST_2                                         ),//input
    .P_RX_EYE_EN                                     (P_RX_EYE_EN_2                                          ),//input
    .P_RX_EYE_TAP                                    (P_RX_EYE_TAP_2                                         ),//input [7:0]
    .P_RX_PIC_EYE                                    (P_RX_PIC_EYE_2                                         ),//input [7:0]
    .P_RX_PIC_FASTLOCK                               (P_RX_PIC_FASTLOCK_2                                    ),//input [7:0]
    .P_RX_PIC_FASTLOCK_STROBE                        (P_RX_PIC_FASTLOCK_STROBE_2                             ),//input
    .P_EM_RD_TRIGGER                                 (P_EM_RD_TRIGGER_2                                      ),//input
    .P_EM_MODE_CTRL                                  (P_EM_MODE_CTRL_2                                       ),//input  [1:0]
    .P_EM_ERROR_CNT                                  (P_EM_ERROR_CNT_2                                       ),//output [2:0]
    .P_RX_CTLE_DCCAL_RST                             (P_RX_CTLE_DCCAL_RST_2                                  ),//input
    .P_RX_SLICER_DCCAL_RST                           (P_RX_SLICER_DCCAL_RST_2                                ),//input
    .P_RX_SLICER_DCCAL_EN                            (P_RX_SLICER_DCCAL_EN_2                                 ),//input
    .P_RX_CTLE_DCCAL_EN                              (P_RX_CTLE_DCCAL_EN_2                                   ),//input
    .P_RX_SLIP_RST                                   (P_RX_SLIP_RST_2                                        ),//input
    .P_RX_SLIP_EN                                    (P_RX_SLIP_EN_2                                         ),//input
    .P_LPLL_POWERDOWN                                (P_LPLL_POWERDOWN_2                                     ),//input
    .P_LPLL_RST                                      (P_LPLL_RST_2                                           ),//input
    .P_LPLL_READY                                    (P_LPLL_READY_2                                         ),//output
    .P_LPLL_REFCLK_IN                                (P_LPLL_REFCLK_IN_2                                     ),//input
    .P_RX_SIGDET_STATUS                              (P_RX_SIGDET_STATUS_2                                   ),//output
    .P_RX_SATA_COMINIT                               (P_RX_SATA_COMINIT_2                                    ),//output
    .P_RX_SATA_COMWAKE                               (P_RX_SATA_COMWAKE_2                                    ),//output
    .P_RX_LS_DATA                                    (P_RX_LS_DATA_2                                         ),//output
    .P_RX_READY                                      (P_RX_READY_2                                           ),//output
    .P_TEST_STATUS                                   (P_TEST_STATUS_2                                        ),//output [19:0]
    .P_TX_LS_DATA                                    (P_TX_LS_DATA_2                                         ),//input
    .P_TX_BEACON_EN                                  (P_TX_BEACON_EN_2                                       ),//input
    .P_TX_SWING                                      (P_TX_SWING_2                                           ),//input
    .P_TX_RXDET_REQ                                  (P_TX_RXDET_REQ_2                                       ),//input
    .P_TX_RXDET_STATUS                               (P_TX_RXDET_STATUS_2                                    ),//output
    .P_TX_RATE                                       (P_TX_RATE_2                                            ),//input  [1:0]
    .P_TX_BUSWIDTH                                   (P_TX_BUSWIDTH_2                                        ),//input  [2:0]
    .P_TX_FREERUN_BUSWIDTH                           (P_TX_FREERUN_BUSWIDTH_2                                ),//input  [2:0]
    .P_TX_MARGIN                                     (P_TX_MARGIN_2                                          ),//input  [2:0]
    .P_TX_PMA_RST                                    (P_TX_PMA_RST_2                                         ),//input
    .P_TX_LANE_POWERDOWN                             (P_TX_LANE_POWERDOWN_2                                  ),//input
    .P_TX_PIC_EN                                     (P_TX_PIC_EN_2                                          ),//input
    .P_RX_RATE                                       (P_RX_RATE_2                                            ),//input  [1:0]
    .P_RX_BUSWIDTH                                   (P_RX_BUSWIDTH_2                                        ),//input  [2:0]
    .P_RX_HIGHZ                                      (P_RX_HIGHZ_2                                           ),//input
    .P_CA_ALIGN_RX                                   (P_CA_ALIGN_RX_2                                        ),//output
    .P_CA_ALIGN_TX                                   (P_CA_ALIGN_TX_2                                        ),//output
    .PMA_HPLL_CK0                                    (PMA_HPLL_CK0_2                                         ),//input
    .PMA_HPLL_CK90                                   (PMA_HPLL_CK90_2                                        ),//input
    .PMA_HPLL_CK180                                  (PMA_HPLL_CK180_2                                       ),//input
    .PMA_HPLL_CK270                                  (PMA_HPLL_CK270_2                                       ),//input
    .PMA_HPLL_READY_IN                               (PMA_HPLL_READY_IN_2                                    ),//input
    .PMA_HPLL_REFCLK_IN                              (PMA_HPLL_REFCLK_IN_2                                   ),//input
    .PMA_TX_SYNC_HPLL_IN                             (PMA_TX_SYNC_HPLL_IN_2                                  ),//input
    .P_TX_RATE_CHANGE_ON_0                           (PMA_TX_RATE_CHANGE_ON_0_2                              ),//input
    .P_TX_RATE_CHANGE_ON_1                           (PMA_TX_RATE_CHANGE_ON_1_2                              ),//input
    .P_TX_SYNC                                       (PMA_TX_SYNC_2                                          ) //input
);
end
else begin:CHANNEL2_NULL //output default value to be done
    assign      P_TX_SDN_2                      = 1'b0 ;//output              
    assign      P_TX_SDP_2                      = 1'b0 ;//output              
    assign      P_RX_PRBS_ERROR_2               = 1'b0 ;//output
    assign      P_RXDVLD_2                      = 1'b0 ;//output
    assign      P_RXDVLD_H_2                    = 1'b0 ;//output
    assign      P_RXSTATUS_2                    = 6'b0 ;//output [5:0]
    assign      P_EM_ERROR_CNT_2                = 3'b0 ;//output [2:0]
    assign      P_PCS_LSM_SYNCED_2              = 1'b0 ;//output              
    assign      P_CFG_READY_2                   = 1'b1 ;//output              
    assign      P_CFG_RDATA_2                   = 8'b0 ;//output [7:0]        
    assign      P_CFG_INT_2                     = 1'b0 ;//output              
    assign      P_RDATA_2                       = 88'b0;//output [87:0]       
    assign      P_RCLK2FABRIC_2                 = 1'b0 ;//output              
    assign      P_TCLK2FABRIC_2                 = 1'b0 ;//output              
    assign      P_RX_SIGDET_STATUS_2            = 1'b0 ;//output              
    assign      P_RX_SATA_COMINIT_2             = 1'b0 ;//output              
    assign      P_RX_SATA_COMWAKE_2             = 1'b0 ;//output              
    assign      P_RX_LS_DATA_2                  = 1'b0 ;//output              
    assign      P_RX_READY_2                    = 1'b0 ;//output              
    assign      P_TEST_STATUS_2                 = 20'b0;//output [19:0]       
    assign      P_TX_RXDET_STATUS_2             = 1'b0 ;//output              
    assign      P_CA_ALIGN_RX_2                 = 1'b0 ;//output              
    assign      P_CA_ALIGN_TX_2                 = 1'b0 ;//output              
    assign      PCS_RX_MCB_STATUS_2             = 1'b0 ;//output              
    assign      LANE_COUT_BUS_FORWARD_2         = 25'b0;//output [24:0]
    assign      LANE_COUT_BUS_BACKWARD_2        = 2'b11;//output              
end
endgenerate

//--------CHANNEL3 instance--------//
generate
if(CHANNEL3_EN == "TRUE") begin:CHANNEL3_ENABLE
ipm2t_hssthp_Transceiver_10G_lane3_wrapper_v1_5 U_LANE3_WRAP (
     //PAD
    .P_RX_SDN                                        (P_RX_SDN_3                                             ),//input
    .P_RX_SDP                                        (P_RX_SDP_3                                             ),//input
    .P_TX_SDN                                        (P_TX_SDN_3                                             ),//output
    .P_TX_SDP                                        (P_TX_SDP_3                                             ),//output
     //SRB                                                                                                  
    .P_RX_CLK_FR_CORE                                (P_RX_CLK_FR_CORE_3                                     ),//input
    .P_RCLK2_FR_CORE                                 (P_RCLK2_FR_CORE_3                                      ),//input
    .P_TX_CLK_FR_CORE                                (P_TX_CLK_FR_CORE_3                                     ),//input
    .P_TCLK2_FR_CORE                                 (P_TCLK2_FR_CORE_3                                      ),//input
    .P_PCS_RX_RST                                    (P_PCS_RX_RST_3                                         ),//input
    .P_PCS_TX_RST                                    (P_PCS_TX_RST_3                                         ),//input
    .P_EXT_BRIDGE_PCS_RST                            (P_EXT_BRIDGE_PCS_RST_3                                 ),//input
    .P_CFG_RST                                       (P_CFG_RST_3                                            ),//input        
    .P_CFG_CLK                                       (P_CFG_CLK_3                                            ),//input        
    .P_CFG_PSEL                                      (P_CFG_PSEL_3                                           ),//input              
    .P_CFG_ENABLE                                    (P_CFG_ENABLE_3                                         ),//input        
    .P_CFG_WRITE                                     (P_CFG_WRITE_3                                          ),//input        
    .P_CFG_ADDR                                      (P_CFG_ADDR_3                                           ),//input  [11:0]
    .P_CFG_WDATA                                     (P_CFG_WDATA_3                                          ),//input  [7:0] 
    .P_CFG_READY                                     (P_CFG_READY_3                                          ),//output
    .P_CFG_RDATA                                     (P_CFG_RDATA_3                                          ),//output [7:0]
    .P_CFG_INT                                       (P_CFG_INT_3                                            ),//output
    .LANE_COUT_BUS_FORWARD                           (LANE_COUT_BUS_FORWARD_3                                ),//output [24:0]
    .LANE_COUT_BUS_BACKWARD                          (LANE_COUT_BUS_BACKWARD_3                               ),//output [1:0]
    .LANE_CIN_BUS_FORWARD                            (LANE_CIN_BUS_FORWARD_3                                 ),//input  [24:0]
    .LANE_CIN_BUS_BACKWARD                           (LANE_CIN_BUS_BACKWARD_3                                ),//input  [1:0]
    .P_TDATA                                         (P_TDATA_3                                              ),//input  [87:0]
    .P_PCIE_EI_H                                     (P_PCIE_EI_H_3                                          ),//input
    .P_PCIE_EI_L                                     (P_PCIE_EI_L_3                                          ),//input
    .P_TX_DEEMP                                      (P_TX_DEEMP_3                                           ),//input  [15:0]
    .P_TX_DEEMP_POST_SEL                             (P_TX_DEEMP_POST_SEL_3                                  ),//input  [1:0]
    .P_BLK_ALIGN_CTRL                                (P_BLK_ALIGN_CTRL_3                                     ),//input
    .P_TX_ENC_TYPE                                   (P_TX_ENC_TYPE_3                                        ),//input
    .P_RX_DEC_TYPE                                   (P_RX_DEC_TYPE_3                                        ),//input
    .P_PCS_BIT_SLIP                                  (P_PCS_BIT_SLIP_3                                       ),//input
    .P_PCS_WORD_ALIGN_EN                             (P_PCS_WORD_ALIGN_EN_3                                  ),//input
    .P_RX_POLARITY_INVERT                            (P_RX_POLARITY_INVERT_3                                 ),//input
    .P_PCS_MCB_EXT_EN                                (P_PCS_MCB_EXT_EN_3                                     ),//input
    .P_PCS_NEAREND_LOOP                              (P_PCS_NEAREND_LOOP_3                                   ),//input
    .P_PCS_FAREND_LOOP                               (P_PCS_FAREND_LOOP_3                                    ),//input
    .P_PMA_NEAREND_PLOOP                             (P_PMA_NEAREND_PLOOP_3                                  ),//input
    .P_PMA_NEAREND_SLOOP                             (P_PMA_NEAREND_SLOOP_3                                  ),//input
    .P_PMA_FAREND_PLOOP                              (P_PMA_FAREND_PLOOP_3                                   ),//input
    .P_PCS_PRBS_EN                                   (P_PCS_PRBS_EN_3                                        ),//input
    .P_RX_PRBS_ERROR                                 (P_RX_PRBS_ERROR_3                                      ),//output
    .P_PCS_RX_MCB_STATUS                             (PCS_RX_MCB_STATUS_3                                    ),//output
    .P_PCS_LSM_SYNCED                                (P_PCS_LSM_SYNCED_3                                     ),//output
    .P_RDATA                                         (P_RDATA_3                                              ),//output [87:0]
    .P_RXDVLD                                        (P_RXDVLD_3                                             ),//output
    .P_RXDVLD_H                                      (P_RXDVLD_H_3                                           ),//output
    .P_RXSTATUS                                      (P_RXSTATUS_3                                           ),//output [5:0]
    .P_RCLK2FABRIC                                   (P_RCLK2FABRIC_3                                        ),//output
    .P_TCLK2FABRIC                                   (P_TCLK2FABRIC_3                                        ),//output
    .P_LANE_POWERDOWN                                (P_LANE_POWERDOWN_3                                     ),//input
    .P_LANE_RST                                      (P_LANE_RST_3                                           ),//input
    .P_RX_LANE_POWERDOWN                             (P_RX_LANE_POWERDOWN_3                                  ),//input
    .P_RX_PMA_RST                                    (P_RX_PMA_RST_3                                         ),//input
    .P_RX_DFE_RST                                    (P_RX_DFE_RST_3                                         ),//input
    .P_RX_LEQ_RST                                    (P_RX_LEQ_RST_3                                         ),//input
    .P_RX_SLIDING_RST                                (P_RX_SLIDING_RST_3                                     ),//input
    .P_RX_DFE_EN                                     (P_RX_DFE_EN_3                                          ),//input
    .P_RX_T1_EN                                      (P_RX_T1_EN_3                                           ),//input
    .P_RX_CDRX_EN                                    (P_RX_CDRX_EN_3                                         ),//input
    .P_RX_T1_DFE_EN                                  (P_RX_T1_DFE_EN_3                                       ),//input
    .P_RX_T2_DFE_EN                                  (P_RX_T2_DFE_EN_3                                       ),//input
    .P_RX_T3_DFE_EN                                  (P_RX_T3_DFE_EN_3                                       ),//input
    .P_RX_T4_DFE_EN                                  (P_RX_T4_DFE_EN_3                                       ),//input
    .P_RX_T5_DFE_EN                                  (P_RX_T5_DFE_EN_3                                       ),//input
    .P_RX_T6_DFE_EN                                  (P_RX_T6_DFE_EN_3                                       ),//input
    .P_RX_SLIDING_EN                                 (P_RX_SLIDING_EN_3                                      ),//input
    .P_RX_EYE_RST                                    (P_RX_EYE_RST_3                                         ),//input
    .P_RX_EYE_EN                                     (P_RX_EYE_EN_3                                          ),//input
    .P_RX_EYE_TAP                                    (P_RX_EYE_TAP_3                                         ),//input [7:0]
    .P_RX_PIC_EYE                                    (P_RX_PIC_EYE_3                                         ),//input [7:0]
    .P_RX_PIC_FASTLOCK                               (P_RX_PIC_FASTLOCK_3                                    ),//input [7:0]
    .P_RX_PIC_FASTLOCK_STROBE                        (P_RX_PIC_FASTLOCK_STROBE_3                             ),//input
    .P_EM_RD_TRIGGER                                 (P_EM_RD_TRIGGER_3                                      ),//input
    .P_EM_MODE_CTRL                                  (P_EM_MODE_CTRL_3                                       ),//input  [1:0]
    .P_EM_ERROR_CNT                                  (P_EM_ERROR_CNT_3                                       ),//output [2:0]
    .P_RX_CTLE_DCCAL_RST                             (P_RX_CTLE_DCCAL_RST_3                                  ),//input
    .P_RX_SLICER_DCCAL_RST                           (P_RX_SLICER_DCCAL_RST_3                                ),//input
    .P_RX_SLICER_DCCAL_EN                            (P_RX_SLICER_DCCAL_EN_3                                 ),//input
    .P_RX_CTLE_DCCAL_EN                              (P_RX_CTLE_DCCAL_EN_3                                   ),//input
    .P_RX_SLIP_RST                                   (P_RX_SLIP_RST_3                                        ),//input
    .P_RX_SLIP_EN                                    (P_RX_SLIP_EN_3                                         ),//input
    .P_LPLL_POWERDOWN                                (P_LPLL_POWERDOWN_3                                     ),//input
    .P_LPLL_RST                                      (P_LPLL_RST_3                                           ),//input
    .P_LPLL_READY                                    (P_LPLL_READY_3                                         ),//output
    .P_LPLL_REFCLK_IN                                (P_LPLL_REFCLK_IN_3                                     ),//input
    .P_RX_SIGDET_STATUS                              (P_RX_SIGDET_STATUS_3                                   ),//output
    .P_RX_SATA_COMINIT                               (P_RX_SATA_COMINIT_3                                    ),//output
    .P_RX_SATA_COMWAKE                               (P_RX_SATA_COMWAKE_3                                    ),//output
    .P_RX_LS_DATA                                    (P_RX_LS_DATA_3                                         ),//output
    .P_RX_READY                                      (P_RX_READY_3                                           ),//output
    .P_TEST_STATUS                                   (P_TEST_STATUS_3                                        ),//output [19:0]
    .P_TX_LS_DATA                                    (P_TX_LS_DATA_3                                         ),//input
    .P_TX_BEACON_EN                                  (P_TX_BEACON_EN_3                                       ),//input
    .P_TX_SWING                                      (P_TX_SWING_3                                           ),//input
    .P_TX_RXDET_REQ                                  (P_TX_RXDET_REQ_3                                       ),//input
    .P_TX_RXDET_STATUS                               (P_TX_RXDET_STATUS_3                                    ),//output
    .P_TX_RATE                                       (P_TX_RATE_3                                            ),//input  [1:0]
    .P_TX_BUSWIDTH                                   (P_TX_BUSWIDTH_3                                        ),//input  [2:0]
    .P_TX_FREERUN_BUSWIDTH                           (P_TX_FREERUN_BUSWIDTH_3                                ),//input  [2:0]
    .P_TX_MARGIN                                     (P_TX_MARGIN_3                                          ),//input  [2:0]
    .P_TX_PMA_RST                                    (P_TX_PMA_RST_3                                         ),//input
    .P_TX_LANE_POWERDOWN                             (P_TX_LANE_POWERDOWN_3                                  ),//input
    .P_TX_PIC_EN                                     (P_TX_PIC_EN_3                                          ),//input
    .P_RX_RATE                                       (P_RX_RATE_3                                            ),//input  [1:0]
    .P_RX_BUSWIDTH                                   (P_RX_BUSWIDTH_3                                        ),//input  [2:0]
    .P_RX_HIGHZ                                      (P_RX_HIGHZ_3                                           ),//input
    .P_CA_ALIGN_RX                                   (P_CA_ALIGN_RX_3                                        ),//output
    .P_CA_ALIGN_TX                                   (P_CA_ALIGN_TX_3                                        ),//output
    .PMA_HPLL_CK0                                    (PMA_HPLL_CK0_3                                         ),//input
    .PMA_HPLL_CK90                                   (PMA_HPLL_CK90_3                                        ),//input
    .PMA_HPLL_CK180                                  (PMA_HPLL_CK180_3                                       ),//input
    .PMA_HPLL_CK270                                  (PMA_HPLL_CK270_3                                       ),//input
    .PMA_HPLL_READY_IN                               (PMA_HPLL_READY_IN_3                                    ),//input
    .PMA_HPLL_REFCLK_IN                              (PMA_HPLL_REFCLK_IN_3                                   ),//input
    .PMA_TX_SYNC_HPLL_IN                             (PMA_TX_SYNC_HPLL_IN_3                                  ),//input
    .P_TX_RATE_CHANGE_ON_0                           (PMA_TX_RATE_CHANGE_ON_0_3                              ),//input
    .P_TX_RATE_CHANGE_ON_1                           (PMA_TX_RATE_CHANGE_ON_1_3                              ),//input
    .P_TX_SYNC                                       (PMA_TX_SYNC_3                                          ) //input
);
end
else begin:CHANNEL3_NULL //output default value to be done             
    assign      P_TX_SDN_3                      = 1'b0 ;//output              
    assign      P_TX_SDP_3                      = 1'b0 ;//output              
    assign      P_RX_PRBS_ERROR_3               = 1'b0 ;//output
    assign      P_RXDVLD_3                      = 1'b0 ;//output
    assign      P_RXDVLD_H_3                    = 1'b0 ;//output
    assign      P_RXSTATUS_3                    = 6'b0 ;//output [5:0]
    assign      P_EM_ERROR_CNT_3                = 3'b0 ;//output [2:0]
    assign      P_PCS_LSM_SYNCED_3              = 1'b0 ;//output              
    assign      P_CFG_READY_3                   = 1'b1 ;//output              
    assign      P_CFG_RDATA_3                   = 8'b0 ;//output [7:0]        
    assign      P_CFG_INT_3                     = 1'b0 ;//output              
    assign      P_RDATA_3                       = 88'b0;//output [87:0]       
    assign      P_RCLK2FABRIC_3                 = 1'b0 ;//output              
    assign      P_TCLK2FABRIC_3                 = 1'b0 ;//output              
    assign      P_RX_SIGDET_STATUS_3            = 1'b0 ;//output              
    assign      P_RX_SATA_COMINIT_3             = 1'b0 ;//output              
    assign      P_RX_SATA_COMWAKE_3             = 1'b0 ;//output              
    assign      P_RX_LS_DATA_3                  = 1'b0 ;//output              
    assign      P_RX_READY_3                    = 1'b0 ;//output              
    assign      P_TEST_STATUS_3                 = 20'b0;//output [19:0]       
    assign      P_TX_RXDET_STATUS_3             = 1'b0 ;//output              
    assign      P_CA_ALIGN_RX_3                 = 1'b0 ;//output              
    assign      P_CA_ALIGN_TX_3                 = 1'b0 ;//output              
    assign      PCS_RX_MCB_STATUS_3             = 1'b0 ;//output              
    assign      LANE_COUT_BUS_FORWARD_3         = 25'b0;//output [24:0]
    assign      LANE_COUT_BUS_BACKWARD_3        = 2'b11;//output              
end
endgenerate

endmodule
