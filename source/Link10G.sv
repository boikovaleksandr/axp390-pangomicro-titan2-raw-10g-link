module Link10G(
input i_clk_50_mhz,
input sys_rst,
input i_p_refckn_0,
input i_p_refckp_0,

input i_p_l0rxn,                               
input i_p_l0rxp,
output o_p_l0txn,
output o_p_l0txp,

input  [23:0]      apb_paddr,
input              apb_psel,
input              apb_penable,
input              apb_pwrite,
input  [31:0]      apb_pwdata,
output             apb_pready,
output  [31:0]     apb_prdata,
output             o_usclk,
output             xgmii_tx_ready,



output      [63:0]      xge_rx_data                           ,
output                  xge_rx_data_en                        ,
output                  xge_rx_data_sop                       ,
output                  xge_rx_data_eop                       ,
output      [ 2:0]      xge_rx_data_byte_vaild                ,
output                  xge_rx_data_err                       ,

input  [63:0]     xge_tx_data                 ,
input             xge_tx_data_en              ,
input             xge_tx_data_sop             ,
input             xge_tx_data_eop             ,
input  [2:0]      xge_tx_data_byte_vaild      ,          
input             o_syn_align
);



wire i_free_clk /* synthesis PAP_MARK_DEBUG = "1" */;



wire              usclk;
wire   [63:0]     xgmii_rxd /* synthesis PAP_MARK_DEBUG = "1" */;
wire   [7:0]      xgmii_rxc /* synthesis PAP_MARK_DEBUG = "1" */;
wire   [63:0]     xgmii_txd /* synthesis PAP_MARK_DEBUG = "1" */;
wire   [7:0]      xgmii_txc /* synthesis PAP_MARK_DEBUG = "1" */;
wire              txlane_done ;
wire              rxlane_done ; //+


wire              mac_pwrite;
wire              mac_psel;
wire              mac_penable;
wire  [18:0]      mac_paddr;
wire  [31:0]      mac_pwdata;
wire  [31:0]      mac_prdata;

wire              pcs_pwrite;
wire              pcs_penable;
wire              pcs_psel;    
wire              pcs_pready;  
wire  [18:0]      pcs_paddr;
wire  [31:0]      pcs_pwdata; 
wire  [31:0]      pcs_prdata;
     
wire          core_pwrite                   ;
wire          core_psel                     ;
wire          core_penable                  ;
wire  [15:0]  core_paddr                    ;
wire  [31:0]  core_pwdata                   ;
wire  [31:0]  core_prdata                   ;

wire          hsst_pwrite                   ;
wire          hsst_penable                  ;
wire          hsst_psel                     ;
wire          hsst_pready                   ;
wire  [15:0]  hsst_paddr                    ;
wire  [31:0]  hsst_pwdata                   ;
wire  [31:0]  hsst_prdata                   ;

wire    slow_rst_done;    
wire    hsst_pint; 
wire    syn_align /* synthesis PAP_MARK_DEBUG = "1" */;
wire    o_p_rx_sigdet_sta_0 /* synthesis PAP_MARK_DEBUG = "1" */;
wire    o_p_lx_cdr_align_0 /* synthesis PAP_MARK_DEBUG = "1" */;
wire    [63:0] tx_data_group_0 /* synthesis PAP_MARK_DEBUG = "1" */;
wire    [6:0] tx_data_seq_0 /* synthesis PAP_MARK_DEBUG = "1" */;
wire    [1:0] tx_data_h_0 /* synthesis PAP_MARK_DEBUG = "1" */;
wire    [5:0] o_rxstatus_0 /* synthesis PAP_MARK_DEBUG = "1" */;
wire    [63:0] rx_data_group_0 /* synthesis PAP_MARK_DEBUG = "1" */;
wire    [1:0] rx_data_h_0 /* synthesis PAP_MARK_DEBUG = "1" */;
wire    rx_data_vld_0 /* synthesis PAP_MARK_DEBUG = "1" */;
wire    o_rxq_start_0 /* synthesis PAP_MARK_DEBUG = "1" */;

wire    [7:0] pfc_pause_stop /* synthesis PAP_MARK_DEBUG = "1" */;
wire    txclk;
wire    rxclk;
wire    cfg_pma_reset;
wire    cfg_pcs_reset;
wire    hsst_rst_done;
wire    rx_data_slip_0;
wire    o_p_clk2core_tx_0;
wire    o_p_clk2core_rx_0;
wire    o_p_refck2core_0;
wire    o_p_calib_done;
wire    cfg_pcs_loopback_0;
wire    cfg_pma_loopback_0;
wire    hsst_txlane_done_0 /* synthesis PAP_MARK_DEBUG = "1" */;
wire    hsst_rxlane_done_0 /* synthesis PAP_MARK_DEBUG = "1" */;

//------------- user configuration ------------------------
//-------- user config base : pin_cfg_en=1'b1 -------------
//   open tx prbs prbs_tx_en=1'b1                         -
//   open rx prbs prbs_rx_en=1'b1                         -
//   prbs-9: prbs_mode=4'd1      prbs-31: prbs_mode=4'd2  -
//   Base-R core loopback : core_loopback=1'b1            -
//   Base-R + HSSTHP loopback : pma_loopback=1'b1         -
//---------------------------------------------------------
assign pin_cfg_en    = 1'b0 ;
assign prbs_rx_en    = 1'b0 ;
assign prbs_tx_en    = 1'b0 ;
assign prbs_mode     = 4'd0 ;
assign core_loopback = 1'b0 ;
assign pma_loopback  = 1'b0 ;



//-------------- HSSTHP LOOPBACK --------------------------
assign i_loop_dbg_0                   = 3'b000   ;
// normal           :     i_loop_dbg_0= 3'b000   ;
// pma_farend_ploop :     i_loop_dbg_0= 3'b000   ;
// pma_nearend_ploop:     i_loop_dbg_0= 3'b011   ;
// pma_nearend_sloop:     i_loop_dbg_0= 3'b000   ;
// pcs_farend_loop  :     i_loop_dbg_0= 3'b011   ;
// pcs_nearend_loop :     i_loop_dbg_0= 3'b011   ;
assign i_p_pcs_nearend_loop_0         = 1'b0     ;
assign i_p_pcs_farend_loop_0          = 1'b0     ;
assign i_p_pma_nearend_ploop_0        = 1'b0     ;
assign i_p_pma_nearend_sloop_0        = 1'b0     ;
assign i_p_pma_farend_ploop_0         = 1'b0     ;
//---------------------------------------------------------

logic hsst_loop_dbg_0;

//assign hsst_loop_dbg_0 = 3'b000;
//assign p_pma_nearend_ploop = 1'b0;
assign  hsst_loop_dbg_0 = (cfg_pcs_loopback_0) ? 3'b111 : (cfg_pma_loopback_0) ? 3'b011 : i_loop_dbg_0  ;
assign  p_pma_nearend_ploop = (cfg_pma_loopback_0) ? 1'b1 : i_p_pma_nearend_ploop_0 ;

assign i_free_clk = i_clk_50_mhz;
assign o_usclk = usclk;
assign o_syn_align = syn_align;

reg_union_bridge_top Reg_bridge
(
.apb_clk                               (i_free_clk),      
.apb_rst_n                             (~sys_rst),    

.apb_psel                              (apb_psel),       
.apb_penable                           (apb_penable), 
.apb_pwrite                            (apb_pwrite),   
.apb_pready                            (apb_pready),  
.apb_paddr                             (apb_paddr[18:0]),     
.apb_pwdata                            (apb_pwdata),   
.apb_prdata                            (apb_prdata),  

.mac_pwrite                            (mac_pwrite),   
.mac_psel                              (mac_psel),       
.mac_penable                           (mac_penable), 
.mac_paddr                             (mac_paddr),     
.mac_pwdata                            (mac_pwdata),   
.mac_prdata                            (mac_prdata),   

.pcs_pwrite                            (pcs_pwrite),   
.pcs_penable                           (pcs_penable), 
.pcs_psel                              (pcs_psel),       
.pcs_pready                            (pcs_pready),    
.pcs_paddr                             (pcs_paddr),     
.pcs_pwdata                            (pcs_pwdata),   
.pcs_prdata                            (pcs_prdata)    
);


pgr_reg_union_v1_0  RegCONFIG
    (
    .apb_clk        (i_free_clk   ),//+
    .apb_rst        (slow_rst_done),//+

    .apb_psel       (pcs_psel     ),//+  
    .apb_penable    (pcs_penable  ),//+  
    .apb_pwrite     (pcs_pwrite   ),//+  
    .apb_pready     (pcs_pready   ),//+  
    .apb_paddr      (pcs_paddr    ),//+  
    .apb_pwdata     (pcs_pwdata   ),//+  
    .apb_prdata     (pcs_prdata   ),//+  

    .core_pwrite    (core_pwrite  ),//+    
    .core_psel      (core_psel    ),//+ 
    .core_penable   (core_penable ),//+ 
    .core_paddr     (core_paddr   ),//+ 
    .core_pwdata    (core_pwdata  ),//+ 
    .core_prdata    (core_prdata  ),//+ 

    .hsst_pwrite    (hsst_pwrite  ),   
    .hsst_penable   (hsst_penable ),   
    .hsst_psel      (hsst_psel    ),   
    .hsst_pready    (hsst_pready  ),   
    .hsst_paddr     (hsst_paddr   ),   
    .hsst_pwdata    (hsst_pwdata  ),   
    .hsst_prdata    (hsst_prdata  )    
    );





pgr_rst_debounce_v1_0 rst_debounce_inst 
    (
    .clk       (i_free_clk),           
    .rst_n     (~sys_rst  ),           
    .signal_b  (1'b1      ),           
    .signal_deb(slow_rst_done)            
    );

pgr_rst_syn_v1_0 pcs_tx_rst_inst
    (
    .clk     (txclk          ),      
    .rst     (hsst_txlane_done_0),      
    .cfg_rst (cfg_pcs_reset  ),      
    .rst_done(txlane_done    )       //+
    );

pgr_rst_syn_v1_0 pcs_rx_rst_inst
    (
    .clk     (rxclk          ),      
    .rst     (hsst_rxlane_done_0),      
    .cfg_rst (cfg_pcs_reset  ),      
    .rst_done(rxlane_done    )       //+
    );

pgr_rst_syn_v1_0 pma_hsst_rst_inst
    (
    .clk     (i_free_clk   ),        
    .rst     (slow_rst_done   ),        
    .cfg_rst (cfg_pma_reset),        
    .rst_done(hsst_rst_done    )         
    );

MAC_Link MAC_10G ( 
.xgmii_clk                             (usclk                 ),    //+
.sys_rst                               (sys_rst               ),
.xgmii_rxd                             (xgmii_rxd             ),
.xgmii_rxc                             (xgmii_rxc             ),
.xgmii_txd                             (xgmii_txd             ),
.xgmii_txc                             (xgmii_txc             ),
.xge_tx_rst                            (~txlane_done          ),
.xge_tx_data                           (xge_tx_data           ),
.xge_tx_data_en                        (xge_tx_data_en        ),
.xge_tx_data_sop                       (xge_tx_data_sop       ),
.xge_tx_data_eop                       (xge_tx_data_eop       ),
.xge_tx_data_byte_vaild                (xge_tx_data_byte_vaild),
.xgmii_tx_ready                        (xgmii_tx_ready        ),
.xge_rx_rst                            (~rxlane_done          ),// +
.xge_rx_data                           (xge_rx_data           ),
.xge_rx_data_en                        (xge_rx_data_en        ),
.xge_rx_data_sop                       (xge_rx_data_sop       ),
.xge_rx_data_eop                       (xge_rx_data_eop       ),
.xge_rx_data_byte_vaild                (xge_rx_data_byte_vaild),
.xge_rx_data_err                       (xge_rx_data_err       ),
.rx_pfc_pause_stop                     (pfc_pause_stop        ),
.tx_pause_en                           (1'b0                  ),
.rx_pause_en                           (1'b0                  ),
.pause_req                             (1'b0                  ),
.pause_req_time                        (16'd0                 ),
.send_interval                         (16'd0                 ),
.apb_penable                           (mac_penable           ),
.apb_pready                            (                      ),
.apb_psel                              (mac_psel              ),
.apb_pwrite                            (mac_pwrite            ),
.apb_clk                               (i_free_clk            ),
.apb_paddr                             (mac_paddr             ),
.apb_prdata                            (mac_prdata            ),
.apb_pwdata                            (mac_pwdata            )
);  


pgr_BaseR_core_v1_0 PCS_10G
    (
    .rx_rst            (rxlane_done        ),    //+
    .rxclk             (rxclk              ),    
    .syn_align         (syn_align          ),    
    .sys_clk           (usclk              ),    //+
    .tx_rst            (txlane_done        ),    //+
    .txclk             (txclk              ),     

    .apb_clk           (i_free_clk         ),
    .apb_rst           (~slow_rst_done     ),
    .apb_psel          (core_psel          ),    
    .apb_penable       (core_penable       ),    
    .apb_pwrite        (core_pwrite        ),    
    .apb_paddr         (core_paddr         ),    
    .apb_pwdata        (core_pwdata        ),    
    .apb_prdata        (core_prdata        ),    

//-----------------------------------------------
    .pin_cfg_en        (pin_cfg_en         ),    
    .prbs_rx_en        (prbs_rx_en         ),    
    .prbs_tx_en        (prbs_tx_en         ),    
    .prbs_mode         (prbs_mode          ),   
    .pcs_loopback      (core_loopback      ),    
    .pma_loopback      (pma_loopback       ),    
    .rx_sigdet         (o_p_rx_sigdet_sta_0),    
    .link_up           (o_p_lx_cdr_align_0 ),    
    .aligned           (o_p_lx_cdr_align_0 ),    
    .cfg_pcs_loopback  (cfg_pcs_loopback_0 ),    
    .cfg_pma_loopback  (cfg_pma_loopback_0 ),
    .cfg_pma_reset     (cfg_pma_reset      ),
    .cfg_pcs_reset     (cfg_pcs_reset      ),
//------------------------------------------------

    .rxc               (xgmii_rxc          ), 
    .rxd               (xgmii_rxd          ), 
    .tx_data_group     (tx_data_group_0      ),    //+
    .tx_data_h         (tx_data_h_0          ),    //+
    .tx_data_seq       (tx_data_seq_0        ),    //+
    .rx_data_group     (rx_data_group_0      ),    //+
    .rx_data_h         (rx_data_h_0          ),    //+
    .rx_data_vld       (rx_data_vld_0        ),    //+
    .rx_data_slip      (rx_data_slip_0    ),
    .o_rxq_start_0     (o_rxq_start_0        ),    //+
    .txc               (xgmii_txc          ), 
    .txd               (xgmii_txd          )  
    );

Transceiver_10G PHY_10G (
.i_free_clk                 (i_free_clk),    //+
.i_hpll_rst                 (~hsst_rst_done),    //+
.i_hpll_wtchdg_clr          (1'b0             ),    //+
.i_hsst_fifo_clr_0          (1'b0             ),    //+
.i_loop_dbg_0               (hsst_loop_dbg_0    ),    //+
//.o_hpll_wtchdg_st                       (o_hpll_wtchdg_st),
//.o_hpll_done                            (o_hpll_done),
.o_txlane_done_0            (hsst_txlane_done_0),    //+
.o_rxlane_done_0            (hsst_rxlane_done_0),    //+
.i_p_refckn_0               (i_p_refckn_0),
.i_p_refckp_0               (i_p_refckp_0),
.o_p_clk2core_tx_0          (o_p_clk2core_tx_0),
.i_p_tx0_clk_fr_core        (txclk),
.o_p_clk2core_rx_0          (o_p_clk2core_rx_0),
.i_p_rx0_clk_fr_core        (rxclk),
.o_p_refck2core_0           (o_p_refck2core_0),
//.o_p_hpll_lock                          (o_p_hpll_lock),
.o_p_rx_sigdet_sta_0        (o_p_rx_sigdet_sta_0),
.o_p_lx_cdr_align_0         (o_p_lx_cdr_align_0),
.i_p_rxpcs_slip_0           (rx_data_slip_0),
.i_p_pcs_nearend_loop_0     (i_p_pcs_nearend_loop_0),
.i_p_pcs_farend_loop_0      (i_p_pcs_farend_loop_0),
.i_p_pma_nearend_ploop_0    (p_pma_nearend_ploop),
.i_p_pma_nearend_sloop_0    (i_p_pma_nearend_sloop_0),
.i_p_pma_farend_ploop_0     (i_p_pma_farend_ploop_0),
.i_p_cfg_clk                (i_free_clk),
.i_p_cfg_rst                (~slow_rst_done),

.i_p_cfg_psel               (hsst_psel),
.i_p_cfg_enable             (hsst_penable),
.i_p_cfg_write              (hsst_pwrite),
.i_p_cfg_addr               (hsst_paddr),
.i_p_cfg_wdata              (hsst_pwdata),
.o_p_cfg_rdata              (hsst_prdata),
.o_p_cfg_int                (hsst_pint),
.o_p_cfg_ready              (hsst_pready),
.o_p_calib_done             (o_p_calib_done),

.i_p_l0rxn                  (i_p_l0rxn),
.i_p_l0rxp                  (i_p_l0rxp),
.o_p_l0txn                  (o_p_l0txn),
.o_p_l0txp                  (o_p_l0txp),

.o_rxstatus_0               (o_rxstatus_0            ),
.i_txd_0                    (tx_data_group_0),    //+
.i_txq_0                    (tx_data_seq_0),    //+
.i_txh_0                    (tx_data_h_0),    //+
.o_rxd_0                    (rx_data_group_0),    //+
.o_rxh_0                    (rx_data_h_0),    //+
.o_rxd_vld_0                (rx_data_vld_0),    //+
.o_rxq_start_0              (o_rxq_start_0)    //+
);


GTP_CLKBUFG CLKBUFG_u (
    .CLKOUT(usclk           ),    //+
    .CLKIN (o_p_refck2core_0)     //+
);

GTP_CLKBUFX CLKBUFX_tx (
    .CLKOUT(txclk            ),    //+
    .CLKIN (o_p_clk2core_tx_0)     //+
);

GTP_CLKBUFX CLKBUFX_rx (
    .CLKOUT(rxclk            ),    //+
    .CLKIN (o_p_clk2core_rx_0)     //+
);

endmodule