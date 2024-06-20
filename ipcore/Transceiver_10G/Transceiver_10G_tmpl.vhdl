-- Created by IP Generator (Version 2023.2-SP1 build 147282)
-- Instantiation Template
--
-- Insert the following codes into your VHDL file.
--   * Change the_instance_name to your own instance name.
--   * Change the net names in the port map.


COMPONENT Transceiver_10G
  PORT (
    i_free_clk : IN STD_LOGIC;
    i_hpll_rst : IN STD_LOGIC;
    i_hpll_wtchdg_clr : IN STD_LOGIC;
    i_hsst_fifo_clr_0 : IN STD_LOGIC;
    i_loop_dbg_0 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    o_hpll_wtchdg_st : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    o_hpll_done : OUT STD_LOGIC;
    o_txlane_done_0 : OUT STD_LOGIC;
    o_rxlane_done_0 : OUT STD_LOGIC;
    i_p_refckn_0 : IN STD_LOGIC;
    i_p_refckp_0 : IN STD_LOGIC;
    o_p_clk2core_tx_0 : OUT STD_LOGIC;
    i_p_tx0_clk_fr_core : IN STD_LOGIC;
    o_p_clk2core_rx_0 : OUT STD_LOGIC;
    i_p_rx0_clk_fr_core : IN STD_LOGIC;
    o_p_refck2core_0 : OUT STD_LOGIC;
    o_p_hpll_lock : OUT STD_LOGIC;
    o_p_rx_sigdet_sta_0 : OUT STD_LOGIC;
    o_p_lx_cdr_align_0 : OUT STD_LOGIC;
    i_p_rxpcs_slip_0 : IN STD_LOGIC;
    i_p_pcs_nearend_loop_0 : IN STD_LOGIC;
    i_p_pcs_farend_loop_0 : IN STD_LOGIC;
    i_p_pma_nearend_ploop_0 : IN STD_LOGIC;
    i_p_pma_nearend_sloop_0 : IN STD_LOGIC;
    i_p_pma_farend_ploop_0 : IN STD_LOGIC;
    i_p_cfg_clk : IN STD_LOGIC;
    i_p_cfg_rst : IN STD_LOGIC;
    i_p_cfg_psel : IN STD_LOGIC;
    i_p_cfg_enable : IN STD_LOGIC;
    i_p_cfg_write : IN STD_LOGIC;
    i_p_cfg_addr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    i_p_cfg_wdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    o_p_cfg_rdata : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    o_p_cfg_int : OUT STD_LOGIC;
    o_p_cfg_ready : OUT STD_LOGIC;
    o_p_calib_done : OUT STD_LOGIC;
    i_p_l0rxn : IN STD_LOGIC;
    i_p_l0rxp : IN STD_LOGIC;
    o_p_l0txn : OUT STD_LOGIC;
    o_p_l0txp : OUT STD_LOGIC;
    i_txd_0 : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    i_txq_0 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    i_txh_0 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    o_rxstatus_0 : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
    o_rxd_0 : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    o_rxh_0 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    o_rxh_h_0 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    o_rxd_vld_0 : OUT STD_LOGIC;
    o_rxd_vld_h_0 : OUT STD_LOGIC;
    o_rxh_vld_0 : OUT STD_LOGIC;
    o_rxh_vld_h_0 : OUT STD_LOGIC;
    o_rxq_start_0 : OUT STD_LOGIC
  );
END COMPONENT;


the_instance_name : Transceiver_10G
  PORT MAP (
    i_free_clk => i_free_clk,
    i_hpll_rst => i_hpll_rst,
    i_hpll_wtchdg_clr => i_hpll_wtchdg_clr,
    i_hsst_fifo_clr_0 => i_hsst_fifo_clr_0,
    i_loop_dbg_0 => i_loop_dbg_0,
    o_hpll_wtchdg_st => o_hpll_wtchdg_st,
    o_hpll_done => o_hpll_done,
    o_txlane_done_0 => o_txlane_done_0,
    o_rxlane_done_0 => o_rxlane_done_0,
    i_p_refckn_0 => i_p_refckn_0,
    i_p_refckp_0 => i_p_refckp_0,
    o_p_clk2core_tx_0 => o_p_clk2core_tx_0,
    i_p_tx0_clk_fr_core => i_p_tx0_clk_fr_core,
    o_p_clk2core_rx_0 => o_p_clk2core_rx_0,
    i_p_rx0_clk_fr_core => i_p_rx0_clk_fr_core,
    o_p_refck2core_0 => o_p_refck2core_0,
    o_p_hpll_lock => o_p_hpll_lock,
    o_p_rx_sigdet_sta_0 => o_p_rx_sigdet_sta_0,
    o_p_lx_cdr_align_0 => o_p_lx_cdr_align_0,
    i_p_rxpcs_slip_0 => i_p_rxpcs_slip_0,
    i_p_pcs_nearend_loop_0 => i_p_pcs_nearend_loop_0,
    i_p_pcs_farend_loop_0 => i_p_pcs_farend_loop_0,
    i_p_pma_nearend_ploop_0 => i_p_pma_nearend_ploop_0,
    i_p_pma_nearend_sloop_0 => i_p_pma_nearend_sloop_0,
    i_p_pma_farend_ploop_0 => i_p_pma_farend_ploop_0,
    i_p_cfg_clk => i_p_cfg_clk,
    i_p_cfg_rst => i_p_cfg_rst,
    i_p_cfg_psel => i_p_cfg_psel,
    i_p_cfg_enable => i_p_cfg_enable,
    i_p_cfg_write => i_p_cfg_write,
    i_p_cfg_addr => i_p_cfg_addr,
    i_p_cfg_wdata => i_p_cfg_wdata,
    o_p_cfg_rdata => o_p_cfg_rdata,
    o_p_cfg_int => o_p_cfg_int,
    o_p_cfg_ready => o_p_cfg_ready,
    o_p_calib_done => o_p_calib_done,
    i_p_l0rxn => i_p_l0rxn,
    i_p_l0rxp => i_p_l0rxp,
    o_p_l0txn => o_p_l0txn,
    o_p_l0txp => o_p_l0txp,
    i_txd_0 => i_txd_0,
    i_txq_0 => i_txq_0,
    i_txh_0 => i_txh_0,
    o_rxstatus_0 => o_rxstatus_0,
    o_rxd_0 => o_rxd_0,
    o_rxh_0 => o_rxh_0,
    o_rxh_h_0 => o_rxh_h_0,
    o_rxd_vld_0 => o_rxd_vld_0,
    o_rxd_vld_h_0 => o_rxd_vld_h_0,
    o_rxh_vld_0 => o_rxh_vld_0,
    o_rxh_vld_h_0 => o_rxh_vld_h_0,
    o_rxq_start_0 => o_rxq_start_0
  );
