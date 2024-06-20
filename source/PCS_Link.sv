module PCS_Link (
    input          i_free_clk                    ,
    input          ext_rst_n                     ,
    input   [63:0]  xgmii_txd                    ,
    input   [7:0]   xgmii_txc                    ,
    output  [63:0]  xgmii_rxd                    ,
    output  [7:0]   xgmii_rxc                    ,
    input          usclk                        ,
    input   [18:0]  apb_paddr                    ,    
    output          txlane_done                  ,
    output          rxlane_done                  ,
    output          syn_align                    ,
    output          o_p_rx_sigdet_sta_0          ,
    output          o_p_lx_cdr_align_0           ,
    output          hsst_rst_done,
    output          slow_rst_done,
    input          o_hsst_txlane_done,
    input          o_hsst_rxlane_done,
    input           txclk,
    input           rxclk,
    output          rx_data_slip,
    output          cfg_pma_loopback,
    output          cfg_pcs_loopback,
    input rx_data_h,
    input rx_data_vld,
    input o_rxq_start,
    output tx_data_group,
    output tx_data_h,
    output tx_data_seq,
    input rx_data_group,
input  [15:0]  core_paddr,
input          core_pwrite,
input          core_psel,
input          core_penable,
input  [31:0]  core_pwdata ,
output  [31:0]  core_prdata



);
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




//-----------------------------------------------
pgr_rst_debounce_v1_0 rst_debounce_inst 
    (
    .clk       (i_free_clk),           
    .rst_n     (ext_rst_n ),           
    .signal_b  (1'b1      ),           
    .signal_deb(slow_rst_done)            
    );

pgr_rst_syn_v1_0 pcs_tx_rst_inst
    (
    .clk     (txclk          ),      
    .rst     (o_hsst_txlane_done),      
    .cfg_rst (cfg_pcs_reset  ),      
    .rst_done(txlane_done    )       
    );

pgr_rst_syn_v1_0 pcs_rx_rst_inst
    (
    .clk     (rxclk          ),      
    .rst     (o_hsst_rxlane_done),      
    .cfg_rst (cfg_pcs_reset  ),      
    .rst_done(rxlane_done    )       
    );

pgr_rst_syn_v1_0 pma_hsst_rst_inst
    (
    .clk     (i_free_clk   ),        
    .rst     (slow_rst_done   ),        
    .cfg_rst (cfg_pma_reset),        
    .rst_done(hsst_rst_done    )         
    );
//-----------------------------------------------------------



pgr_BaseR_core_v1_0 BaseR_core_inst
    (
    .rx_rst            (rxlane_done        ),    
    .rxclk             (rxclk              ),    
    .syn_align         (syn_align          ),    
    .sys_clk           (usclk              ),    
    .tx_rst            (txlane_done        ),    
    .txclk             (txclk              ),    
    .rx_data_group     (rx_data_group      ),  

    .apb_clk           (i_free_clk         ),
    .apb_rst           (slow_rst_done         ),
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
    .cfg_pcs_loopback  (cfg_pcs_loopback   ),    
    .cfg_pma_loopback  (cfg_pma_loopback   ),
    .cfg_pma_reset     (cfg_pma_reset      ),
    .cfg_pcs_reset     (cfg_pcs_reset      ),
//------------------------------------------------

    .rxc               (xgmii_rxc          ), 
    .rxd               (xgmii_rxd          ), 
    .tx_data_group     (tx_data_group      ), 
    .tx_data_h         (tx_data_h          ), 
    .tx_data_seq       (tx_data_seq        ), 
    .rx_data_h         (rx_data_h          ),
    .rx_data_vld       (rx_data_vld        ),
    .rx_data_slip      (rx_data_slip       ),
    .o_rxq_start_0     (o_rxq_start      ),
    .txc               (xgmii_txc          ), 
    .txd               (xgmii_txd          )  
    );

endmodule