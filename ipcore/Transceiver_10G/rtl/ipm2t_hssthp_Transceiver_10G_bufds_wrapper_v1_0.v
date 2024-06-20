
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
`timescale 1ns/100fs

module ipm2t_hssthp_Transceiver_10G_bufds_wrapper_v1_0(
     //PAD
    input  wire             PAD_REFCLKP                   ,
    input  wire             PAD_REFCLKN                   ,
     //SRB
    input  wire             COM_POWERDOWN                 ,
    output wire             REFCLK_OUTP                   , 
    output wire             PMA_REFCLK_TO_FABRIC                     
);

//wire
GTP_HSSTHP_BUFDS #(
    .PMA_REG_REFCLK_FAB                              ("REFCLK"                  ),
    .PMA_REG_HPLL_REFCLK_PD                          ("ON"                      ),
    .PMA_REG_COM_PD                                  ("FALSE"                   ),
    .PMA_REG_COM_PD_OW                               ("FALSE"                   ),
    .PMA_CFG_COMMPOWERUP                             ( "ON"                     ) 
) U_BUFDS (
    //input ports
    .COM_POWERDOWN                                   (COM_POWERDOWN             ),
    .PAD_REFCLKP                                     (PAD_REFCLKP               ),
    .PAD_REFCLKN                                     (PAD_REFCLKN               ),
    //output ports
    .REFCLK_OUTP                                     (REFCLK_OUTP               ),
    .PMA_REFCLK_TO_FABRIC                            (PMA_REFCLK_TO_FABRIC      )
);

endmodule
