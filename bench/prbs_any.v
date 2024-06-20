module prbs_any
#(
parameter  DATA_WIDTH               = 16         ,
parameter  PRBS_CHECK               =0           
)
(
input                                   clk      ,
input                                   rst      ,
input      [DATA_WIDTH-1:0]              data_in  ,
input                                   en       ,
output reg [DATA_WIDTH-1:0]              data_out
);

wire  [1:31]  prbs_data[DATA_WIDTH:0];
wire  [DATA_WIDTH-1:0] prbs_gen1;
wire  [DATA_WIDTH-1:0] prbs_gen2;
wire  [DATA_WIDTH:1]   prbs_check;
reg   [1:31]  prbs_data_reg; 

assign prbs_data[0] = prbs_data_reg;

genvar i;
generate for (i=0 ; i< DATA_WIDTH;i=i+1) begin : prbs_gen
  assign prbs_gen1[i] = prbs_data[i][3] ^ prbs_data[i][31];
  assign prbs_gen2[i] = prbs_gen1[i] ^ data_in[i];
  assign prbs_check[i+1] = PRBS_CHECK ? data_in[i] : prbs_gen1[i];
  assign prbs_data[i+1] = {prbs_check[i+1],prbs_data[i][1:30]};
  end
endgenerate

always @ (posedge clk)
  begin
    if (rst)
      begin
        data_out <= {DATA_WIDTH{1'b1}};
        prbs_data_reg <= {31{1'b1}};
      end
    else if (en)
      begin
        data_out <= prbs_gen2;
        prbs_data_reg <= prbs_data[DATA_WIDTH];
      end
  end
endmodule