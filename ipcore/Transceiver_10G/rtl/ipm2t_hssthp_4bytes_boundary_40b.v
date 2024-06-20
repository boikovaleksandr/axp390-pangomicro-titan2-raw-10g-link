///////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2019 PANGO MICROSYSTEMS, INC
// ALL RIGHTS REVERVED.
//
// THE SOURCE CODE CONTAINED HEREIN IS PROPRIETARY TO PANGO MICROSYSTEMS, INC.
// IT SHALL NOT BE REPRODUCED OR DISCLOSED IN WHOLE OR IN PART OR USED BY
// PARTIES WITHOUT WRITTEN AUTHORIZATION FROM THE OWNER.
//
///////////////////////////////////////////////////////////////////////////////
//
// Library:
// Filename:
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
module ipm2t_hssthp_4bytes_boundary_40b(
    input  wire          clk                    ,
    input  wire          rst_n                  ,
    input  wire          enable                 ,
    input  wire          cfg_8b10b_dec_en       , 
    input  wire  [7 :0]  cfg_comma_reg0         , 
    input  wire  [1 :0]  cfg_data_width         , 
    input  wire  [79:0]  i_rxd                  , 
    input  wire  [7 :0]  i_rxk                  , 
    input  wire  [7 :0]  i_rdisper              , 
    input  wire  [7 :0]  i_rdecer               , 
    output reg   [79:0]  o_align_rxd            , 
    output reg   [7 :0]  o_align_rxk            , 
    output reg   [7 :0]  o_align_rdisper        , 
    output reg   [7 :0]  o_align_rdecer         , 
    output reg           o_pcs_word_align_en    , 
    output reg           o_comma_aligned       
);

reg  [79:0]   i_rxd_ff1;
reg  [7 :0]   i_rxk_ff1;
reg  [7 :0]   i_rdisper_ff1;
reg  [7 :0]   i_rdecer_ff1 ;

reg  [7 :0]   comma_ind_byte;
reg  [7 :0]   comma_ind_byte_ff1;

wire [3 :0]   comma_ind_l;
wire [3 :0]   comma_ind_h;
wire [3 :0]   comma_ind;

reg  [31:0]   align_rxd_l;
reg  [3 :0]   align_rxk_l;
reg  [3 :0]   align_rdisper_l;
reg  [3 :0]   align_rdecer_l;
wire [31:0]   align_rxd_nxt_l;
wire [3 :0]   align_rxk_nxt_l;
wire [3 :0]   align_rdisper_nxt_l;
wire [3 :0]   align_rdecer_nxt_l;
reg  [31:0]   align_rxd_h;
reg  [3 :0]   align_rxk_h;
reg  [3 :0]   align_rdisper_h;
reg  [3 :0]   align_rdecer_h;
wire [31:0]   align_rxd_nxt_h;
wire [3 :0]   align_rxk_nxt_h;
wire [3 :0]   align_rdisper_nxt_h;
wire [3 :0]   align_rdecer_nxt_h;

//delay input data and control code
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i_rxd_ff1       <= 80'd0;
        i_rxk_ff1       <= 8'd0;
        i_rdisper_ff1   <= 8'd0;
        i_rdecer_ff1    <= 8'd0;
    end
    else begin
        i_rxd_ff1       <= i_rxd;
        i_rxk_ff1       <= i_rxk;
        i_rdisper_ff1   <= i_rdisper;
        i_rdecer_ff1    <= i_rdecer;
    end
end

//generate comma byte indication base input data
integer i0;
always @ (*) begin
    for (i0=0; i0<=7; i0=i0+1) begin
        if (enable) begin
           if (i_rxk[i0]==1'b1) begin//k code
               if (i_rdisper[i0]==1'b0 && i_rdecer[i0]==1'b0)
                  comma_ind_byte[i0] = (i_rxd[i0*8+:8] == cfg_comma_reg0);//no disparity and decode error
               else
                  comma_ind_byte[i0] = 1'b0;
           end
           else
              comma_ind_byte[i0] = 1'b0;
        end
        else begin
           comma_ind_byte[i0] = 1'b0;
        end
    end
end

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) 
        comma_ind_byte_ff1 <= 8'b0;    
    else if (|comma_ind_byte)
        comma_ind_byte_ff1 <= comma_ind_byte; 
    else ;
end

assign comma_ind_l = comma_ind_byte_ff1[3:0];//low 32bit comma indication
assign comma_ind_h = comma_ind_byte_ff1[7:4];//high 32bit comma indication

assign comma_ind = |comma_ind_h ? comma_ind_h : comma_ind_l; //gen comma ind when comma in high 32bit

//accord comma byte indication, split and meger output data
always @ (*) begin
    if (cfg_data_width==2'b00) begin//32bit
        if (comma_ind_l[3]==1'b1) begin
            align_rxd_l     = {i_rxd[0*8+:3*8],i_rxd_ff1[3*8+:1*8]};
            align_rxk_l     = {i_rxk[0+:3],i_rxk_ff1[3+:1]};
            align_rdisper_l = {i_rdisper[0+:3],i_rdisper_ff1[3+:1]};
            align_rdecer_l  = {i_rdecer[0+:3],i_rdecer_ff1[3+:1]};
        end
        else if (comma_ind_l[2]==1'b1) begin
            align_rxd_l     = {i_rxd[0*8+:2*8],i_rxd_ff1[2*8+:2*8]};
            align_rxk_l     = {i_rxk[0+:2],i_rxk_ff1[2+:2]};
            align_rdisper_l = {i_rdisper[0+:2],i_rdisper_ff1[2+:2]};
            align_rdecer_l  = {i_rdecer[0+:2],i_rdecer_ff1[2+:2]};
        end
        else if (comma_ind_l[1]==1'b1) begin
            align_rxd_l     = {i_rxd[0*8+:1*8],i_rxd_ff1[1*8+:3*8]};
            align_rxk_l     = {i_rxk[0+:1],i_rxk_ff1[1+:3]};
            align_rdisper_l = {i_rdisper[0+:1],i_rdisper_ff1[1+:3]};
            align_rdecer_l  = {i_rdecer[0+:1],i_rdecer_ff1[1+:3]};
        end
        else begin
            align_rxd_l     = i_rxd_ff1[0+:4*8];
            align_rxk_l     = i_rxk_ff1[0+:4];
            align_rdisper_l = i_rdisper_ff1[0+:4];
            align_rdecer_l  = i_rdecer_ff1[0+:4];
        end
    end
    else if (cfg_data_width==2'b10) begin //64bit
        if (comma_ind[3]==1'b1) begin
            align_rxd_l     = {i_rxd_ff1[3*8+:4*8]};//align byte3 of low 32bit
            align_rxk_l     = {i_rxk_ff1[3+:4]};
            align_rdisper_l = {i_rdisper_ff1[3+:4]};
            align_rdecer_l  = {i_rdecer_ff1[3+:4]};
        end
        else if (comma_ind[2]==1'b1) begin
            align_rxd_l     = {i_rxd_ff1[2*8+:4*8]};//align byte2 of low 32bit
            align_rxk_l     = {i_rxk_ff1[2+:4]};
            align_rdisper_l = {i_rdisper_ff1[2+:4]};
            align_rdecer_l  = {i_rdecer_ff1[2+:4]};
        end
        else if (comma_ind[1]==1'b1) begin
            align_rxd_l     = {i_rxd_ff1[1*8+:4*8]};//align byte1 of low 32bit
            align_rxk_l     = {i_rxk_ff1[1+:4]};
            align_rdisper_l = {i_rdisper_ff1[1+:4]};
            align_rdecer_l  = {i_rdecer_ff1[1+:4]};
        end
        else begin
            align_rxd_l     = i_rxd_ff1[0+:4*8];//align byte0 of low 32bit
            align_rxk_l     = i_rxk_ff1[0+:4];
            align_rdisper_l = i_rdisper_ff1[0+:4];
            align_rdecer_l  = i_rdecer_ff1[0+:4];
        end
    end
    else begin
         align_rxd_l     = i_rxd_ff1[0+:4*8];
         align_rxk_l     = i_rxk_ff1[0+:4];
         align_rdisper_l = i_rdisper_ff1[0+:4];
         align_rdecer_l  = i_rdecer_ff1[0+:4];
    end
end


always @ (*) begin //64bit
    if (comma_ind[3]==1'b1) begin
         align_rxd_h     = {i_rxd[0*8+:3*8],i_rxd_ff1[7*8+:1*8]};//align byte3 of high 32bit
         align_rxk_h     = {i_rxk[0+:3],i_rxk_ff1[7+:1]};      
         align_rdisper_h = {i_rdisper[0+:3],i_rdisper_ff1[7+:1]};
         align_rdecer_h  = {i_rdecer[0+:3],i_rdecer_ff1[7+:1]};
    end
    else if (comma_ind[2]==1'b1) begin
         align_rxd_h     = {i_rxd[0*8+:2*8],i_rxd_ff1[6*8+:2*8]};//align byte2 of high 32bit
         align_rxk_h     = {i_rxk[0+:2],i_rxk_ff1[6+:2]};
         align_rdisper_h = {i_rdisper[0+:2],i_rdisper_ff1[6+:2]};
         align_rdecer_h  = {i_rdecer[0+:2],i_rdecer_ff1[6+:2]};
    end
    else if (comma_ind[1]==1'b1) begin
         align_rxd_h     = {i_rxd[0*8+:1*8],i_rxd_ff1[5*8+:3*8]};//align byte1 of high 32bit
         align_rxk_h     = {i_rxk[0+:1],i_rxk_ff1[5+:3]};
         align_rdisper_h = {i_rdisper[0+:1],i_rdisper_ff1[5+:3]};
         align_rdecer_h  = {i_rdecer[0+:1],i_rdecer_ff1[5+:3]};
    end
    else begin//align byte0 of high 32bit
         align_rxd_h     = i_rxd_ff1[4*8+:4*8];
         align_rxk_h     = i_rxk_ff1[4+:4];
         align_rdisper_h = i_rdisper_ff1[4+:4];
         align_rdecer_h  = i_rdecer_ff1[4+:4];
    end
end

//control hsst pcs finish the comma byte align
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) 
        o_pcs_word_align_en <= 1'b0;
    else if (enable)
        o_pcs_word_align_en <= o_comma_aligned ? 1'b0 : 1'b1;
    else
        o_pcs_word_align_en <= 1'b0;
end

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n)
        o_comma_aligned <= 1'b0;
    else if (enable) begin
        if (|comma_ind_byte_ff1)
            o_comma_aligned <= 1'b1;
        else ;
    end
    else
        o_comma_aligned <= 1'b0;
end

//process 64bit abort
assign align_rxd_nxt_h      = (cfg_data_width[1]==1'b1) ? align_rxd_h     : 32'd0;
assign align_rxk_nxt_h      = (cfg_data_width[1]==1'b1) ? align_rxk_h     : 4'd0;
assign align_rdisper_nxt_h  = (cfg_data_width[1]==1'b1) ? align_rdisper_h : 4'd0;
assign align_rdecer_nxt_h   = (cfg_data_width[1]==1'b1) ? align_rdecer_h  : 4'd0;

assign align_rxd_nxt_l      = (cfg_data_width==2'b00 || cfg_data_width==2'b10) ? align_rxd_l     : 32'd0; 
assign align_rxk_nxt_l      = (cfg_data_width==2'b00 || cfg_data_width==2'b10) ? align_rxk_l     : 4'd0;
assign align_rdisper_nxt_l  = (cfg_data_width==2'b00 || cfg_data_width==2'b10) ? align_rdisper_l : 4'd0;
assign align_rdecer_nxt_l   = (cfg_data_width==2'b00 || cfg_data_width==2'b10) ? align_rdecer_l  : 4'd0;

//genrate output meger data
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_align_rxd      <= 80'd0; 
        o_align_rxk      <= 8'd0;
        o_align_rdisper  <= 8'd0;
        o_align_rdecer   <= 8'd0; 
    end
    else if (cfg_8b10b_dec_en) begin
        o_align_rxd      <= {16'b0,align_rxd_nxt_h,align_rxd_nxt_l}; 
        o_align_rxk      <= {align_rxk_nxt_h,align_rxk_nxt_l};
        o_align_rdisper  <= {align_rdisper_nxt_h,align_rdisper_nxt_l};
        o_align_rdecer   <= {align_rdecer_nxt_h,align_rdecer_nxt_l}; 
    end
    else begin
        o_align_rxd      <= i_rxd;    
        o_align_rxk      <= i_rxk;   
        o_align_rdisper  <= i_rdisper;
        o_align_rdecer   <= i_rdecer;
    end
end

endmodule
