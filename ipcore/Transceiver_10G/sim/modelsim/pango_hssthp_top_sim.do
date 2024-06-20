file delete -force work
vlib  work
vmap  work work
vlog -incr +define+IPM2T_HSST_SPEEDUP_SIM \
D:/Pango/PDS_2023.2-SP1/ip/module_ip/ipm2t_flex_hssthp/ipm2t_hssthp_eval/ipm2t_hssthp//../../../../../arch/vendor/pango/verilog/simulation/modelsim10.2c/hssthp_lane_source_codes/*.vp\
D:/Pango/PDS_2023.2-SP1/ip/module_ip/ipm2t_flex_hssthp/ipm2t_hssthp_eval/ipm2t_hssthp//../../../../../arch/vendor/pango/verilog/simulation/modelsim10.2c/hssthp_hpll_source_codes/*.vp\
D:/Pango/PDS_2023.2-SP1/ip/module_ip/ipm2t_flex_hssthp/ipm2t_hssthp_eval/ipm2t_hssthp//../../../../../arch/vendor/pango/verilog/simulation/modelsim10.2c/hssthp_bufds_source_codes/*.vp\
D:/Pango/PDS_2023.2-SP1/ip/module_ip/ipm2t_flex_hssthp/ipm2t_hssthp_eval/ipm2t_hssthp//../../../../../arch/vendor/pango/verilog/simulation/modelsim10.2c/common_lib/*.vp\
D:/Pango/PDS_2023.2-SP1/ip/module_ip/ipm2t_flex_hssthp/ipm2t_hssthp_eval/ipm2t_hssthp//../../../../../arch/vendor/pango/verilog/simulation/GTP_HSSTHP_LANE.v \
D:/Pango/PDS_2023.2-SP1/ip/module_ip/ipm2t_flex_hssthp/ipm2t_hssthp_eval/ipm2t_hssthp//../../../../../arch/vendor/pango/verilog/simulation/GTP_HSSTHP_HPLL.v \
D:/Pango/PDS_2023.2-SP1/ip/module_ip/ipm2t_flex_hssthp/ipm2t_hssthp_eval/ipm2t_hssthp//../../../../../arch/vendor/pango/verilog/simulation/GTP_HSSTHP_BUFDS.v \
-f ./pango_hssthp_top_filelist.f -l vlog.log
vsim -novopt work.Transceiver_10G_top_tb -l vsim.log
do pango_hssthp_top_wave.do
run -all
