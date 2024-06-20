//******************************************************************
// Copyright (c) 2014 PANGO MICROSYSTEMS, INC
// ALL RIGHTS REVERVED.
//******************************************************************
`timescale 1ns/1ns
module pgr_uart_ctrl_top_32bit
#(
    parameter CLK_FREQ      = 8'd50       , //frequency, for 50MHz
    parameter CLK_DIV       = 16'd72       ,
    parameter FIFO_D        = 8'd16        , //fifo depth
    parameter WORD_LEN      = 2'b11     , //the bit width of valid data(00:5 01:6 10:7 11:8)
    parameter PARITY_EN     = 1'b0      , //0:no parity bit  1:1 parity bit
    parameter PARITY_TYPE   = 1'b0      , //the type of parity(0:even 1:odd)
    parameter STOP_LEN      = 1'b0      , //1:2 stop bit  0:1 stop bit
    parameter MODE          = 1'b0      , //0:LSBF 1:MSBF
    parameter AW            = 8'd24        , //the bit width of addr
    parameter DW            = 8'd32        , //the bit width of data
    parameter MDC_DIV       = 8'd20
)
(
    input           clk,
    input           rst_n,

    input           uart_ctrl_sel,
    output          uart_match,

    output          mdc,
    input           mdi,
    output          mdo,
    output          mdo_en,

    //apb enable
    output             p_ce,
    output  [24-1:0]   p_addr,
    output  [32-1:0]   p_wdata,
    output             p_enable,
    output             p_we,
    input              p_rdy,
    input   [32-1:0]   p_rdata,

    //uart
    output             txd,
    input              rxd
);

wire    [7:0]   tx_fifo_wr_data;
wire            tx_fifo_wr_data_valid;
wire            tx_fifo_wr_data_req;

wire    [7:0]   rx_fifo_rd_data;
wire            rx_fifo_rd_data_valid;
wire            rx_fifo_rd_data_req;

wire            sync_rst_n;

pgr_uart_top_32bit
#(
    .CLK_FREQ       (CLK_FREQ       ), 
    .CLK_DIV        (CLK_DIV        ),
    .FIFO_D         (FIFO_D         ),
    .WORD_LEN       (WORD_LEN       ),
    .PARITY_EN      (PARITY_EN      ),
    .PARITY_TYPE    (PARITY_TYPE    ),
    .STOP_LEN       (STOP_LEN       ),
    .MODE           (MODE           )
)
u_uart_top(
    .clk                        (clk                    ),
    .rst_n                      (sync_rst_n             ),

    .tx_fifo_wr_data            (tx_fifo_wr_data        ),
    .tx_fifo_wr_data_valid      (tx_fifo_wr_data_valid  ),
    .tx_fifo_wr_data_req        (tx_fifo_wr_data_req    ),

    .rx_fifo_rd_data            (rx_fifo_rd_data        ),
    .rx_fifo_rd_data_valid      (rx_fifo_rd_data_valid  ),
    .rx_fifo_rd_data_req        (rx_fifo_rd_data_req    ),

    .txd                        (txd                    ),
    .rxd                        (rxd                    ),

    .rx_overrun                 (                       ),
    .rx_chk_err                 (                       )
);

pgr_uart_ctrl_32bit #(
    .CLK_FREQ      ( CLK_FREQ    ),
    .AW            ( AW          ),
    .DW            ( DW          ),
    .MDC_DIV       ( MDC_DIV     )
) u_uart_ctrl(
    .clk                        (clk                    ),
    .rst_n                      (sync_rst_n             ),

    .tx_fifo_wr_data            (tx_fifo_wr_data        ),
    .tx_fifo_wr_data_valid      (tx_fifo_wr_data_valid  ),
    .tx_fifo_wr_data_req        (tx_fifo_wr_data_req    ),

    .rx_fifo_rd_data            (rx_fifo_rd_data        ),
    .rx_fifo_rd_data_valid      (rx_fifo_rd_data_valid  ),
    .rx_fifo_rd_data_req        (rx_fifo_rd_data_req    ),

    .p_ce                       (p_ce                   ),
    .p_addr                     (p_addr                 ),
    .p_wdata                    (p_wdata                ),
    .p_enable                   (p_enable               ),
    .p_we                       (p_we                   ),
    .p_rdy                      (p_rdy                  ),
    .p_rdata                    (p_rdata                ),
    .uart_ctrl_sel              (uart_ctrl_sel          ),
    .uart_match                 (uart_match             ),
    .mdc                        (mdc                    ),
    .mdi                        (mdi                    ),
    .mdo                        (mdo                    ),
    .mdo_en                     (mdo_en                 )
);

rstn_sync_32bit u_rstn_sync(
    .clk                        (clk                    ),
    .rst_n                      (rst_n                  ),
    .sync_rst_n                 (sync_rst_n             )
);

endmodule //pgr_uart2apb_top
