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
module  ipm2t_hssthp_rxlane_rst_fsm_v1_5b#(
    parameter FREE_CLOCK_FREQ          = 100        , //unit is MHz, free clock  freq from GUI
    parameter CH_MULT_LANE_MODE        = 1          , //1: 1lane 2:2lane 4:4lane
    parameter CH_BYPASS_WORD_ALIGN     = "FALSE"    , //TRUE: Lane Bypass Word Alignment, FALSE: Lane No Bypass Word Alignment
    parameter CH_BYPASS_BONDING        = "FALSE"    , //TRUE: Lane Bypass Channel Bonding, FALSE: Lane No Bypass Channel Bonding
    parameter CH_BYPASS_CTC            = "FALSE"    , //TRUE: Lane Bypass CTC, FALSE: Lane No Bypass CTC
    parameter LX_RX_CKDIV              = 0          ,
    parameter PCS_RX_CLK_EXPLL_USE     = "FALSE"    ,
    parameter CH_RX_RATE               = 1.25       ,
    parameter CH_RXPCS_ALIGN_TIMER     = 1000   

)(
    // Reset and Clock
    input  wire                   clk                   ,
    input  wire                   rst_n                 ,
    // HSST Reset Control Signal
    input  wire                   fifo_clr_en           ,
    input  wire                   i_rx_rate_chng        ,
    input  wire                   i_tx_ckdiv_done       ,
    input  wire   [1:0]           i_rxckdiv             ,
    input  wire                   sigdet                ,
    input  wire                   cdr_align             ,
    input  wire                   word_align            ,
    input  wire                   bonding               ,
    input  wire                   i_pll_lock_rx         ,
    input  wire                   i_rx_pma_rst          ,
    input  wire                   i_rx_pcs_rst          ,
    input  wire                   i_rx_data_sel_en      ,
    input  wire   [1:0]           i_rx_data_sel         ,
    output reg                    PMA_RX_PD             ,
    output reg                    P_PCS_RX_RST          ,
    output reg    [1:0]           RX_RATE               ,
    output reg                    RX_PMA_RST            ,
    output reg                    o_rxckdiv_done        ,
    output reg                    o_rxlane_done         ,
    output reg                    fifoclr_sig       
);

localparam integer PMA_RST_CNTR_VALUE                 = 2*((1.5*FREE_CLOCK_FREQ)); //add 50 percent margin
localparam integer RX_RATE_CNTR_VALUE                 = 2*((0.5*FREE_CLOCK_FREQ)); //add 50 percent margin
localparam integer RX_PMA_RST_RELEASE_CNTR_VALUE      = 2*((1.0*FREE_CLOCK_FREQ)); //add 50 percent margin
`ifdef IPM2T_HSST_SPEEDUP_SIM
localparam integer CDR_LOCK_CNTR_VALUE                = 1;
`else
localparam integer CDR_LOCK_CNTR_VALUE                = FREE_CLOCK_FREQ*200/CH_RX_RATE; 
`endif

localparam integer PCS_RST_RELEASE_DLY_CNTR_VALUE     = 32;//add for rxlane_done is active but fabric clock is none by wenbin 
//Counter Width
localparam         CNTR_WIDTH                         = 28 ;
//RX Lane FSM Status
localparam RX_LANE_IDLE         = 4'd0;
localparam RX_LANE_PMA_POWERUP  = 4'd1;
localparam RX_LANE_PMA_RST      = 4'd2;
localparam RX_LANE_SIGNAL_WAIT  = 4'd3;
localparam RX_LANE_CDR_WAIT     = 4'd4;
localparam RX_LANE_CDR_CNTR     = 4'd5;//RXPCS Reset Status
localparam RX_LANE_ALIGN_WAIT   = 4'd6;
localparam RX_LANE_BONDING_WAIT = 4'd7;
localparam RX_LANE_DONE         = 4'd8;
localparam RX_CKDIV_ONLY        = 4'd10;

//****************************************************************************//
//                      Internal Signal                                       //
//****************************************************************************//
reg     [CNTR_WIDTH-1  : 0] cntr                  ;
wire                       tx_rate_done           ;
reg     [3            : 0] rxlane_rst_fsm         ;
reg     [3            : 0] next_state             ;
reg     [1            : 0] i_rx_rate_chng_ff      ;
reg                        i_rx_rate_chng_posedge ;
wire                       rxlane_word_align_en   ;
wire                       rxlane_ctc_en          ;
wire                       rxlane_bonding_en      ;
wire                       rxlane_mult_en         ;
wire                       expll_lock_rx          ;
reg     [1            : 0] i_rxckdiv_ff           ;
reg     [1            : 0] rxckdiv                ;
reg     [2            : 0] i_ckdiv_done_ff        ;
reg                        rxcdr_realign_en       ;
//****************************************************************************//
//                      Sequential and Logic                                  //
//****************************************************************************//
assign rxlane_word_align_en     = i_rx_data_sel_en==1'b1 ? (i_rx_data_sel==2'b01 ? 1'b1 : 1'b0) : (CH_BYPASS_WORD_ALIGN=="FALSE" ? 1'b1 : 1'b0);
assign rxlane_ctc_en            = (CH_BYPASS_CTC=="FALSE")        ? 1'b1 : 1'b0;
assign rxlane_bonding_en        = (CH_BYPASS_BONDING=="FALSE")    ? 1'b1 : 1'b0;
assign rxlane_mult_en           = (CH_MULT_LANE_MODE==2 || CH_MULT_LANE_MODE==4) ? 1'b1 : 1'b0;
assign expll_lock_rx            = (PCS_RX_CLK_EXPLL_USE=="FALSE") ? 1'b1 : i_pll_lock_rx;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        i_ckdiv_done_ff     <= 3'b000;
    else 
        i_ckdiv_done_ff     <= {i_ckdiv_done_ff[1],i_ckdiv_done_ff[0],i_tx_ckdiv_done};
end
assign tx_rate_done = i_ckdiv_done_ff[1] & (!i_ckdiv_done_ff[2]) ;//TX CHANGE RATE DONE 

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        i_rx_rate_chng_ff     <= 2'b00;
    else 
        i_rx_rate_chng_ff     <= {i_rx_rate_chng_ff[0],i_rx_rate_chng};
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        i_rxckdiv_ff     <= 2'b00;
    else 
        i_rxckdiv_ff     <= i_rxckdiv;
end


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        i_rx_rate_chng_posedge     <= 1'b0;
    else if (rxlane_rst_fsm == RX_CKDIV_ONLY)
        i_rx_rate_chng_posedge     <= 1'b0;
    else if (i_rx_rate_chng_ff[0] & (!i_rx_rate_chng_ff[1]))
        i_rx_rate_chng_posedge     <= 1'b1;
    else ;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        rxckdiv                  <= 2'b00;
    else if (!i_rx_rate_chng_posedge && i_rx_rate_chng_ff[0] && (!i_rx_rate_chng_ff[1]) && rxlane_rst_fsm != RX_CKDIV_ONLY)
        rxckdiv                  <= i_rxckdiv_ff ;
    else ;
end
 

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        rxlane_rst_fsm     <=   RX_LANE_IDLE   ;
    end
    else begin
        rxlane_rst_fsm     <=   next_state ;
    end
end

always @(*)
begin
    case(rxlane_rst_fsm)
        RX_LANE_IDLE        :
            next_state     =   RX_LANE_PMA_POWERUP ;
        RX_LANE_PMA_POWERUP        :
        begin
            next_state = RX_LANE_PMA_RST ;
        end
        RX_LANE_PMA_RST     :
        begin
            if(cntr == PMA_RST_CNTR_VALUE && ~i_rx_pma_rst)
                next_state = RX_LANE_SIGNAL_WAIT ;
            else
                next_state = RX_LANE_PMA_RST ;
        end
        RX_LANE_SIGNAL_WAIT :
        begin
            if(i_rx_pma_rst)
                next_state = RX_LANE_PMA_RST ;
            else if(i_rx_rate_chng_posedge)
                next_state = RX_CKDIV_ONLY ;
            else if (sigdet)
                next_state = RX_LANE_CDR_WAIT ;
            else
                next_state = RX_LANE_SIGNAL_WAIT ;
        end
        RX_LANE_CDR_WAIT    :
        begin
            if(!sigdet || i_rx_pma_rst)
                next_state = RX_LANE_PMA_RST ;
            else if (i_rx_rate_chng_posedge)
                next_state = RX_CKDIV_ONLY ;
            else if (cdr_align) begin
                if(PCS_RX_CLK_EXPLL_USE == "FALSE")
                    next_state = RX_LANE_CDR_CNTR ;
                else
                    next_state = expll_lock_rx ? RX_LANE_CDR_CNTR : RX_LANE_CDR_WAIT;
            end
            else
                next_state = RX_LANE_CDR_WAIT ;
        end
        RX_LANE_CDR_CNTR     :
        begin
            if(!sigdet || !cdr_align || i_rx_pma_rst)
                next_state = RX_LANE_PMA_RST ;
            else if (i_rx_pcs_rst)
                next_state = RX_LANE_CDR_CNTR ;
            else if (i_rx_rate_chng_posedge)
                next_state = RX_CKDIV_ONLY ;
            else if (cntr == CDR_LOCK_CNTR_VALUE+PCS_RST_RELEASE_DLY_CNTR_VALUE )
                if (rxlane_word_align_en)
                    next_state = RX_LANE_ALIGN_WAIT ;
                else
                    next_state = RX_LANE_DONE ;
            else
                next_state = RX_LANE_CDR_CNTR ;
        end
        RX_LANE_ALIGN_WAIT  :
        begin
            if(!sigdet || !cdr_align || i_rx_pma_rst)
                next_state = RX_LANE_PMA_RST ;
            else if (i_rx_pcs_rst)
                next_state = RX_LANE_CDR_CNTR ;
            else if (i_rx_rate_chng_posedge)
                next_state = RX_CKDIV_ONLY ;
            else if (tx_rate_done && rxlane_ctc_en)
                next_state = RX_LANE_CDR_CNTR ;
            else if (!word_align && cntr==CH_RXPCS_ALIGN_TIMER && rxcdr_realign_en)
                next_state = RX_LANE_PMA_RST;
            else if (word_align&&rxlane_bonding_en)
                next_state = RX_LANE_BONDING_WAIT ;
            else if(word_align&&!rxlane_bonding_en)
                next_state = RX_LANE_DONE ;
            else
                next_state = RX_LANE_ALIGN_WAIT ;
        end
        RX_LANE_BONDING_WAIT:
        begin
            if(!sigdet || !cdr_align || i_rx_pma_rst)
                next_state = RX_LANE_PMA_RST ;
            else if (i_rx_pcs_rst)
                next_state = RX_LANE_CDR_CNTR ;
            else if (i_rx_rate_chng_posedge)
                next_state = RX_CKDIV_ONLY ;
            else if ((tx_rate_done && rxlane_ctc_en) || fifo_clr_en)
                next_state = RX_LANE_CDR_CNTR ;
            else if (bonding)
                next_state = RX_LANE_DONE ;
            else
                next_state = RX_LANE_BONDING_WAIT ;
        end
        RX_LANE_DONE        :
        begin
            if(!sigdet || !cdr_align || i_rx_pma_rst)
                next_state = RX_LANE_PMA_RST ;
            else if (i_rx_pcs_rst)
                next_state = RX_LANE_CDR_CNTR ;
            else if(!word_align&&rxlane_word_align_en)
                next_state = RX_LANE_ALIGN_WAIT ;
            else if(!bonding && rxlane_bonding_en)
                next_state = RX_LANE_BONDING_WAIT ;
            else if (tx_rate_done && rxlane_ctc_en)
                next_state = RX_LANE_CDR_CNTR ;
            else if (i_rx_rate_chng_posedge)
                next_state = RX_CKDIV_ONLY ;
            else if (fifo_clr_en && rxlane_mult_en)
                next_state = RX_LANE_CDR_CNTR ;
            else
                next_state = RX_LANE_DONE ;
        end
        RX_CKDIV_ONLY       :
        begin
            if(cntr == RX_PMA_RST_RELEASE_CNTR_VALUE)
                next_state = RX_LANE_SIGNAL_WAIT ;
            else
                next_state = RX_CKDIV_ONLY ;
        end
        default             :
        begin
            next_state     = RX_LANE_IDLE  ;
        end
    endcase
end

always @(posedge clk or negedge rst_n) 
begin
    if(!rst_n) 
    begin
        cntr                    <= {CNTR_WIDTH{1'b0}}; 
        PMA_RX_PD               <= 1'b1;
        P_PCS_RX_RST            <= 1'b1;
        RX_PMA_RST              <= 1'b1;
        RX_RATE                 <= LX_RX_CKDIV;
        o_rxckdiv_done          <= 1'b0;       
        o_rxlane_done           <= 1'b0;
        fifoclr_sig             <= 1'b0;
        rxcdr_realign_en        <= 1'b0;
    end
    else 
    begin
        case (rxlane_rst_fsm)
            RX_LANE_IDLE        :   
            begin
                cntr                    <= {CNTR_WIDTH{1'b0}}; 
                PMA_RX_PD               <= 1'b1;
                P_PCS_RX_RST            <= 1'b1;
                RX_PMA_RST              <= 1'b1;
                RX_RATE                 <= LX_RX_CKDIV;
                o_rxckdiv_done          <= 1'b0;       
                o_rxlane_done           <= 1'b0;
                fifoclr_sig             <= 1'b0;
                rxcdr_realign_en        <= 1'b0;
            end
            RX_LANE_PMA_POWERUP        :    begin
                PMA_RX_PD               <= 1'b0;
            end
            RX_LANE_PMA_RST     :   begin
                if(rxlane_rst_fsm!=next_state)
                begin
                    cntr                   <= {CNTR_WIDTH{1'b0}} ;
                end
                else if (i_rx_pma_rst)
                begin
                    cntr                   <= {CNTR_WIDTH{1'b0}} ;
                end
                else
                begin
                    cntr                    <= cntr + {{CNTR_WIDTH-1{1'b0}},{1'b1}} ;
                end
                if(cntr == PMA_RST_CNTR_VALUE)  begin
                    RX_PMA_RST              <= 1'b0;
                    rxcdr_realign_en        <= rxlane_word_align_en;
                end
                else    begin
                    RX_PMA_RST              <= 1'b1;
                    rxcdr_realign_en        <= 1'b0;
                end
                o_rxlane_done           <=1'b0 ;
                fifoclr_sig             <=1'b0 ;
                P_PCS_RX_RST            <=1'b1 ;
            end
            RX_LANE_SIGNAL_WAIT :
            begin
            end
            RX_LANE_CDR_CNTR    :
                begin
                if(rxlane_rst_fsm!=next_state)
                begin
                    cntr                   <= {CNTR_WIDTH{1'b0}} ;
                end
                else if(i_rx_pcs_rst)
                begin
                    cntr                   <= {CNTR_WIDTH{1'b0}} ;
                end
                else
                begin
                    cntr                    <= cntr + {{CNTR_WIDTH-1{1'b0}},{1'b1}} ;
                end
                if(cntr >= CDR_LOCK_CNTR_VALUE)     begin
                    P_PCS_RX_RST            <= 1'b0 ;
                end
                else
                P_PCS_RX_RST            <= 1'b1 ;
                o_rxlane_done           <= 1'b0 ;
                fifoclr_sig             <= 1'b0 ;
            end
            RX_LANE_CDR_WAIT  :
            begin
                o_rxlane_done           <= 1'b0 ;
            end
            RX_LANE_ALIGN_WAIT     :
            begin
                 if(rxlane_rst_fsm!=next_state)
                begin
                    cntr                   <= {CNTR_WIDTH{1'b0}} ;
                    rxcdr_realign_en       <= 1'b0;
                end
                else
                begin
                    cntr                    <= cntr + {{CNTR_WIDTH-1{1'b0}},{1'b1}} ;
                    rxcdr_realign_en        <= rxcdr_realign_en;
                end
                o_rxlane_done               <= 1'b0 ;
            end
            RX_LANE_BONDING_WAIT  :
            begin
                o_rxlane_done           <= 1'b0 ;
                fifoclr_sig             <= 1'b1 ;
            end
            RX_LANE_DONE        :
            begin
                if(rxlane_rst_fsm!=next_state)
                begin
                    cntr                   <= {CNTR_WIDTH{1'b0}} ;
                end
                else if(cntr==PCS_RST_RELEASE_DLY_CNTR_VALUE)
                begin
                    cntr                   <= PCS_RST_RELEASE_DLY_CNTR_VALUE ;
                    o_rxlane_done          <= 1'b1;
                end
                else
                begin
                    cntr                    <= cntr + {{CNTR_WIDTH-1{1'b0}},{1'b1}} ;
                    o_rxlane_done           <= 1'b0;
                end
                fifoclr_sig             <= 1'b1 ;
                rxcdr_realign_en        <= 1'b0;
            end
            RX_CKDIV_ONLY       :
            begin
                 if(rxlane_rst_fsm!=next_state)
                begin
                    cntr                   <= {CNTR_WIDTH{1'b0}} ;
                end
                else
                begin
                    cntr                    <= cntr + {{CNTR_WIDTH-1{1'b0}},{1'b1}} ;
                end
                if(cntr == RX_RATE_CNTR_VALUE)  begin
                    RX_RATE             <=  rxckdiv;
                end
                if(cntr == RX_PMA_RST_RELEASE_CNTR_VALUE)   begin
                    RX_PMA_RST              <= 1'b0;
                    o_rxckdiv_done          <= 1'b1;
                end
                else    begin
                    RX_PMA_RST              <= 1'b1;
                    o_rxckdiv_done          <= 1'b0;
                end
                P_PCS_RX_RST            <= 1'b1;
                rxcdr_realign_en        <= 1'b0;
            end
            default             :
            begin
                cntr                    <= {CNTR_WIDTH{1'b0}}; 
                PMA_RX_PD               <= 1'b1;
                P_PCS_RX_RST            <= 1'b1;
                RX_PMA_RST              <= 1'b1;
                RX_RATE                 <= LX_RX_CKDIV;
                o_rxckdiv_done          <= 1'b0;       
                o_rxlane_done           <= 1'b0;
                fifoclr_sig             <= 1'b0;
                rxcdr_realign_en        <= 1'b0;
            end
        endcase
    end
end


endmodule
