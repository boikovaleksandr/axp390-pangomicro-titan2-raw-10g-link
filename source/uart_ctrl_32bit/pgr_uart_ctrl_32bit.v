//******************************************************************
// Copyright (c) 2014 PANGO MICROSYSTEMS, INC
// ALL RIGHTS REVERVED.
//******************************************************************
`timescale 1ns/1ns
module pgr_uart_ctrl_32bit #(
    parameter CLK_FREQ = 8'd50,
    parameter AW = 8'd24,
    parameter DW = 8'd32,
    parameter MDC_DIV  = 8'd20
)(
    input           clk,
    input           rst_n,

    output reg  [7:0]  tx_fifo_wr_data,
    input              tx_fifo_wr_data_valid,
    output reg         tx_fifo_wr_data_req,

    input   [7:0]   rx_fifo_rd_data,
    input           rx_fifo_rd_data_valid,
    output          rx_fifo_rd_data_req,

    input           uart_ctrl_sel           ,
    output          uart_match              ,

    output            p_ce,
    output  [AW-1:0]  p_addr,
    output  [DW-1:0]  p_wdata,
    output            p_enable,
    output            p_we,
    input             p_rdy,
    input   [DW-1:0]  p_rdata,

    output          mdc                     ,
    input           mdi                     ,
    output          mdo                     ,
    output          mdo_en
);

wire    [AW-1:0]   addr/* synthesis PAP_MARK_DEBUG="1" */;
wire    [DW-1:0]   data;
wire               we;

wire            cmd_en;
wire            apb_cmd_en                 ;
wire            mdio_cmd_en                ;

reg             cmd_done;
wire            apb_cmd_done               ;
wire            mdio_cmd_done              ;

wire    [7:0]   apb_tx_fifo_wr_data        ;
wire            apb_tx_fifo_wr_data_req    ;
wire    [7:0]   mdio_tx_fifo_wr_data       ;
wire            mdio_tx_fifo_wr_data_req   ;

assign uart_match = (addr[23] == uart_ctrl_sel);

always@(*)
begin
    if(~uart_match)
    begin
        cmd_done            = 1'b1;
        tx_fifo_wr_data     = 8'b0;
        tx_fifo_wr_data_req = 1'b0;
    end
    else
        case(addr[22])
            1'd0: begin
                      cmd_done            = apb_cmd_done;
                      tx_fifo_wr_data     = apb_tx_fifo_wr_data;
                      tx_fifo_wr_data_req = apb_tx_fifo_wr_data_req;
                  end
            1'd1: begin
                      cmd_done            = mdio_cmd_done;
                      tx_fifo_wr_data     = mdio_tx_fifo_wr_data;
                      tx_fifo_wr_data_req = mdio_tx_fifo_wr_data_req;
                  end
            default: begin
                      cmd_done            = 1'b0;
                      tx_fifo_wr_data     = 8'b0;
                      tx_fifo_wr_data_req = 1'b0;
                  end
        endcase
end

assign apb_cmd_en  = (uart_match && (addr[22] == 1'd0)) ? cmd_en : 1'b0;
assign mdio_cmd_en = (uart_match && (addr[22] == 1'd1)) ? cmd_en : 1'b0;

pgr_apb_mif_32bit #(
    .CLK_FREQ   ( CLK_FREQ    ),
    .AW           ( AW        ),
    .DW           ( DW        )
) u_apb_mif(
    .clk                (clk                     ),
    .rst_n              (rst_n                   ),

    .strb               (4'b0                    ),
    .addr               (addr                    ),
    .wdata              (data                    ),
    .we                 (we                      ),
    .cmd_en             (apb_cmd_en              ),
    .cmd_done           (apb_cmd_done            ),

    .fifo_data          (apb_tx_fifo_wr_data     ),
    .fifo_data_valid    (tx_fifo_wr_data_valid   ),
    .fifo_data_req      (apb_tx_fifo_wr_data_req ),

    .apb_en             (1'b1                    ),
    .p_sel              (p_ce                    ),
    .p_strb             (                        ),
    .p_addr             (p_addr                  ),
    .p_wdata            (p_wdata                 ),
    .p_ce               (p_enable                ),
    .p_we               (p_we                    ),
    .p_rdy              (p_rdy                   ),
    .p_rdata            (p_rdata                 ),

    .uart_txvld         (                        ),
    .uart_txreq         (1'b0                    ),
    .uart_txdata        (8'b0                    )
);

pgr_mdio_mif_16bit #(
    .MDC_DIV      ( MDC_DIV   ),
    .AW           ( AW        ),
    .DW           ( DW        )
)u_mdio_mif(
    .clk                (clk                    ),
    .rst_n              (rst_n                  ),

    .addr               (addr                   ),
    .data               (data                   ),
    .cmd_en             (mdio_cmd_en            ),
    .cmd_done           (mdio_cmd_done          ),

    .fifo_data          (mdio_tx_fifo_wr_data   ),
    .fifo_data_valid    (tx_fifo_wr_data_valid  ),
    .fifo_data_req      (mdio_tx_fifo_wr_data_req),

    .mdc_pos            (                       ),

    .mdc                (mdc                    ),
    .mdi                (mdi                    ),
    .mdo                (mdo                    ),
    .mdo_en             (mdo_en                 )
);

pgr_cmd_parser_32bit #(
    .AW           ( AW       ),
    .DW           ( DW       ),
    .CLK_FREQ     (CLK_FREQ  )
)u_cmd_parser(
    .clk                (clk                    ),
    .rst_n              (rst_n                  ),

    .fifo_data          (rx_fifo_rd_data        ),
    .fifo_data_valid    (rx_fifo_rd_data_valid  ),
    .fifo_data_req      (rx_fifo_rd_data_req    ),

    .strb               (                       ),
    .addr               (addr                   ),
    .wdata              (data                   ),
    .we                 (we                     ),
    .cmd_en             (cmd_en                 ),
    .cmd_done           (cmd_done               ),

    .uart_rxvld         (                       ),
    .uart_rxreq         (1'b0                   ),
    .uart_rxdata        (                       ),

    .apb_en             (1'b1                   ),
    .strb_en            (1'b0                   )
);

endmodule //pgr_apb_ctr
