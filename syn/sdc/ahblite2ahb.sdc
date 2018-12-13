###############################################
### Clock Definition                        ###
###############################################

set apb_period 30
set counter_period 30

create_clock -name PCLK \
             -period $apb_period  \
             -waveform "0 [expr $apb_period / 2.0]" [get_ports i_pclk]
create_clock -name CLK0 \
             -period $counter_period  \
             -waveform "0 [expr $counter_period / 2.0]" [get_ports i_clk[0]]
create_clock -name CLK1 \
             -period $counter_period  \
             -waveform "0 [expr $counter_period / 2.0]" [get_ports i_clk[1]]
create_clock -name CLK2 \
             -period $counter_period  \
             -waveform "0 [expr $counter_period / 2.0]" [get_ports i_clk[2]]
create_clock -name CLK3 \
             -period $counter_period  \
             -waveform "0 [expr $counter_period / 2.0]" [get_ports i_clk[3]]
create_clock -name sCLK0 \
             -period $counter_period  \
             -waveform "0 [expr $counter_period / 2.0]" [get_ports i_clk_ir_s[0]]
create_clock -name sCLK1 \
             -period $counter_period  \
             -waveform "0 [expr $counter_period / 2.0]" [get_ports i_clk_ir_s[1]]
create_clock -name sCLK2 \
             -period $counter_period  \
             -waveform "0 [expr $counter_period / 2.0]" [get_ports i_clk_ir_s[2]]
create_clock -name sCLK3 \
             -period $counter_period  \
             -waveform "0 [expr $counter_period / 2.0]" [get_ports i_clk_ir_s[3]]

set_clock_uncertainty -setup $ahb_setup_uncertainty [all_clocks]


# Cross clock domain


# ICG constraint

###############################################
# Exception Constraint                      ###
###############################################

# False Path
set_false_path -from [get_ports i_prst_n]
set_false_path -from [get_ports i_rst_n*]
set_false_path -from [get_ports i_rst_ir_n*]
set_false_path -to [get_ports o_int]
set_clock_groups -asynchronous -group PCLK -group CLK0 -group CLK1 -group CLK2 -group CLK3
set_clock_groups -asynchronous -group PCLK -group sCLK0 -group sCLK1 -group sCLK2 -group sCLK3
set_clock_groups -asynchronous -group sCLK0 -group CLK1 -group CLK2 -group CLK3
set_clock_groups -asynchronous -group CLK0 -group sCLK1 -group CLK2 -group CLK3
set_clock_groups -asynchronous -group CLK0 -group CLK1 -group sCLK2 -group CLK3
set_clock_groups -asynchronous -group CLK0 -group CLK1 -group CLK2 -group sCLK3
#set_clock_groups -asynchronous -group sCLK0 -group CLK1 -group CLK2 -group CLK3
#set all_regs [get_cells [all_registers] -filter is_sequential]
#set all_mems [get_cells -hierarchical? -filter is_memory_cell]
#group_path -name in2reg -from $data_inputs -to $all_regs
#foreach_in_collection group [get_path_group "reg2reg reg2mem mem2reg in2reg reg2out
#**async_default** **clock_gating_default**"] {
#set group_name [get_object_name $grou p]
#report_timing -group $group_name -capacitance -nets -transition_time -derate -max_path 2000
#-path_type full clock expand
#${rpt_dir}${TOP}${opcond)_${file_name)${group_name}_max2000.rpt
#get_message_info -error_count

#set_false_path -from [get_ports scan_test]
set_ideal_network [get_ports i_pclk]
set_ideal_network [get_ports i_clk*]
set_ideal_network [get_ports i_clk_ir_s*]
#set_ideal_network [get_ports tck]

#set_dont_touch_network  [get_ports i_pclk]
#set_dont_touch_network  [get_ports i_clk*]
#set_dont_touch_network  [get_ports i_clk_ir_s*]
#set_dont_touch_network  [get_ports tck]


# Multi Cycle Path


###############################################
# Input/Output Timing Margin                ###
###############################################
# Global
#set_max_delay [expr $tckc_period * 0.05] -from [all_inputs] -to [all_outputs]
set_max_transition $max_trans [all_clocks]

# Input/Output Delay
#set clock_list [list PCLK CLK0 CLK1 CLK2 CLK1 sCLK0 sCLK1 sCLK2 sCLK3]
set clock_list [list i_pclk i_clk i_clk_ir_s]
#set input_ports [remove_from_collection [all_inputs] $clock_list]
#set output_ports [all_outputs]
set apb_input_ports [remove_from_collection [get_ports i_p*] $clock_list]
set apb_output_ports [get_ports  [list o_prdata o_clk_ctrl o_enable]]
set counter_input_ports [get_ports i_extern_din*]
set counter_output_ports [get_ports o_extern_dout*]

set_input_delay  [expr $apb_period * 0.61] -clock [get_clocks PCLK] $apb_input_ports
set_input_delay  [expr $counter_period * 0.61] -clock [get_clocks CLK0] $counter_input_ports
set_input_delay  [expr $counter_period * 0.61] -clock [get_clocks CLK1] $counter_input_ports
set_input_delay  [expr $counter_period * 0.61] -clock [get_clocks CLK2] $counter_input_ports
set_input_delay  [expr $counter_period * 0.61] -clock [get_clocks CLK3] $counter_input_ports
set_input_delay  [expr $counter_period * 0.61] -clock [get_clocks sCLK0] $counter_input_ports
set_input_delay  [expr $counter_period * 0.61] -clock [get_clocks sCLK1] $counter_input_ports
set_input_delay  [expr $counter_period * 0.61] -clock [get_clocks sCLK2] $counter_input_ports
set_input_delay  [expr $counter_period * 0.61] -clock [get_clocks sCLK3] $counter_input_ports

# Output delay
set_output_delay [expr $apb_period * 0.61] -clock [get_clocks PCLK] $apb_output_ports
set_output_delay [expr $counter_period * 0.61] -clock [get_clocks CLK0] [get_ports $counter_output_ports]
set_output_delay [expr $counter_period * 0.61] -clock [get_clocks CLK1] [get_ports $counter_output_ports]
set_output_delay [expr $counter_period * 0.61] -clock [get_clocks CLK2] [get_ports $counter_output_ports]
set_output_delay [expr $counter_period * 0.61] -clock [get_clocks CLK3] [get_ports $counter_output_ports]
set_output_delay [expr $counter_period * 0.61] -clock [get_clocks sCLK0] [get_ports $counter_output_ports]
set_output_delay [expr $counter_period * 0.61] -clock [get_clocks sCLK1] [get_ports $counter_output_ports]
set_output_delay [expr $counter_period * 0.61] -clock [get_clocks sCLK2] [get_ports $counter_output_ports]
set_output_delay [expr $counter_period * 0.61] -clock [get_clocks sCLK3] [get_ports $counter_output_ports]

###############################################
# Path Groups for optimization              ###
###############################################


