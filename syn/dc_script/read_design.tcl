### Read rtl ###
define_design_lib work -path ./work

#analyze -lib work -define NDS_GATE -format verilog $NDS_HOME/rtl/down_counter8.v
#analyze -lib work -define NDS_GATE -format verilog $NDS_HOME/rtl/atcpit100_channel.v
#analyze -lib work -define NDS_GATE -format verilog $NDS_HOME/rtl/atcpit100_apbslv.v
#analyze -lib work -define NDS_GATE -format verilog $NDS_HOME/rtl/nds_sync_l2l.v
#analyze -lib work -define NDS_GATE -format verilog $NDS_HOME/rtl/atcpit100.v
source  -verbose ${NDS_HOME}/dc_script/filelist.tcl

elaborate $root_design -lib work > ./log/elaborate.log

# Design Environment Setting
current_design $root_design

set load_value [load_of ${tech_lib}/$loading_pin]
set_load [expr $load_value * 4] [all_outputs]
set_driving_cell -lib_cell $driving_cell [all_inputs]

set_operating_conditions -lib $tech_lib $op_condition

set_max_area 0
set_max_transition $max_trans $root_design
#set_wire_load_mode enclosed
set_wire_load_mode top
#set_wire_load_model -name Zero -library ${tech_lib}
set_wire_load_model -name Medium -library ${tech_lib} 
## wire_laod "Small Medium Large Huge"
set_fix_multiple_port_net -all -buffer_constants [all_designs]
