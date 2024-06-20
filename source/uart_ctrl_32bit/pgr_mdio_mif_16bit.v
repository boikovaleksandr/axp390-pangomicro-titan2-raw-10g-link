//******************************************************************
// Copyright (c) 2014 PANGO MICROSYSTEMS, INC
// ALL RIGHTS REVERVED.
//******************************************************************
`timescale 1ns/1ns
module pgr_mdio_mif_16bit #(
    parameter  MDC_DIV = 8'd20,
    parameter  AW = 8'd24,
    parameter  DW = 8'd32
)
(
    input               clk              ,
    input               rst_n            ,

    input       [AW-1:0]  addr             ,
    input       [DW-1:0]  data             ,
    input               cmd_en           ,
    output  reg         cmd_done         ,

    output  reg [7:0]   fifo_data        ,
    input               fifo_data_valid  ,
    output  reg         fifo_data_req    ,

    output  wire        mdc_pos          ,

    output  reg         mdc              ,
    input   wire        mdi              ,
    output  reg         mdo              ,
    output  reg         mdo_en
);

localparam  E_IDLE  = 4'd0;
localparam  E_PRE   = 4'd1;
localparam  E_ST    = 4'd2;
localparam  E_OP    = 4'd3;
localparam  E_AD1   = 4'd4;
localparam  E_AD2   = 4'd5;
localparam  E_TA0   = 4'd6;
localparam  E_TA1   = 4'd7;
localparam  E_DATA  = 4'd8;

reg  [3:0]   cnt              ;
reg  [1:0]   st               ;
reg  [1:0]   op               ;
reg  [4:0]   ad_part1         ; //phyad or prtad
reg  [4:0]   ad_part2         ; //regad or devad
reg  [15:0]  wdata            ;
reg          fsm_sta          ;

reg  [3:0]   MDIO_CS          ;
reg  [3:0]   MDIO_NS          ;
reg  [15:0]  rdata            ;
wire         mdio_rd          ;
reg  [7:0]   clk_div_cnt      ;
wire         mdc_inv          ;
//wire         mdc_pos          ;



always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        st       <= 2'b01;
        op       <= 2'b10;
        ad_part1 <= 5'b00000;
        ad_part2 <= 5'b00000;
    end
    else if(cmd_en)
    begin
        st       <= addr[19:18];
        op       <= addr[17:16];
        ad_part1 <= addr[12:8];
        ad_part2 <= addr[4:0];
    end
end

assign mdio_rd = ((st == 2'b00) && ((op == 2'b10) || (op == 2'b11))) || ((st == 2'b01) && (op == 2'b10));

always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
        wdata <= 16'b0;
    else if(cmd_en)
        wdata <= data[15:0];
    else;
end

always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
        fsm_sta <= 1'b0;
    else if(cmd_en)
        fsm_sta <= 1'b1;
    else if(fsm_sta && mdc_pos)
        fsm_sta <= 1'b0;
    else;
end

always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
        clk_div_cnt <= 8'b0;
    else if(mdc_inv)
        clk_div_cnt <= 8'b0;
    else
        clk_div_cnt <= clk_div_cnt + 8'b1;
end

assign mdc_inv = (clk_div_cnt == MDC_DIV);

always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
        mdc <= 1'b0;
    else if(mdc_inv)
        mdc <= ~mdc;
    else;
end

assign mdc_pos = mdc_inv & (~mdc);

//************************************************************ main code ************************************************************************************

//1st always block, sequential state transition
always @(posedge clk or negedge rst_n)
begin
  if(!rst_n)
     MDIO_CS <= E_IDLE;
  else if(mdc_pos)
     MDIO_CS <= MDIO_NS;
  else;
end

//2nd always block,combinational codition judgment
always @( * )
begin
   case(MDIO_CS)
      E_IDLE:begin
         if(fsm_sta)
            MDIO_NS = E_PRE;
         else
            MDIO_NS = E_IDLE;
      end
      E_PRE:begin
         if(cnt == 4'd15)
            MDIO_NS = E_ST;
         else
            MDIO_NS = E_PRE;
      end
      E_ST:begin
         if(cnt == 4'd1)
            MDIO_NS = E_OP;
         else
            MDIO_NS = E_ST;
      end
      E_OP:begin
         if(cnt == 4'd1)
            MDIO_NS = E_AD1;
         else
            MDIO_NS = E_OP;
      end
      E_AD1:begin
         if(cnt == 4'd4)
            MDIO_NS = E_AD2;
         else
            MDIO_NS = E_AD1;
      end
      E_AD2:begin
         if(cnt == 4'd4)
            MDIO_NS = E_TA0;
         else
            MDIO_NS = E_AD2;
      end
      E_TA0:begin
         MDIO_NS = E_TA1;
      end
      E_TA1:begin
         MDIO_NS = E_DATA;
      end
      E_DATA:begin
         if(cnt==4'd15)
            MDIO_NS = E_IDLE;
         else
            MDIO_NS = E_DATA;
      end
      default:begin
         MDIO_NS = E_IDLE;
      end
   endcase
end

always @(posedge clk or negedge rst_n)
begin
  if(!rst_n)
      cnt <= 4'd0;
  else if(mdc_pos)
      if(MDIO_CS != MDIO_NS)
         cnt <= 4'd0;
      else
         cnt <= cnt + 4'd1;
  else;
end

//3rd always block,sequential FSM output
always @( posedge clk or negedge rst_n)
begin
   if(!rst_n)
   begin
      mdo    <= 1'b1;
      mdo_en <= 1'b1;
      rdata  <= 16'd0;
   end
   else if(mdc_pos)
   begin
      case(MDIO_CS)
         E_IDLE:
         begin
            mdo    <= 1'b1;
            mdo_en <= 1'b1;
         end
         E_PRE:
         begin
            mdo    <= 1'b1;
         end
         E_ST:
         begin
            mdo <= st[4'd1 - cnt];
         end
         E_OP:
         begin
            mdo <= op[4'd1 - cnt];
         end
         E_AD1:
         begin
            mdo <= ad_part1[4'd4 - cnt];
         end
         E_AD2:
         begin
            mdo <= ad_part2[4'd4 - cnt];
         end
         E_TA0:
         begin
            mdo <= 1'b1;
            if(mdio_rd)
               mdo_en <= 1'b0;
            else
               mdo_en <= 1'b1;
         end
         E_TA1:
         begin
            mdo <= 1'b0;
         end
         E_DATA:
         begin
            mdo <= wdata[4'd15 - cnt];
            if(mdio_rd)
               rdata <= {rdata[14:0],mdi};
            else
               rdata <= 16'd0;
         end
         default:
         begin
            mdo    <= 1'b1;
            mdo_en <= 1'b1;
            rdata  <= 16'd0;
         end
      endcase
   end
   else;
end

//while mdio frame is complete,the cmd_done will be one for one period
reg [31:0] rdata_vld;
reg rdata_en;
reg [2:0] cnt1;

always @(posedge clk or negedge rst_n)
begin
  if(!rst_n)
      cnt1 <= 3'b0;
  else if(cnt1 == 3'd4)
      cnt1 <= 3'b0;
  else if(rdata_en && fifo_data_valid)
      cnt1 <= cnt1 + 1'b1;
end

always @(posedge clk or negedge rst_n)
begin
  if(!rst_n)
      rdata_vld <= 32'b0;
  else if(cmd_done && mdio_rd)
      rdata_vld <= {16'b0,rdata};
  else if(rdata_en && fifo_data_valid)
      rdata_vld <= {8'b0, rdata_vld[31:8]};
end

always @(posedge clk or negedge rst_n)
begin
  if(!rst_n)
      cmd_done <= 1'b0;
  else if((MDIO_CS == E_DATA) && (MDIO_NS == E_IDLE) && mdc_pos)
      cmd_done <= 1'b1;
  else
      cmd_done <= 1'b0;
end

always @(posedge clk or negedge rst_n)
begin
  if(!rst_n)
      rdata_en <= 1'b0;
  else if(cnt1 == 3'd4)
      rdata_en <= 1'b0;
  else if(cmd_done && mdio_rd)
      rdata_en <= 1'b1;
end

always @(posedge clk or negedge rst_n)
begin
  if(!rst_n)
  begin
      fifo_data <= 8'b0;
      fifo_data_req <= 1'b0;
  end
  else if(cnt1 == 3'd4)
  begin
      fifo_data <= 8'b0;
      fifo_data_req <= 1'b0;
  end
  else if(rdata_en && fifo_data_valid)
  begin
      fifo_data <= rdata_vld[7:0];
      fifo_data_req <= 1'b1;
  end
  else
  begin
      fifo_data <= 8'b0;
      fifo_data_req <= 1'b0;
  end
end

endmodule //pgr_apb_mif
