
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


module ipm2t_hssthp_Transceiver_10G_hpll_wrapper_v1_6(

    //----------HPLL Port----------//
    
    //PAD
    input  wire            P_HPLL_REFCLK_I                    ,
    //SRB
    input  wire             P_HPLL_POWERDOWN                  ,
    input  wire             P_HPLL_RST                        ,
    input  wire             P_TX_SYNC                         ,
    input  wire             P_HPLL_DIV_SYNC                   ,
    input  wire             P_REFCLK_DIV_SYNC                 ,
    input  wire             P_HPLL_VCO_CALIB_EN               ,
    output wire             P_HPLL_READY                      ,
    input  wire             P_HPLL_DIV_CHANGE                 ,
    //INNER
    input  wire             p_calib_en                        ,
    output wire             p_calib_done                      ,
    input  wire             P_CFG_RST_HPLL                    ,
    input  wire             P_CFG_CLK_HPLL                    ,
    input  wire             P_CFG_PSEL_HPLL                   ,
    input  wire             P_CFG_ENABLE_HPLL                 ,
    input  wire             P_CFG_WRITE_HPLL                  ,
    input  wire [11:0]      P_CFG_ADDR_HPLL                   ,
    input  wire [7:0]       P_CFG_WDATA_HPLL                  ,
    output wire             P_CFG_READY_HPLL                  ,
    output wire [7:0]       P_CFG_RDATA_HPLL                  ,
    output wire             P_CFG_INT_HPLL                    ,
    output wire             PMA_HPLL_READY_O                  ,
    output wire             PMA_HPLL_REFCLK_O                 ,
    output wire             PMA_TX_SYNC_HPLL_O                ,
    input  wire             REFCLK_TO_TX_SYNC_I               ,
    input  wire             REFCLK_TO_REFCLK_SYNC_I           ,
    input  wire             REFCLK_TO_DIV_SYNC_I              ,
    output wire             TX_SYNC_REFSYNC_O                 ,
    output wire             REFCLK_SYNC_REFSYNC_O             ,
    output wire             DIV_SYNC_REFSYNC_O                ,
    input  wire             ANA_TX_SYNC_I                     ,
    input  wire             ANA_HPLL_REFCLK_SYNC_I            ,
    input  wire             ANA_HPLL_DIV_SYNC_I               , 
    output wire             PMA_HPLL_CK0                      ,
    output wire             PMA_HPLL_CK90                     ,
    output wire             PMA_HPLL_CK180                    ,
    output wire             PMA_HPLL_CK270                     
    
);

//wire
wire  [5:0]      P_RES_CAL_CODE_FABRIC       ;
wire             P_HPLL_LOCKDET_RST          = 1'b0;//input
wire  [5:0]      P_RESCAL_I_CODE_I           = 6'b101110 ;


//fsm status
localparam       S_IDLE                      = 3'd0 ;
localparam       S_DETECT                    = 3'd1 ;
localparam       S_CALIB_START               = 3'd2 ;
localparam       S_CALIB_WAIT                = 3'd3 ;
localparam       S_CALIB_EXIT                = 3'd4 ;
localparam       S_CALIB_VLD_DONE            = 3'd5 ;
localparam       S_CALIB_INVLD_DONE          = 3'd6 ;
localparam       S_CALIB_ABORT_DONE          = 3'd7 ;

//Calibration Control Logic
reg               nxt_rstn      ;
reg               rstn          ;
reg   [2 :0]      cur_st        ;
reg   [2 :0]      nxt_st        ;
wire              init_done     ;
wire              calib_vld     ;
wire              det_done      ;
wire              res_done      ;
wire              start_rdy     ;
wire              exit_rdy      ;
reg   [3 :0]      det_cnt       ;
reg   [1 :0]      wr_cnt        ;
reg   [2 :0]      calib_cnt     ;
reg   [9 :0]      wait_cnt1     ;
reg   [9 :0]      wait_cnt2     ;
reg   [7 :0]      cfg_refclk    ;
reg               res_cal_rst   ;
reg               calib_done    ;
reg               rdy_err       ;
reg   [1 :0]      err_cnt       ;
reg               psel          ;
reg               penable       ;
wire              pwrite        ;
reg   [11:0]      paddr         ;
wire  [7 :0]      pwdata        ;
wire  [7 :0]      prdata        ;
wire              pready        ;
wire              p_psel        ;
wire              p_enable      ;
wire              p_write       ;
wire  [11:0]      p_addr        ;
wire  [7 :0]      p_wdata       ;

assign clk  = P_CFG_CLK_HPLL ; 

//when calib is done, the rstn is force 1.
always @(*) begin
    if (calib_done==1'b1)
        nxt_rstn = 1'b1;
    else
        nxt_rstn = ~P_CFG_RST_HPLL;
end

always @(posedge clk) begin
    rstn <= nxt_rstn;
end

always @(posedge clk or negedge rstn) begin
    if (!rstn)
        cur_st <= S_IDLE;
    else
        cur_st <= nxt_st;
end

always @(*) begin
    case (cur_st)
        S_IDLE      :   begin
            if (init_done==1'b1)
                nxt_st = S_DETECT;
            else
                nxt_st = S_IDLE;
        end
        S_DETECT :   begin
            if (err_cnt==2'd2)
                nxt_st = S_CALIB_ABORT_DONE;
            else if (det_done==1'b1) begin
                if (calib_vld==1'b1)
                    nxt_st = S_CALIB_START;
                else
                    nxt_st = S_CALIB_INVLD_DONE;
            end
            else
                nxt_st = S_DETECT;
        end
        S_CALIB_START         :   begin
            if (rdy_err==1'b1)
                nxt_st = S_DETECT;
            else if (start_rdy==1'b1)
                nxt_st = S_CALIB_WAIT;
            else
                nxt_st = S_CALIB_START;
        end
        S_CALIB_WAIT         :   begin
            if (rdy_err==1'b1)
                nxt_st = S_DETECT;
            else if (res_done==1'b1)
                nxt_st = S_CALIB_EXIT;
            else
                nxt_st = S_CALIB_WAIT;
        end
        S_CALIB_EXIT         :   begin
            if (rdy_err==1'b1)
                nxt_st = S_DETECT;
            else if (exit_rdy==1'b1)
                nxt_st = S_CALIB_VLD_DONE;
            else
                nxt_st = S_CALIB_EXIT;
        end
        S_CALIB_VLD_DONE      :   nxt_st  = S_CALIB_VLD_DONE  ;
        S_CALIB_INVLD_DONE    :   nxt_st  = S_CALIB_INVLD_DONE;
        S_CALIB_ABORT_DONE    :   nxt_st  = S_CALIB_ABORT_DONE;
        default               :   nxt_st  = S_IDLE;
    endcase
end

//generate apb det cnt control logic
always @(posedge clk or negedge rstn) begin
    if (!rstn)    
        det_cnt <= 4'd0;
    else if (cur_st==S_IDLE) begin
        det_cnt <= det_cnt + 4'd1;
    end
    else if (cur_st==S_DETECT) begin
        if (det_cnt==4'd10)
            det_cnt <= 4'd0;
        else
            det_cnt <= det_cnt + 4'd1;
    end
    else
        det_cnt <= 4'd0;
end

//generate apb write cnt control logic
always @(posedge clk or negedge rstn) begin
    if (!rstn)    
        wr_cnt <= 2'd0;
    else if (cur_st==S_CALIB_START || cur_st==S_CALIB_EXIT)
            wr_cnt <= wr_cnt + 2'd1;
    else
        wr_cnt <= 2'd0;
end

//generate apb calib cnt control logic
always @(posedge clk or negedge rstn) begin
    if (!rstn)    
        wait_cnt1 <= 10'd0;
    else if (cur_st==S_CALIB_WAIT) begin
        if (wait_cnt1[9]==1'b1)
            wait_cnt1 <= 10'd0;
        else
            wait_cnt1 <= wait_cnt1 + 10'd1;
    end
    else
        wait_cnt1 <= 10'd0;
end

always @(posedge clk or negedge rstn) begin
    if (!rstn)    
        wait_cnt2 <= 10'd0;
    else if (cur_st==S_CALIB_WAIT) begin
        if (wait_cnt2[9]==1'b1)
            wait_cnt2 <= 10'd0;
        else if (wait_cnt1[9]==1'b1)
            wait_cnt2 <= wait_cnt2 + 10'd1;
        else
            wait_cnt2 <= wait_cnt2;
    end
    else
        wait_cnt2 <= 10'd0;
end

always @(posedge clk or negedge rstn) begin
    if (!rstn)    
        calib_cnt <= 3'd0;
    else if (cur_st==S_CALIB_WAIT) begin
        if (calib_cnt==3'd5)
            calib_cnt <= 3'd0;
        else if (wait_cnt2[9]==1'b1)
            calib_cnt <= 3'd1;
        else if (calib_cnt!=3'd0)
            calib_cnt <= calib_cnt + 3'd1;
        else
            calib_cnt <= calib_cnt;
    end
    else
        calib_cnt <= 3'd0;
end

//save refclk config
always @(posedge clk or negedge rstn) begin
    if (!rstn)
        cfg_refclk <= 8'd0;
    else if (cur_st==S_DETECT && pready==1'b1 && det_cnt==4'd4)
        cfg_refclk <= prdata;
    else;
end

assign init_done = (det_cnt==4'd15);
assign det_done  = (cur_st==S_DETECT && det_cnt==4'd10);
assign calib_vld = (cur_st==S_DETECT && pready==1'b1 && prdata[5:4]==2'b0);
assign start_rdy = (cur_st==S_CALIB_START && wr_cnt==2'd3 && pready==1'b1);
assign res_done  = (cur_st==S_CALIB_WAIT && calib_cnt==3'd5 && pready==1'b1 && prdata[0]==1'b1);
assign exit_rdy  = (cur_st==S_CALIB_EXIT && wr_cnt==2'd3 && pready==1'b1);

//when access apb, the rdy is no retrun
always @(*) begin
    case (cur_st)
        S_DETECT                     :   rdy_err = (det_cnt==4'd4 && pready==1'b0) || (det_cnt==4'd10 && pready==1'b0);
        S_CALIB_START,S_CALIB_EXIT   :   rdy_err = (wr_cnt==2'd3 && pready==1'b0);
        S_CALIB_WAIT                 :   rdy_err = (calib_cnt==3'd5 && pready==1'b0);
        default                      :   rdy_err = 1'b0;
    endcase
end

//recoard rdy err times
always @(posedge clk or negedge rstn) begin
    if (!rstn)
        err_cnt <= 2'd0;
    else if (cur_st==S_IDLE)
        err_cnt <= 2'd0;
    else if (rdy_err==1'b1)
        err_cnt <= err_cnt + 2'd1;
    else;
end

//generate psel penable paddr
always @(*) begin
    case (cur_st)
        S_DETECT                     :   psel = (det_cnt!=4'd5);
        S_CALIB_START,S_CALIB_EXIT   :   psel = (wr_cnt!=2'd0);
        S_CALIB_WAIT                 :   psel = (calib_cnt!=3'd0);
        default                      :   psel = 1'b0;
    endcase
end

always @(*) begin
    case (cur_st)
        S_DETECT                     :   penable = (det_cnt!=4'd0 && det_cnt!=4'd5 && det_cnt!=4'd6);
        S_CALIB_START,S_CALIB_EXIT   :   penable = (wr_cnt>2'b1);
        S_CALIB_WAIT                 :   penable = (calib_cnt>3'd1);
        default                      :   penable = 1'b0;
    endcase
end

assign pwrite  = (cur_st==S_CALIB_START || cur_st==S_CALIB_EXIT) ? 1'b1 : 1'b0;
assign pwdata  = (cur_st==S_CALIB_START) ? {cfg_refclk[7:6],3'b111,cfg_refclk[2:0]} : cfg_refclk; 
assign prdata  = P_CFG_RDATA_HPLL;
assign pready  = P_CFG_READY_HPLL;

always @(*) begin
    case (cur_st)
        S_DETECT                     :   paddr = (det_cnt<4'd5) ? 12'h003 : 12'h026;
        S_CALIB_START,S_CALIB_EXIT   :   paddr = 12'h003;
        S_CALIB_WAIT                 :   paddr = 12'h03c;
        default                      :   paddr = 12'h000;
    endcase
end

//generate calib_done and res_cal_rst signal
always @(posedge clk or negedge rstn) begin
    if (!rstn)
        calib_done <= 1'b0;
    else if (cur_st==S_CALIB_VLD_DONE)
        calib_done <= 1'b1;
    else if (cur_st==S_CALIB_INVLD_DONE)
        calib_done <= p_calib_en;
    else if (cur_st==S_CALIB_ABORT_DONE)
        calib_done <= 1'b1;
    else;
end

`ifdef IPM2T_HSST_SPEEDUP_SIM
assign p_calib_done = 1'b1;
`else
assign p_calib_done = calib_done;
`endif

always @(posedge clk or negedge rstn) begin
    if (!rstn)
        res_cal_rst <= 1'b0;
    else if (res_cal_rst==1'b1)
        res_cal_rst <= 1'b0;
    else if (start_rdy==1'b1)
        res_cal_rst <= 1'b1;
    else;
end

`ifdef IPM2T_HSST_SPEEDUP_SIM
assign p_psel   = P_CFG_PSEL_HPLL  ; 
assign p_enable = P_CFG_ENABLE_HPLL; 
assign p_write  = P_CFG_WRITE_HPLL ; 
assign p_wdata  = P_CFG_WDATA_HPLL ; 
assign p_addr   = P_CFG_ADDR_HPLL  ; 
`else
assign p_psel   = calib_done==1'b1 ? P_CFG_PSEL_HPLL   : psel   ; 
assign p_enable = calib_done==1'b1 ? P_CFG_ENABLE_HPLL : penable; 
assign p_write  = calib_done==1'b1 ? P_CFG_WRITE_HPLL  : pwrite ; 
assign p_wdata  = calib_done==1'b1 ? P_CFG_WDATA_HPLL  : pwdata ; 
assign p_addr   = calib_done==1'b1 ? P_CFG_ADDR_HPLL   : paddr  ; 
`endif


//--------GTP HPLL instance--------//
GTP_HSSTHP_HPLL#(
    .PMA_REG_REFCLK0_IMPEDANCE_SEL                   ("100_OHM"                 ),
    .PMA_REG_REFCLK1_IMPEDANCE_SEL                   ("100_OHM"                 ),
    .PMA_REG_PLL_JTAG0_VTH_SEL                       ("60MV"                    ),
    .PMA_REG_PLL_JTAG0_LPF_RSEL                      ("20K"                     ),
    .PMA_REG_PLL_JTAG1_VTH_SEL                       ("60MV"                    ),
    .PMA_REG_PLL_JTAG1_LPF_RSEL                      ("20K"                     ),
    .PMA_REG_IBIAS_STATIC_SEL_7_0                    (255                       ),
    .PMA_REG_IBIAS_STATIC_SEL_15_8                   (247                       ),
    .PMA_REG_IBIAS_STATIC_SEL_18_16                  (7                         ),
    .PMA_REG_IBIAS_STATIC_SEL_21_19                  (0                         ),
    .PMA_REG_IBIAS_STATIC_SEL_29_22                  (0                         ),
    .PMA_REG_IBIAS_STATIC_SEL_37_30                  (1                         ),
    .PMA_REG_IBIAS_DYNAMIC_PD_7_0                    (0                         ),
    .PMA_REG_IBIAS_DYNAMIC_PD_15_8                   (0                         ),
    .PMA_REG_IBIAS_DYNAMIC_PD_18_16                  (0                         ),
    .PMA_REG_IBIAS_STA_CUR_SEL_4_0                   (31                        ),
    .PMA_REG_IBIAS_STA_CUR_SEL_8_5                   (15                        ),
    .PMA_REG_IBIAS_STA_CUR_SEL_12_9                  (0                         ),
    .PMA_REG_IBIAS_STA_CUR_SEL_17_13                 (0                         ),
    .PMA_REG_IBIAS_STA_CUR_PD_2_0                    (0                         ),
    .PMA_REG_IBIAS_STA_CUR_PD_8_3                    (0                         ),
    .PMA_REG_BANDGAP_VOL_SEL                         ("BANDGAP"                 ),
    .PMA_REG_BANDGAP_TEST                            (0                         ),
    .PMA_REG_CALIB_CLKDIV_RATION                     ("DIV1"                    ),
    .PMA_REG_TX_RATE_CHANGE_SEL0                     ("CLK_FROM_HPLL"           ),
    .PMA_REG_TX_RATE_CHANGE_SEL1                     ("SEL_SYNC_RATE_CHANGE"    ),
    .PMA_REG_TLING_IMPEDANCE_CTRL                    ("125OHM"                  ),
    .PMA_ANA_COM_REG_143                             (0                         ),
    .PMA_ANA_COM_REG_149                             (0                         ),
    .PMA_ANA_COM_REG_155                             (0                         ),
    .PMA_REG_HPLL_DIV_CHANGE_3_0                     (8                         ),
    .PMA_REG_HPLL_DIV_CHANGE_11_4                    (66                        ),
    .PMA_REG_HPLL_DIV_CHANGE_15_12                   (1                         ),
    .PMA_REG_HPLL_VCOLDO_EN                          ("TRUE"                    ),
    .PMA_REG_HPLL_LDO_VOL_RANGE_O                    ("1000MV"                  ),
    .PMA_REG_HPLL_LDO_VOL_RANGE_I                    ("640MV"                   ),
     
    .PMA_REG_HPLL_REFCLK_DIV                         (1                        ),
    .PMA_REG_HPLL_CHARGE_PUMP_PD                     ("WORK"                    ),
    .PMA_REG_HPLL_CHARGE_PUMP_CTRL                   (7                         ),
    .PMA_REG_HPLL_VCTRL_SEL_L                        ("0.4V"                    ),
    .PMA_REG_HPLL_VCTRL_SEL_H                        ("0.5V"                    ),
    .PMA_REG_HPLL_LPF_RES_SEL                        ("5K"                      ),
    .PMA_REG_HPLL_PCURRENT_SEL                       ("16*IO"                   ),
    .PMA_REG_HPLL_VCO_EN                             (1                         ),
    .PMA_REG_HPLL_PCURRENT_SEL0                      ("10*IO"                   ),
    .PMA_REG_HPLL_PCURRENT_SEL1                      (1                         ),
    .PMA_REG_REFCLK_RST_SEL                          (0                         ),
     
    .PMA_REG_HPLL_FBDIV0                             (7'b0010001                 ),
    .PMA_REG_HPLL_FBDIV1                             (7'b0010000                 ),
    .PMA_REG_HPLL_PHASE_SEL                          ("DIV2"                    ),
    .PMA_REG_HPLL_CFG_7_0                            (7                         ),
    .PMA_REG_HPLL_CFG_15_8                           (0                         ),
    .PMA_REG_PLL_LOCKDET_RESET_N                     ("FALSE"                   ),
    .PMA_REG_PLL_LOCKDET_RESET_N_OW                  ("FALSE"                   ),
    .PMA_REG_READY_OR_LOCK                           ("TRUE"                    ),
    .PMA_REG_HPLL_READY                              ("FALSE"                   ),
    .PMA_REG_HPLL_READY_OW                           ("FALSE"                   ),
    `ifdef IPM2T_HSST_SPEEDUP_SIM
    .PMA_REG_PLL_LOCKDET_REFCT_0                     ("FALSE"                   ),
    .PMA_REG_PLL_LOCKDET_REFCT_2_1                   (0                         ),
    .PMA_REG_PLL_LOCKDET_FBCT                        (0                         ),
    .PMA_REG_PLL_LOCKDET_LOCKCT                      (0                         ),
    .PMA_REG_PLL_LOCKDET_ITER                        (0                         ),
    `else
     
    .PMA_REG_PLL_LOCKDET_REFCT_0                     ("TRUE"                  ),
    .PMA_REG_PLL_LOCKDET_REFCT_2_1                   (3                       ),
    .PMA_REG_PLL_LOCKDET_FBCT                        (7                       ),
    .PMA_REG_PLL_LOCKDET_LOCKCT                      (4                         ),
     
    .PMA_REG_PLL_LOCKDET_ITER                        (0                       ),
    `endif
    .PMA_REG_PLL_UNLOCKDET_ITER                      (2                         ),
    .PMA_REG_PLL_LOCKDET_EN_OW                       ("FALSE"                   ),
    .PMA_REG_PLL_LOCKDET_EN                          ("FALSE"                   ),
     
    .PMA_REG_PLL_LOCKDET_MODE                        ("FALSE"                  ),
    .PMA_REG_PLL_LOCKED_OW                           ( "FALSE"                  ),
    .PMA_REG_PLL_LOCKED                              ("FALSE"                   ),
    .PMA_REG_PLL_UNLOCKED_OW                         ("FALSE"                   ),
    .PMA_REG_PLL_UNLOCKED                            ("FALSE"                   ),
    .PMA_REG_PLL_LOCKED_STICKY_CLEAR                 ("FALSE"                   ),
    .PMA_REG_PLL_UNLOCKED_STICKY_CLEAR               ("FALSE"                   ),
    .PMA_REG_LOCKDET_REPEAT                          ("TRUE"                    ),
    .PMA_REG_NOFBCLK_STICKY_CLEAR                    ("FALSE"                   ),
    .PMA_REG_NOREFCLK_STICKY_CLEAR                   ("FALSE"                   ),
    .PMA_REG_RESCAL_EN                               ("FALSE"                   ),
    .PMA_REG_RESCAL_RST_N_OW                         ("FALSE"                   ),
    .PMA_REG_RESCAL_RST_N_VAL                        ("FALSE"                   ),
    .PMA_REG_RESCAL_DONE_VAL                         ("FALSE"                   ),
    .PMA_REG_RESCAL_DONE_OW                          ("FALSE"                   ),
    .PMA_REG_RESCAL_I_CODE_VAL_1_0                   (0                         ),
    .PMA_REG_RESCAL_I_CODE_VAL_5_2                   (0                         ),
    .PMA_REG_RESCAL_I_CODE_OW                        ("FALSE"                   ),
    .PMA_REG_RESCAL_ITER_VALID_SEL                   (0                         ),
    .PMA_REG_RESCAL_WAIT_SEL                         ("FALSE"                   ),
    .PMA_REG_I_CTRL_MAX                              (45                        ),
    .PMA_REG_I_CTRL_MIN_1_0                          (3                         ),
    .PMA_REG_I_CTRL_MIN_5_2                          (4                         ),
    .PMA_REG_RESCAL_I_CODE_3_0                       (0                         ),
    .PMA_REG_RESCAL_I_CODE_5_4                       (2                         ),
    .PMA_REG_RESCAL_INT_R_SMALL_VAL                  ("FALSE"                   ),
    .PMA_REG_RESCAL_INT_R_SMALL_OW                   ("FALSE"                   ),
    .PMA_REG_RESCAL_I_CODE_PMA                       ("FALSE"                   ),
    .PMA_REG_REFCLK0_JTAG_OE                         ("FALSE"                   ),
    .PMA_REG_REFCLK1_JTAG_OE                         ("FALSE"                   ),
    .PMA_REG_RES_CAL_EN                              ("TRUE"                    ),
    .PMA_REG_HPLL_RSTN                               ("FALSE"                   ),
    .PMA_REG_HPLL_RSTN_OW                            ("FALSE"                   ),
     
    .PMA_REG_HPLL_PD                                 ("FALSE"                  ),
    .PMA_REG_HPLL_PD_OW                              ("FALSE"                  ),
    .PMA_REG_LC_VCO_CAL_EN                           ("FALSE"                   ),
    .PMA_REG_DIV_CALI_BYPASS                         ("TRUE"                    ),
    .PMA_REG_CALIB_WAIT                              (3                         ),
    .PMA_REG_CALIB_TIMER                             (0                         ),
    .PMA_REG_BAND_LB                                 (0                         ),
    .PMA_REG_BAND_HB_0                               ("TRUE"                    ),
    .PMA_REG_BAND_HB_4_1                             (15                        ),
    .PMA_REG_NFC_STIC_DIS_N                          (0                         ),
    .PMA_CFG_HSST_RSTN                               ("TRUE"                    ),
    
    .PMA_CFG_PLLPOWERUP                             ("ON"                      ),
    .PMA_PLL_RSTN                                   ("TRUE"                     ) 
) U_HPLL (
     //PAD
    
    .P_HPLL_REFCLK_I                                (P_HPLL_REFCLK_I                      ),//input
    
    .P_PLL_REFCLK6_I                                (P_CFG_CLK_HPLL                       ),//input
     //SRB
    .P_CFG_RST_HPLL                                 (P_CFG_RST_HPLL                       ),//input
    .P_CFG_CLK_HPLL                                 (P_CFG_CLK_HPLL                       ),//input
    .P_CFG_PSEL_HPLL                                (p_psel                               ),//input
    .P_CFG_ENABLE_HPLL                              (p_enable                             ),//input
    .P_CFG_WRITE_HPLL                               (p_write                              ),//input
    .P_CFG_ADDR_HPLL                                (p_addr                               ),//input  [11:0]
    .P_CFG_WDATA_HPLL                               (p_wdata                              ),//input  [7:0]
    .P_CFG_READY_HPLL                               (P_CFG_READY_HPLL                     ),//output
    .P_CFG_RDATA_HPLL                               (P_CFG_RDATA_HPLL                     ),//output [7:0]
    .P_CFG_INT_HPLL                                 (P_CFG_INT_HPLL                       ),//output
    .P_HPLL_POWERDOWN                               (P_HPLL_POWERDOWN                     ),//input
    .P_HPLL_RST                                     (P_HPLL_RST                           ),//input
    .P_HPLL_LOCKDET_RST                             (P_HPLL_LOCKDET_RST                   ),//input
    .P_RES_CAL_RST                                  (res_cal_rst                          ),//input
    .P_HPLL_VCO_CALIB_EN                            (P_HPLL_VCO_CALIB_EN                  ),//input
    .P_RESCAL_I_CODE_I                              (P_RESCAL_I_CODE_I                    ),//input  [5:0]
    .P_RES_CAL_CODE_FABRIC                          (P_RES_CAL_CODE_FABRIC                ),//output [5:0]
    .P_HPLL_READY                                   (P_HPLL_READY                         ),//output
    .P_HPLL_DIV_CHANGE                              (P_HPLL_DIV_CHANGE                    ),//input
    .PMA_HPLL_READY_O                               (PMA_HPLL_READY_O                     ),//output
    .PMA_HPLL_REFCLK_O                              (PMA_HPLL_REFCLK_O                    ),//output
    .PMA_TX_SYNC_HPLL_O                             (PMA_TX_SYNC_HPLL_O                   ),//output
    .P_TX_SYNC                                      (P_TX_SYNC                            ),//input
    .P_HPLL_DIV_SYNC                                (P_HPLL_DIV_SYNC                      ),//input
    .P_REFCLK_DIV_SYNC                              (P_REFCLK_DIV_SYNC                    ),//input
    .REFCLK_TO_TX_SYNC_I                            (REFCLK_TO_TX_SYNC_I                  ),//input
    .REFCLK_TO_REFCLK_SYNC_I                        (REFCLK_TO_REFCLK_SYNC_I              ),//input
    .REFCLK_TO_DIV_SYNC_I                           (REFCLK_TO_DIV_SYNC_I                 ),//input
    .TX_SYNC_REFSYNC_O                              (TX_SYNC_REFSYNC_O                    ),//output
    .REFCLK_SYNC_REFSYNC_O                          (REFCLK_SYNC_REFSYNC_O                ),//output
    .DIV_SYNC_REFSYNC_O                             (DIV_SYNC_REFSYNC_O                   ),//output
    .ANA_TX_SYNC_I                                  (ANA_TX_SYNC_I                        ),//input
    .ANA_HPLL_REFCLK_SYNC_I                         (ANA_HPLL_REFCLK_SYNC_I               ),//input
    .ANA_HPLL_DIV_SYNC_I                            (ANA_HPLL_DIV_SYNC_I                  ),//input
    .PMA_HPLL_CK0                                   (PMA_HPLL_CK0                         ),//output
    .PMA_HPLL_CK90                                  (PMA_HPLL_CK90                        ),//output
    .PMA_HPLL_CK180                                 (PMA_HPLL_CK180                       ),//output
    .PMA_HPLL_CK270                                 (PMA_HPLL_CK270                       ) //output
);

endmodule
