// Created by IP Generator (Version 2023.2-SP1 build 147282)
// Instantiation Template
//
// Insert the following codes into your Verilog file.
//   * Change the_instance_name to your own instance name.
//   * Change the signal names in the port associations


Transceiver_10G the_instance_name (
  .i_free_clk(i_free_clk),                              // input
  .i_hpll_rst(i_hpll_rst),                              // input
  .i_hpll_wtchdg_clr(i_hpll_wtchdg_clr),                // input
  .i_hsst_fifo_clr_0(i_hsst_fifo_clr_0),                // input
  .i_loop_dbg_0(i_loop_dbg_0),                          // input [2:0]
  .o_hpll_wtchdg_st(o_hpll_wtchdg_st),                  // output [1:0]
  .o_hpll_done(o_hpll_done),                            // output
  .o_txlane_done_0(o_txlane_done_0),                    // output
  .o_rxlane_done_0(o_rxlane_done_0),                    // output
  .i_p_refckn_0(i_p_refckn_0),                          // input
  .i_p_refckp_0(i_p_refckp_0),                          // input
  .o_p_clk2core_tx_0(o_p_clk2core_tx_0),                // output
  .i_p_tx0_clk_fr_core(i_p_tx0_clk_fr_core),            // input
  .o_p_clk2core_rx_0(o_p_clk2core_rx_0),                // output
  .i_p_rx0_clk_fr_core(i_p_rx0_clk_fr_core),            // input
  .o_p_refck2core_0(o_p_refck2core_0),                  // output
  .o_p_hpll_lock(o_p_hpll_lock),                        // output
  .o_p_rx_sigdet_sta_0(o_p_rx_sigdet_sta_0),            // output
  .o_p_lx_cdr_align_0(o_p_lx_cdr_align_0),              // output
  .i_p_rxpcs_slip_0(i_p_rxpcs_slip_0),                  // input
  .i_p_pcs_nearend_loop_0(i_p_pcs_nearend_loop_0),      // input
  .i_p_pcs_farend_loop_0(i_p_pcs_farend_loop_0),        // input
  .i_p_pma_nearend_ploop_0(i_p_pma_nearend_ploop_0),    // input
  .i_p_pma_nearend_sloop_0(i_p_pma_nearend_sloop_0),    // input
  .i_p_pma_farend_ploop_0(i_p_pma_farend_ploop_0),      // input
  .i_p_cfg_clk(i_p_cfg_clk),                            // input
  .i_p_cfg_rst(i_p_cfg_rst),                            // input
  .i_p_cfg_psel(i_p_cfg_psel),                          // input
  .i_p_cfg_enable(i_p_cfg_enable),                      // input
  .i_p_cfg_write(i_p_cfg_write),                        // input
  .i_p_cfg_addr(i_p_cfg_addr),                          // input [15:0]
  .i_p_cfg_wdata(i_p_cfg_wdata),                        // input [7:0]
  .o_p_cfg_rdata(o_p_cfg_rdata),                        // output [7:0]
  .o_p_cfg_int(o_p_cfg_int),                            // output
  .o_p_cfg_ready(o_p_cfg_ready),                        // output
  .o_p_calib_done(o_p_calib_done),                      // output
  .i_p_l0rxn(i_p_l0rxn),                                // input
  .i_p_l0rxp(i_p_l0rxp),                                // input
  .o_p_l0txn(o_p_l0txn),                                // output
  .o_p_l0txp(o_p_l0txp),                                // output
  .i_txd_0(i_txd_0),                                    // input [63:0]
  .i_txq_0(i_txq_0),                                    // input [6:0]
  .i_txh_0(i_txh_0),                                    // input [1:0]
  .o_rxstatus_0(o_rxstatus_0),                          // output [5:0]
  .o_rxd_0(o_rxd_0),                                    // output [63:0]
  .o_rxh_0(o_rxh_0),                                    // output [1:0]
  .o_rxh_h_0(o_rxh_h_0),                                // output [1:0]
  .o_rxd_vld_0(o_rxd_vld_0),                            // output
  .o_rxd_vld_h_0(o_rxd_vld_h_0),                        // output
  .o_rxh_vld_0(o_rxh_vld_0),                            // output
  .o_rxh_vld_h_0(o_rxh_vld_h_0),                        // output
  .o_rxq_start_0(o_rxq_start_0)                         // output
);
