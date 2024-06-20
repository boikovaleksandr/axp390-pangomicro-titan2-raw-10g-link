module reg_union_bridge_top(

    input               apb_clk,   
    input               apb_rst_n,   
    // wrapper APB Interface
    input   [18:0]      apb_paddr,    // APB address
    input               apb_psel,     // APB Select 
    input               apb_penable,  // APB Enable 
    input               apb_pwrite,   // APB Direction 
    input   [31:0]      apb_pwdata,   // APB write data
    output              apb_pready,   // APB Ready 
    output  [31:0]      apb_prdata,   // APB read data
    //BaseR Core APB Interface
    output  [18:0]      mac_paddr,
    output              mac_pwrite,
    output              mac_psel,
    output              mac_penable,
    output  [31:0]      mac_pwdata,
    input   [31:0]      mac_prdata,
    // HSST APB Interface
    output  [18:0]      pcs_paddr,
    output              pcs_pwrite,
    output              pcs_penable,
    output  [31:0]      pcs_pwdata,
    output              pcs_psel,     
    input   [31:0]      pcs_prdata,
    input               pcs_pready           
);

//****************************************************************************//
//                      Parameter and Define                                  //
//****************************************************************************//

//****************************************************************************//
//                      Internal Signal                                       //
//****************************************************************************//

reg         mac_pready;
reg [1:0]   mac_enable_cnt ;


//****************************************************************************//
//                      Sequential and Logic                                  //
//****************************************************************************//

assign mac_paddr   = (apb_paddr[17] == 1'b1) ? apb_paddr[18:0] : 19'b0 ;
assign mac_pwrite  = (apb_paddr[17] == 1'b1) ? apb_pwrite : 1'b0 ;
assign mac_psel    = (apb_paddr[17] == 1'b1) ? apb_psel : 1'b0;
assign mac_penable = (apb_paddr[17] == 1'b1) ? apb_penable : 1'b0;
assign mac_pwdata  = (apb_paddr[17] == 1'b1) ? apb_pwdata : 32'b0;

assign pcs_paddr   = (apb_paddr[17] == 1'b0) ? apb_paddr[18:0] : 19'h0;
assign pcs_pwrite  = (apb_paddr[17] == 1'b0) ? apb_pwrite  : 1'b0;
assign pcs_penable = (apb_paddr[17] == 1'b0) ? apb_penable : 1'b0;
assign pcs_pwdata  = (apb_paddr[17] == 1'b0) ? apb_pwdata[31:0] : 32'b0;
assign pcs_psel    = (apb_paddr[17] == 1'b0) ? apb_psel : 1'b0;

assign apb_prdata  = (apb_paddr[17] == 1'b1) ? mac_prdata : pcs_prdata[31:0];
assign apb_pready  = (apb_paddr[17] == 1'b1) ? mac_pready: pcs_pready;

always @ (posedge apb_clk or negedge apb_rst_n) begin
      if(!apb_rst_n)
	     mac_enable_cnt <= 2'b0;
	  else if(apb_paddr[17] == 1'b1 && apb_penable==1'b1 && apb_psel==1'b1)
	     mac_enable_cnt <= mac_enable_cnt + 2'b1;
	  else 
	     mac_enable_cnt <= 2'b0;
end

always @ (posedge apb_clk or negedge apb_rst_n) begin
     if(!apb_rst_n)
	    mac_pready <= 1'b0;
     else if(apb_penable==1'b1) begin
	    if(apb_pwrite == 1'b1)
	        mac_pready <= 1'b1;
        else if(mac_enable_cnt == 2'd2)
	        mac_pready <= 1'b1;
        else
	        mac_pready <= 1'b0;
     end
	 else 
	    mac_pready <= 1'b0;
end

endmodule