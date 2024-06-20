`timescale 1ns/100ps
module tb_xge_mac();
reg                   sys_rst;
wire   [63:0]         xge_tx_data;
wire                  xge_tx_data_en;
wire                  xge_tx_data_sop;
wire                  xge_tx_data_eop;
wire   [2:0]          xge_tx_data_byte_vaild;

wire                  xgmii_tx_ready                             ;


wire   [63:0]         xge_rx_data                           ;
wire                  xge_rx_data_en                        ;
wire                  xge_rx_data_sop                       ;
wire                  xge_rx_data_eop                       ;
wire   [ 2:0]         xge_rx_data_byte_vaild                ;
wire                  xge_rx_data_err                       ;
reg    [31:0]         tx_packet_cnt                         ;
reg    [31:0]         rx_packet_cnt                         ;
reg    [31:0]         tx_byte_cnt                           ;
reg    [31:0]         rx_byte_cnt                           ;
reg    [7:0]          rx_ipg                                ;

reg i_free_clk ;

wire usclk ;
reg i_p_refckp_0 ;
wire i_p_refckn_0 ;
wire o_p_l0txp ;
wire o_p_l0txn ;
wire i_p_l0rxp ;
wire i_p_l0rxn ;
wire syn_align ;

assign i_p_l0rxp = o_p_l0txp ;
assign i_p_l0rxn = o_p_l0txn ;

initial
  begin
    i_free_clk = 1'b0;
	forever #10  i_free_clk = ~ i_free_clk;
  end

initial
  begin
    i_p_refckp_0 = 1'b0;
	forever #3.2  i_p_refckp_0 = ~ i_p_refckp_0;
  end

assign i_p_refckn_0 = ~i_p_refckp_0 ;

initial
  begin
    sys_rst = 1'b1;
	# 100 sys_rst = 1'b0;
  end

always @ (posedge usclk)
  if (sys_rst)
    begin
      tx_byte_cnt <= 32'd0;
      rx_byte_cnt <= 32'd0;
      tx_packet_cnt <= 32'd0;
      rx_packet_cnt <= 32'd0;
    end
  else
    begin
      if (xge_rx_data_sop)
        rx_packet_cnt <= rx_packet_cnt + 32'd1;
      else
        rx_packet_cnt <= rx_packet_cnt;
      if (xge_tx_data_sop)
        tx_packet_cnt <= tx_packet_cnt + 32'd1;
      else
        tx_packet_cnt <= tx_packet_cnt;  
        
      if (xge_tx_data_en)
        begin
          
          if (xge_tx_data_eop)
            begin
              if (xge_tx_data_byte_vaild == 3'd0)
                tx_byte_cnt <= tx_byte_cnt + 32'd8;
              else
                tx_byte_cnt <= tx_byte_cnt + xge_tx_data_byte_vaild;
            end
          else
            tx_byte_cnt <= tx_byte_cnt + 32'd8;
        end
      else
        tx_byte_cnt <= tx_byte_cnt;
        
      if (xge_rx_data_en)
        begin
          if (xge_rx_data_eop)
            begin
              if (xge_rx_data_byte_vaild == 3'd0)
                rx_byte_cnt <= rx_byte_cnt + 32'd8;
              else
                rx_byte_cnt <= rx_byte_cnt + xge_rx_data_byte_vaild;
            end
          else
            rx_byte_cnt <= rx_byte_cnt + 32'd8;
        end
      else
        rx_byte_cnt <= rx_byte_cnt;
    end    
always @ (posedge usclk)
  begin
    if (xge_tx_data_en)
      begin
        if (xge_tx_data_eop)
          case (xge_tx_data_byte_vaild)
            3'd0 : wr_tx_file(xge_tx_data);
            3'd1 : wr_tx_file({56'd0,xge_tx_data[7:0]});
            3'd2 : wr_tx_file({48'd0,xge_tx_data[15:0]});
            3'd3 : wr_tx_file({40'd0,xge_tx_data[23:0]});
            3'd4 : wr_tx_file({32'd0,xge_tx_data[31:0]});
            3'd5 : wr_tx_file({24'd0,xge_tx_data[39:0]});
            3'd6 : wr_tx_file({16'd0,xge_tx_data[47:0]});
            3'd7 : wr_tx_file({8'd0,xge_tx_data[55:0]});
          endcase
        else
          wr_tx_file(xge_tx_data);
      end
    if (xge_rx_data_en)
      begin
        if (xge_rx_data_eop)
          case (xge_rx_data_byte_vaild)
            3'd0 : wr_rx_file(xge_rx_data);
            3'd1 : wr_rx_file({56'd0,xge_rx_data[7:0]});
            3'd2 : wr_rx_file({48'd0,xge_rx_data[15:0]});
            3'd3 : wr_rx_file({40'd0,xge_rx_data[23:0]});
            3'd4 : wr_rx_file({32'd0,xge_rx_data[31:0]});
            3'd5 : wr_rx_file({24'd0,xge_rx_data[39:0]});
            3'd6 : wr_rx_file({16'd0,xge_rx_data[47:0]});
            3'd7 : wr_rx_file({8'd0,xge_rx_data[55:0]});
          endcase
        else
          wr_rx_file(xge_rx_data);
      end
  end  
always @ (posedge usclk or posedge sys_rst)
  if  (sys_rst)
    rx_ipg <= 8'd0;
  else 
    begin
      if (xge_rx_data_eop)
        begin
          case (xge_rx_data_byte_vaild)
            3'd0 : rx_ipg <= 8'd0;
            3'd1 : rx_ipg <= 8'd7;
            3'd2 : rx_ipg <= 8'd6;
            3'd3 : rx_ipg <= 8'd5;
            3'd4 : rx_ipg <= 8'd4;
            3'd5 : rx_ipg <= 8'd3;
            3'd6 : rx_ipg <= 8'd2;
            3'd7 : rx_ipg <= 8'd1;
          endcase 
        end
      else if (xge_rx_data_en == 1'b0)
        rx_ipg <= rx_ipg + 8'd8;
      else if (xge_rx_data_sop)
        begin
          wr_rx_ipg(rx_ipg);
          rx_ipg <= 8'd0;
        end
    end
    
    
   



Link10G LinkMain (
.i_clk_50_mhz(i_free_clk),
.sys_rst(sys_rst),
.i_p_refckn_0(i_p_refckn_0),
.i_p_refckp_0(i_p_refckp_0),
.i_p_l0rxn(i_p_l0rxn),                               
.i_p_l0rxp(i_p_l0rxp),
.o_p_l0txn(o_p_l0txn),
.o_p_l0txp(o_p_l0txp),


.apb_paddr(apb_paddr),
.apb_psel (apb_psel),     
.apb_penable(apb_penable),  
.apb_pwrite(apb_pwrite),   
.apb_pwdata(apb_pwdata),   
.apb_pready(apb_pready),   
.apb_prdata(apb_prdata),

.xge_rx_data(xge_rx_data),
.xge_rx_data_en(xge_rx_data_en),
.xge_rx_data_sop(xge_rx_data_sop),
.xge_rx_data_eop(xge_rx_data_eop),
.xge_rx_data_byte_vaild(xge_rx_data_byte_vaild),
.xge_rx_data_err(xge_rx_data_err),


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
.sys_rst                 (sys_rst | (~syn_align)),
//.sys_rst                 (sys_rst ),
.tx_ready                (xgmii_tx_ready        ),
.tx_data                 (xge_tx_data           ),
.tx_data_en              (xge_tx_data_en        ),
.tx_data_sop             (xge_tx_data_sop       ),
.tx_data_eop             (xge_tx_data_eop       ),
.tx_data_byte_vaild      (xge_tx_data_byte_vaild)          
);


/*

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
    .clk                     (i_free_clk          ),
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

*/

task wr_tx_file;
input [63:0]  tx_data;
integer fd;
begin
fd = $fopen("./tx_data.txt","a+");
$fdisplay(fd,"%h",tx_data);
$fclose(fd);
end
endtask

task wr_rx_file;
input [63:0]  rx_data;
integer fd;
begin
fd = $fopen("./rx_data.txt","a+");
$fdisplay(fd,"%h",rx_data);
$fclose(fd);
end
endtask

task wr_rx_ipg;
input [7:0]  rx_ipg;
integer fd;
begin
fd = $fopen("./rx_ipg.txt","a+");
$fdisplay(fd,"%h",rx_ipg);
$fclose(fd);
end
endtask


GTP_GRS GRS_INST(
    .GRS_N(1'b1)
) ;




endmodule