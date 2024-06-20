file delete -force work
vlib  work
vmap  work work
vlog D:/Pango/PDS_2023.2-SP1/arch/vendor/pango/verilog/simulation/GTP_CLKBUFG.v
vlog D:/Pango/PDS_2023.2-SP1/arch/vendor/pango/verilog/simulation/GTP_CLKBUFX.v
vlog D:/Pango/PDS_2023.2-SP1/arch/vendor/pango/verilog/simulation/GTP_DRM36K_E1.v
vlog D:/Pango/PDS_2023.2-SP1/arch/vendor/pango/verilog/simulation/GTP_GRS.v 
vlog D:/Pango/PDS_2023.2-SP1/arch/vendor/pango/verilog/simulation/GTP_GPLL.v 
vlog D:/Pango/PDS_2023.2-SP1/arch/vendor/pango/verilog/simulation/GTP_HSSTHP_BUFDS.v 
vlog -incr +define+IPM2T_HSST_SPEEDUP_SIM \
D:/Pango/PDS_2023.2-SP1/ip/module_ip/ipm2t_flex_hssthp/ipm2t_hssthp_eval/ipm2t_hssthp/../../../../../arch/vendor/pango/verilog/simulation/modelsim10.2c/hssthp_lane_source_codes/*.vp\
D:/Pango/PDS_2023.2-SP1/ip/module_ip/ipm2t_flex_hssthp/ipm2t_hssthp_eval/ipm2t_hssthp/../../../../../arch/vendor/pango/verilog/simulation/modelsim10.2c/hssthp_hpll_source_codes/*.vp\
D:/Pango/PDS_2023.2-SP1/ip/module_ip/ipm2t_flex_hssthp/ipm2t_hssthp_eval/ipm2t_hssthp/../../../../../arch/vendor/pango/verilog/simulation/modelsim10.2c/hssthp_bufds_source_codes/*.vp\
D:/Pango/PDS_2023.2-SP1/ip/module_ip/ipm2t_flex_hssthp/ipm2t_hssthp_eval/ipm2t_hssthp/../../../../../arch/vendor/pango/verilog/simulation/modelsim10.2c/common_lib/*.vp\
D:/Pango/PDS_2023.2-SP1/ip/module_ip/ipm2t_flex_hssthp/ipm2t_hssthp_eval/ipm2t_hssthp/../../../../../arch/vendor/pango/verilog/simulation/GTP_HSSTHP_LANE.v \
D:/Pango/PDS_2023.2-SP1/ip/module_ip/ipm2t_flex_hssthp/ipm2t_hssthp_eval/ipm2t_hssthp/../../../../../arch/vendor/pango/verilog/simulation/GTP_HSSTHP_HPLL.v \
-f ./xge_mac_top_filelist.f -l vlog.log
vsim -voptargs=+acc tb_xge_mac -l vsim.log

add wave -position end  sim:/tb_xge_mac/LinkMain/sys_rst
add wave -position end  sim:/tb_xge_mac/LinkMain/o_usclk
add wave -position end  sim:/tb_xge_mac/LinkMain/i_free_clk
add wave -position end  sim:/tb_xge_mac/LinkMain/syn_align
add wave -position end  sim:/tb_xge_mac/LinkMain/slow_rst_done
add wave -position end  sim:/tb_xge_mac/LinkMain/txclk
add wave -position end  sim:/tb_xge_mac/LinkMain/rxclk
add wave -position end  sim:/tb_xge_mac/LinkMain/cfg_pma_reset
add wave -position end  sim:/tb_xge_mac/LinkMain/cfg_pcs_reset
add wave -position end  sim:/tb_xge_mac/LinkMain/hsst_rst_done
add wave -position end  sim:/tb_xge_mac/LinkMain/o_p_calib_done
add wave -position end  sim:/tb_xge_mac/LinkMain/xgmii_rxd
add wave -position end  sim:/tb_xge_mac/LinkMain/xgmii_rxc
add wave -position end  sim:/tb_xge_mac/LinkMain/xgmii_txd
add wave -position end  sim:/tb_xge_mac/LinkMain/xgmii_txc

add wave -position end  sim:/tb_xge_mac/LinkMain/tx_data_group_0
add wave -position end  sim:/tb_xge_mac/LinkMain/tx_data_seq_0
add wave -position end  sim:/tb_xge_mac/LinkMain/tx_data_h_0

add wave -position end  sim:/tb_xge_mac/LinkMain/rx_data_group_0
add wave -position end  sim:/tb_xge_mac/LinkMain/rx_data_h_0
add wave -position end  sim:/tb_xge_mac/LinkMain/rx_data_vld_0
add wave -position end  sim:/tb_xge_mac/LinkMain/o_rxq_start_0
add wave -position end  sim:/tb_xge_mac/LinkMain/rx_data_slip_0

add wave -position end  sim:/tb_xge_mac/LinkMain/o_rxstatus_0

configure wave -timelineunits ns
run -all
WaveRestoreZoom {1 ns} {100000 ns}