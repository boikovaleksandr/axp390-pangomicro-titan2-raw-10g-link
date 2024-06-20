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
module  ipm2t_hssthp_txlane_rst_fsm_v1_5#(
    parameter P_LX_TX_CKDIV               = 0       , //initial params
    parameter FREE_CLOCK_FREQ             = 100     ,//10MHz~100MHz
    parameter PCS_TX_CLK_EXPLL_USE_CH     = "FALSE" ,
    parameter CH_MULT_LANE_MODE           = 1
)(
    // Reset and Clock
    input  wire                   clk                   ,
    input  wire                   rst_n                 ,
    // HSST Reset Control Signal
    input  wire                   i_tx_rate_chng        ,
    input  wire   [1:0]           i_txckdiv             ,
    input  wire                   i_pll_lock_tx         ,
    input  wire                   i_tx_pma_rst          ,
    input  wire                   i_tx_pcs_rst          ,

    output reg                    TX_PMA_RST            ,
    output reg    [1:0]           TX_RATE               ,
    output reg                    PCS_TX_RST            ,
    output reg                    TX_LANE_POWERDOWN     ,
    output reg                    o_txlane_done         ,
    output reg                    lane_sync             ,
    output reg                    rate_change_on        ,
    output reg                    o_txckdiv_done        
);

localparam         CNTR_WIDTH                        = 18;
//TX Lane Power Up
localparam integer TX_PMA_RST_CNTR_VALUE             = 2*(0.5*FREE_CLOCK_FREQ);//add 50 percent margin
localparam integer PMA_RST_CNTR_VALUE                = 2*(0.5*FREE_CLOCK_FREQ);//add 50 percent margin
localparam integer PCS_RST_WAIT_CNTR_VALUE           = 2*(0.1*FREE_CLOCK_FREQ);//add 50 percent margin
localparam integer RATE_CHANGE_ON_CNTR_F_VALUE       = 2*(0.2*FREE_CLOCK_FREQ);//add 50 percent margin
localparam integer TX_SYNC_CNTR_VALUE                = 2*(0.4*FREE_CLOCK_FREQ);//add 50 percent margin
localparam integer TX_RST_DONE_DLY_CNTR_VALUE        = 32;//add for txlane_done is active but fabric clock is none by wenbin at @2019.9.26
//TX LANE SYNC
localparam integer TX_RATE_CNTR_VALUE                = 2*(0.45*FREE_CLOCK_FREQ);//add 50 percent margin
//TX Lane Rate Change
localparam integer TX_SYNC_CNTR_F_VALUE              = 2*(0.5*FREE_CLOCK_FREQ);//add 50 percent margin
localparam integer PMA_RST_CNTR_RELEASE_VALUE        = 2*(0.55*FREE_CLOCK_FREQ);//add 50 percent margin
localparam integer RATE_CHANGE_ON_CNTR_R_VALUE       = 2*(0.75*FREE_CLOCK_FREQ);//add 50 percent margin
localparam integer PCS_RST_CNTR_RELEASE_VALUE        = 2*(0.85*FREE_CLOCK_FREQ);//add 50 percent margin
localparam integer TX_CKDIV_DONE_CNTR_VALUE          = 2*(1*FREE_CLOCK_FREQ);//add 50 percent margin
localparam integer TX_BONDING_SYNC_CNTR_VALUE        = 2*(14*FREE_CLOCK_FREQ);//add 50 percent margin
localparam integer TX_SYNC_R_CNTR_VALUE              = 2*(10*FREE_CLOCK_FREQ);//add 50 percent margin
//TX Lane FSM Status
localparam TX_LANE_IDLE   = 3'd0;
localparam TX_LANE_PMA    = 3'd1;
localparam TX_LANE_PCS    = 3'd3;
localparam TX_DONE        = 3'd4;
localparam TX_CKDIV       = 3'd5;
localparam TX_SYNC        = 3'd6;
//****************************************************************************//
//                      Internal Signal                                       //
//****************************************************************************//
reg     [CNTR_WIDTH-1 : 0] cntr                 ;
reg     [2            : 0] txlane_rst_fsm       ;
reg     [2            : 0] next_state           ;
reg     [1            : 0] i_tx_rate_chng_ff    ;
reg                       i_tx_rate_chng_posedge;
reg     [1            : 0] i_txckdiv_ff         ;
reg     [1            : 0] txckdiv              ;
wire                       expll_lock_tx        ;
wire                       bonding              ;

//****************************************************************************//
//                      Sequential and Logic                                  //
//****************************************************************************//
assign expll_lock_tx = (PCS_TX_CLK_EXPLL_USE_CH  ==  "FALSE") ? 1'b1 : i_pll_lock_tx ;
assign bonding = (CH_MULT_LANE_MODE!=1) ? 1'b1 : 1'b0 ;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        i_tx_rate_chng_ff     <= 2'b0;
    else 
        i_tx_rate_chng_ff     <= {i_tx_rate_chng_ff[0],i_tx_rate_chng};
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        i_tx_rate_chng_posedge     <= 1'b0;
    else if (txlane_rst_fsm == TX_CKDIV)
        i_tx_rate_chng_posedge     <= 1'b0;
    else if (i_tx_rate_chng_ff[0] & (!i_tx_rate_chng_ff[1]))
        i_tx_rate_chng_posedge     <= 1'b1;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        i_txckdiv_ff     <= 2'b00;
    else 
        i_txckdiv_ff     <= i_txckdiv;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        txckdiv                  <= 2'b00;
    else if (!i_tx_rate_chng_posedge && i_tx_rate_chng_ff[0] && (!i_tx_rate_chng_ff[1]) && txlane_rst_fsm != TX_CKDIV)
        txckdiv                  <= i_txckdiv_ff;
    else ;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        txlane_rst_fsm     <=   TX_LANE_IDLE   ;
    end
    else begin
        txlane_rst_fsm     <=   next_state ;
    end
end

always@(*) begin
    case(txlane_rst_fsm)
        TX_LANE_IDLE    :
            next_state      = TX_LANE_PMA     ;
        TX_LANE_PMA     :
        begin
            if (i_tx_pma_rst)
                next_state    =    TX_LANE_PMA     ;
            else if(cntr == PMA_RST_CNTR_VALUE&&expll_lock_tx&&!bonding)
                next_state  = TX_LANE_PCS     ;
            else if(cntr == PMA_RST_CNTR_VALUE&&expll_lock_tx&&bonding)
                next_state  = TX_SYNC         ; 
            else
                next_state    =    TX_LANE_PMA     ;
        end
        TX_SYNC        :
        begin
            if(cntr == TX_BONDING_SYNC_CNTR_VALUE)
                next_state  = TX_LANE_PCS     ;
            else
                next_state  = TX_SYNC     ;
        end
        TX_LANE_PCS    :
        begin 
                if (cntr == TX_RST_DONE_DLY_CNTR_VALUE && ~i_tx_pcs_rst)
                    next_state    =    TX_DONE     ;
                else
                    next_state    =    TX_LANE_PCS    ;
        end
        TX_DONE      :
            if(i_tx_pma_rst)
                next_state  =      TX_LANE_PMA ;
            else if(i_tx_pcs_rst)
                next_state  =      TX_LANE_PCS ;
            else if(i_tx_rate_chng_posedge)
                next_state  =      TX_CKDIV    ;
            else
                next_state    =    TX_DONE     ;
        TX_CKDIV     :
        begin
            if(cntr == TX_CKDIV_DONE_CNTR_VALUE)
                next_state    =    TX_DONE     ;
            else
                next_state    =    TX_CKDIV     ;
        end
        default    :
        begin
            next_state    =    TX_LANE_IDLE     ;
        end
    endcase
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n) 
    begin
        cntr                   <= {CNTR_WIDTH{1'b0}};
        TX_PMA_RST             <= 1'b1;
        PCS_TX_RST             <= 1'b1;
        lane_sync              <= 1'b0;
        rate_change_on         <= 1'b1;
        TX_RATE                <= P_LX_TX_CKDIV;
        TX_LANE_POWERDOWN      <= 1'b1;
        o_txlane_done          <= 1'b0; 
        o_txckdiv_done         <= 1'b0; 
    end
    else
    begin
        case(txlane_rst_fsm)
            TX_LANE_IDLE    :   begin
               cntr                   <= {CNTR_WIDTH{1'b0}}; 
               TX_PMA_RST             <= 1'b1;
               PCS_TX_RST             <= 1'b1;
               lane_sync              <= 1'b0;
               rate_change_on         <= 1'b1;
               TX_RATE                <= P_LX_TX_CKDIV;
               TX_LANE_POWERDOWN      <= 1'b1;
               o_txlane_done          <= 1'b0; 
               o_txckdiv_done         <= 1'b0;  
            end
            TX_LANE_PMA    :
            begin
                if(txlane_rst_fsm!=next_state)  begin
                    cntr                   <= {CNTR_WIDTH{1'b0}};
                end
                else if(i_tx_pma_rst) begin
                    cntr                   <= {CNTR_WIDTH{1'b0}};
                end
                else if(cntr == PMA_RST_CNTR_VALUE)   begin
                    cntr                   <=PMA_RST_CNTR_VALUE ;
                end
                else    begin
                    cntr                    <= cntr + {{CNTR_WIDTH-1{1'b0}},{1'b1}};
                end
                if(cntr == PMA_RST_CNTR_VALUE)
                    TX_PMA_RST             <= 1'b0;
                else
                    TX_PMA_RST             <= 1'b1;
               TX_LANE_POWERDOWN      <= 1'b0;
               o_txlane_done          <= 1'b0; 
               o_txckdiv_done         <= 1'b0;  
            end
            TX_SYNC     :
            begin
                if(txlane_rst_fsm!=next_state)  begin
                    cntr                   <= {CNTR_WIDTH{1'b0}};
                end
                else
                    cntr                    <= cntr + {{CNTR_WIDTH-1{1'b0}},{1'b1}};
                if(cntr == TX_SYNC_R_CNTR_VALUE)
                    lane_sync              <= 1'b1;
                else if(cntr == TX_BONDING_SYNC_CNTR_VALUE)
                    lane_sync              <= 1'b0;
                else
                    lane_sync              <= lane_sync;
               o_txlane_done          <= 1'b0; 
               o_txckdiv_done         <= 1'b0;  
            end
            TX_LANE_PCS    :
            begin
                if(txlane_rst_fsm!=next_state)  begin
                    cntr                <= {CNTR_WIDTH{1'b0}};
                    PCS_TX_RST          <= 1'b0;
                end
                else if(i_tx_pcs_rst) begin
                    cntr                <= {CNTR_WIDTH{1'b0}};
                    PCS_TX_RST          <= 1'b1;
                end
                else    begin
                    cntr                <= cntr + {{CNTR_WIDTH-1{1'b0}},{1'b1}};
                    PCS_TX_RST          <= 1'b1;
                end
               o_txlane_done          <= 1'b0; 
               o_txckdiv_done         <= 1'b0;  
            end
            TX_DONE    :
            begin
                o_txlane_done    <= 1'b1 ;
                cntr             <= {CNTR_WIDTH{1'b0}};
            end
            TX_CKDIV    :
            begin
                o_txlane_done    <= 1'b0 ;
                if(txlane_rst_fsm!=next_state)  begin
                    cntr                <= {CNTR_WIDTH{1'b0}};
                    o_txckdiv_done      <= 1'b1 ;
                end
                else    begin
                   cntr                <= cntr + {{CNTR_WIDTH-1{1'b0}},{1'b1}};
                   o_txckdiv_done      <= 1'b0 ;
                end
                    if(cntr == PCS_RST_WAIT_CNTR_VALUE)
                         PCS_TX_RST             <= 1'b1;
                    else if (cntr == RATE_CHANGE_ON_CNTR_F_VALUE)
                        rate_change_on          <= 1'b0 ;
                    else if (cntr == TX_SYNC_CNTR_VALUE)    begin
                            TX_PMA_RST          <= 1'b1 ;
                            lane_sync           <= 1'b1 ;
                    end
                    else if (cntr == TX_RATE_CNTR_VALUE)
                    begin
                        TX_RATE              <= txckdiv ;
                    end
                    else if (cntr == TX_SYNC_CNTR_F_VALUE)
                        lane_sync           <= 1'b0 ;
                    else if (cntr == PMA_RST_CNTR_RELEASE_VALUE)
                        TX_PMA_RST          <= 1'b0 ;
                    else if (cntr == RATE_CHANGE_ON_CNTR_R_VALUE)
                        rate_change_on          <= 1'b1 ;
                    else if (cntr == PCS_RST_CNTR_RELEASE_VALUE)
                        PCS_TX_RST             <= 1'b0;
            end   
            default    :
            begin
               cntr                   <= {CNTR_WIDTH{1'b0}}; 
               TX_PMA_RST             <= 1'b1;
               PCS_TX_RST             <= 1'b1;
               lane_sync              <= 1'b0;
               rate_change_on         <= 1'b1;
               TX_RATE                <= P_LX_TX_CKDIV;
               TX_LANE_POWERDOWN      <= 1'b1;
               o_txlane_done          <= 1'b0; 
               o_txckdiv_done         <= 1'b0;
            end
        endcase
    end
end

endmodule
