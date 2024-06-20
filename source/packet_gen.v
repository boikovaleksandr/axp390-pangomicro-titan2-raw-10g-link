module packet_gen
(
input                 sys_clk                 ,
input                 sys_rst                 ,
input                 tx_ready                ,

output reg [63:0]     tx_data                 ,
output reg            tx_data_en              ,
output reg            tx_data_sop             ,
output reg            tx_data_eop             ,
output reg [2:0]      tx_data_byte_vaild                 
);

reg        [7:0]      clk_cnt                 ;
wire       [7:0]      random_len              ;
wire       [2:0]      random_byte_vaild       ;
wire       [2:0]      random_byte_vaild_tmp   ;
reg        [7:0]      packet_len              ;

wire sys_rst_d ;
//rst_syn gen_rst_syn
//    (
//    .clk(sys_clk),                  // input
//    .rst_in(sys_rst),    // input
//    .rst_out(sys_rst_d)        // output
//);
assign sys_rst_d = sys_rst ;


// initial 
  // begin
    // forever #25.6 random_len = 5+{$random}%195;
  // end

// initial 
  // begin
    // forever #25.6 random_byte_vaild = {$random}%7;
  // end
prbs_any #(3,0 )prbs_any3
(
.clk      (sys_clk   ),
.rst      (sys_rst_d   ),
.data_in  (3'd0      ),
.en       (1'b1      ),
.data_out (random_byte_vaild)
);  
//assign random_byte_vaild = (random_byte_vaild_tmp > 4'd8) ? 4'd8 : random_byte_vaild_tmp ;
prbs_any #(8,0 )prbs_any7
(
.clk      (sys_clk   ),
.rst      (sys_rst_d   ),
.data_in  (8'd8      ),
.en       (1'b1      ),
.data_out (random_len)
);  
always @ (posedge sys_clk)
  if (sys_rst_d)
    clk_cnt <= 8'd0;
  else if (tx_ready)
    begin
      if (clk_cnt == (packet_len + 8'd2))
        clk_cnt <= 8'd0;
      else
        clk_cnt <= clk_cnt + 8'd1;
    end
  else
    clk_cnt <= clk_cnt;
    
always @ (posedge sys_clk)
  if (sys_rst_d)
    packet_len <= 8'd2;
  else if (clk_cnt == 8'd1)
    if (random_len < 8'd100)
      packet_len <= random_len + 8'd120;
    else if (random_len > 8'd253)
      packet_len <= random_len - 8'd3;
    else 
      packet_len <= random_len ;
  else
    packet_len <= packet_len;

//always @ (posedge sys_clk)
//  if (sys_rst_d)
//    packet_len <= 8'd2;
//  else if (clk_cnt == 8'd1)
//     if (random_len > 8'd8)
//      packet_len <= 8'd7;
//    else 
//      packet_len <= random_len ;
//  else
//    packet_len <= packet_len;
    
always @ (posedge sys_clk)
  if (sys_rst_d)
    begin
      tx_data             <= 64'd0;
      tx_data_en          <= 1'd0;
      tx_data_sop         <= 1'd0;
      tx_data_eop         <= 1'd0;
      tx_data_byte_vaild  <= 3'd0;
    end
  else if (tx_ready)
    begin
      if (clk_cnt == 8'd0)
        begin
          tx_data             <= 64'd0;
          tx_data_en          <= 1'd0;
          tx_data_sop         <= 1'd0;
          tx_data_eop         <= 1'd0;
          tx_data_byte_vaild  <= 3'd0;
        end
      else if (clk_cnt == 8'd1)
//      else if (clk_cnt == 8'd50)
        begin
          tx_data             <= {57'd0,random_len};
          tx_data_en          <= 1'd1;
          tx_data_sop         <= 1'd1;
          tx_data_eop         <= 1'd0;
          tx_data_byte_vaild  <= 3'd0;
        end
      else if (clk_cnt == 8'd2)
//      else if (clk_cnt == 8'd51)
        begin
          tx_data             <= 64'hffffffffffffffff;
          tx_data_en          <= 1'd1;
          tx_data_sop         <= 1'd0;
          tx_data_eop         <= 1'd0;
          tx_data_byte_vaild  <= 3'd0;
        end
      else if (clk_cnt == (packet_len + 8'd1))
        begin
          tx_data             <= 64'haaaaaaaaaaaaaaaa;
          tx_data_en          <= 1'd1;
          tx_data_sop         <= 1'd0;
          tx_data_eop         <= 1'd1;
          tx_data_byte_vaild  <= random_byte_vaild;
//          tx_data_byte_vaild  <= 3'd5;
        end
      else if (clk_cnt == (packet_len + 8'd2))
        begin
          tx_data             <= 64'h0;
          tx_data_en          <= 1'd0;
          tx_data_sop         <= 1'd0;
          tx_data_eop         <= 1'd0;
          tx_data_byte_vaild  <= 3'd0;
        end
//      else  if (clk_cnt > 8'd51)
      else  
        begin
          tx_data             <= 64'd0;
          tx_data_en          <= 1'd1;
          tx_data_sop         <= 1'd0;
          tx_data_eop         <= 1'd0;
          tx_data_byte_vaild  <= 3'd0;
        end
    end
  else
    begin
      tx_data             <= 64'd0;
      tx_data_en          <= 1'd0;
      tx_data_sop         <= 1'd0;
      tx_data_eop         <= 1'd0;
      tx_data_byte_vaild  <= 3'd0;
    end
endmodule