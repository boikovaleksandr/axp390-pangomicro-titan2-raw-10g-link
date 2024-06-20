wire p_calib_done;//use to control HSSTHP IP Reset Port
ipm2t_hssthp_Transceiver_10G_hpll_wrapper_v1_6 U_CALIB_WRAP (
    .P_CFG_RST_HPLL        (P_CFG_RST_HPLL        ),//input
    .P_CFG_CLK_HPLL        (P_CFG_CLK_HPLL        ),//input
    .p_calib_en            (1'b1                  ),//input
    .p_calib_done          (p_calib_done          ) //output
);
