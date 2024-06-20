module MAC_Link #(
         parameter     TX_REG_STSTISTICS   =  "FALSE"         ,
         parameter     RX_REG_STSTISTICS   =  "FALSE"         , 
         parameter     PAUSE_FLOW          =  "FALSE"          
)
(
input                   xgmii_clk                             ,// 156.25M 
input                   sys_rst                               ,// active high
                                                              
//XGMII interface                                             
input       [63:0]      xgmii_rxd                             ,
input       [ 7:0]      xgmii_rxc                             ,
output      [63:0]      xgmii_txd                             ,
output      [ 7:0]      xgmii_txc                             ,
                                                              
//packet interface                                            
input                   xge_tx_rst                            ,
input       [63:0]      xge_tx_data                           ,
input                   xge_tx_data_en                        ,
input                   xge_tx_data_sop                       ,
input                   xge_tx_data_eop                       ,
input       [ 2:0]      xge_tx_data_byte_vaild                ,
output                  xgmii_tx_ready                        ,

input                   xge_rx_rst                            ,
output      [63:0]      xge_rx_data                           ,
output                  xge_rx_data_en                        ,
output                  xge_rx_data_sop                       ,
output                  xge_rx_data_eop                       ,
output      [ 2:0]      xge_rx_data_byte_vaild                ,
output                  xge_rx_data_err                       ,

input                   tx_pause_en                           ,
input                   rx_pause_en                           ,
input                   pause_req                             ,
input       [15:0]      pause_req_time                        ,
input       [15:0]      send_interval                         ,
output      [7:0]       rx_pfc_pause_stop                     ,
                                                                                                                        
//APB BUS                                                     
input                   apb_clk                               ,
input                   apb_penable                           ,
input                   apb_pwrite                            ,
input       [18:0]      apb_paddr                             ,
input       [31:0]      apb_pwdata                            ,
input                   apb_psel                              ,
output      [31:0]      apb_prdata                            ,
output                  apb_pready                         

);                                                            
wire                     xgmii_clk_rx_rst                     ;
wire                     xgmii_clk_tx_rst                     ;
wire                     apb_clk_rst                          ;
wire                     mac_tx_rst                           ;
wire                     mac_rx_rst                           ;
wire        [2:0]        link_fault                           ;
wire        [2:0]        link_fault_toreg                     ;
wire                     fault_inhibit                        ;

wire        [63:0]       xgmii_txd_alarm                      ;
wire        [7:0]        xgmii_txc_alarm                      ;


wire                     pin_cfg_en                           ;
wire                     rx_reset                             ;  
wire                     tx_reset                             ;    
wire                     tx_packet_sta_clr                    ;
wire                     rx_packet_sta_clr                    ;
wire                     ifg_en                               ;
wire        [5:0]        ifg_value                            ;


wire        [47:0]       cfg_pause_mac                        ;   
wire                     cfg_rx_reset                         ;   
wire                     cfg_fault_inhibit                    ;   
wire                     cfg_rx_mtu_en                        ;   
wire        [14:0]       cfg_rx_mtu_size                      ;   
wire                     cfg_tx_reset                         ;   
wire                     cfg_tx_mtu_en                        ;   
wire        [14:0]       cfg_tx_mtu_size                      ;   
wire                     cfg_tx_ipg_en                        ;   
wire        [5:0]        cfg_tx_ipg_value                     ;   

wire                     cfg_xon                              ;                   
wire                     cfg_tx_pfc_en                        ;              
wire        [7:0]        cfg_pfc_pri_req                      ;            
wire        [7:0]        cfg_tx_pfc_pri_en                    ;          
wire        [15:0]       cfg_pfc0_pause_req_time              ;    
wire        [15:0]       cfg_pfc0_send_interval               ;     
wire        [15:0]       cfg_pfc1_pause_req_time              ;    
wire        [15:0]       cfg_pfc1_send_interval               ;     
wire        [15:0]       cfg_pfc2_pause_req_time              ;    
wire        [15:0]       cfg_pfc2_send_interval               ;     
wire        [15:0]       cfg_pfc3_pause_req_time              ;    
wire        [15:0]       cfg_pfc3_send_interval               ;     
wire        [15:0]       cfg_pfc4_pause_req_time              ;    
wire        [15:0]       cfg_pfc4_send_interval               ;     
wire        [15:0]       cfg_pfc5_pause_req_time              ;    
wire        [15:0]       cfg_pfc5_send_interval               ;     
wire        [15:0]       cfg_pfc6_pause_req_time              ;    
wire        [15:0]       cfg_pfc6_send_interval               ;     
wire        [15:0]       cfg_pfc7_pause_req_time              ;    
wire        [15:0]       cfg_pfc7_send_interval               ;    
wire                     cfg_rx_pfc_en                        ;  
wire                     cfg_tx_packet_sta_clr                ;
wire                     cfg_rx_packet_sta_clr                ;


wire        [8:0]        cfg_paddr                            ;
wire                     cfg_pwrite                           ;
wire                     cfg_psel                             ;
wire                     cfg_penable                          ;
wire        [31:0]       cfg_pwdata                           ;
wire        [31:0]       cfg_prdata                           ;
                         
wire        [8:0]        rx_paddr                             ; 
wire                     rx_pwrite                            ; 
wire                     rx_psel                              ; 
wire                     rx_penable                           ;
wire        [31:0]       rx_pwdata                            ; 
wire        [31:0]       rx_prdata                            ; 
                         
wire        [8:0]        tx_paddr                             ; 
wire                     tx_pwrite                            ; 
wire                     tx_psel                              ; 
wire                     tx_penable                           ;
wire        [31:0]       tx_pwdata                            ; 
wire        [31:0]       tx_prdata                            ;
wire                     rx_pause_stop                        ;    

//------------- user configuration ------------------------
//------- user config base : pin_cfg_en=1'b1 -------------
//   reset mac tx      : tx_reset      = 1'b1                 -
//   reset mac rx      : rx_reset      = 1'b1                 -
//   forbit link fault : fault_inhibit = 1'b1                 -
//   config ifg enable : ifg_en        = 1'b1                 -
//   config ifg time   : ifg_value     = xxx                  -
//---------------------------------------------------------
assign                   pin_cfg_en    = 1'b0                 ;
assign                   rx_reset      = 1'b0                 ;
assign                   fault_inhibit = 1'b0                 ;
assign                   tx_reset      = 1'b0                 ;
assign                   ifg_en        = 1'b0                 ;
assign                   ifg_value     = 6'd0                 ;
                        
//------------------------------------------------


reset_pro_top reset_pro_top                                   
(                                                             
.xgmii_clk                   (xgmii_clk                       ),
.apb_clk                     (apb_clk                         ),
                                                              
.sys_rst                     (sys_rst                         ),
.mac_tx_rst                  (xge_tx_rst | cfg_tx_reset       ),
.mac_rx_rst                  (xge_rx_rst | cfg_rx_reset       ),
                                                              
.xgmii_clk_rx_rst            (xgmii_clk_rx_rst                ),
.xgmii_clk_tx_rst            (xgmii_clk_tx_rst                ),
.apb_clk_rst                 (apb_clk_rst                     )      
);

//--------------------------------------------------------------

xge_mac_reg_union  xge_mac_reg_union_inst
(
.apb_clk                     (apb_clk                         ),          
.apb_penable                 (apb_penable                     ),  
.apb_pready                  (apb_pready                      ),    
.apb_psel                    (apb_psel                        ),        
.apb_pwrite                  (apb_pwrite                      ),    
.apb_rst                     (~apb_clk_rst                    ),     
.apb_paddr                   (apb_paddr                       ),      
.apb_prdata                  (apb_prdata                      ),    
.apb_pwdata                  (apb_pwdata                      ),         
.cfg_penable                 (cfg_penable                     ),  
.cfg_psel                    (cfg_psel                        ),        
.cfg_pwrite                  (cfg_pwrite                      ),    
.cfg_paddr                   (cfg_paddr                       ),      
.cfg_prdata                  (cfg_prdata                      ),    
.cfg_pwdata                  (cfg_pwdata                      ),  
.rx_penable                  (rx_penable                      ),    
.rx_psel                     (rx_psel                         ),          
.rx_pwrite                   (rx_pwrite                       ),   
.rx_paddr                    (rx_paddr                        ),        
.rx_prdata                   (rx_prdata                       ),      
.rx_pwdata                   (rx_pwdata                       ),        
.tx_penable                  (tx_penable                      ),    
.tx_psel                     (tx_psel                         ),          
.tx_pwrite                   (tx_pwrite                       ),      
.tx_paddr                    (tx_paddr                        ),        
.tx_prdata                   (tx_prdata                       ),      
.tx_pwdata                   (tx_pwdata                       )       
);

cfg_reg xge_cfg_reg
(
.clk                         (apb_clk                         ),                         
.rst_n                       (~apb_clk_rst                    ),                  
.apb_psel                    (cfg_psel                        ),                   
.apb_penable                 (cfg_penable                     ),             
.apb_pwrite                  (cfg_pwrite                      ),               
.pin_cfg_en                  (pin_cfg_en                      ),   
.tx_packet_sta_clr           (tx_packet_sta_clr               ),
.rx_packet_sta_clr           (rx_packet_sta_clr               ),     
.rx_reset                    (rx_reset                        ),                   
.link_fault_toreg            (link_fault_toreg                ),   
.fault_inhibit               (fault_inhibit                   ),         
.tx_reset                    (tx_reset                        ),                   
.tx_ipg_en                   (ifg_en                          ),                 
.cfg_rx_reset                (cfg_rx_reset                    ),           
.cfg_fault_inhibit           (cfg_fault_inhibit               ), 
.cfg_rx_mtu_en               (cfg_rx_mtu_en                   ),         
.cfg_tx_reset                (cfg_tx_reset                    ),           
.cfg_tx_mtu_en               (cfg_tx_mtu_en                   ),         
.cfg_tx_ipg_en               (cfg_tx_ipg_en                   ),         
.apb_paddr                   (cfg_paddr                       ),                 
.apb_pwdata                  (cfg_pwdata                      ),               
.apb_prdata                  (cfg_prdata                      ),               
.tx_ipg_value                (ifg_value                       ),           
.cfg_pause_mac               (cfg_pause_mac                   ),         
.cfg_rx_mtu_size             (cfg_rx_mtu_size                 ),     
.cfg_tx_mtu_size             (cfg_tx_mtu_size                 ),     
.cfg_tx_ipg_value            (cfg_tx_ipg_value                ),   
.cfg_xon                     (cfg_xon                         ),                  
.cfg_tx_pfc_en               (cfg_tx_pfc_en                   ),            
.cfg_pfc_pri_req             (cfg_pfc_pri_req                 ),          
.cfg_tx_pfc_pri_en           (cfg_tx_pfc_pri_en               ),        
.cfg_pfc0_pause_req_time     (cfg_pfc0_pause_req_time         ),  
.cfg_pfc0_send_interval      (cfg_pfc0_send_interval          ),   
.cfg_pfc1_pause_req_time     (cfg_pfc1_pause_req_time         ),  
.cfg_pfc1_send_interval      (cfg_pfc1_send_interval          ),   
.cfg_pfc2_pause_req_time     (cfg_pfc2_pause_req_time         ),  
.cfg_pfc2_send_interval      (cfg_pfc2_send_interval          ),   
.cfg_pfc3_pause_req_time     (cfg_pfc3_pause_req_time         ),  
.cfg_pfc3_send_interval      (cfg_pfc3_send_interval          ),   
.cfg_pfc4_pause_req_time     (cfg_pfc4_pause_req_time         ),  
.cfg_pfc4_send_interval      (cfg_pfc4_send_interval          ),   
.cfg_pfc5_pause_req_time     (cfg_pfc5_pause_req_time         ),  
.cfg_pfc5_send_interval      (cfg_pfc5_send_interval          ),   
.cfg_pfc6_pause_req_time     (cfg_pfc6_pause_req_time         ),  
.cfg_pfc6_send_interval      (cfg_pfc6_send_interval          ),   
.cfg_pfc7_pause_req_time     (cfg_pfc7_pause_req_time         ),  
.cfg_pfc7_send_interval      (cfg_pfc7_send_interval          ),   
.cfg_rx_pfc_en               (cfg_rx_pfc_en                   ),
.cfg_tx_packet_sta_clr       (cfg_tx_packet_sta_clr)  ,
.cfg_rx_packet_sta_clr       (cfg_rx_packet_sta_clr)      
);


//-------------------------------------------------------------- 

alarm_detect xge_mac_alarm_detect
(
.xgmii_clk                   (xgmii_clk                       ),         
.sys_rst                     (xgmii_clk_rx_rst                ),  
.fault_inhibit               (cfg_fault_inhibit               ),     
.xgmii_rxd                   (xgmii_rxd                       ),         
.xgmii_rxc                   (xgmii_rxc                       ),         
.link_fault                  (link_fault                      ),        
.link_fault_toreg            (link_fault_toreg                )   
);
                                                             
                                                              
xge_mac_rx_top #
(
.PAUSE_FLOW                  (PAUSE_FLOW                      ),
.RX_REG_STSTISTICS           (RX_REG_STSTISTICS               )
)
xge_mac_rx_top                                 
(                                                             
.xgmii_clk                   (xgmii_clk                       ),
.sys_rst                     (xgmii_clk_rx_rst                ), 

.apb_clk                     (apb_clk                         ),      
.apb_rst                     (~apb_clk_rst                    ),      
.rx_packet_clr               (cfg_rx_packet_sta_clr           ),  

.rx_paddr                    (rx_paddr                        ),
.rx_pwrite                   (rx_pwrite                       ),
.rx_psel                     (rx_psel                         ),
.rx_penable                  (rx_penable                      ),
.rx_pwdata                   (rx_pwdata                       ),
.rx_prdata_mux               (rx_prdata                       ),
                                                                
.xgmii_rxd                   (xgmii_rxd                       ),
.xgmii_rxc                   (xgmii_rxc                       ),

.rx_pause_en                 (rx_pause_en                     ), 
.rx_pfc_en                   (cfg_rx_pfc_en                   ), 
.mtu_en                      (cfg_rx_mtu_en                   ),                       
.mtu_size                    (cfg_rx_mtu_size                 ),          
.rx_req_pause_mux            (rx_pause_stop                   ), 
.rx_pfc_stop_mux             (rx_pfc_pause_stop               ),  
                                                              
.xge_rx_data                 (xge_rx_data                     ),
.xge_rx_data_en              (xge_rx_data_en                  ),
.xge_rx_data_sop             (xge_rx_data_sop                 ),
.xge_rx_data_eop             (xge_rx_data_eop                 ),
.xge_rx_data_byte_vaild      (xge_rx_data_byte_vaild          ),
.xge_rx_data_err             (xge_rx_data_err                 )
                                                              
);                                                            
                      
                                        
xge_mac_tx_top #
(
.PAUSE_FLOW                  (PAUSE_FLOW                      ),
.TX_REG_STSTISTICS           (TX_REG_STSTISTICS               )
)
xge_mac_tx_top                                 
(                                                             
.xgmii_clk                   (xgmii_clk                       ),
.sys_rst                     (xgmii_clk_tx_rst                ),

.apb_clk                     (apb_clk                         ),      
.apb_rst                     (~apb_clk_rst                    ),      
.tx_packet_clr               (cfg_tx_packet_sta_clr           ),  

.tx_paddr                    (tx_paddr                        ),
.tx_pwrite                   (tx_pwrite                       ),
.tx_psel                     (tx_psel                         ),
.tx_penable                  (tx_penable                      ),
.tx_pwdata                   (tx_pwdata                       ),
.tx_prdata_mux               (tx_prdata                       ),

.ifg_en                      (cfg_tx_ipg_en                   ),
.ifg_value                   (cfg_tx_ipg_value                ),    
.pause_stop                  (rx_pause_stop                   ),
.xon                         (cfg_xon                         ),                                     
.tx_pause_en                 (tx_pause_en                     ),                                      
.pause_req                   (pause_req                       ),                                    
.pause_req_time              (pause_req_time                  ),                                  
.send_interval               (send_interval                   ),  
.pause_mac                   (cfg_pause_mac                   ),     
.mtu_en                      (cfg_tx_mtu_en                   ),                       
.mtu_size                    (cfg_tx_mtu_size                 ),                                  
.tx_pfc_en                   (cfg_tx_pfc_en                   ),               
.pfc_pri_req                 (cfg_pfc_pri_req                 ),              
.tx_pfc_pri_en               (cfg_tx_pfc_pri_en               ),             
.pfc0_pause_req_time         (cfg_pfc0_pause_req_time         ),       
.pfc0_send_interval          (cfg_pfc0_send_interval          ),        
.pfc1_pause_req_time         (cfg_pfc1_pause_req_time         ),                              
.pfc1_send_interval          (cfg_pfc1_send_interval          ),                             
.pfc2_pause_req_time         (cfg_pfc2_pause_req_time         ),                             
.pfc2_send_interval          (cfg_pfc2_send_interval          ),                             
.pfc3_pause_req_time         (cfg_pfc3_pause_req_time         ),                              
.pfc3_send_interval          (cfg_pfc3_send_interval          ),                             
.pfc4_pause_req_time         (cfg_pfc4_pause_req_time         ),                              
.pfc4_send_interval          (cfg_pfc4_send_interval          ),                             
.pfc5_pause_req_time         (cfg_pfc5_pause_req_time         ),                              
.pfc5_send_interval          (cfg_pfc5_send_interval          ),                              
.pfc6_pause_req_time         (cfg_pfc6_pause_req_time         ),                                      
.pfc6_send_interval          (cfg_pfc6_send_interval          ),
.pfc7_pause_req_time         (cfg_pfc7_pause_req_time         ),
.pfc7_send_interval          (cfg_pfc7_send_interval          ),
                             
.xge_tx_data                 (xge_tx_data                     ),
.xge_tx_data_en              (xge_tx_data_en                  ),
.xge_tx_data_sop             (xge_tx_data_sop                 ),
.xge_tx_data_eop             (xge_tx_data_eop                 ),
.xge_tx_data_byte_vaild      (xge_tx_data_byte_vaild          ),
                                                                                        
.xgmii_txd                   (xgmii_txd_alarm                 ),
.xgmii_txc                   (xgmii_txc_alarm                 ),
                                                                                                                               
.xgmii_tx_ready              (xgmii_tx_ready                  )
);                                                            
                                                              


alarm_insert xge_mac_alarm_insert
(
.xgmii_clk                   (xgmii_clk                       ),  
.sys_rst                     (xgmii_clk_tx_rst                ),  
.xgmii_txd_alarm             (xgmii_txd_alarm                 ),  
.xgmii_txc_alarm             (xgmii_txc_alarm                 ),  
.link_fault                  (link_fault                      ),  
.xgmii_txd                   (xgmii_txd                       ),  
.xgmii_txc                   (xgmii_txc                       )   
);


endmodule