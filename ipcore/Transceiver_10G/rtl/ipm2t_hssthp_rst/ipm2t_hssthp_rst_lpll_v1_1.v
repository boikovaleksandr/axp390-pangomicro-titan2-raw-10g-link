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
module  ipm2t_hssthp_rst_lpll_v1_1#( 
    parameter FREE_CLOCK_FREQ         = 100            ,//Unit is MHz, free clock  freq from GUI Freq: 0~200MHz
    parameter CH0_LPLL_USE            = "TRUE"         ,
    parameter CH1_LPLL_USE            = "TRUE"         ,
    parameter CH2_LPLL_USE            = "TRUE"         ,
    parameter CH3_LPLL_USE            = "TRUE"         
)(
    //User Side 
    input  wire                   clk                     ,
    input  wire                   i_lpll_rst_0            ,
    input  wire                   i_lpll_rst_1            ,
    input  wire                   i_lpll_rst_2            ,
    input  wire                   i_lpll_rst_3            ,
    input  wire                   LPLL_READY_0            ,
    input  wire                   LPLL_READY_1            ,
    input  wire                   LPLL_READY_2            ,
    input  wire                   LPLL_READY_3            ,
    input  wire                   i_wtchdg_clr_lpll_0     ,
    input  wire                   i_wtchdg_clr_lpll_1     ,
    input  wire                   i_wtchdg_clr_lpll_2     ,
    input  wire                   i_wtchdg_clr_lpll_3     ,
    output wire    [1 : 0]        o_wtchdg_st_lpll_0      ,
    output wire    [1 : 0]        o_wtchdg_st_lpll_1      ,
    output wire    [1 : 0]        o_wtchdg_st_lpll_2      ,
    output wire    [1 : 0]        o_wtchdg_st_lpll_3      ,
    output wire                   o_lpll_done_0           ,
    output wire                   o_lpll_done_1           ,
    output wire                   o_lpll_done_2           ,
    output wire                   o_lpll_done_3           ,
    output wire                   LPLL_POWERDOWN_0        ,
    output wire                   LPLL_POWERDOWN_1        ,
    output wire                   LPLL_POWERDOWN_2        ,
    output wire                   LPLL_POWERDOWN_3        ,
    output wire                   LPLL_RST_0              ,
    output wire                   LPLL_RST_1              ,
    output wire                   LPLL_RST_2              ,
    output wire                   LPLL_RST_3              

);


localparam PLL_LOCK_RISE_CNTR_WIDTH    = 12  ;
`ifdef IPM2T_HSST_SPEEDUP_SIM
localparam PLL_LOCK_RISE_CNTR_VALUE    = 20;
`else
localparam PLL_LOCK_RISE_CNTR_VALUE    = 2048;
`endif
localparam PLL_LOCK_WTCHDG_CNTR1_WIDTH = 10  ;
localparam PLL_LOCK_WTCHDG_CNTR2_WIDTH = 10  ; 

//****************************************************************************//
//                      Internal Signal                                       //
//****************************************************************************//
wire              i_lpll_rstn_0  ;
wire              i_lpll_rstn_1  ;
wire              i_lpll_rstn_2  ;
wire              i_lpll_rstn_3  ;
wire              s_lpll_rstn_0  ;
wire              s_lpll_rstn_1  ;
wire              s_lpll_rstn_2  ;
wire              s_lpll_rstn_3  ;
wire              s_pll_lock_0   ;
wire              s_pll_lock_1   ;
wire              s_pll_lock_2   ;
wire              s_pll_lock_3   ;
wire              pll_lock_0     ;
wire              pll_lock_1     ;
wire              pll_lock_2     ;
wire              pll_lock_3     ;
wire              wtchdg_rstn_0  ;
wire              wtchdg_rstn_1  ;
wire              wtchdg_rstn_2  ;
wire              wtchdg_rstn_3  ;
wire              hpll_rstn_0    ;
wire              hpll_rstn_1    ;
wire              hpll_rstn_2    ;
wire              hpll_rstn_3    ;
//****************************************************************************//
//                      Sequential and Logic                                  //
//****************************************************************************//
assign   i_lpll_rstn_0 = ~i_lpll_rst_0        ;
assign   i_lpll_rstn_1 = ~i_lpll_rst_1        ;
assign   i_lpll_rstn_2 = ~i_lpll_rst_2        ;
assign   i_lpll_rstn_3 = ~i_lpll_rst_3        ;
//Sync signal
ipm2t_hssthp_rst_sync_v1_0 lpll_rstn_sync_0 (.clk(clk), .rst_n(i_lpll_rstn_0), .sig_async(1'b1), .sig_synced(s_lpll_rstn_0));
ipm2t_hssthp_rst_sync_v1_0 lpll_rstn_sync_1 (.clk(clk), .rst_n(i_lpll_rstn_1), .sig_async(1'b1), .sig_synced(s_lpll_rstn_1));
ipm2t_hssthp_rst_sync_v1_0 lpll_rstn_sync_2 (.clk(clk), .rst_n(i_lpll_rstn_2), .sig_async(1'b1), .sig_synced(s_lpll_rstn_2));
ipm2t_hssthp_rst_sync_v1_0 lpll_rstn_sync_3 (.clk(clk), .rst_n(i_lpll_rstn_3), .sig_async(1'b1), .sig_synced(s_lpll_rstn_3));
ipm2t_hssthp_rst_sync_v1_0 hpll_lock_sync_0 (.clk(clk), .rst_n(s_lpll_rstn_0), .sig_async(LPLL_READY_0), .sig_synced(s_pll_lock_0));
ipm2t_hssthp_rst_sync_v1_0 hpll_lock_sync_1 (.clk(clk), .rst_n(s_lpll_rstn_1), .sig_async(LPLL_READY_1), .sig_synced(s_pll_lock_1));
ipm2t_hssthp_rst_sync_v1_0 hpll_lock_sync_2 (.clk(clk), .rst_n(s_lpll_rstn_2), .sig_async(LPLL_READY_2), .sig_synced(s_pll_lock_2));
ipm2t_hssthp_rst_sync_v1_0 hpll_lock_sync_3 (.clk(clk), .rst_n(s_lpll_rstn_3), .sig_async(LPLL_READY_3), .sig_synced(s_pll_lock_3));

//Debounce
ipm2t_hssthp_rst_debounce_v1_0  #(.RISE_CNTR_WIDTH(PLL_LOCK_RISE_CNTR_WIDTH), .RISE_CNTR_VALUE(PLL_LOCK_RISE_CNTR_VALUE))
pll0_lock_deb_0             (.clk(clk), .rst_n(s_lpll_rstn_0), .signal_b(s_pll_lock_0), .signal_deb(pll_lock_0));
ipm2t_hssthp_rst_debounce_v1_0  #(.RISE_CNTR_WIDTH(PLL_LOCK_RISE_CNTR_WIDTH), .RISE_CNTR_VALUE(PLL_LOCK_RISE_CNTR_VALUE))
pll0_lock_deb_1             (.clk(clk), .rst_n(s_lpll_rstn_1), .signal_b(s_pll_lock_1), .signal_deb(pll_lock_1));
ipm2t_hssthp_rst_debounce_v1_0  #(.RISE_CNTR_WIDTH(PLL_LOCK_RISE_CNTR_WIDTH), .RISE_CNTR_VALUE(PLL_LOCK_RISE_CNTR_VALUE))
pll0_lock_deb_2             (.clk(clk), .rst_n(s_lpll_rstn_2), .signal_b(s_pll_lock_2), .signal_deb(pll_lock_2));
ipm2t_hssthp_rst_debounce_v1_0  #(.RISE_CNTR_WIDTH(PLL_LOCK_RISE_CNTR_WIDTH), .RISE_CNTR_VALUE(PLL_LOCK_RISE_CNTR_VALUE))
pll0_lock_deb_3             (.clk(clk), .rst_n(s_lpll_rstn_3), .signal_b(s_pll_lock_3), .signal_deb(pll_lock_3));

ipm2t_hssthp_rst_wtchdg_v1_0  #(.WTCHDG_CNTR1_WIDTH(PLL_LOCK_WTCHDG_CNTR1_WIDTH), .WTCHDG_CNTR2_WIDTH(PLL_LOCK_WTCHDG_CNTR2_WIDTH))
pll0_lock_wtchdg_0       (.clk(clk), .rst_n(s_lpll_rstn_0), .wtchdg_clr(i_wtchdg_clr_lpll_0), .wtchdg_in(s_pll_lock_0), .wtchdg_rst_n(wtchdg_rstn_0), .wtchdg_st(o_wtchdg_st_lpll_0));
ipm2t_hssthp_rst_wtchdg_v1_0  #(.WTCHDG_CNTR1_WIDTH(PLL_LOCK_WTCHDG_CNTR1_WIDTH), .WTCHDG_CNTR2_WIDTH(PLL_LOCK_WTCHDG_CNTR2_WIDTH))
pll0_lock_wtchdg_1       (.clk(clk), .rst_n(s_lpll_rstn_1), .wtchdg_clr(i_wtchdg_clr_lpll_1), .wtchdg_in(s_pll_lock_1), .wtchdg_rst_n(wtchdg_rstn_1), .wtchdg_st(o_wtchdg_st_lpll_1));
ipm2t_hssthp_rst_wtchdg_v1_0  #(.WTCHDG_CNTR1_WIDTH(PLL_LOCK_WTCHDG_CNTR1_WIDTH), .WTCHDG_CNTR2_WIDTH(PLL_LOCK_WTCHDG_CNTR2_WIDTH))
pll0_lock_wtchdg_2       (.clk(clk), .rst_n(s_lpll_rstn_2), .wtchdg_clr(i_wtchdg_clr_lpll_2), .wtchdg_in(s_pll_lock_2), .wtchdg_rst_n(wtchdg_rstn_2), .wtchdg_st(o_wtchdg_st_lpll_2));
ipm2t_hssthp_rst_wtchdg_v1_0  #(.WTCHDG_CNTR1_WIDTH(PLL_LOCK_WTCHDG_CNTR1_WIDTH), .WTCHDG_CNTR2_WIDTH(PLL_LOCK_WTCHDG_CNTR2_WIDTH))
pll0_lock_wtchdg_3       (.clk(clk), .rst_n(s_lpll_rstn_3), .wtchdg_clr(i_wtchdg_clr_lpll_3), .wtchdg_in(s_pll_lock_3), .wtchdg_rst_n(wtchdg_rstn_3), .wtchdg_st(o_wtchdg_st_lpll_3));

assign lpll_rstn_0  =  wtchdg_rstn_0 && s_lpll_rstn_0  ;
assign lpll_rstn_1  =  wtchdg_rstn_1 && s_lpll_rstn_1  ;
assign lpll_rstn_2  =  wtchdg_rstn_2 && s_lpll_rstn_2  ;
assign lpll_rstn_3  =  wtchdg_rstn_3 && s_lpll_rstn_3  ;

//-----  Instance lpll Rst Fsm Module -----------
generate if( CH0_LPLL_USE== "TRUE")     begin: CH0_LPLL
ipm2t_hssthp_lpll_rst_fsm_v1_0#(
    .FREE_CLOCK_FREQ    (FREE_CLOCK_FREQ    )
) hpll_rst_fsm_0 (
    .clk                (clk                ),
    .rst_n              (lpll_rstn_0          ),
    .pll_lock           (pll_lock_0           ),
    .LPLL_POWERDOWN     (LPLL_POWERDOWN_0     ),
    .LPLL_RST           (LPLL_RST_0           ),
    .o_lpll_done        (o_lpll_done_0         ) 
);
end
else begin: CH0_NO_LPLL
    //assign o_wtchdg_st_lpll_0 = 2'b00 ;
    assign o_lpll_done_0   = 1'b0 ;
    assign LPLL_POWERDOWN_0 = 1'b1 ;
    assign LPLL_RST_0  = 1'b1 ;
end
endgenerate
generate if( CH1_LPLL_USE== "TRUE")     begin: CH1_LPLL
ipm2t_hssthp_lpll_rst_fsm_v1_0#(
    .FREE_CLOCK_FREQ    (FREE_CLOCK_FREQ    )
) hpll_rst_fsm_1 (
    .clk                (clk                ),
    .rst_n              (lpll_rstn_1          ),
    .pll_lock           (pll_lock_1           ),
    .LPLL_POWERDOWN     (LPLL_POWERDOWN_1     ),
    .LPLL_RST           (LPLL_RST_1           ),
    .o_lpll_done        (o_lpll_done_1         ) 
);
end
else begin: CH1_NO_LPLL
    //assign o_wtchdg_st_lpll_1 = 2'b00 ;
    assign o_lpll_done_1   = 1'b0 ;
    assign LPLL_POWERDOWN_1 = 1'b1 ;
    assign LPLL_RST_1  = 1'b1 ;
end
endgenerate
generate if( CH2_LPLL_USE== "TRUE")     begin: CH2_LPLL
ipm2t_hssthp_lpll_rst_fsm_v1_0#(
    .FREE_CLOCK_FREQ    (FREE_CLOCK_FREQ    )
) hpll_rst_fsm_2 (
    .clk                (clk                ),
    .rst_n              (lpll_rstn_2          ),
    .pll_lock           (pll_lock_2          ),
    .LPLL_POWERDOWN     (LPLL_POWERDOWN_2     ),
    .LPLL_RST           (LPLL_RST_2           ),
    .o_lpll_done        (o_lpll_done_2         ) 
);
end
else begin: CH2_NO_LPLL
    //assign o_wtchdg_st_lpll_2 = 2'b00 ;
    assign o_lpll_done_2   = 1'b0 ;
    assign LPLL_POWERDOWN_2 = 1'b1 ;
    assign LPLL_RST_2  = 1'b1 ;
end
endgenerate
generate if( CH3_LPLL_USE== "TRUE")     begin: CH3_LPLL
ipm2t_hssthp_lpll_rst_fsm_v1_0#(
    .FREE_CLOCK_FREQ    (FREE_CLOCK_FREQ    )
) hpll_rst_fsm_3 (
    .clk                (clk                ),
    .rst_n              (lpll_rstn_3          ),
    .pll_lock           (pll_lock_3           ),
    .LPLL_POWERDOWN     (LPLL_POWERDOWN_3     ),
    .LPLL_RST           (LPLL_RST_3           ),
    .o_lpll_done        (o_lpll_done_3         ) 
);
end
else begin: CH3_NO_LPLL
    //assign o_wtchdg_st_lpll_3 = 2'b00 ;
    assign o_lpll_done_3   = 1'b0 ;
    assign LPLL_POWERDOWN_3 = 1'b1 ;
    assign LPLL_RST_3  = 1'b1 ;
end
endgenerate

endmodule
