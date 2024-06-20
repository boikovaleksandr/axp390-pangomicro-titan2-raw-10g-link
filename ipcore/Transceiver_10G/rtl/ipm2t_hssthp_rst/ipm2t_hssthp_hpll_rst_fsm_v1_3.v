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
`timescale 1ns/1ps
module  ipm2t_hssthp_hpll_rst_fsm_v1_3#(
    parameter FREE_CLOCK_FREQ    = 100   ,//unit is MHz, free clock  freq from GUI
    parameter SINGLEHPLL_BONDING = "TRUE",
    parameter MULTHPLL_BONDING   = "TRUE"
)(
    // Reset and Clock
    input  wire                   clk                 ,
    input  wire                   rst_n               ,
    // HSST Reset Control Signal
    input  wire                   pll_lock            ,
    output reg                    P_HPLL_POWERDOWN    ,
    output reg                    P_HPLL_RST          ,
    output reg                    P_HPLL_VCO_CALIB_EN ,
    output reg                    P_REFCLK_DIV_SYNC   ,
    output reg                    P_HPLL_DIV_SYNC     ,
    output reg                    tx_sync_hpll        ,
    output reg                    o_hpll_done   
);

localparam         CNTR_WIDTH                = 12;
localparam integer COM_POUP_CNTR_VALUE       = 0.75*FREE_CLOCK_FREQ;
localparam integer PLL_POUP_CNTR_VALUE       = 1.5*FREE_CLOCK_FREQ;
localparam integer REF_SYNC_CNTR_VALUE       = 8.75*FREE_CLOCK_FREQ;
localparam integer MULTHPLL_PD_CNTR_VALUE    = 10.75*FREE_CLOCK_FREQ;
localparam integer REF_SYNC_RST_CNTR_VALUE   = 11.5*FREE_CLOCK_FREQ;
localparam integer HPLL_RST_CNTR_VALUE       = 2*(4*FREE_CLOCK_FREQ);//add 50 percent margin
localparam integer SYNC_WAIT_CNTR_VALUE      = 2*(0.1*FREE_CLOCK_FREQ);//add 50 percent margin
localparam integer SYNC_SINGLE_CNTR_VALUE    = 2*(4.1*FREE_CLOCK_FREQ);//add 50 percent margin
localparam integer DIV_SYNC_WAIT_CNTR_VALUE  = 0.75*FREE_CLOCK_FREQ;
localparam integer DIV_SYNC_CNTR_VALUE       = 8.75*FREE_CLOCK_FREQ;//add 50 percent margin
localparam integer TX_SYNC_WAIT_CNTR_VALUE   = 28.75*FREE_CLOCK_FREQ;
//localparam integer TX_SYNC_WAIT_CNTR_VALUE   = 2*(4*FREE_CLOCK_FREQ);//add 50 percent margin
localparam integer SIGNGLE_TX_SYNC_CNTR_VALUE= 2*(4.1*FREE_CLOCK_FREQ);//add 50 percent margin
localparam integer MULT_TX_SYNC_CNTR_VALUE   = 36.75*FREE_CLOCK_FREQ;//add 50 percent margin
localparam integer HPLL_DONE_CNTR_VALUE      = 2*(1*FREE_CLOCK_FREQ);//add 50 percent margin

localparam HPLL_IDLE        = 3'd0;
localparam POWERUP          = 3'd1;
localparam HPLL_RST         = 3'd2;
localparam MULT_BONDING     = 3'd4;
localparam MULTQUAD_BONDING = 3'd5;
localparam SINGLE_BONDING   = 3'd6;
localparam PLL_DONE         = 3'd7;

//****************************************************************************//
//                      Internal Signal                                       //
//****************************************************************************//
reg     [CNTR_WIDTH-1 : 0] cntr     ;
reg     [2            : 0] hpll_fsm  ;
reg     [2            : 0] next_state ;
//****************************************************************************//
//                      Sequential and Logic                                  //
//****************************************************************************//
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        hpll_fsm     <=   HPLL_IDLE   ;
    end
    else begin
        hpll_fsm     <=   next_state ;
    end
end

always @ (*) begin
    case(hpll_fsm)
        HPLL_IDLE    :    begin
            if(MULTHPLL_BONDING == "TRUE") begin
                next_state  =  MULT_BONDING ;
            end
            else begin
                  next_state  =  POWERUP   ;
            end
        end
        POWERUP     :    begin
            if(cntr ==  PLL_POUP_CNTR_VALUE)   begin
                next_state  =  HPLL_RST  ;
            end
            else begin
                next_state  =  POWERUP   ;
            end
        end
        MULT_BONDING     :    begin
            if(cntr ==  REF_SYNC_RST_CNTR_VALUE)   begin
                next_state  =  HPLL_RST  ;
            end
            else begin
                next_state  =  MULT_BONDING   ;
            end
        end
        HPLL_RST    :    begin
            if(cntr ==  HPLL_RST_CNTR_VALUE && pll_lock && SINGLEHPLL_BONDING == "TRUE")   begin
                next_state  =  SINGLE_BONDING  ;
            end
            else if(cntr ==  HPLL_RST_CNTR_VALUE && pll_lock && MULTHPLL_BONDING == "TRUE") begin
                next_state  =  MULTQUAD_BONDING;
            end
            else if(cntr == HPLL_RST_CNTR_VALUE &&pll_lock&&SINGLEHPLL_BONDING == "FALSE"&&MULTHPLL_BONDING == "FALSE") begin
                next_state  =  PLL_DONE        ;
            end
            else    begin
                next_state  =  HPLL_RST ;
            end
        end
        SINGLE_BONDING     :    begin
            if(cntr ==  SYNC_SINGLE_CNTR_VALUE)   begin
                next_state  =  PLL_DONE  ;
            end
            else begin
                next_state  =  SINGLE_BONDING   ;
            end
        end
        MULTQUAD_BONDING     :    begin
            if(cntr ==  MULT_TX_SYNC_CNTR_VALUE)   begin
                next_state  =  PLL_DONE  ;
            end
            else begin
                next_state  =  MULTQUAD_BONDING   ;
            end
        end
        PLL_DONE    :   begin
            next_state  =   PLL_DONE    ;
        end
        default    :    begin
            next_state    =    HPLL_IDLE  ;
        end
    endcase
end
 
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cntr              <=   {CNTR_WIDTH{1'b0}} ;
        P_HPLL_POWERDOWN  <=   1'b1               ;
        P_HPLL_RST        <=   1'b1               ;
        P_HPLL_VCO_CALIB_EN <= 1'b0               ;
        P_REFCLK_DIV_SYNC <=   1'b0               ;
        P_HPLL_DIV_SYNC   <=   1'b0               ;
        tx_sync_hpll      <=   1'b0               ;
        o_hpll_done        <=   1'b0               ;
    end
    else  begin
        case(hpll_fsm)
            HPLL_IDLE    :    begin
                    cntr              <=   {CNTR_WIDTH{1'b0}} ;
                    P_HPLL_POWERDOWN  <=   1'b1               ;
                    P_HPLL_RST        <=   1'b1               ;
                    P_HPLL_VCO_CALIB_EN <= 1'b0               ;
                    P_REFCLK_DIV_SYNC <=   1'b0               ;
                    P_HPLL_DIV_SYNC   <=   1'b0               ;
                    tx_sync_hpll      <=   1'b0               ;
                    o_hpll_done       <=   1'b0               ;
                end
            POWERUP     :    begin
                if(hpll_fsm != next_state)    begin
                    cntr              <=   {CNTR_WIDTH{1'b0}}    ;
                end
                else    begin
                    cntr              <=   cntr + {{CNTR_WIDTH-1{1'b0}},{1'b1}} ;
                end
                if(cntr == COM_POUP_CNTR_VALUE)     begin
                    P_HPLL_POWERDOWN  <=   1'b0               ;
                end
            end
            MULT_BONDING    :    begin
                if(hpll_fsm != next_state)   begin
                    cntr              <=   {CNTR_WIDTH{1'b0}}    ;
                end
                else    begin
                    cntr              <=   cntr + {{CNTR_WIDTH-1{1'b0}},{1'b1}} ;
                end
                if(cntr ==  COM_POUP_CNTR_VALUE)    begin
                    P_REFCLK_DIV_SYNC <=   1'b1               ;
                end
                else if(cntr==REF_SYNC_CNTR_VALUE)   begin
                   P_REFCLK_DIV_SYNC <=   1'b0               ;
                end
                else if(cntr==MULTHPLL_PD_CNTR_VALUE)   begin
                    P_HPLL_POWERDOWN  <= 1'b0                 ;
                end
            end
            HPLL_RST     :    begin
                if(hpll_fsm != next_state)    begin
                    cntr              <=   {CNTR_WIDTH{1'b0}}    ; 
                end
                else if(cntr==HPLL_RST_CNTR_VALUE)  begin
                    cntr              <= HPLL_RST_CNTR_VALUE     ;
                end
                else
                    cntr              <=   cntr + {{CNTR_WIDTH-1{1'b0}},{1'b1}} ;
                if (cntr==HPLL_RST_CNTR_VALUE)   begin
                    P_HPLL_RST        <=   1'b0                  ;
                    P_HPLL_VCO_CALIB_EN <= 1'b1                  ;
                end
                else    begin
                    P_HPLL_RST        <=   1'b1                  ;
                    P_HPLL_VCO_CALIB_EN <= 1'b0                  ;
                end
            end
            MULTQUAD_BONDING     :    begin
                if(hpll_fsm != next_state)    begin
                    cntr              <=   {CNTR_WIDTH{1'b0}}    ;
                end
                else    begin
                    cntr              <=   cntr + {{CNTR_WIDTH-1{1'b0}},{1'b1}} ;
                end
                if (cntr==DIV_SYNC_WAIT_CNTR_VALUE)  begin
                    P_REFCLK_DIV_SYNC        <=   1'b1                  ;
                end
                else if (cntr==DIV_SYNC_CNTR_VALUE)  begin
                    P_REFCLK_DIV_SYNC        <=   1'b0                  ;
                end
                else if (cntr==TX_SYNC_WAIT_CNTR_VALUE)  begin
                    tx_sync_hpll      <=   1'b1               ;
                end
                else if (cntr==MULT_TX_SYNC_CNTR_VALUE)  begin
                    tx_sync_hpll      <=   1'b0               ;
                end
            end
            SINGLE_BONDING     :    begin
                if(hpll_fsm != next_state)    begin
                    cntr              <=   {CNTR_WIDTH{1'b0}}    ; 
                end
                else    begin
                    cntr              <=   cntr + {{CNTR_WIDTH-1{1'b0}},{1'b1}} ;
                end
                if (cntr==SYNC_WAIT_CNTR_VALUE)   begin
                   tx_sync_hpll      <=   1'b1               ;    
                end
                else if (cntr==SYNC_SINGLE_CNTR_VALUE)   begin
                   tx_sync_hpll      <=   1'b0               ;    
                end
            end
            PLL_DONE :  begin
                if (cntr==HPLL_DONE_CNTR_VALUE) begin
                    cntr        <= HPLL_DONE_CNTR_VALUE ;
                    o_hpll_done <= 1'b1 ;
                end
                else    begin 
                    cntr              <=   cntr + {{CNTR_WIDTH-1{1'b0}},{1'b1}} ;
                    o_hpll_done <= 1'b0 ;
                end
            end
            default:    begin
                cntr              <=   {CNTR_WIDTH{1'b0}} ;
                P_HPLL_POWERDOWN  <=   1'b1               ;
                P_HPLL_RST        <=   1'b1               ;
                P_HPLL_VCO_CALIB_EN <= 1'b0               ;
                P_REFCLK_DIV_SYNC <=   1'b0               ;
                P_HPLL_DIV_SYNC   <=   1'b0               ;
                tx_sync_hpll      <=   1'b0               ;
                o_hpll_done       <=   1'b0               ;
            end
        endcase
    end
end

endmodule
