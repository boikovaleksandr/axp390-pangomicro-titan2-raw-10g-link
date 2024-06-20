
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

module ipm2t_hssthp_Transceiver_10G_lane0_wrapper_v1_5(
    //PAD
    input  wire             P_RX_SDN                                         ,
    input  wire             P_RX_SDP                                         ,
    output wire             P_TX_SDN                                         ,
    output wire             P_TX_SDP                                         ,
     //SRB                                                                                           
    input  wire             P_RX_CLK_FR_CORE                                 ,
    input  wire             P_RCLK2_FR_CORE                                  ,
    input  wire             P_TX_CLK_FR_CORE                                 ,
    input  wire             P_TCLK2_FR_CORE                                  ,
    input  wire             P_PCS_RX_RST                                     ,
    input  wire             P_PCS_TX_RST                                     ,
    input  wire             P_EXT_BRIDGE_PCS_RST                             ,
    input  wire [87:0]      P_TDATA                                          , 
    input  wire             P_PCIE_EI_H                                      ,
    input  wire             P_PCIE_EI_L                                      ,
    input  wire [15:0]      P_TX_DEEMP                                       ,  
    input  wire [1:0]       P_TX_DEEMP_POST_SEL                              ,  
    input  wire             P_BLK_ALIGN_CTRL                                 ,
    input  wire             P_TX_ENC_TYPE                                    ,
    input  wire             P_RX_DEC_TYPE                                    ,
    input  wire             P_PCS_BIT_SLIP                                   ,
    input  wire             P_PCS_WORD_ALIGN_EN                              ,
    input  wire             P_RX_POLARITY_INVERT                             ,
    input  wire             P_PCS_MCB_EXT_EN                                 ,
    input  wire             P_PCS_NEAREND_LOOP                               ,
    input  wire             P_PCS_FAREND_LOOP                                ,
    input  wire             P_PMA_NEAREND_PLOOP                              ,
    input  wire             P_PMA_NEAREND_SLOOP                              ,
    input  wire             P_PMA_FAREND_PLOOP                               ,
    input  wire             P_PCS_PRBS_EN                                    ,
    output wire             P_RX_PRBS_ERROR                                  ,
    output wire             P_PCS_RX_MCB_STATUS                              ,
    output wire             P_PCS_LSM_SYNCED                                 ,
    output wire [87:0]      P_RDATA                                          , 
    output wire             P_RXDVLD                                         ,
    output wire             P_RXDVLD_H                                       ,
    output wire [5:0]       P_RXSTATUS                                       , 
    output wire             P_RCLK2FABRIC                                    ,
    output wire             P_TCLK2FABRIC                                    ,
    input  wire             P_LANE_POWERDOWN                                 ,
    input  wire             P_LANE_RST                                       ,
    input  wire             P_RX_LANE_POWERDOWN                              ,
    input  wire             P_RX_PMA_RST                                     ,
    input  wire             P_RX_EYE_RST                                     ,
    input  wire             P_RX_EYE_EN                                      ,
    input  wire [7:0]       P_RX_EYE_TAP                                     ,
    input  wire [7:0]       P_RX_PIC_EYE                                     ,
    input  wire [7:0]       P_RX_PIC_FASTLOCK                                ,
    input  wire             P_RX_PIC_FASTLOCK_STROBE                         ,
    input  wire             P_EM_RD_TRIGGER                                  ,
    input  wire [1:0]       P_EM_MODE_CTRL                                   ,
    output wire [2:0]       P_EM_ERROR_CNT                                   ,
    input  wire             P_RX_SLIP_RST                                    ,
    input  wire             P_RX_SLIP_EN                                     ,
    input  wire             P_LPLL_POWERDOWN                                 ,
    input  wire             P_LPLL_RST                                       ,
    output wire             P_LPLL_READY                                     ,
    output wire             P_RX_SIGDET_STATUS                               ,
    output wire             P_RX_SATA_COMINIT                                ,
    output wire             P_RX_SATA_COMWAKE                                ,
    output wire             P_RX_READY                                       ,
    input  wire             P_TX_LS_DATA                                     ,
    input  wire             P_TX_BEACON_EN                                   ,
    input  wire             P_TX_SWING                                       ,
    input  wire             P_TX_RXDET_REQ                                   ,
    output wire             P_TX_RXDET_STATUS                                ,
    input  wire [1:0]       P_TX_RATE                                        ,
    input  wire [2:0]       P_TX_BUSWIDTH                                    ,
    input  wire [2:0]       P_TX_FREERUN_BUSWIDTH                            ,
    input  wire [2:0]       P_TX_MARGIN                                      ,
    input  wire             P_TX_PMA_RST                                     ,
    input  wire             P_TX_LANE_POWERDOWN                              ,
    input  wire             P_TX_PIC_EN                                      ,
    input  wire [1:0]       P_RX_RATE                                        ,
    input  wire [2:0]       P_RX_BUSWIDTH                                    ,
    input  wire             P_RX_HIGHZ                                       ,
    input  wire             P_RX_DFE_RST                                     ,
    input  wire             P_RX_LEQ_RST                                     ,
    input  wire             P_RX_DFE_EN                                      ,
    input  wire             P_RX_T1_DFE_EN                                   ,
    input  wire             P_RX_T2_DFE_EN                                   ,
    input  wire             P_RX_T3_DFE_EN                                   ,
    input  wire             P_RX_T4_DFE_EN                                   ,
    input  wire             P_RX_T5_DFE_EN                                   ,
    input  wire             P_RX_T6_DFE_EN                                   ,
    input  wire             P_RX_T1_EN                                       ,
    input  wire             P_RX_CDRX_EN                                     ,
    input  wire             P_RX_SLIDING_EN                                  ,
    input  wire             P_RX_SLIDING_RST                                 ,
    input  wire             P_RX_SLICER_DCCAL_EN                             ,
    input  wire             P_RX_SLICER_DCCAL_RST                            ,
    input  wire             P_RX_CTLE_DCCAL_EN                               ,
    input  wire             P_RX_CTLE_DCCAL_RST                              ,
    input  wire             P_CFG_RST                                      ,
    input  wire             P_CFG_CLK                                      ,
    input  wire             P_CFG_PSEL                                     ,
    input  wire             P_CFG_ENABLE                                   ,
    input  wire             P_CFG_WRITE                                    ,
    input  wire [11:0]      P_CFG_ADDR                                     ,
    input  wire [7:0]       P_CFG_WDATA                                    ,
    output wire             P_CFG_READY                                    ,
    output wire [7:0]       P_CFG_RDATA                                    ,
    output wire             P_CFG_INT                                      ,
    output wire [24:0]      LANE_COUT_BUS_FORWARD                          ,
    output wire [1:0]       LANE_COUT_BUS_BACKWARD                         ,
    input  wire [24:0]      LANE_CIN_BUS_FORWARD                           ,
    input  wire [1:0]       LANE_CIN_BUS_BACKWARD                          ,
    input  wire             P_LPLL_REFCLK_IN                               ,
    input  wire             PMA_HPLL_CK0                                   ,
    input  wire             PMA_HPLL_CK90                                  ,
    input  wire             PMA_HPLL_CK180                                 ,
    input  wire             PMA_HPLL_CK270                                 ,
    input  wire             PMA_HPLL_READY_IN                              ,
    input  wire             PMA_HPLL_REFCLK_IN                             ,
    input  wire             PMA_TX_SYNC_HPLL_IN                            ,
    input  wire             P_TX_SYNC                                      ,
    input  wire             P_TX_RATE_CHANGE_ON_0                          ,
    input  wire             P_TX_RATE_CHANGE_ON_1                          ,
    output wire             P_RX_LS_DATA                                   ,
    output wire [19:0]      P_TEST_STATUS                                  ,
    output wire             P_CA_ALIGN_RX                                  ,
    output wire             P_CA_ALIGN_TX                                   
);

//wire
wire             P_RX_CDR_RST                                     = 1'b0;//input
wire             P_RX_CLKPATH_RST                                 = 1'b0;//input
wire             P_LPLL_LOCKDET_RST                               = 1'b0;
wire [7:0]       P_CIM_CLK_ALIGNER_RX                             = 8'b0;//input  [7:0]
wire [7:0]       P_CIM_CLK_ALIGNER_TX                             = 8'b0;//input  [7:0]
wire             P_ALIGN_MODE_VALID_RX                            = 1'b0;//input 
wire [1:0]       P_ALIGN_MODE_RX                                  = 2'b0;//input  [1:0]
wire             P_ALIGN_MODE_VALID_TX                            = 1'b0;//input 
wire [2:0]       P_ALIGN_MODE_TX                                  = 3'b0;//input  [2:0]

//--------GTP LANE instance--------//
GTP_HSSTHP_LANE#(
    //PCS
    .PCS_DYN_DLY_SEL_RX                              ("FALSE"                              ),
    .PCS_PMA_RCLK_POLINV                             ("PMA_RCLK"                           ),
     
    .PCS_PCS_RCLK_SEL                                ("PMA_RCLK"                               ),
    .PCS_GEAR_RCLK_SEL                               ("PMA_RCLK"                               ),
    .PCS_RCLK2FABRIC_SEL                             ("FABRIC_CLK_DIV"                             ),
    .PCS_SCAN_INTERVAL_RX                            ("4_CLOCKS"                           ),
     
    .PCS_BRIDGE_RCLK_SEL                             ("RCLK"                             ),
    .PCS_RCLK_POLINV                                 ("RCLK"                               ),
     
    .PCS_TO_FABRIC_CLK_SEL                           ("PMA_RCLK"                           ),
    .PCS_CLK2ALIGNER_SEL                             ("TO_FABRIC_CLK"                      ),
    .PCS_TO_FABRIC_CLK_DIV_EN                        ("TRUE"                           ),
    .PCS_AUTO_NEAR_LOOP_EN                           ("TRUE"                               ),
     
    .PCS_PCS_RCLK_EN                                 ("FALSE"                           ),
    .PCS_BRIDGE_PCS_RCLK_EN_SEL                      ("TOGGLE"                      ),
    .PCS_BRIDGE_RCLK_EN_SEL                          ("HARD_1"                           ),
    .PCS_GEAR_RCLK_EN_SEL                            ("SYNC_BRIDGE_PCS_RCLK_EN"                   ),
    .PCS_NEGEDGE_EN_RX                               ("FALSE"                              ),
    .PCS_PCS_RX_RSTN                                 ("TRUE"                               ),
    .PCS_BRIDGE_PCS_RSTN                             ("TRUE"                               ),
    .PCS_TO_FABRIC_RST_EN                            ("FALSE"                              ),
     
    .PCS_BYPASS_GEAR_RRSTN                           ("FALSE"                           ),
    .PCS_BYPASS_BRIDGE_RRSTN                         ("FALSE"                           ),
    .PCS_ALIGNER_EN_RX                               ("TRUE"                              ),
     
    .PCS_RX_SLAVE                                    ("MASTER"                           ),
    .PCS_RX_CA                                       (255                                  ),
    .PCS_SUM_THRESHOLD_RX                            (0                                    ),
    .PCS_AVG_CYCLES_RX                               (0                                    ),
     
    .PCS_REG_PMA_RX2TX_PLOOP_EN                      ("TRUE"                           ),
    .PCS_REG_PMA_RX2TX_PLOOP_FIFOEN                  ("TRUE"                           ),
    .PCS_STEP_SIZE_RX                                (0                                    ),
    .PCS_REV_CNT_LIMIT_RX                            (3                                    ),
    .PCS_FILTER_CNT_SIZE_RX                          (0                                    ),
    .PCS_DLY_ADJUST_SIZE_RX_3_0                      (7                                    ),
    .PCS_DLY_REC_SIZE_RX                             (1                                    ),
    .PCS_ALIGN_THRD_RX                               (0                                    ),
    .PCS_DLY_ADJUST_SIZE_RX_4                        (0                                    ),
    .PCS_CFG_DEC_TYPE_EN                             ("TRUE"                               ),
     
    .PCS_RXBRIDGE_GEAR_SEL                           ("TRUE"                           ),
    .PCS_GE_AUTO_EN                                  ("FALSE"                           ),
    .PCS_RXBRG_FULL_CHK_EN                           ("TRUE"                               ),
    .PCS_RXBRG_EMPTY_CHK_EN                          ("TRUE"                               ),
     
    .PCS_IFG_EN                                      ("FALSE"                           ),
    .PCS_FLP_FULL_CHK_EN                             ("TRUE"                               ),
    .PCS_FLP_EMPTY_CHK_EN                            ("TRUE"                               ),
    .PCS_RX_POLARITY_INV                             ("DELAY"                              ),
    .PCS_FARLP_PWR_REDUCTION                         ("FALSE"                              ),
    .PCS_RXPRBS_PWR_REDUCTION                        ("NORMAL"                             ),
    .PCS_WDALIGN_PWR_REDUCTION                       ("NORMAL"                             ),
    .PCS_RXDEC_PWR_REDUCTION                         ("NORMAL"                             ),
    .PCS_RXBRG_PWR_REDUCTION                         ("NORMAL"                             ),
    .PCS_RXTEST_PWR_REDUCTION                        ("NORMAL"                             ),
    .PCS_WA_SOS_DET_TOL                              (0                                    ),
    .PCS_WA_SE_DET_TOL                               (0                                    ),
     
    .PCS_RX_SAMPLE_UNION                             ("FALSE"                             ),
    .PCS_NEAR_LOOP                                   ("FALSE"                              ),
     
    .PCS_BYPASS_WORD_ALIGN                           ("FALSE"                             ),
    .PCS_BYPASS_DENC                                 ("FALSE"                             ),
    .PCS_RX_ERRCNT_CLR                               ("FALSE"                              ),
     
    .PCS_RX_CODE_MODE                                ("32BIT_64B66B"                         ),
    .PCS_RX_BYPASS_GEAR                              ("FALSE"                             ),
    .PCS_ERRDETECT_SILENCE                           ("TRUE"                               ),
     
    .PCS_RX_DATA_MODE                                ("32BIT"                             ),
    .PCS_CA_DYN_CLY_EN_RX                            ("TRUE"                              ),
     
    .PCS_CFG_APATTERN_STATUS_DELAY                   ("DELAY_THREE_CYCLE"                    ),
    .PCS_RX_PRBS_MODE                                ("DISABLE"                            ),
     
    .PCS_ALIGN_MODE                                  ("1GB"                             ),
    .PCS_COMMA_DET_MODE                              ("PCS_BIT_SLIP_RISE"                    ),
    .PCS_RAPID_VMIN_1                                (250                                 ),
    .PCS_RAPID_VMIN_2                                (1                                 ),
    .PCS_RXBU_WIDER_EN                               ("80BIT"                     ),
    .PCS_RAPID_IMAX                                  (5                                 ),
    .PCS_RX_SPLIT                                    ("UNION_44BIT_88BIT"                     ),
    .PCS_RXBRG_END_PACKET_9_8                        (0                                 ),
    .PCS_RXBRG_END_PACKET_7_0                        (0                                 ),
    .PCS_CTC_MAX_DEL                                 (0                                  ),
    .PCS_COMMA_REG0_9_8                              (2'b0                              ),
    .PCS_COMMA_REG1_9_8                              (2'b11 - 2'b0                      ),
    .PCS_COMMA_MASK_9_8                              (2'b0                              ),
    .PCS_COMMA_REG0_7_0                              (8'b0                         ),
    .PCS_COMMA_REG1_7_0                              (8'b11111111 - 8'b0           ),
    .PCS_COMMA_MASK_7_0                              (8'b0                         ),
    .PCS_FLP_WRADDR_START                            (0                                    ),
    .PCS_FLP_RDADDR_START                            (0                                    ),
     
    .PCS_CFG_RX_BRIDGE_CLK_POLINV                    ("FALSE"                             ),
    .PCS_CTC_MODE_RD_SEL                             ("NOMINAL_HALF_FULL_MODE"         ),
    .PCS_CTC_AFULL                                   (48                                  ),
    .PCS_FAST_LOCK_GEAR_EN                           ("FALSE"                              ),
     
    .PCS_CTC_MODE_WR_SEL                             ("NOMINAL_HALF_FULL_MODE"         ),
    .PCS_CTC_AEMPTY                                  (16                                  ),
    .PCS_CTC_MODE                                    ("ONE_BYTE"                            ),
    .PCS_RXBRIDGE_MODE                               ("BRIDGE_FIFO_MODE"                            ),
    .PCS_CTC_ADD_MAX                                 (1                                  ),
    .PCS_CFG_PHDET_EN_RX                             ("TRUE"                               ),
    .PCS_WA_SDS_DET_TOL                              (0                                    ),
     
    .PCS_CEB_MODE                                    ("10GB"                               ),
    .PCS_APATTERN_MODE                               ("ONE_BYTE"                             ),
    .PCS_A_REG0_8                                    ("TRUE"                            ),
    .PCS_RXBRG_WADDR_START                           (6                                 ),
    .PCS_A_REG1_8                                    ("TRUE"                            ),
    .PCS_RXBRG_RADDR_START                           (1                                  ),
    .PCS_A_REG0_7_0                                  (8'b01111100                           ),
    .PCS_A_REG1_7_0                                  (8'b01111100                           ),
    .PCS_CEB_RAPIDLS_MMAX                            (5                                  ),
    .PCS_CEB_DETECT_TIME                             (9                                  ),
    .PCS_WL_FIFO_RD                                  (8                                  ),
    .PCS_SKIP_REG0_9_8                               (2'b0                              ),
    .PCS_SKIP_REG0_7_0                               (8'b0                         ),
    .PCS_CFG_CONTI_SKP_SET                           (0                                  ),
    .PCS_CFG_RX_BASE_ADV_MODE                        ("BASE_MODE"                          ),
     
    .PCS_SKIP_REG1_9_8                               (2'b0                              ),
    .PCS_SKIP_REG2_9_8                               (2'b0                              ),
    .PCS_SKIP_REG3_9_8                               (2'b0                              ),
    .PCS_SKIP_REG1_7_0                               (8'b0                         ),
    .PCS_SKIP_REG2_7_0                               (8'b0                         ),
    .PCS_SKIP_REG3_7_0                               (8'b0                         ),
    .PCS_CFG_PRBS_ERR_O_SEL                          (0                                    ),
    .PCS_CFG_PD_DELAY_RX                             (3                                    ),
     
    .PCS_WR_START_GAP                                (9                                  ),
    .PCS_MIN_IFG                                     (0                                  ),
    .PCS_INT_RX_MASK_0                               ("FALSE"                              ),
    .PCS_INT_RX_MASK_1                               ("FALSE"                              ),
    .PCS_INT_RX_MASK_2                               ("FALSE"                              ),
    .PCS_INT_RX_MASK_3                               ("FALSE"                              ),
    .PCS_INT_RX_MASK_4                               ("FALSE"                              ),
    .PCS_INT_RX_MASK_5                               ("FALSE"                              ),
    .PCS_INT_RX_CLR_5                                ("FALSE"                              ),
    .PCS_INT_RX_CLR_4                                ("FALSE"                              ),
    .PCS_INT_RX_CLR_3                                ("FALSE"                              ),
    .PCS_INT_RX_CLR_2                                ("FALSE"                              ),
    .PCS_INT_RX_CLR_1                                ("FALSE"                              ),
    .PCS_INT_RX_CLR_0                                ("FALSE"                              ),
    .PCS_EM_CNT_RD_EN                                ("FALSE"                              ),
    .PCS_EM_CTRL_SEL                                 ("SIGNAL_CTRL"                        ),
    .PCS_EM_MODE_CTRL                                ("HOLD"                               ),
    .PCS_EM_RD_CONDITION                             ("TRIGGER"                            ),
    .PCS_EM_SP_PATTERN_7_0                           (0                                    ),
    .PCS_EM_SP_PATTERN_15_8                          (0                                    ),
    .PCS_EM_SP_PATTERN_23_16                         (0                                    ),
    .PCS_EM_SP_PATTERN_31_24                         (0                                    ),
    .PCS_EM_SP_PATTERN_39_32                         (0                                    ),
    .PCS_EM_SP_PATTERN_47_40                         (0                                    ),
    .PCS_EM_SP_PATTERN_55_48                         (0                                    ),
    .PCS_EM_SP_PATTERN_63_56                         (0                                    ),
    .PCS_EM_SP_PATTERN_71_64                         (0                                    ),
    .PCS_EM_SP_PATTERN_79_72                         (0                                    ),
    .PCS_EM_PMA_MASK_7_0                             (0                                    ),
    .PCS_EM_PMA_MASK_15_8                            (0                                    ),
    .PCS_EM_PMA_MASK_23_16                           (0                                    ),
    .PCS_EM_PMA_MASK_31_24                           (0                                    ),
    .PCS_EM_PMA_MASK_39_32                           (0                                    ),
    .PCS_EM_PMA_MASK_47_40                           (0                                    ),
    .PCS_EM_PMA_MASK_55_48                           (0                                    ),
    .PCS_EM_PMA_MASK_63_56                           (0                                    ),
    .PCS_EM_PMA_MASK_71_64                           (0                                    ),
    .PCS_EM_PMA_MASK_79_72                           (0                                    ),
    .PCS_EM_EYED_MASK_7_0                            (0                                    ),
    .PCS_EM_EYED_MASK_15_8                           (0                                    ),
    .PCS_EM_EYED_MASK_23_16                          (0                                    ),
    .PCS_EM_EYED_MASK_31_24                          (0                                    ),
    .PCS_EM_EYED_MASK_39_32                          (0                                    ),
    .PCS_EM_EYED_MASK_47_40                          (0                                    ),
    .PCS_EM_EYED_MASK_55_48                          (0                                    ),
    .PCS_EM_EYED_MASK_63_56                          (0                                    ),
    .PCS_EM_EYED_MASK_71_64                          (0                                    ),
    .PCS_EM_EYED_MASK_79_72                          (0                                    ),
    .PCS_EM_PRESCALE                                 (0                                    ),
    .PCS_CFG_TEST_STATUS_SEL                         ("SEL_PMA_TEST_STATUS_INT"            ),
    .PCS_CFG_DIFF_CNT_BND_RX                         (0                                    ),
    .PCS_CFG_FLT_SEL_RX                              ("FALSE"                              ),
    .PCS_FILTER_BND_RX                               (0                                    ),
    .PCS_TCLK2FABRIC_DIV_RST_M                       ("FALSE"                              ),
    .PCS_TX_PMA_TCLK_POLINV                          ("PMA_TCLK"                           ),
    .PCS_TX_TCLK_POLINV                              ("TCLK"                               ),
     
    .PCS_PCS_TCLK_SEL                                ("PMA_TCLK"                            ),
    .PCS_GEAR_TCLK_SEL                               ("PMA_TCLK"                            ),
    .PCS_TX_BRIDGE_TCLK_SEL                          ("TCLK"                             ),
    .PCS_TCLK2ALIGNER_SEL                            ("PMA_TCLK_DIV2"                           ),
    .CA_DYN_DLY_EN_TX                                ("TRUE"                              ),
     
    .PCS_TX_PCS_CLK_EN_SEL                           ("TOGGLE"                        ),
    .PCS_TX_GEAR_CLK_EN_SEL                          ("ALIGN_PCS_CLK_EN"                        ),
    .PCS_TCLK2FABRIC_DIV_EN                          ("TRUE"                           ),
    .PCS_TCLK2FABRIC_SEL                             ("CLK2ALIGNER_N_DIV2"                 ),
    .DLY_ADJUST_SIZE_TX                              (7                                    ),
    .PCS_TX_PCS_TX_RSTN                              ("TRUE"                               ),
    .PCS_TX_CA_RSTN                                  ("TRUE"                               ),
     
    .PCS_TX_SLAVE                                    ("MASTER"                          ),
    .PCS_TX_CA                                       (255                                  ),
    .PCS_CFG_PI_CLK_SEL                              (1                                    ),
    .PCS_CFG_PI_CLK_EN_SEL                           ("CLK_EN_ROLL"                        ),
    .PCS_CFG_PI_STEP_SIZE_TX                         (11                                   ),
    .PCS_CFG_SUM_THRESHOLD_TX                        (10                                   ),
    .PCS_CFG_AVG_CYCLES_TX                           (1                                    ),
    .PCS_CFG_NEGEDGE_EN_TX                           ("FALSE"                              ),
    .PCS_CFG_ALIGN_THRD_TX                           (112                                  ),
    .PCS_CFG_SCAN_INTERVAL_TX                        (1                                    ),
    .PCS_CFG_STEP_SIZE_TX                            (2                                    ),
    .PCS_CFG_REV_CNT_LIMIT_TX                        (3                                    ),
    .PCS_CFG_FILTER_CNT_SIZE_TX                      (1                                    ),
    .PCS_CFG_PI_DEFAULT_TX                           (0                                    ),
    .PCS_CFG_PHDET_EN_TX                             ("TRUE"                               ),
     
    .PCS_PMA_TX2RX_PLOOP_EN                          ("TRUE"                             ),
    .PCS_PMA_TX2RX_SLOOP_EN                          ("TRUE"                             ),
    .PCS_CFG_DYN_DLY_SEL_TX                          ("FALSE"                              ),
    .PCS_CFG_DLY_REC_SIZE_TX                         (0                                    ),
     
    .PCS_TX_DATA_WIDTH_MODE                          ("32BIT"                             ),
    .PCS_TX_BYPASS_BRIDGE_UINT                       ("FALSE"                            ),
    .PCS_TX_BYPASS_BRIDGE_FIFO                       ("FALSE"                            ),
    .PCS_TX_BYPASS_GEAR                              ("FALSE"                            ),
    .PCS_TX_BYPASS_ENC                               ("FALSE"                            ),
    .PCS_TX_BYPASS_BIT_SLIP                          ("TRUE"                               ),
     
    .PCS_TX_BRIDGE_GEAR_SEL                          ("FALSE"                            ),
    .PCS_TXBRG_PWR_REDUCTION                         ("NORMAL"                             ),
    .PCS_TXGEAR_PWR_REDUCTION                        ("NORMAL"                             ),
    .PCS_TXENC_PWR_REDUCTION                         ("NORMAL"                             ),
    .PCS_TXBSLP_PWR_REDUCTION                        ("NORMAL"                             ),
    .PCS_TXPRBS_PWR_REDUCTION                        ("NORMAL"                             ),
    .PCS_TXBRG_FULL_CHK_EN                           ("FALSE"                              ),
    .PCS_TXBRG_EMPTY_CHK_EN                          ("FALSE"                              ),
     
    .PCS_TX_ENCODER_MODE                             ("32BIT_64B66B"                         ),
    .PCS_TX_PRBS_MODE                                ("DISABLE"                            ),
    .PCS_TX_DRIVE_REG_MODE                           ("NO_CHANGE"                          ),
    .PCS_TX_BIT_SLIP_CYCLES                          (0                                    ),
    .PCS_TX_BASE_ADV_MODE                            ("BASE"                               ),
     
    .PCS_TX_GEAR_SPLIT                               ("SPLIT_TX_DATA"                          ),
    .PCS_RX_BRIDGE_CLK_POLINV                        ("N_CLK_INVERT"                    ),//actually Tx Bridge Clk Polinv
    .PCS_PRBS_ERR_LPBK                               ("FALSE"                              ),
    .PCS_TX_INSERT_ER                                ("FALSE"                              ),
    .PCS_ENABLE_PRBS_GEN                             ("FALSE"                              ),
    .PCS_FAR_LOOP                                    ("FALSE"                              ),
    .PCS_CFG_ENC_TYPE_EN                             ("TRUE"                               ),
    .PCS_TXBRG_WADDR_START                           (5                                    ),
    .PCS_TXBRG_RADDR_START                           (1                                    ),
    .PCS_CFG_TX_PIC_EN                               ("DISABLE"                            ),
    .PCS_CFG_PIC_DIRECT_INV                          ("FALSE"                              ),
    .PCS_CFG_PI_MOD_CLK_EN                           ("FALSE"                              ),
    .PCS_CFG_TX_MODULATOR_OW_EN                      ("FALSE"                              ),
    .PCS_CFG_TX_PI_SSC_MODE_EN                       ("FALSE"                              ),
    .PCS_CFG_TX_PI_OFFSET_MODE_EN                    ("FALSE"                              ),
    .PCS_CFG_TX_PI_SSC_MODE_SEL                      (0                                    ),
    .PCS_CFG_TXDEEMPH_EN                             ("FALSE"                              ),
    .PCS_PI_STROBE_SEL                               ("TRUE"                               ),
    .PCS_CFG_TX_PIC_GREY_SEL                         ("FALSE"                              ),
    .PCS_CFG_PIC_RENEW_INV                           ("NORMAL"                             ),
    .PCS_CFG_NUM_PIC                                 (0                                    ),
    .PCS_CFG_TXPIC_OW_EN                             ("FALSE"                              ),
    .PCS_CFG_TX_SSC_OW_VALUE_0_7                     (0                                    ),
    .PCS_INT_TX_MASK_0                               ("FALSE"                              ),
    .PCS_INT_TX_MASK_1                               ("FALSE"                              ),
    .PCS_INT_TX_MASK_2                               ("FALSE"                              ),
    .PCS_TX_WPTR_SEL                                 ("FALSE"                              ),
    .PCS_INT_TX_CLR_2                                ("FALSE"                              ),
    .PCS_INT_TX_CLR_1                                ("FALSE"                              ),
    .PCS_INT_TX_CLR_0                                ("FALSE"                              ),
    .PCS_CFG_PD_DELAY_TX                             (0                                    ),
    .PCS_CFG_DIFF_CNT_BND_TX                         (0                                    ),
    .PCS_CFG_PD_CLK_FR_CORE_SEL                      ("FALSE"                              ),
    .PCS_CFG_FLT_SEL_TX                              ("FALSE"                              ),
    .PCS_FILTER_BND_TX                               (0                                    ),
    .PCS_CFG_TX_SSC_RANGE_7_0                        (0                                    ),
    .PCS_CFG_TX_SSC_MODULATOR_EN                     ("FALSE"                              ),
    .PCS_CFG_TX_SSC_SCALE2_SEL                       (0                                    ),
    .PCS_CFG_TX_SSC_SCALE_SEL                        (0                                    ),
    .PCS_CFG_TX_SSC_RANGE_8_9                        (0                                    ),
    .PCS_CFG_TX_SSC_MODULATION_STEP_7_0              (0                                    ),
    .PCS_CFG_TX_SSC_OFFSET_7_0                       (0                                    ),
    .PCS_CFG_TX_SSC_MODULATION_STEP_8                (0                                    ),
    .PCS_CFG_TX_SSC_OFFSET_8_9                       (0                                    ),
    //PMA
    .PMA_REG_IBIAS_STATIC_SEL_7_0                    (255                                  ),
    .PMA_REG_IBIAS_STATIC_SEL_15_8                   (247                                  ),
    .PMA_REG_IBIAS_STATIC_SEL_18_16                  (7                                    ),
    .PMA_REG_IBIAS_STATIC_SEL_21_19                  (0                                    ),
    .PMA_REG_IBIAS_STATIC_SEL_29_22                  (0                                    ),
    .PMA_REG_IBIAS_STATIC_SEL_37_30                  (1                                    ),
    .PMA_REG_IBIAS_DYNAMIC_PD_7_0                    (0                                    ),
    .PMA_REG_IBIAS_DYNAMIC_PD_15_8                   (0                                    ),
    .PMA_REG_IBIAS_DYNAMIC_PD_18_16                  (0                                    ),
    .PMA_REG_IBIAS_STA_CUR_SEL_4_0                   (31                                   ),
    .PMA_REG_IBIAS_STA_CUR_SEL_8_5                   (15                                   ),
    .PMA_REG_IBIAS_STA_CUR_SEL_12_9                  (0                                    ),
    .PMA_REG_IBIAS_STA_CUR_SEL_17_13                 (0                                    ),
    .PMA_REG_IBIAS_STA_CUR_PD_2_0                    (0                                    ),
    .PMA_REG_IBIAS_STA_CUR_PD_8_3                    (0                                    ),
    .PMA_REG_BANDGAP_VOL_SEL                         ("BANDGAP"                            ),
    .PMA_REG_BANDGAP_TEST                            (0                                    ),
    //RX PMA
    .PMA_REG_CHL_BIAS_POWER_SEL                      ("FALSE"          ),
    .PMA_REG_CHL_BIAS_POWER                          ("FALSE"          ),
     
    .PMA_REG_RX_BUSWIDTH                             ( "32BIT"          ),
    .PMA_REG_RX_RATE                                 ( "MUL2"          ),
    .PMA_REG_RX_RATE_EN                              ( "FALSE"          ),
    .PMA_REG_RX_RES_TRIM                             ( 49               ),
    .PMA_REG_RX_SIGDET_STATUS_EN                     ( "FALSE"          ),
    .PMA_REG_CDR_READY_THD_7_0                       ( 0                ),
    .PMA_REG_CDR_READY_THD_11_8                      ( 0                ),
     
    .PMA_REG_RX_BUSWIDTH_EN                          ( "TRUE"          ),
    .PMA_REG_RX_PCLK_EDGE_SEL                        ( "POS_EDGE"       ),
     
    .PMA_REG_RX_PIBUF_IC                             ( 3               ),
    .PMA_REG_RX_DCC_IC_RX                            ( 1               ),
    .PMA_REG_CDR_READY_CHECK_CTRL                    ( 0                ),
    .PMA_REG_RX_ICTRL_TRX                            ( "100PCT"         ),
     
    .PMA_REG_PRBS_CHK_WIDTH_SEL                      ( 4              ),
    .PMA_REG_RX_ICTRL_PIBUF                          ( "100PCT"         ),
    .PMA_REG_RX_ICTRL_PI                             ( "100PCT"         ),
    .PMA_REG_RX_ICTRL_DCC                            ( "100PCT"         ),
     
    .PMA_REG_TX_RATE                                 ( "MUL2"          ),
    .PMA_REG_TX_RATE_EN                              ( "FALSE"          ),
    .PMA_REG_RX_TX2RX_PLPBK_RST_N                    ( "TRUE"           ),
    .PMA_REG_RX_TX2RX_PLPBK_RST_N_EN                 ( "FALSE"          ),
    .PMA_REG_RX_TX2RX_PLPBK_EN                       ( "FALSE"          ),
    .PMA_REG_RX_DATA_POLARITY                        ( "NORMAL"         ),
    .PMA_REG_RX_ERR_INSERT                           ( "FALSE"          ),
    .PMA_REG_UDP_CHK_EN                              ( "FALSE"          ),
    .PMA_REG_PRBS_SEL                                ( "PRBS7"          ),
    .PMA_REG_PRBS_CHK_EN                             ( "FALSE"          ),
    .PMA_REG_LPLL_NFC_STIC_DIS_N                     ( 0                ),
    .PMA_REG_BIST_CHK_PAT_SEL                        ( "PRBS"           ),
    .PMA_REG_LOAD_ERR_CNT                            ( "FALSE"          ),
    .PMA_REG_CHK_COUNTER_EN                          ( "FALSE"          ),
     
    .PMA_REG_CDR_PROP_GAN_SEL                        ( 3              ),
    .PMA_REG_CDR_TUBO_PROP_GAIN_SEL                  ( 6                ),
     
    .PMA_REG_CDR_INT_GAIN_SEL                        ( 2              ),
    .PMA_REG_CDR_TUBO_INT_GAIN_SEL                   ( 6                ),
    .PMA_REG_CDR_INT_SAT_MAX_4_0                     ( 0                ),
     
    .PMA_REG_CDR_INT_SAT_MAX_9_5                     ( 31             ),
    .PMA_REG_CDR_INT_SAT_MIN_2_0                     ( 0                ),
     
    .PMA_REG_CDR_INT_SAT_MIN_9_3                     ( 4             ),
    .PMA_ANA_RX_REG_O_61_55                          ( 0               ),
    .PMA_ANA_RX_REG_O_69_62                          ( 0                ),
    `ifdef IPM2T_HSST_SPEEDUP_SIM
    .PMA_ANA_RX_REG_O_77_70                          ( 129              ),
    `else
     
    .PMA_ANA_RX_REG_O_77_70                          ( 133             ),
    `endif
    .PMA_ANA_RX_REG_O_85_78                          ( 1                ),
     
    .PMA_ANA_RX_REG_O_93_86                          ( 17              ),
    .PMA_ANA_RX_REG_O_100_94                         ( 64               ),
    .PMA_ANA_RX_REG_O_108_101                        ( 0                ),
    .PMA_ANA_RX_REG_O_111_109                        ( 0                ),
    .PMA_REG_OOB_COMWAKE_GAP_MIN_4_0                 ( 3                ),
    .PMA_REG_OOB_COMWAKE_GAP_MIN_5                   ( 0                ),
    .PMA_REG_OOB_COMWAKE_GAP_MAX                     ( 11               ),
    .PMA_REG_OOB_COMINIT_GAP_MIN                     ( 15               ),
    .PMA_REG_OOB_COMINIT_GAP_MAX                     ( 35               ),
    .PMA_REG_COMWAKE_STATUS_CLEAR                    ( 0                ),
    .PMA_REG_COMINIT_STATUS_CLEAR                    ( 0                ),
    .PMA_REG_RX_SATA_COMINIT_OW                      ( "FALSE"          ),
    .PMA_REG_RX_SATA_COMINIT                         ( "FALSE"          ),
    .PMA_REG_RX_SATA_COMWAKE_OW                      ( "FALSE"          ),
    .PMA_REG_RX_SATA_COMWAKE                         ( "FALSE"          ),
    .PMA_REG_RX_DCC_DISABLE                          ( "FALSE"          ),
    .PMA_REG_RX_SLIP_SEL_EN                          ( "FALSE"          ),
    .PMA_REG_RX_SLIP_SEL_3_0                         ( 0                ),
    .PMA_REG_RX_SLIP_EN                              ( "FALSE"          ),
    .PMA_REG_RX_SIGDET_STATUS_SEL                    ( 5                ),
    .PMA_REG_RX_SIGDET_FSM_RST_N                     ( "TRUE"           ),
    .PMA_REG_RX_SIGDET_STATUS                        ( "FALSE"          ),
     
    .PMA_REG_RX_SIGDET_VTH                           ( "72MV"           ),
    .PMA_REG_RX_SIGDET_GRM                           ( 0                ),
    .PMA_REG_RX_SIGDET_PULSE_EXT                     ( "FALSE"          ),
    .PMA_REG_RX_SIGDET_CH2_SEL                       ( 0                ),
    .PMA_REG_RX_SIGDET_CH2_CHK_WINDOW                ( 3                ),
    .PMA_REG_RX_SIGDET_CHK_WINDOW_EN                 ( "TRUE"           ),
    .PMA_REG_RX_SIGDET_NOSIG_COUNT_SETTING           ( 4                ),
    .PMA_REG_RX_SIGDET_OOB_DET_COUNT_VAL_2_0         ( 0                ),
    .PMA_REG_RX_SIGDET_OOB_DET_COUNT_VAL_4_3         ( 0                ),
    .PMA_REG_RX_SIGDET_4OOB_DET_SEL                  ( 7                ),
    .PMA_REG_RX_SIGDET_IC_I                          ( 10               ),
    .PMA_REG_RX_EQ1_R_SET_TOP                        ( 0                ),
     
    .PMA_REG_RX_EQ1_C_SET_FB                         ( 0              ),
    .PMA_REG_RX_EQ1_OFF                              ( "FALSE"          ),
    .PMA_REG_RX_EQ2_R_SET_TOP                        ( 0                ),
    .PMA_REG_RX_EQ2_C_SET_FB                         ( 0                ),
    .PMA_REG_RX_EQ2_OFF                              ( "FALSE"          ),
    .PMA_REG_RX_ICTRL_EQ                             ( 2                ),
    .PMA_REG_EQ_DC_CALIB_EN                          ( "FALSE"          ),
    .PMA_CTLE_CTRL_REG_I                             ( 0                ),
    .PMA_CTLE_REG_FORCE_SEL_I                        ( "FALSE"          ),
    .PMA_CTLE_REG_HOLD_I                             ( "FALSE"          ),
    .PMA_CTLE_REG_INIT_DAC_I_1_0                     ( 0                ),
    .PMA_CTLE_REG_INIT_DAC_I_3_2                     ( 0                ),
    .PMA_CTLE_REG_POLARITY_I                         ( "FALSE"          ),
    .PMA_CTLE_REG_SHIFTER_GAIN_I                     ( 4                ),
    .PMA_CTLE_REG_THRESHOLD_I_1_0                    ( 0                ),
    .PMA_CTLE_REG_THRESHOLD_I_9_2                    ( 1                ),
    .PMA_CTLE_REG_THRESHOLD_I_11_10                  ( 0                ),
     
    .PMA_REG_RX_RES_TRIM_EN                          ( "TRUE"             ),
    .PMA_REG_ALG_RX_TERM_POWER_DIVIDING_SELECTION    ( 1                ),
    .PMA_REG_ALG_RX_TERM_VCM_SELECTION               ( 3                ),
    .PMA_REG_ALG_RX_TERM_TEST_SELECTION_7_0          ( 0                ),
    .PMA_REG_ALG_RX_TERM_TEST_SELECTION_9_8          ( 0                ),
    .PMA_REG_ALG_LOW_SPEED_MODE_ENABLE               ( "FALSE"          ),
    .PMA_REG_ALG_RX_CLOCK_POWER_DOWN_REGISTER        ( "FALSE"          ),
    .PMA_REG_ALG_RX_CLOCK_POWER_DOWN_SELECTION       ( "FALSE"          ),
    .PMA_REG_ALG_RX_DFE_POWER_DOWN_REGISTER_0        ( "FALSE"          ),
    .PMA_REG_ALG_RX_DFE_POWER_DOWN_SELECTION_1       ( "FALSE"          ),
    .PMA_REG_ALG_RX_CTLE_POWER_DOWN_REGISTER_0       ( "FALSE"          ),
    .PMA_REG_ALG_RX_CTLE_POWER_DOWN_SELECTION_1      ( "FALSE"          ),
    .PMA_REG_EYE_DFETAP1_PLORITY                     ( "TRUE"           ),
    .PMA_REG_CDR_SEL                                 ( "FALSE"          ),
    .PMA_REG_EYE_DET_EN                              ( "TRUE"           ),
    .PMA_REG_PI_BIAS_CURRENT                         ( 0                ),
    .PMA_REG_ALG_DFE_TEST_SEL_6_0                    ( 0                ),
    .PMA_REG_ALG_DFE_TEST_SEL_14_7                   ( 0                ),
    .PMA_REG_ALG_DFE_TEST_SEL_21_15                  ( 0                ),
    .PMA_REG_ALG_EYE_PATH_SEL                        ( 0                ),
    .PMA_REG_ALG_CTLE_TEST_SEL                       ( 0                ),
    .PMA_REG_RX_SLIP_SEL_4                           ( "FALSE"          ),
    .PMA_REG_ALG_RX_T1_BUFF_EN                       ( "TRUE"           ),
    .PMA_REG_ALG_RX_CDRX_BUFF_EN                     ( "TRUE"           ),
    .PMA_REG_ALG_RX_VP_T1_SW_PLORITY                 ( "FALSE"          ),
    .PMA_REG_ALG_RX_VP_PLORITY                       ( "TRUE"           ),
    .PMA_REG_ALG_RX_GAIN_CTRL_SUMMER                 ( "TRUE"           ),
    .PMA_REG_ALG_RX_DC_OFFSET_T1_EN                  ( "TRUE"           ),
    .PMA_REG_ALG_RX_DC_OFFSET_VP_EN                  ( "TRUE"           ),
    .PMA_REG_ALG_RX_DC_OFFSET_CDRX_EN                ( "TRUE"           ),
    .PMA_REG_ALG_RX_DC_OFFSET_CDRY_EN                ( "TRUE"           ),
    .PMA_REG_ALG_RX_DC_OFFSET_EYE_EN                 ( "TRUE"           ),
    .PMA_REG_ALG_SLICER_DC_OFFSET_OVERWITE           ( "FALSE"          ),
    .PMA_REG_ALG_SLICER_DC_OFFSET_REG                ( "FALSE"          ),
    .PMA_REG_RX_PGA_OFF                              ( "FALSE"          ),
    .PMA_REG_ALG_CDR_XWEIGHT_I                       ( 4                ),
    .PMA_REG_ALG_CDR_YWEIGHT_I                       ( 2                ),
    .PMA_REG_ALG_CTLE_FLIPDIR_I                      ( "FALSE"          ),
    .PMA_REG_ALG_CTLE_HOLD_I                         ( "FALSE"          ),
    .PMA_REG_ALG_CTLE_INITDAC_5_0                    ( 0                ),
    .PMA_REG_ALG_CTLE_INITDAC_6                      ( 0                ),
    .PMA_REG_ALG_CTLE_OVERWREN_I                     ( "FALSE"          ),
    .PMA_REG_ALG_CTLE_SHIFT_I                        ( 4                ),
    .PMA_REG_ALG_CTLE_TOPNUM_2_0                     ( 4                ),
    .PMA_REG_ALG_CTLE_TOPNUM_4_3                     ( 2                ),
    .PMA_REG_ALG_CTLEOFS_FLIPDIR_I                   ( "TRUE"           ),
    .PMA_REG_ALG_CTLEOFS_HOLD_I                      ( "FALSE"          ),
    .PMA_REG_ALG_CTLEOFS_INITDAC_3_0                 ( 0                ),
    .PMA_REG_ALG_CTLEOFS_INITDAC_6_4                 ( 5                ),
    .PMA_REG_ALG_CTLEOFS_OVERWREN                    ( "FALSE"          ),
    .PMA_REG_ALG_CTLEOFS_SHIFT_I                     ( 4                ),
    .PMA_REG_ALG_DFE_CTLE_PWD                        ( "FALSE"          ),
    .PMA_REG_ALG_H1_FLIPDIR_I                        ( "FALSE"          ),
    .PMA_REG_ALG_H1_HOLD_I                           ( "FALSE"          ),
    .PMA_REG_ALG_H1_INITDAC_5_0                      ( 0                ),
    .PMA_REG_ALG_H1_INITDAC_6                        ( 0                ),
    .PMA_REG_ALG_H1_OVERWREN_I                       ( "FALSE"          ),
    .PMA_REG_ALG_H1_SHIFT_I                          ( 4                ),
    .PMA_REG_ALG_H2_FLIPDIR_I                        ( "FALSE"          ),
    .PMA_REG_ALG_H2_HOLD_I                           ( "FALSE"          ),
    .PMA_REG_ALG_H2_INITDAC_0                        ( 0                ),
    .PMA_REG_ALG_H2_INITDAC_5_1                      ( 0                ),
    .PMA_REG_ALG_H2_OVERWREN_I                       ( "FALSE"          ),
    .PMA_REG_ALG_H2_SHIFT_I_1_0                      ( 0                ),
    .PMA_REG_ALG_H2_SHIFT_I_2                        ( 1                ),
    .PMA_REG_ALG_H3_FLIPDIR_I                        ( "FALSE"          ),
    .PMA_REG_ALG_H3_HOLD_I                           ( "FALSE"          ),
    .PMA_REG_ALG_H3_INITDAC_4_0                      ( 0                ),
    .PMA_REG_ALG_H3_INITDAC_5                        ( 1                ),
    .PMA_REG_ALG_H3_OVERWREN_I                       ( "FALSE"          ),
    .PMA_REG_ALG_H3_SHIFT_I                          ( 4                ),
    .PMA_REG_ALG_H4_FLIPDIR_I                        ( "FALSE"          ),
    .PMA_REG_ALG_H4_HOLD_I                           ( "FALSE"          ),
    .PMA_REG_ALG_H4_INITDAC_0                        ( 0                ),
    .PMA_REG_ALG_H4_INITDAC_4_1                      ( 8                ),
    .PMA_REG_ALG_H4_OVERWREN_I                       ( "FALSE"          ),
    .PMA_REG_ALG_H4_SHIFT_I                          ( 4                ),
    .PMA_REG_ALG_H5_FLIPDIR_I                        ( "FALSE"          ),
    .PMA_REG_ALG_H5_HOLD_I                           ( "FALSE"          ),
    .PMA_REG_ALG_H5_INITDAC                          ( 16               ),
    .PMA_REG_ALG_H5_OVERWREN_I                       ( "FALSE"          ),
    .PMA_REG_ALG_H5_SHIFT_I                          ( 4                ),
    .PMA_REG_ALG_H6_FLIPDIR_I                        ( "FALSE"          ),
    .PMA_REG_ALG_H6_HOLD_I                           ( "FALSE"          ),
    .PMA_REG_ALG_H6_INITDAC_2_0                      ( 0                ),
    .PMA_REG_ALG_H6_INITDAC_4_3                      ( 2                ),
    .PMA_REG_ALG_H6_OVERWREN_I                       ( "FALSE"          ),
    .PMA_REG_ALG_H6_SHIFT_I                          ( 4                ),
    .PMA_REG_ALG_HCTLE_OFS_1_0                       ( 0                ),
    .PMA_REG_ALG_HCTLE_OFS_3_2                       ( 3                ),
    .PMA_REG_ALG_HCTLE_OVERWRDAC_5_0                 ( 0                ),
    .PMA_REG_ALG_HCTLE_OVERWRDAC_6                   ( 1                ),
    .PMA_REG_ALG_HCTLE_OVERWREN                      ( "FALSE"          ),
    .PMA_REG_ALG_LEQH_INITDAC_I                      ( 0                ),
    .PMA_REG_ALG_LEQH_PWD_I                          ( "FALSE"          ),
    .PMA_REG_ALG_LEQH_REG_HOLD_I                     ( "FALSE"          ),
    .PMA_REG_ALG_LEQH_REG_SHIFT_I                    ( 4                ),
    .PMA_REG_ALG_LEQL_INITDAC_I                      ( 0                ),
    .PMA_REG_ALG_LEQL_PWD_I                          ( "FALSE"          ),
    .PMA_REG_ALG_LEQL_REG_HOLD_I                     ( "FALSE"          ),
    .PMA_REG_ALG_LEQL_REG_PRESELECT_I                ( 7                ),
    .PMA_REG_ALG_LEQL_REG_SHIFT_I                    ( 4                ),
    .PMA_REG_ALG_NEXTBIT_I                           ( "FALSE"          ),
     
    .PMA_REG_ALG_SOFS_COUNTMAX_I_6_0                 ( 127              ),
    .PMA_REG_ALG_SOFS_COUNTMAX_I_14_7                ( 255              ),
    .PMA_REG_ALG_SOFS_COUNTMAX_I_19_15               ( 31               ),
    .PMA_REG_ALG_SOFS_DACWIN_I                       ( 1                ),
    .PMA_REG_ALG_SOFS_FLIP_DIR_I                     ( "TRUE"           ),
    .PMA_REG_ALG_SOFS_FORCE_I                        ( "FALSE"          ),
    .PMA_REG_ALG_SOFS_FORCEDAC_I_5_0                 ( 0                ),
    .PMA_REG_ALG_SOFS_FORCEDAC_I_6                   ( 1                ),
    .PMA_REG_ALG_SOFS_FORCENUM_I                     ( 0                ),
    .PMA_REG_ALG_SOFS_INITDAC_2_0                    ( 0                ),
    .PMA_REG_ALG_SOFS_INITDAC_6_3                    ( 8                ),
    .PMA_REG_ALG_SOFS_SHIFT_I                        ( 1                ),
    `ifdef IPM2T_HSST_SPEEDUP_SIM
    .PMA_REG_ALG_SOFS_SKIP_I                         ( "TRUE"           ),
    .PMA_REG_ALG_SOFS_WINCOUNTMAX_I_7_0              ( 0                ),
    .PMA_REG_ALG_SOFS_WINCOUNTMAX_I_11_8             ( 4                ),
    `else
     
    .PMA_REG_ALG_SOFS_SKIP_I                         ( "FALSE"         ),
    .PMA_REG_ALG_SOFS_WINCOUNTMAX_I_7_0              ( 254               ),
    .PMA_REG_ALG_SOFS_WINCOUNTMAX_I_11_8             ( 15               ),
    `endif
    .PMA_REG_ALG_ST_FLIPDIR_I                        ( "TRUE"           ),
    .PMA_REG_ALG_ST_FORCEN                           ( "FALSE"          ),
    .PMA_REG_ALG_ST_HOLD_I                           ( "FALSE"          ),
    .PMA_REG_ALG_ST_INITDAC_0                        ( 0                ),
    .PMA_REG_ALG_ST_INITDAC_4_1                      ( 8                ),
    .PMA_REG_ALG_ST_RECALEN                          ( "FALSE"          ),
    .PMA_REG_ALG_ST_SHIFT_I                          ( 4                ),
    .PMA_REG_ALG_ST_STARTCNT_7_0                     ( 0                ),
    .PMA_REG_ALG_ST_STARTCNT_15_8                    ( 128              ),
    .PMA_REG_ALG_ST_STARTCNT_19_16                   ( 0                ),
    .PMA_REG_ALG_ST_TAPCNT_3_0                       ( 0                ),
    .PMA_REG_ALG_ST_TAPCNT_11_4                      ( 0                ),
    .PMA_REG_ALG_ST_TAPCNT_17_12                     ( 2                ),
    .PMA_REG_ALG_ST_TOPTAP_1_0                       ( 3                ),
    .PMA_REG_ALG_ST_TOPTAP_3_2                       ( 3                ),
    .PMA_REG_ALG_SWCLK_DIV                           ( 0                ),
    .PMA_REG_ALG_TAPA_DAC_3_0                        ( 0                ),
    .PMA_REG_ALG_TAPA_DAC_4                          ( 1                ),
    .PMA_REG_ALG_TAPA_NUM                            ( 7                ),
    .PMA_REG_ALG_TAPB_DAC_0                          ( 0                ),
    .PMA_REG_ALG_TAPB_DAC_4_1                        ( 8                ),
    .PMA_REG_ALG_TAPB_NUM_3_0                        ( 8                ),
    .PMA_REG_ALG_TAPB_NUM_5_4                        ( 0                ),
    .PMA_REG_ALG_TAPC_DAC                            ( 16               ),
    .PMA_REG_ALG_TAPC_NUM_0                          ( 1                ),
    .PMA_REG_ALG_TAPC_NUM_5_1                        ( 4                ),
    .PMA_REG_ALG_TAPD_DAC_2_0                        ( 0                ),
    .PMA_REG_ALG_TAPD_DAC_4_3                        ( 2                ),
    .PMA_REG_ALG_TAPD_NUM                            ( 10               ),
    .PMA_REG_ALG_VP_FLIPDIR_I                        ( "FALSE"          ),
    .PMA_REG_ALG_VP_GRN_SHIFT_I                      ( 5                ),
    .PMA_REG_ALG_VP_HOLD_I                           ( "FALSE"          ),
    .PMA_REG_ALG_VP_IDEAL_2_0                        ( 0                ),
    .PMA_REG_ALG_VP_IDEAL_6_3                        ( 10               ),
    .PMA_REG_ALG_VP_INITDAC_I_3_0                    ( 0                ),
    .PMA_REG_ALG_VP_INITDAC_I_6_4                    ( 0                ),
    .PMA_REG_ALG_VP_OVERWREN                         ( "FALSE"          ),
    .PMA_REG_ALG_VP_RED_SHIFT_I                      ( 5                ),
    .PMA_REG_ALG_VPOFS_SEL_0                         ( 0                ),
    .PMA_REG_ALG_VPOFS_SEL_2_1                       ( 2                ),
    .PMA_REG_ALG_H1_UPBOUND_5_0                      ( 55               ),
    .PMA_REG_ALG_H1_UPBOUND_6                        ( 1                ),
    .PMA_REG_ALG_CTLEOFS_PWDN                        ( "FALSE"          ),
    .PMA_REG_ALG_LEQH_OVEREN_I                       ( "FALSE"          ),
    .PMA_REG_ALG_LEQL_OVEREN_I                       ( "FALSE"          ),
    .PMA_REG_ALG_AGC_FLIPDIR_I                       ( "FALSE"          ),
    .PMA_REG_ALG_AGC_HOLD_I                          ( "FALSE"          ),
    .PMA_REG_ALG_AGC_INITDAC                         ( 0                ),
    .PMA_REG_ALG_AGC_LOWBOUND_1_0                    ( 3                ),
    .PMA_REG_ALG_AGC_LOWBOUND_3_2                    ( 0                ),
    .PMA_REG_ALG_AGC_OVERWREN_I                      ( "FALSE"          ),
    .PMA_REG_ALG_AGC_PWD                             ( "FALSE"          ),
    .PMA_REG_ALG_AGC_SHIFT_I                         ( 4                ),
    .PMA_REG_ALG_AGC_UPBOUND_0                       ( 1                ),
    .PMA_REG_ALG_AGC_UPBOUND_3_1                     ( 7                ),
    .PMA_REG_ALG_AGC_WAITSEL                         ( 11               ),
    .PMA_REG_PI_CTRL_SEL_RX                          ( "FALSE"          ),
    .PMA_REG_PI_CTRL_RX_4_0                          ( 0                ),
    .PMA_REG_PI_CTRL_RX_7_5                          ( 0                ),
    .PMA_CFG_RX_LANE_POWERUP                         ( "ON"             ),
    .PMA_CFG_RX_PMA_RSTN                             ( "TRUE"           ),
    .PMA_INT_PMA_RX_MASK_0                           ( "FALSE"          ),
    .PMA_INT_PMA_RX_CLR_0                            ( "FALSE"          ),
    .PMA_CFG_CTLE_ADP_RSTN                           ( "TRUE"           ),
    .PMA_CFG_RX_CDR_RSTN                             ( "TRUE"           ),
    .PMA_CFG_RX_CLKPATH_RSTN                         ( "TRUE"           ),
    .PMA_CFG_RX_DFE_RSTN                             ( "TRUE"           ),
    .PMA_CFG_RX_LEQ_RSTN                             ( "TRUE"           ),
    .PMA_CFG_RX_SLIDING_RSTN                         ( "TRUE"           ),
    .PMA_CFG_RX_EYE_RSTN                             ( "TRUE"           ),
    .PMA_CFG_RX_CTLE_DCCAL_RSTN                      ( "TRUE"           ),
    .PMA_CFG_RX_SLICER_DCCAL_RSTN                    ( "TRUE"           ),
    .PMA_CFG_RX_SLIP_RSTN                            ( "TRUE"           ),
    //TX PMA
    .PMA_REG_TX_BEACON_TIMER_SEL                     (0                           ),
    .PMA_REG_TX_BIT_CONV                             ("FALSE"                     ),
    .PMA_REG_TX_RES_CAL                              (50                          ),
    .PMA_REG_TX_UDP_DATA_20                          (0                           ),
    .PMA_REG_TX_UDP_DATA_26_21                       (0                           ),
    .PMA_REG_TX_UDP_DATA_34_27                       (0                           ),
    .PMA_REG_TX_UDP_DATA_39_25                       (0                           ),
     
    .PMA_REG_TX_BUSWIDTH_EN                          (1                         ),
    .PMA_REG_TX_PD_POST                              ("OFF"                     ),
    .PMA_REG_TX_PD_POST_OW                           ("FALSE"                     ),
     
    .PMA_REG_TX_BUSWIDTH                             ("32BIT"                    ),
    .PMA_REG_EI_PCLK_DELAY_SEL                       (0                           ),
    .PMA_REG_TX_AMP_DAC0                             (63                          ),
    .PMA_REG_TX_AMP_DAC1                             (19                          ),
    .PMA_REG_TX_AMP_DAC2                             (14                          ),
    .PMA_REG_TX_AMP_DAC3                             (9                           ),
    .PMA_REG_TX_RXDET_THRESHOLD                      ("84MV"                      ),
    .PMA_REG_TX_BEACON_OSC_CTRL                      ("FALSE"                     ),
     
    .PMA_REG_TX_PRBS_GEN_WIDTH_SEL                   (4                         ),
    .PMA_REG_TX_TX2RX_SLPBACK_EN                     ("FALSE"                     ),
    .PMA_REG_TX_PCLK_EDGE_SEL                        ("FALSE"                     ),
    .PMA_REG_TX_PRBS_GEN_EN                          ("FALSE"                     ),
    .PMA_REG_TX_PRBS_SEL                             ("PRBS7"                     ),
    .PMA_REG_TX_UDP_DATA_7_TO_0                      (0                           ),
    .PMA_REG_TX_UDP_DATA_15_TO_8                     (0                           ),
    .PMA_REG_TX_UDP_DATA_19_TO_16                    (0                           ),
    .PMA_REG_TX_FIFO_WP_CTRL                         (4                           ),
    .PMA_REG_TX_FIFO_EN                              ("FALSE"                     ),
    .PMA_REG_TX_DATA_MUX_SEL                         (0                           ),
    .PMA_REG_TX_ERR_INSERT                           ("FALSE"                     ),
    .PMA_REG_TX_SATA_EN                              ("FALSE"                     ),
     
    .PMA_REG_RATE_CHANGE_TXPCLK_ON_OW                ("TRUE"                    ),
    .PMA_REG_RATE_CHANGE_TXPCLK_ON                  ("TRUE"                    ),
    .PMA_REG_TX_CFG_POST1                            (0                         ),
    .PMA_REG_TX_CFG_POST2                            (0                         ),
    .PMA_REG_TX_OOB_DELAY_SEL                        (0                           ),
    .PMA_REG_TX_POLARITY                             ("NORMAL"                    ),
    .PMA_REG_TX_LS_MODE_EN                           ("FALSE"                     ),
    .PMA_REG_RX_JTAG_OE                              ("FALSE"                     ),
    .PMA_REG_RX_ACJTAG_VHYSTSEL                      (0                           ),
     
    .PMA_REG_TX_RES_CAL_EN                           ("FALSE"                    ),
    .PMA_REG_RX_TERM_MODE_CTRL                       (5                           ),
    .PMA_REG_PLPBK_TXPCLK_EN                         ("FALSE"                     ),
    .PMA_REG_CLK_SEL_STROBE_TXPCLK                   (2                           ),
    .PMA_REG_TX_PH_SEL_0                             (1                           ),
    .PMA_REG_TX_PH_SEL_6_1                           (0                           ),
     
    .PMA_REG_TX_CFG_PRE                              (0                         ),
    .PMA_REG_TX_CFG_MAIN                             (0                           ),
     
    .PMA_REG_CFG_POST                                (0                         ),
    .PMA_REG_PD_MAIN                                 ("TRUE"                      ),
     
    .PMA_REG_PD_PRE                                  ("TRUE"                    ),
    .PMA_REG_TX_RXDET_TIMER_SEL                      (87                          ),
     
    .PMA_REG_TX_PI_CUR_BUF                           ("10GHz"                      ),
    .PMA_REG_TX_MOD_STAND_BY_EN                      ("FALSE"                     ),
    .PMA_REG_STATE_STAND_BY_SEL                      ("FALSE"                     ),
     
    .PMA_REG_TX_SYNC_NEW                             ("FALSE"                    ),
    .PMA_REG_TX_SYNC_NEW_OW                          ("TRUE"                    ),
    .PMA_REG_TX_CHANGE_ON_OW                         ("FALSE"                     ),
    .PMA_REG_TX_CHANGE_ON_POLAR_CTRL                 ("FALSE"                     ),
    .PMA_REG_TX_FREERUN_PD                           ("FALSE"                     ),
    .PMA_REG_TX_CHANGE_ON_SEL                        ("FALSE"                     ),
    .PMA_REG_TX_CHANGE_ON_CTRL                       ("FALSE"                     ),
    .PMA_REG_TX_FREERUN_RATE_0                       (0                           ),
    .PMA_REG_TX_FREERUN_RATE_1                       (1                           ),
    .PMA_REG_TX_FREERUN_RATE_OW                      ("FALSE"                     ),
    .PMA_REG_TX_RST_SYNC_CLK_SEL                     ("FALSE"                     ),
    .PMA_REG_TX_PI_CTRL_SEL                          (0                           ),
    .PMA_REG_TX_PI_CTRL                              (0                           ),
    .PMA_LANE_POWERUP                                ("TRUE"                      ),
    .PMA_POR_N                                       ("TRUE"                      ),
    .PMA_TX_LANE_POWERUP                             ("TRUE"                      ),
    .PMA_TX_PMA_RSTN                                 ("TRUE"                      ),
     
    .PMA_LPLL_POWERUP                                ("TRUE"                    ),
    .PMA_LPLL_RSTN                                   ("TRUE"                      ),
    .PMA_LPLL_LOCKDET_RSTN                           ("TRUE"                      ),
    .PMA_REG_LPLL_PFDDELAY_SEL                       (1                           ),
    .PMA_REG_LPLL_PFDDELAY_EN                        ("TRUE"                      ),
    .PMA_REG_LPLL_VCTRL_SET                          (0                           ),
    .PMA_LPLL_CHARGE_PUMP_CTRL                       ("type"                      ),
     
    .PMA_LPLL_REFDIV                                 ("DIV1"                     ),
    .PMA_LPLL_FBDIV                                  (6'b100100                   ),
    .PMA_LPLL_LPF_RES                                (1                           ),
    .PMA_LPLL_REFLOSS_READY                          (0                           ),
    .PMA_LPLL_LOCKED_PFDDELAY                        (0                           ),
    .PMA_LPLL_MCLK_SEL                               (0                           ),
    .PMA_LPLL_TEST_SEL                               (0                           ),
    .PMA_LPLL_TEST_SIG_HALF_EN                       ("TRUE"                      ),
    .PMA_LPLL_TEST_V_EN                              ("FALSE"                     ),
    .PMA_LPLL_MCLK_EN                                ("TRUE"                      ),
    .PMA_LPLL_MCLK_DET_CTL                           (16                          ),
    `ifdef IPM2T_HSST_SPEEDUP_SIM
    .PMA_LPLL_LOCKDET_REFCT                          (0                           ),
    .PMA_LPLL_LOCKDET_FBCT                           (0                           ),
    .PMA_LPLL_LOCKDET_LOCKCT                         (0                           ),
    .PMA_LPLL_LOCKDET_ITER                           (0                           ),
    `else
     
    .PMA_LPLL_LOCKDET_REFCT                          (7                         ),
    .PMA_LPLL_LOCKDET_FBCT                           (7                         ),
    .PMA_LPLL_LOCKDET_LOCKCT                         (4                           ),
    
    .PMA_LPLL_LOCKDET_ITER                           (0                         ),
    `endif
    .PMA_LPLL_UNLOCKDET_ITER                         (0                           ),
    .PMA_LPLL_LOCKDET_EN_OW                          (0                           ),
    .PMA_LPLL_LOCKDET_EN                             (0                           ),
     
    .PMA_LPLL_LOCKDET_MODE                           (0                         ),
    .PMA_LPLL_LOCKDET_OW                             (0                           ),
    .PMA_LPLL_LOCKDETED                              (0                           ),
    .PMA_LPLL_UNLOCKDET_OW                           (0                           ),
    .PMA_LPLL_UNLOCKDETED                            (0                           ),
    .PMA_LPLL_LOCKED_STICKY_CLEAR                    (0                           ),
    .PMA_LPLL_UNLOCKED_STICKY_CLEAR                  (0                           ),
    .PMA_LPLL_LOCKDET_REPEAT                         (1                           ),
    .PMA_LPLL_NOFBCLK_STICKY_CLEAR                   (0                           ),
    .PMA_LPLL_NOREFCLK_STICKY_CLEAR                  (0                           ),
    .PMA_LPLL_READY_OR_LOCK                          (1                           ),
    .PMA_LPLL_READY                                  (0                           ),
    .PMA_LPLL_READY_OW                               (0                           ),
     
    .PMA_REG_TXCLK_SEL                               ("HPLL"                    ),
    .PMA_REG_RXCLK_SEL                               ("HPLL"                    ),
    .PMA_REG_TEST_BUF                                (0                           ),
    .PMA_REG_RX_DEF_SEL0                             ("18.75uA"                   ),
    .PMA_REG_RX_DEF_SEL1                             ("18.75uA"                   ),
    .PMA_REG_TX_DIV_SEL                              ("25uA"                      ),
    .PMA_REG_LPLL_AMP_SEL                            ("25uA"                      ),
    .PMA_REG_LPLL_VCO_SEL                            ("25uA"                      ),
    .PMA_REG_LPLL_CHARGE_PUMP_SEL                    ("25uA"                      ),
    .PMA_REG_RX_EQ0_SEL                              ("56.25uA"                   ),
    .PMA_REG_RX_EQ1_SEL                              ("56.25uA"                   ),
    .PMA_REG_RX_PGA_SEL                              ("56.25uA"                   ),
    .PMA_REG_CHL_TEST                                (0                           ) 
) U_LANE0 (
     //PAD
    .P_RX_SDN                                        (P_RX_SDN                                             ),//input
    .P_RX_SDP                                        (P_RX_SDP                                             ),//input
    .P_TX_SDN                                        (P_TX_SDN                                             ),//output
    .P_TX_SDP                                        (P_TX_SDP                                             ),//output
     //SRB                                                                                                  
    .P_RX_CLK_FR_CORE                                (P_RX_CLK_FR_CORE                                     ),//input
    .P_RCLK2_FR_CORE                                 (P_RCLK2_FR_CORE                                      ),//input
    .P_TX_CLK_FR_CORE                                (P_TX_CLK_FR_CORE                                     ),//input
    .P_TCLK2_FR_CORE                                 (P_TCLK2_FR_CORE                                      ),//input
    .P_PCS_RX_RST                                    (P_PCS_RX_RST                                         ),//input
    .P_PCS_TX_RST                                    (P_PCS_TX_RST                                         ),//input
    .P_EXT_BRIDGE_PCS_RST                            (P_EXT_BRIDGE_PCS_RST                                 ),//input
    .P_CFG_RST                                       (P_CFG_RST                                            ),//input        
    .P_CFG_CLK                                       (P_CFG_CLK                                            ),//input        
    .P_CFG_PSEL                                      (P_CFG_PSEL                                           ),//input              
    .P_CFG_ENABLE                                    (P_CFG_ENABLE                                         ),//input        
    .P_CFG_WRITE                                     (P_CFG_WRITE                                          ),//input        
    .P_CFG_ADDR                                      (P_CFG_ADDR                                           ),//input  [11:0]
    .P_CFG_WDATA                                     (P_CFG_WDATA                                          ),//input  [7:0] 
    .P_CFG_READY                                     (P_CFG_READY                                          ),//output
    .P_CFG_RDATA                                     (P_CFG_RDATA                                          ),//output [7:0]
    .P_CFG_INT                                       (P_CFG_INT                                            ),//output
    .LANE_COUT_BUS_FORWARD                           (LANE_COUT_BUS_FORWARD                                ),//output [24:0]
    .LANE_COUT_BUS_BACKWARD                          (LANE_COUT_BUS_BACKWARD                               ),//output [1:0]
    .LANE_CIN_BUS_FORWARD                            (LANE_CIN_BUS_FORWARD                                 ),//input  [24:0]
    .LANE_CIN_BUS_BACKWARD                           (LANE_CIN_BUS_BACKWARD                                ),//input  [1:0]
    .P_TDATA                                         (P_TDATA                                              ),//input  [87:0]
    .P_PCIE_EI_H                                     (P_PCIE_EI_H                                          ),//input
    .P_PCIE_EI_L                                     (P_PCIE_EI_L                                          ),//input
    .P_TX_DEEMP                                      (P_TX_DEEMP                                           ),//input  [15:0]
    .P_TX_DEEMP_POST_SEL                             (P_TX_DEEMP_POST_SEL                                  ),//input  [1:0]
    .P_BLK_ALIGN_CTRL                                (P_BLK_ALIGN_CTRL                                     ),//input
    .P_TX_ENC_TYPE                                   (P_TX_ENC_TYPE                                        ),//input
    .P_RX_DEC_TYPE                                   (P_RX_DEC_TYPE                                        ),//input
    .P_PCS_BIT_SLIP                                  (P_PCS_BIT_SLIP                                       ),//input
    .P_PCS_WORD_ALIGN_EN                             (P_PCS_WORD_ALIGN_EN                                  ),//input
    .P_RX_POLARITY_INVERT                            (P_RX_POLARITY_INVERT                                 ),//input
    .P_PCS_MCB_EXT_EN                                (P_PCS_MCB_EXT_EN                                     ),//input
    .P_PCS_NEAREND_LOOP                              (P_PCS_NEAREND_LOOP                                   ),//input
    .P_PCS_FAREND_LOOP                               (P_PCS_FAREND_LOOP                                    ),//input
    .P_PMA_NEAREND_PLOOP                             (P_PMA_NEAREND_PLOOP                                  ),//input
    .P_PMA_NEAREND_SLOOP                             (P_PMA_NEAREND_SLOOP                                  ),//input
    .P_PMA_FAREND_PLOOP                              (P_PMA_FAREND_PLOOP                                   ),//input
    .P_PCS_PRBS_EN                                   (P_PCS_PRBS_EN                                        ),//input
    .P_RX_PRBS_ERROR                                 (P_RX_PRBS_ERROR                                      ),//output
    .P_PCS_RX_MCB_STATUS                             (P_PCS_RX_MCB_STATUS                                  ),//output
    .P_PCS_LSM_SYNCED                                (P_PCS_LSM_SYNCED                                     ),//output
    .P_RDATA                                         (P_RDATA                                              ),//output [87:0]
    .P_RXDVLD                                        (P_RXDVLD                                             ),//output
    .P_RXDVLD_H                                      (P_RXDVLD_H                                           ),//output
    .P_RXSTATUS                                      (P_RXSTATUS                                           ),//output [5:0]
    .P_RCLK2FABRIC                                   (P_RCLK2FABRIC                                        ),//output
    .P_TCLK2FABRIC                                   (P_TCLK2FABRIC                                        ),//output
    .P_LANE_POWERDOWN                                (P_LANE_POWERDOWN                                     ),//input
    .P_LANE_RST                                      (P_LANE_RST                                           ),//input
    .P_RX_LANE_POWERDOWN                             (P_RX_LANE_POWERDOWN                                  ),//input
    .P_RX_PMA_RST                                    (P_RX_PMA_RST                                         ),//input
    .P_RX_CDR_RST                                    (P_RX_CDR_RST                                         ),//input
    .P_RX_CLKPATH_RST                                (P_RX_CLKPATH_RST                                     ),//input
    .P_RX_DFE_RST                                    (P_RX_DFE_RST                                         ),//input
    .P_RX_LEQ_RST                                    (P_RX_LEQ_RST                                         ),//input
    .P_RX_SLIDING_RST                                (P_RX_SLIDING_RST                                     ),//input
    .P_RX_DFE_EN                                     (P_RX_DFE_EN                                          ),//input
    .P_RX_T1_EN                                      (P_RX_T1_EN                                           ),//input
    .P_RX_CDRX_EN                                    (P_RX_CDRX_EN                                         ),//input
    .P_RX_T1_DFE_EN                                  (P_RX_T1_DFE_EN                                       ),//input
    .P_RX_T2_DFE_EN                                  (P_RX_T2_DFE_EN                                       ),//input
    .P_RX_T3_DFE_EN                                  (P_RX_T3_DFE_EN                                       ),//input
    .P_RX_T4_DFE_EN                                  (P_RX_T4_DFE_EN                                       ),//input
    .P_RX_T5_DFE_EN                                  (P_RX_T5_DFE_EN                                       ),//input
    .P_RX_T6_DFE_EN                                  (P_RX_T6_DFE_EN                                       ),//input
    .P_RX_SLIDING_EN                                 (P_RX_SLIDING_EN                                      ),//input
    .P_RX_EYE_RST                                    (P_RX_EYE_RST                                         ),//input
    .P_RX_EYE_EN                                     (P_RX_EYE_EN                                          ),//input
    .P_RX_EYE_TAP                                    (P_RX_EYE_TAP                                         ),//input [7:0]
    .P_RX_PIC_EYE                                    (P_RX_PIC_EYE                                         ),//input [7:0]
    .P_RX_PIC_FASTLOCK                               (P_RX_PIC_FASTLOCK                                    ),//input [7:0]
    .P_RX_PIC_FASTLOCK_STROBE                        (P_RX_PIC_FASTLOCK_STROBE                             ),//input
    .P_EM_RD_TRIGGER                                 (P_EM_RD_TRIGGER                                      ),//input
    .P_EM_MODE_CTRL                                  (P_EM_MODE_CTRL                                       ),//input  [1:0]
    .P_EM_ERROR_CNT                                  (P_EM_ERROR_CNT                                       ),//output [2:0]
    .P_RX_CTLE_DCCAL_RST                             (P_RX_CTLE_DCCAL_RST                                  ),//input
    .P_RX_SLICER_DCCAL_RST                           (P_RX_SLICER_DCCAL_RST                                ),//input
    .P_RX_SLICER_DCCAL_EN                            (P_RX_SLICER_DCCAL_EN                                 ),//input
    .P_RX_CTLE_DCCAL_EN                              (P_RX_CTLE_DCCAL_EN                                   ),//input
    .P_RX_SLIP_RST                                   (P_RX_SLIP_RST                                        ),//input
    .P_RX_SLIP_EN                                    (P_RX_SLIP_EN                                         ),//input
    .P_LPLL_POWERDOWN                                (P_LPLL_POWERDOWN                                     ),//input
    .P_LPLL_RST                                      (P_LPLL_RST                                           ),//input
    .P_LPLL_LOCKDET_RST                              (P_LPLL_LOCKDET_RST                                   ),//input
    .P_LPLL_READY                                    (P_LPLL_READY                                         ),//output
    //input
    
    .P_LPLL_REFCLK_IN                                (                                                     ),//input
    .P_RX_SIGDET_STATUS                              (P_RX_SIGDET_STATUS                                   ),//output
    .P_RX_SATA_COMINIT                               (P_RX_SATA_COMINIT                                    ),//output
    .P_RX_SATA_COMWAKE                               (P_RX_SATA_COMWAKE                                    ),//output
    .P_RX_LS_DATA                                    (P_RX_LS_DATA                                         ),//output
    .P_RX_READY                                      (P_RX_READY                                           ),//output
    .P_TEST_STATUS                                   (P_TEST_STATUS                                        ),//output [19:0]
    .P_TX_LS_DATA                                    (P_TX_LS_DATA                                         ),//input
    .P_TX_BEACON_EN                                  (P_TX_BEACON_EN                                       ),//input
    .P_TX_SWING                                      (P_TX_SWING                                           ),//input
    .P_TX_RXDET_REQ                                  (P_TX_RXDET_REQ                                       ),//input
    .P_TX_RXDET_STATUS                               (P_TX_RXDET_STATUS                                    ),//output
    .P_TX_RATE                                       (P_TX_RATE                                            ),//input  [1:0]
    .P_TX_BUSWIDTH                                   (P_TX_BUSWIDTH                                        ),//input  [2:0]
    .P_TX_FREERUN_BUSWIDTH                           (P_TX_FREERUN_BUSWIDTH                                ),//input  [2:0]
    .P_TX_MARGIN                                     (P_TX_MARGIN                                          ),//input  [2:0]
    .P_TX_PMA_RST                                    (P_TX_PMA_RST                                         ),//input
    .P_TX_LANE_POWERDOWN                             (P_TX_LANE_POWERDOWN                                  ),//input
    .P_TX_PIC_EN                                     (P_TX_PIC_EN                                          ),//input
    .P_RX_RATE                                       (P_RX_RATE                                            ),//input  [1:0]
    .P_RX_BUSWIDTH                                   (P_RX_BUSWIDTH                                        ),//input  [2:0]
    .P_RX_HIGHZ                                      (P_RX_HIGHZ                                           ),//input
    .P_CA_ALIGN_RX                                   (P_CA_ALIGN_RX                                        ),//output
    .P_CA_ALIGN_TX                                   (P_CA_ALIGN_TX                                        ),//output
    .P_CIM_CLK_ALIGNER_RX                            (P_CIM_CLK_ALIGNER_RX                                 ),//input  [7:0]
    .P_CIM_CLK_ALIGNER_TX                            (P_CIM_CLK_ALIGNER_TX                                 ),//input  [7:0]
    .P_ALIGN_MODE_VALID_RX                           (P_ALIGN_MODE_VALID_RX                                ),//input 
    .P_ALIGN_MODE_RX                                 (P_ALIGN_MODE_RX                                      ),//input  [1:0]
    .P_ALIGN_MODE_VALID_TX                           (P_ALIGN_MODE_VALID_TX                                ),//input 
    .P_ALIGN_MODE_TX                                 (P_ALIGN_MODE_TX                                      ),//input  [2:0]
    .PMA_HPLL_CK0                                    (PMA_HPLL_CK0                                         ),//input
    .PMA_HPLL_CK90                                   (PMA_HPLL_CK90                                        ),//input
    .PMA_HPLL_CK180                                  (PMA_HPLL_CK180                                       ),//input
    .PMA_HPLL_CK270                                  (PMA_HPLL_CK270                                       ),//input
    .PMA_HPLL_READY_IN                               (PMA_HPLL_READY_IN                                    ),//input
    .PMA_HPLL_REFCLK_IN                              (PMA_HPLL_REFCLK_IN                                   ),//input
    .PMA_TX_SYNC_HPLL_IN                             (PMA_TX_SYNC_HPLL_IN                                  ),//input
    .P_TX_SYNC                                       (P_TX_SYNC                                            ),//input
    .P_TX_RATE_CHANGE_ON_0                           (P_TX_RATE_CHANGE_ON_0                                ),//input
    .P_TX_RATE_CHANGE_ON_1                           (P_TX_RATE_CHANGE_ON_1                                ) //input
    );

endmodule
