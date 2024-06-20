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
module  ipm2t_hssthp_rst_tx_v1_5#( 
    parameter FREE_CLOCK_FREQ          = 100     , //Unit is MHz, free clock  freq from GUI Freq: 0~200MHz
    parameter CH0_TX_ENABLE            = "TRUE"  , //TRUE:lane0 TX Reset Logic used, FALSE: lane0 TX Reset Logic remove
    parameter CH1_TX_ENABLE            = "TRUE"  , //TRUE:lane1 TX Reset Logic used, FALSE: lane1 TX Reset Logic remove
    parameter CH2_TX_ENABLE            = "TRUE"  , //TRUE:lane2 TX Reset Logic used, FALSE: lane2 TX Reset Logic remove
    parameter CH3_TX_ENABLE            = "TRUE"  , //TRUE:lane3 TX Reset Logic used, FALSE: lane3 TX Reset Logic remove
    parameter CH0_MULT_LANE_MODE       = 1       , //Lane0 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    parameter CH1_MULT_LANE_MODE       = 1       , //Lane1 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    parameter CH2_MULT_LANE_MODE       = 1       , //Lane2 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    parameter CH3_MULT_LANE_MODE       = 1       , //Lane3 --> 1: Singel Lane 2:Two Lane 4:Four Lane
    parameter P_LX_TX_CKDIV_0          = 0       ,
    parameter P_LX_TX_CKDIV_1          = 0       ,
    parameter P_LX_TX_CKDIV_2          = 0       ,
    parameter P_LX_TX_CKDIV_3          = 0       ,
    parameter CH0_TX_PLL_SEL           = "HPLL"  ,//"HPLL": Tx Channel select HPLL "LPLL": Tx Channel select LPLL
    parameter CH1_TX_PLL_SEL           = "HPLL"  ,//"HPLL": Tx Channel select HPLL "LPLL": Tx Channel select LPLL
    parameter CH2_TX_PLL_SEL           = "HPLL"  ,//"HPLL": Tx Channel select HPLL "LPLL": Tx Channel select LPLL
    parameter CH3_TX_PLL_SEL           = "HPLL"  ,//"HPLL": Tx Channel select HPLL "LPLL": Tx Channel select LPLL
    parameter PCS_TX_CLK_EXPLL_USE_CH0 = "FALSE" ,//TRUE: Fabric  PLL USE
    parameter PCS_TX_CLK_EXPLL_USE_CH1 = "FALSE" ,
    parameter PCS_TX_CLK_EXPLL_USE_CH2 = "FALSE" ,
    parameter PCS_TX_CLK_EXPLL_USE_CH3 = "FALSE" 
)(
    //User Side 
    input  wire                   clk                     ,
    input  wire                   i_txlane_rst_0          ,
    input  wire                   i_txlane_rst_1          ,
    input  wire                   i_txlane_rst_2          ,
    input  wire                   i_txlane_rst_3          ,
    input  wire                   i_lpll_done_0           ,
    input  wire                   i_lpll_done_1           ,
    input  wire                   i_lpll_done_2           ,
    input  wire                   i_lpll_done_3           ,
    input  wire                   i_hpll_done             ,
    input  wire                   i_tx_rate_chng_0        ,
    input  wire                   i_tx_rate_chng_1        ,
    input  wire                   i_tx_rate_chng_2        ,
    input  wire                   i_tx_rate_chng_3        ,
    input  wire                   i_pll_lock_tx_0         ,
    input  wire                   i_pll_lock_tx_1         ,
    input  wire                   i_pll_lock_tx_2         ,
    input  wire                   i_pll_lock_tx_3         ,
    input  wire                   i_pll_tx_sel_0          ,
    input  wire                   i_pll_tx_sel_1          ,
    input  wire                   i_pll_tx_sel_2          ,
    input  wire                   i_pll_tx_sel_3          ,
    input  wire    [1 : 0]        i_txckdiv_0             ,
    input  wire    [1 : 0]        i_txckdiv_1             ,
    input  wire    [1 : 0]        i_txckdiv_2             ,
    input  wire    [1 : 0]        i_txckdiv_3             ,
    input  wire                   i_tx_pma_rst_0          ,
    input  wire                   i_tx_pma_rst_1          ,
    input  wire                   i_tx_pma_rst_2          ,
    input  wire                   i_tx_pma_rst_3          ,
    input  wire                   i_tx_pcs_rst_0          ,
    input  wire                   i_tx_pcs_rst_1          ,
    input  wire                   i_tx_pcs_rst_2          ,
    input  wire                   i_tx_pcs_rst_3          ,
    output wire                   o_txlane_done_0         ,
    output wire                   o_txlane_done_1         ,
    output wire                   o_txlane_done_2         ,
    output wire                   o_txlane_done_3         ,
    output wire                   o_txckdiv_done_0        ,
    output wire                   o_txckdiv_done_1        ,
    output wire                   o_txckdiv_done_2        ,
    output wire                   o_txckdiv_done_3        ,
    output wire                   TX_PMA_RST_0            ,
    output wire                   TX_PMA_RST_1            ,
    output wire                   TX_PMA_RST_2            ,
    output wire                   TX_PMA_RST_3            ,
    output wire    [1 : 0]        TX_RATE_0               ,
    output wire    [1 : 0]        TX_RATE_1               ,
    output wire    [1 : 0]        TX_RATE_2               ,
    output wire    [1 : 0]        TX_RATE_3               ,
    output wire                   PCS_TX_RST_0            ,
    output wire                   PCS_TX_RST_1            ,
    output wire                   PCS_TX_RST_2            ,
    output wire                   PCS_TX_RST_3            ,
    output wire                   TX_LANE_POWERDOWN_0     ,
    output wire                   TX_LANE_POWERDOWN_1     ,
    output wire                   TX_LANE_POWERDOWN_2     ,
    output wire                   TX_LANE_POWERDOWN_3     ,
    output wire                   lane_sync_0             ,
    output wire                   lane_sync_1             ,
    output wire                   lane_sync_2             ,
    output wire                   lane_sync_3             ,
    output wire                   rate_change_on_0        ,
    output wire                   rate_change_on_1        ,
    output wire                   rate_change_on_2        ,
    output wire                   rate_change_on_3        
);
localparam PLL_LOCK_RISE_CNTR_WIDTH    = 12  ;
`ifdef IPM2T_HSST_SPEEDUP_SIM
localparam PLL_LOCK_RISE_CNTR_VALUE    = 20;
`else
localparam PLL_LOCK_RISE_CNTR_VALUE    = 2048;
`endif

//****************************************************************************//
//                      Internal Signal                                       //
//****************************************************************************//
wire [3:0]        i_txlane_rstn;
wire [3:0]        i_tx_pma_rst ;
wire [3:0]        i_tx_pcs_rst ;
wire [3:0]        i_pll_lock_tx;
wire [3:0]        s_txlane_rstn;
wire [3:0]        s_pll_lock_tx;
wire [3:0]        s_pll_lock_tx_deb;
wire [3:0]        i_tx_rate_chng;
wire [3:0]        s_tx_rate_chng;
wire [3:0]        l_tx_lane_rstn;
wire              pll_ready_0   ;
wire              pll_ready_1   ;
wire              pll_ready_2   ;
wire              pll_ready_3   ;
wire [3:0]        pll_ready     ;
wire [3:0]        o_tx_pma_rst ;
wire [3:0]        p_tx_pma_rst ;
wire [7:0]        o_tx_rate ;
wire [7:0]        p_tx_rate ;
wire [3:0]        o_lane_poewrdown ;
wire [3:0]        p_lane_poewrdown ;
wire [3:0]        o_txlane_done ;
wire [3:0]        p_txlane_done ;
wire [3:0]        o_lane_sync ;
wire [3:0]        p_lane_sync ;
wire [3:0]        o_rate_change_on ;
wire [3:0]        p_rate_change_on ;
wire [3:0]        o_txckdiv_done ;
wire [3:0]        p_txckdiv_done ;
wire [3:0]        o_pcs_tx_rst   ;
wire [7:0]        l_txckdiv      ;
wire [3:0]        l_pll_lock_tx_deb;
wire [3:0]        p_pcs_tx_rst;
wire [3:0]        p_tx_lane_powerdown;

//****************************************************************************//
//                      Sequential and Logic                                  //
//****************************************************************************//
assign pll_ready_0 = i_pll_tx_sel_0 ? i_lpll_done_0 : i_hpll_done ;
assign pll_ready_1 = i_pll_tx_sel_1 ? i_lpll_done_1 : i_hpll_done ;
assign pll_ready_2 = i_pll_tx_sel_2 ? i_lpll_done_2 : i_hpll_done ;
assign pll_ready_3 = i_pll_tx_sel_3 ? i_lpll_done_3 : i_hpll_done ;
assign pll_ready={pll_ready_3,pll_ready_2,pll_ready_1,pll_ready_0};
assign i_txlane_rstn = {~i_txlane_rst_3,~i_txlane_rst_2,~i_txlane_rst_1,~i_txlane_rst_0};
assign i_pll_lock_tx = {i_pll_lock_tx_3,i_pll_lock_tx_2,i_pll_lock_tx_1,i_pll_lock_tx_0};
//Sync  signal and Debounce signal
genvar i;
generate
for(i=0; i<4; i=i+1) begin:SYNC_TXLANE
    ipm2t_hssthp_rst_sync_v1_0 txlane_rstn_sync (.clk(clk), .rst_n(i_txlane_rstn[i]), .sig_async(1'b1), .sig_synced(s_txlane_rstn[i]));
    ipm2t_hssthp_rst_sync_v1_0 tx_rate_chng_sync (.clk(clk), .rst_n(s_txlane_rstn[i]), .sig_async(1'b1), .sig_synced(s_tx_rate_chng[i]));
    ipm2t_hssthp_rst_sync_v1_0 i_pll_lock_rstn_sync (.clk(clk), .rst_n(s_txlane_rstn[i]), .sig_async(i_pll_lock_tx[i]), .sig_synced(s_pll_lock_tx[i]));
    ipm2t_hssthp_rst_debounce_v1_0  #(.RISE_CNTR_WIDTH(PLL_LOCK_RISE_CNTR_WIDTH), .RISE_CNTR_VALUE(PLL_LOCK_RISE_CNTR_VALUE))
pll_lock_deb             (.clk(clk), .rst_n(l_tx_lane_rstn[i]), .signal_b(s_pll_lock_tx[i]), .signal_deb(s_pll_lock_tx_deb[i]));
end
endgenerate
generate
if(CH0_MULT_LANE_MODE==4) begin:FOUR_LANE_MODE
    //From USER
    assign l_tx_lane_rstn         = {3'b0,pll_ready[0] & s_txlane_rstn[0]}; //From lane0 control signal
    assign i_tx_rate_chng         = {3'b0,i_tx_rate_chng_0};
    assign l_txckdiv              = {6'b0,i_txckdiv_0};
    assign l_pll_lock_tx_deb      = {3'b0,s_pll_lock_tx_deb[0]};
    assign i_tx_pma_rst           = {3'b0,i_tx_pma_rst_0};
    assign i_tx_pcs_rst           = {3'b0,i_tx_pcs_rst_0};
    //To HSST         
    assign p_tx_pma_rst           = {4{o_tx_pma_rst        [0]}};           
    assign p_lane_sync            = {4{o_lane_sync              [0]}};        
    assign p_rate_change_on       = {4{o_rate_change_on         [0]}};        
    assign p_tx_rate              = {4{o_tx_rate             [1:0]}};
    assign p_pcs_tx_rst           = {4{o_pcs_tx_rst             [0]}};
    assign p_txlane_done          = {4{o_txlane_done            [0]}};
    assign p_txckdiv_done         = {4{o_txckdiv_done           [0]}};
    assign p_tx_lane_powerdown    = {4{o_lane_poewrdown         [0]}};
end
else if(CH0_MULT_LANE_MODE==2 && CH2_MULT_LANE_MODE==2) begin: TWO_LANE_MODE
   //From USER
    assign l_tx_lane_rstn         = {1'b0,pll_ready[2] & s_txlane_rstn[2],1'b0,pll_ready[0] & s_txlane_rstn[0]};
    assign i_tx_rate_chng         = {1'b0,i_tx_rate_chng_2,1'b0,i_tx_rate_chng_0};
    assign l_txckdiv              = {3'b0,i_txckdiv_2,3'b0,i_txckdiv_0};
    assign l_pll_lock_tx_deb      = {1'b0,s_pll_lock_tx_deb[2],1'b0,s_pll_lock_tx_deb[0]};
    assign i_tx_pma_rst           = {1'b0,i_tx_pma_rst_2,1'b0,i_tx_pma_rst_0};
    assign i_tx_pcs_rst           = {1'b0,i_tx_pcs_rst_2,1'b0,i_tx_pcs_rst_0};
    //To HSST                    
    assign p_lane_sync            = {{2{o_lane_sync              [2]}},{2{o_lane_sync              [0]}}};        
    assign p_rate_change_on       = {{2{o_rate_change_on         [2]}},{2{o_rate_change_on         [0]}}};        
    assign p_tx_rate              = {{2{o_tx_rate             [5:4]}},{2{o_tx_rate             [1:0]}}};
    assign p_tx_pma_rst           = {{2{o_tx_pma_rst             [2]}},{2{o_tx_pma_rst             [0]}}};
    assign p_pcs_tx_rst           = {{2{o_pcs_tx_rst             [2]}},{2{o_pcs_tx_rst             [0]}}};
    assign p_txlane_done          = {{2{o_txlane_done            [2]}},{2{o_txlane_done            [0]}}};
    assign p_txckdiv_done         = {{2{o_txckdiv_done           [2]}},{2{o_txckdiv_done           [0]}}};
    assign p_tx_lane_powerdown    = {{2{o_lane_poewrdown         [2]}},{2{o_lane_poewrdown         [0]}}};
end
else if(CH0_MULT_LANE_MODE==2) begin:TWO_LANE_MODE0
    //From USER
    assign l_tx_lane_rstn         = {pll_ready[3] & s_txlane_rstn[3],pll_ready[2] & s_txlane_rstn[2],1'b0,pll_ready[0] & s_txlane_rstn[0]};
    assign i_tx_rate_chng         = {i_tx_rate_chng_3,i_tx_rate_chng_2,1'b0,i_tx_rate_chng_0};
    assign l_txckdiv              = {i_txckdiv_3,i_txckdiv_2,3'b0,i_txckdiv_0};
    assign l_pll_lock_tx_deb      = {s_pll_lock_tx_deb[3],s_pll_lock_tx_deb[2],1'b0,s_pll_lock_tx_deb[0]};
    assign i_tx_pma_rst           = {i_tx_pma_rst_3,i_tx_pma_rst_2,1'b0,i_tx_pma_rst_0};
    assign i_tx_pcs_rst           = {i_tx_pcs_rst_3,i_tx_pcs_rst_2,1'b0,i_tx_pcs_rst_0};
    //To HSST                   
    assign p_lane_sync            = {o_lane_sync              [3],o_lane_sync              [2],{2{o_lane_sync              [0]}}};        
    assign p_rate_change_on       = {o_rate_change_on         [3],o_rate_change_on         [2],{2{o_rate_change_on         [0]}}};        
    assign p_tx_rate              = {o_tx_rate             [7:6],o_tx_rate             [5:4],{2{o_tx_rate             [1:0]}}};
    assign p_tx_pma_rst           = {o_tx_pma_rst             [3],o_tx_pma_rst             [2],{2{o_tx_pma_rst             [0]}}};
    assign p_pcs_tx_rst           = {o_pcs_tx_rst             [3],o_pcs_tx_rst             [2],{2{o_pcs_tx_rst             [0]}}};
    assign p_txlane_done          = {o_txlane_done            [3],o_txlane_done            [2],{2{o_txlane_done            [0]}}};
    assign p_txckdiv_done         = {o_txckdiv_done           [3],o_txckdiv_done           [2],{2{o_txckdiv_done           [0]}}};
    assign p_tx_lane_powerdown    = {o_lane_poewrdown         [3],o_lane_poewrdown         [2],{2{o_lane_poewrdown         [0]}}};
end
else if(CH2_MULT_LANE_MODE==2) begin:TWO_LANE_MODE1
    //From USER
    assign l_tx_lane_rstn         = {1'b0,pll_ready[2] & s_txlane_rstn[2],pll_ready[1] & s_txlane_rstn[1],pll_ready[0] & s_txlane_rstn[0]};
    assign i_tx_rate_chng         = {1'b0,i_tx_rate_chng_2,i_tx_rate_chng_1,i_tx_rate_chng_0};
    assign l_txckdiv              = {3'b0,i_txckdiv_2,i_txckdiv_1,i_txckdiv_0};
    assign l_pll_lock_tx_deb      = {1'b0,s_pll_lock_tx_deb[2],s_pll_lock_tx_deb[1],s_pll_lock_tx_deb[0]};
    assign i_tx_pma_rst           = {1'b0,i_tx_pma_rst_2,i_tx_pma_rst_1,i_tx_pma_rst_0};
    assign i_tx_pcs_rst           = {1'b0,i_tx_pcs_rst_2,i_tx_pcs_rst_1,i_tx_pcs_rst_0};
    //To HSST                    
    assign p_lane_sync            = {{2{o_lane_sync              [2]}},o_lane_sync              [1],o_lane_sync              [0]};        
    assign p_rate_change_on       = {{2{o_rate_change_on         [2]}},o_rate_change_on         [1],o_rate_change_on         [0]};        
    assign p_tx_rate              = {{2{o_tx_rate             [7:6]}},o_tx_rate             [5:4],o_tx_rate             [1:0]};
    assign p_tx_pma_rst           = {{2{o_tx_pma_rst             [2]}},o_tx_pma_rst             [1],o_tx_pma_rst             [0]};
    assign p_pcs_tx_rst           = {{2{o_pcs_tx_rst             [2]}},o_pcs_tx_rst             [1],o_pcs_tx_rst             [0]};
    assign p_txlane_done          = {{2{o_txlane_done            [2]}},o_txlane_done            [1],o_txlane_done            [0]};
    assign p_txckdiv_done         = {{2{o_txckdiv_done           [2]}},o_txckdiv_done           [1],o_txckdiv_done           [0]};
end
else begin:ONE_LANE_MODE
    //From USER
    assign l_tx_lane_rstn         = {pll_ready[3] & s_txlane_rstn[3],pll_ready[2] & s_txlane_rstn[2],pll_ready[1] & s_txlane_rstn[1],pll_ready[0] & s_txlane_rstn[0]};
    assign i_tx_rate_chng         = {i_tx_rate_chng_3,i_tx_rate_chng_2,i_tx_rate_chng_1,i_tx_rate_chng_0};
    assign l_txckdiv              = {i_txckdiv_3,i_txckdiv_2,i_txckdiv_1,i_txckdiv_0};
    assign l_pll_lock_tx_deb      = {s_pll_lock_tx_deb[3],s_pll_lock_tx_deb[2],s_pll_lock_tx_deb[1],s_pll_lock_tx_deb[0]};
    assign i_tx_pma_rst           = {i_tx_pma_rst_3,i_tx_pma_rst_2,i_tx_pma_rst_1,i_tx_pma_rst_0};
    assign i_tx_pcs_rst           = {i_tx_pcs_rst_3,i_tx_pcs_rst_2,i_tx_pcs_rst_1,i_tx_pcs_rst_0};
    //To HSST                    
    assign p_lane_sync            = {o_lane_sync              [3],o_lane_sync              [2],o_lane_sync              [1],o_lane_sync              [0]};        
    assign p_rate_change_on       = {o_rate_change_on         [3],o_rate_change_on         [2],o_rate_change_on         [1],o_rate_change_on         [0]};        
    assign p_tx_rate              = {o_tx_rate             [7:6],o_tx_rate             [5:4],o_tx_rate             [3:2],o_tx_rate             [1:0]};
    assign p_tx_pma_rst           = {o_tx_pma_rst             [3],o_tx_pma_rst             [2],o_tx_pma_rst             [1],o_tx_pma_rst             [0]};
    assign p_pcs_tx_rst           = {o_pcs_tx_rst             [3],o_pcs_tx_rst             [2],o_pcs_tx_rst             [1],o_pcs_tx_rst             [0]};
    assign p_txlane_done          = {o_txlane_done            [3],o_txlane_done            [2],o_txlane_done            [1],o_txlane_done            [0]};
    assign p_txckdiv_done         = {o_txckdiv_done           [3],o_txckdiv_done           [2],o_txckdiv_done           [1],o_txckdiv_done           [0]};
    assign p_tx_lane_powerdown         = {o_lane_poewrdown           [3],o_lane_poewrdown           [2],o_lane_poewrdown           [1],o_lane_poewrdown           [0]};
end
endgenerate

//-----  Instance Txlane Rst Fsm Module -----------
//Lane0
generate
if(CH0_TX_ENABLE=="TRUE") begin : TXLANE0_ENABLE //Lane is Enable
        ipm2t_hssthp_txlane_rst_fsm_v1_5#(
            .FREE_CLOCK_FREQ          (FREE_CLOCK_FREQ                ),
            .P_LX_TX_CKDIV            (P_LX_TX_CKDIV_0                ),
            .PCS_TX_CLK_EXPLL_USE_CH  (PCS_TX_CLK_EXPLL_USE_CH0       ),
            .CH_MULT_LANE_MODE        (CH0_MULT_LANE_MODE             )
        ) txlane_rst_fsm0 (
            .clk                    (clk                            ),
            .rst_n                  (l_tx_lane_rstn       [0      ] ),
            .i_tx_rate_chng         (i_tx_rate_chng       [0      ] ),
            .i_txckdiv              (l_txckdiv            [0*2 +:2] ),
            .i_pll_lock_tx          (l_pll_lock_tx_deb    [0      ] ),
            .i_tx_pma_rst           (i_tx_pma_rst         [0      ] ),
            .i_tx_pcs_rst           (i_tx_pcs_rst         [0      ] ),
            .TX_PMA_RST             (o_tx_pma_rst         [0      ] ),
            .TX_RATE                (o_tx_rate            [0*2 +:2] ),
            .TX_LANE_POWERDOWN      (o_lane_poewrdown     [0      ] ), 
            .o_txlane_done          (o_txlane_done        [0      ] ),
            .lane_sync              (o_lane_sync          [0      ] ), 
            .rate_change_on         (o_rate_change_on     [0      ] ),
            .o_txckdiv_done         (o_txckdiv_done       [0      ] ),
            .PCS_TX_RST             (o_pcs_tx_rst         [0      ] )
        );
end
else begin : TXLANE0_DISABLE //Lane is disable
    assign o_tx_pma_rst        [0]          = 1'b1;
    assign o_tx_rate           [0*2 +:2]    = 2'b00;
    assign o_lane_poewrdown    [0]         = 1'b1;
    assign o_txlane_done       [0]         = 1'b0;
    assign o_lane_sync         [0]         = 1'b0;
    assign o_rate_change_on    [0]         = 1'b1;
    assign o_txckdiv_done      [0]         = 1'b0;
    assign o_pcs_tx_rst        [0]         = 1'b1;
end
endgenerate

//Lane1
generate
if((CH1_TX_ENABLE=="TRUE") && (CH1_MULT_LANE_MODE   == 1)) begin : TXLANE1_ENABLE //Lane is Enable and no bonding
        ipm2t_hssthp_txlane_rst_fsm_v1_5#(
            .FREE_CLOCK_FREQ          (FREE_CLOCK_FREQ                ),
            .P_LX_TX_CKDIV            (P_LX_TX_CKDIV_1                ),
            .PCS_TX_CLK_EXPLL_USE_CH  (PCS_TX_CLK_EXPLL_USE_CH1       ),
            .CH_MULT_LANE_MODE        (CH1_MULT_LANE_MODE             )
        ) txlane_rst_fsm1 (
            .clk                    (clk                            ),
            .rst_n                  (l_tx_lane_rstn       [1      ] ),
            .i_tx_rate_chng         (i_tx_rate_chng       [1      ] ),
            .i_txckdiv              (l_txckdiv            [1*2 +:2] ),
            .i_pll_lock_tx          (l_pll_lock_tx_deb    [1      ] ),
            .i_tx_pma_rst           (i_tx_pma_rst         [1      ] ),
            .i_tx_pcs_rst           (i_tx_pcs_rst         [1      ] ),
            .TX_PMA_RST             (o_tx_pma_rst         [1      ] ),
            .TX_RATE                (o_tx_rate            [1*2 +:2] ),
            .TX_LANE_POWERDOWN      (o_lane_poewrdown     [1      ] ), 
            .o_txlane_done          (o_txlane_done        [1      ] ),
            .lane_sync              (o_lane_sync          [1      ] ), 
            .rate_change_on         (o_rate_change_on     [1      ] ),
            .o_txckdiv_done         (o_txckdiv_done       [1      ] ),
            .PCS_TX_RST           (o_pcs_tx_rst         [1      ] )
        );
end
else begin : TXLANE1_DISABLE //Lane is disable
    assign o_tx_pma_rst        [1]          = 1'b1;
    assign o_tx_rate           [1*2 +:2]    = 2'b00;
    assign o_lane_poewrdown    [1]         = 1'b1;
    assign o_txlane_done       [1]         = 1'b0;
    assign o_lane_sync         [1]         = 1'b0;
    assign o_rate_change_on    [1]         = 1'b1;
    assign o_txckdiv_done      [1]         = 1'b0;
    assign o_pcs_tx_rst        [1]         = 1'b1;
end
endgenerate

//Lane2
generate
if((CH2_TX_ENABLE=="TRUE") && (CH0_MULT_LANE_MODE  != 4 )) begin : TXLANE2_ENABLE //Lane is Enable and no 4LANE bonding
        ipm2t_hssthp_txlane_rst_fsm_v1_5#(
            .FREE_CLOCK_FREQ          (FREE_CLOCK_FREQ                ),
            .P_LX_TX_CKDIV            (P_LX_TX_CKDIV_2                ),
            .PCS_TX_CLK_EXPLL_USE_CH  (PCS_TX_CLK_EXPLL_USE_CH2       ),
            .CH_MULT_LANE_MODE        (CH2_MULT_LANE_MODE             )
        ) txlane_rst_fsm2 (
            .clk                    (clk                            ),
            .rst_n                  (l_tx_lane_rstn       [2      ] ),
            .i_tx_rate_chng         (i_tx_rate_chng       [2      ] ),
            .i_txckdiv              (l_txckdiv            [2*2 +:2] ),
            .i_pll_lock_tx          (l_pll_lock_tx_deb    [2      ] ),
            .i_tx_pma_rst           (i_tx_pma_rst         [2      ] ),
            .i_tx_pcs_rst           (i_tx_pcs_rst         [2      ] ),
            .TX_PMA_RST             (o_tx_pma_rst         [2      ] ),
            .TX_RATE                (o_tx_rate            [2*2 +:2] ),
            .TX_LANE_POWERDOWN      (o_lane_poewrdown     [2      ] ), 
            .o_txlane_done          (o_txlane_done        [2      ] ),
            .lane_sync              (o_lane_sync          [2      ] ), 
            .rate_change_on         (o_rate_change_on     [2      ] ),
            .o_txckdiv_done         (o_txckdiv_done       [2      ] ),
            .PCS_TX_RST           (o_pcs_tx_rst         [2      ] )
        );
end
else begin : TXLANE2_DISABLE //Lane is disable
    assign o_tx_pma_rst        [2]          = 1'b1;
    assign o_tx_rate           [2*2 +:2]    = 2'b00;
    assign o_lane_poewrdown    [2]         = 1'b1;
    assign o_txlane_done       [2]         = 1'b0;
    assign o_lane_sync         [2]         = 1'b0;
    assign o_rate_change_on    [2]         = 1'b1;
    assign o_txckdiv_done      [2]         = 1'b0;
    assign o_pcs_tx_rst        [2]         = 1'b1;
end
endgenerate

//Lane3
generate
if((CH3_TX_ENABLE=="TRUE") && (CH3_MULT_LANE_MODE   == 1)) begin : TXLANE3_ENABLE //Lane is Enable and no bonding
    ipm2t_hssthp_txlane_rst_fsm_v1_5#(
            .FREE_CLOCK_FREQ          (FREE_CLOCK_FREQ                ),
            .P_LX_TX_CKDIV            (P_LX_TX_CKDIV_3                ),
            .PCS_TX_CLK_EXPLL_USE_CH  (PCS_TX_CLK_EXPLL_USE_CH3       ),
            .CH_MULT_LANE_MODE        (CH3_MULT_LANE_MODE             )
        ) txlane_rst_fsm3 (
            .clk                    (clk                            ),
            .rst_n                  (l_tx_lane_rstn       [3      ] ),
            .i_tx_rate_chng         (i_tx_rate_chng       [3      ] ),
            .i_txckdiv              (l_txckdiv            [3*2 +:2] ),
            .i_pll_lock_tx          (l_pll_lock_tx_deb    [3      ] ),
            .i_tx_pma_rst           (i_tx_pma_rst         [3      ] ),
            .i_tx_pcs_rst           (i_tx_pcs_rst         [3      ] ),
            .TX_PMA_RST             (o_tx_pma_rst         [3      ] ),
            .TX_RATE                (o_tx_rate            [3*2 +:2] ),
            .TX_LANE_POWERDOWN      (o_lane_poewrdown     [3      ] ), 
            .o_txlane_done          (o_txlane_done        [3      ] ),
            .lane_sync              (o_lane_sync          [3      ] ), 
            .rate_change_on         (o_rate_change_on     [3      ] ),
            .o_txckdiv_done         (o_txckdiv_done       [3      ] ),
            .PCS_TX_RST           (o_pcs_tx_rst         [3      ] )
        );
end
else begin : TXLANE3_DISABLE //Lane is disable
    assign o_tx_pma_rst        [3]          = 1'b1;
    assign o_tx_rate           [3*2 +:2]    = 2'b00;
    assign o_lane_poewrdown    [3]         = 1'b1;
    assign o_txlane_done       [3]         = 1'b0;
    assign o_lane_sync         [3]         = 1'b0;
    assign o_rate_change_on    [3]         = 1'b1;
    assign o_txckdiv_done      [3]         = 1'b0;
    assign o_pcs_tx_rst        [3]         = 1'b1;
end
endgenerate

assign o_txlane_done_0        = p_txlane_done[0];
assign o_txlane_done_1        = p_txlane_done[1];
assign o_txlane_done_2        = p_txlane_done[2];
assign o_txlane_done_3        = p_txlane_done[3];
assign o_txckdiv_done_0       = p_txckdiv_done[0];
assign o_txckdiv_done_1       = p_txckdiv_done[1];
assign o_txckdiv_done_2       = p_txckdiv_done[2];
assign o_txckdiv_done_3       = p_txckdiv_done[3];
assign TX_PMA_RST_0    = p_tx_pma_rst[0];
assign TX_PMA_RST_1    = p_tx_pma_rst[1];
assign TX_PMA_RST_2    = p_tx_pma_rst[2];
assign TX_PMA_RST_3    = p_tx_pma_rst[3];
assign TX_RATE_0            = p_tx_rate[1:0];
assign TX_RATE_1            = p_tx_rate[3:2];
assign TX_RATE_2            = p_tx_rate[5:4];
assign TX_RATE_3            = p_tx_rate[7:6];
assign PCS_TX_RST_0         = p_pcs_tx_rst[0];
assign PCS_TX_RST_1         = p_pcs_tx_rst[1];
assign PCS_TX_RST_2         = p_pcs_tx_rst[2];
assign PCS_TX_RST_3         = p_pcs_tx_rst[3];
assign TX_LANE_POWERDOWN_0         = p_tx_lane_powerdown[0];
assign TX_LANE_POWERDOWN_1         = p_tx_lane_powerdown[1];
assign TX_LANE_POWERDOWN_2         = p_tx_lane_powerdown[2];
assign TX_LANE_POWERDOWN_3         = p_tx_lane_powerdown[3];
assign lane_sync_0         = p_lane_sync[0];
assign lane_sync_1         = p_lane_sync[1];
assign lane_sync_2         = p_lane_sync[2];
assign lane_sync_3         = p_lane_sync[3];
assign rate_change_on_0         = p_rate_change_on[0];
assign rate_change_on_1         = p_rate_change_on[1];
assign rate_change_on_2         = p_rate_change_on[2];
assign rate_change_on_3         = p_rate_change_on[3];

endmodule
