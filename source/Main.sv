module Main(
// clocks
    input i_clk_50,
    input fpga_rst_n,
    input QR1_ref_clk_156_n,
    input QR1_ref_clk_156_p,
    input i_clk_100_p,
    input i_clk_100_n,

// Transivers
    input sfp_1_rx_n,
    input sfp_1_rx_p,    
    output sfp_1_tx_n,
    output sfp_1_tx_p, 
    output sfp_1_tx_dis,
    input sfp_1_loss,
//  UART
    output txd,
    input rxd,
// FAN
    output fan  
// LEDs
  /*  output LED1,
    output LED2,
    output LED3,
    output LED4*/
// input debug_clk_100_p,
//input debug_clk_100_n,
);

assign fan = 1'b0;
assign sfp_1_tx_dis = 1'b0;

//assign {LED1, LED2, LED3, LED4} = 1'b1;


wire clk_50;
wire pll_50_lock;
wire clk_312_5 /* synthesis PAP_MARK_DEBUG="true" */;
wire clk_312_5_lock;

wire  [23:0]      apb_paddr    ;    
wire              apb_psel     ;     
wire              apb_penable  ;  
wire              apb_pwrite   ;   
wire  [31:0]      apb_pwdata   ;   
wire              apb_pready   ;   
wire  [31:0]      apb_prdata   ; 


Debug_pll Debug (
  .clkout0(clk_312_5),
  .lock(clk_312_5_lock),            // output
  .clkin1_p(i_clk_100_p),    // input
  .clkin1_n(i_clk_100_n)     // input
);


PLL_IN_50 Pll_50mhz (
  .clkout0(clk_50),    // output
//  .clkout1(clkout1),    // output
//  .clkout2(clkout2),    // output
  .lock(pll_50_lock),          // output
  .clkin1(i_clk_50)       // input
);

Link10G LinkMain (
.i_clk_50_mhz(clk_50),
.sys_rst(~fpga_rst_n),
.i_p_refckn_0(QR1_ref_clk_156_n),
.i_p_refckp_0(QR1_ref_clk_156_p),
.i_p_l0rxn(sfp_1_rx_n),                               
.i_p_l0rxp(sfp_1_rx_p),
.o_p_l0txn(sfp_1_tx_n),
.o_p_l0txp(sfp_1_tx_p),


.apb_paddr(apb_paddr),
.apb_psel (apb_psel),     
.apb_penable(apb_penable),  
.apb_pwrite(apb_pwrite),   
.apb_pwdata(apb_pwdata),   
.apb_pready(apb_pready),   
.apb_prdata(apb_prdata),


.xgmii_tx_ready              (xgmii_tx_ready        ),
.xge_tx_data                 (xge_tx_data           ),
.xge_tx_data_en              (xge_tx_data_en        ),
.xge_tx_data_sop             (xge_tx_data_sop       ),
.xge_tx_data_eop             (xge_tx_data_eop       ),
.xge_tx_data_byte_vaild      (xge_tx_data_byte_vaild),
.o_syn_align                 (syn_align),
.o_usclk                     (usclk)
);


packet_gen packet_gen
(
.sys_clk                 (usclk),
.sys_rst                 (~fpga_rst_n | (~syn_align)),
//.sys_rst                 (sys_rst ),
.tx_ready                (xgmii_tx_ready        ),
.tx_data                 (xge_tx_data           ),
.tx_data_en              (xge_tx_data_en        ),
.tx_data_sop             (xge_tx_data_sop       ),
.tx_data_eop             (xge_tx_data_eop       ),
.tx_data_byte_vaild      (xge_tx_data_byte_vaild)          
);


pgr_uart_ctrl_top_32bit #(
    .CLK_FREQ               ( 16'd50           ),
    .MDC_DIV                ( 7'd20            ),
    .FIFO_D                 ( 8'd16            ),
    .WORD_LEN               ( 2'b11            ),
    .PARITY_EN              ( 1'b0             ),
    .PARITY_TYPE            ( 1'b0             ),
    .STOP_LEN               ( 1'b0             ),
    .MODE                   ( 1'b0             )
) uart_ctrl_inst (
    .clk                     (clk_50            ),
    .rst_n                   (~fpga_rst_n         ),

    .uart_ctrl_sel           ( 1'b0            ),
    .uart_match              (                 ),

    .p_addr                  ( apb_paddr       ),
    .p_wdata                 ( apb_pwdata      ),
    .p_ce                    ( apb_psel        ),
    .p_enable                ( apb_penable     ),
    .p_we                    ( apb_pwrite      ),
    .p_rdy                   ( apb_pready      ),
    .p_rdata                 ( apb_prdata      ),

    .mdc                     (                 ),
    .mdi                     ( 1'b0            ),
    .mdo                     (                 ),
    .mdo_en                  (                 ),

    .txd                     ( txd             ),
    .rxd                     ( rxd             )
);

endmodule