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
module  ipm2t_hssthp_lpll_rst_fsm_v1_0#(
    parameter FREE_CLOCK_FREQ    = 100   //unit is MHz, free clock  freq from GUI
)(
    // Reset and Clock
    input  wire                   clk                 ,
    input  wire                   rst_n               ,
    // HSST Reset Control Signal
    input  wire                   pll_lock            ,
    output reg                    LPLL_POWERDOWN     ,
    output reg                    LPLL_RST    ,
    output reg                    o_lpll_done   
);

localparam         CNTR_WIDTH                = 12;
localparam integer LPLL_PD_CNTR_VALUE        = 2*(15*FREE_CLOCK_FREQ);//add 50 percent margin
localparam integer LPLL_RST_WAIT_CNTR_VALUE  = 30.15*FREE_CLOCK_FREQ;
localparam integer LPLL_RST_CNTR_VALUE       = 38.15*FREE_CLOCK_FREQ;
localparam integer LPLL_DONE_CNTR_VALUE      = 2*(1*FREE_CLOCK_FREQ);//add 50 percent margin

localparam LPLL_IDLE        = 2'd0;
localparam POWERUP          = 2'd1;
localparam LPLL_DONE        = 2'd2;

//****************************************************************************//
//                      Internal Signal                                       //
//****************************************************************************//
reg     [CNTR_WIDTH-1 : 0] cntr     ;
reg     [1            : 0] lpll_fsm  ;
reg     [1            : 0] next_state ;
//****************************************************************************//
//                      Sequential and Logic                                  //
//****************************************************************************//
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        lpll_fsm     <=   LPLL_IDLE   ;
    end
    else begin
        lpll_fsm     <=   next_state ;
    end
end

always @ (*) begin
    case(lpll_fsm)
        LPLL_IDLE    :    begin
                next_state  =  POWERUP ;
            end
        POWERUP     :    begin
            if(cntr ==  LPLL_RST_CNTR_VALUE&&pll_lock)   begin
                next_state  =  LPLL_DONE  ;
            end
            else begin
                next_state  =  POWERUP   ;
            end
        end
        LPLL_DONE     :    begin
            next_state  =  LPLL_DONE  ;
            end
        default    :    begin
            next_state    =    LPLL_IDLE  ;
        end
    endcase
end
 
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cntr              <=   {CNTR_WIDTH{1'b0}} ;
        LPLL_POWERDOWN    <=   1'b1               ;
        LPLL_RST          <=   1'b0               ;
        o_lpll_done       <=   1'b0               ;
    end
    else  begin
        case(lpll_fsm)
            LPLL_IDLE    :    begin
                cntr              <=   {CNTR_WIDTH{1'b0}} ;
                LPLL_POWERDOWN    <=   1'b1               ;
                LPLL_RST          <=   1'b0               ;
                o_lpll_done       <=   1'b0               ;
            end
            POWERUP     :    begin
                if(lpll_fsm != next_state)    begin
                    cntr              <=   {CNTR_WIDTH{1'b0}}    ;
                end
                else if(cntr == LPLL_RST_CNTR_VALUE)    begin
                    cntr              <=    LPLL_RST_CNTR_VALUE  ;
                end
                else    begin
                    cntr              <=   cntr + {{CNTR_WIDTH-1{1'b0}},{1'b1}} ;
                end
                if(cntr ==  LPLL_PD_CNTR_VALUE)   begin
                    LPLL_POWERDOWN    <=   1'b0               ;
                end
                else if(cntr == LPLL_RST_WAIT_CNTR_VALUE)   begin
                    LPLL_RST          <=   1'b1               ;
                end
                else if(cntr == LPLL_RST_CNTR_VALUE)    begin
                    LPLL_RST          <=   1'b0               ;
                end
            end
            LPLL_DONE    :    begin
                    if(cntr ==  LPLL_DONE_CNTR_VALUE)    begin
                        cntr              <= LPLL_DONE_CNTR_VALUE ;
                        o_lpll_done       <= 1'b1   ;
                    end
                    else    begin
                    cntr              <=   cntr + {{CNTR_WIDTH-1{1'b0}},{1'b1}} ;
                    o_lpll_done       <=   1'b0 ;
                    end
            end
            default:    begin
                cntr              <=   {CNTR_WIDTH{1'b0}} ;
                LPLL_POWERDOWN    <=   1'b1               ;
                LPLL_RST          <=   1'b0               ;
                o_lpll_done       <=   1'b0               ;
            end
        endcase
    end
end

endmodule
