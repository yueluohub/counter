### Check out license
set license_flag [get_license HDL-Compiler]
while {$license_flag!=1}  {
    exec sleep 10
    set license_flag [get_license HDL-Compiler]
}

#set license_flag [get_license DC-Ultra-Opt]
#while {$license_flag!=1}  {
#    exec sleep 10
#    set license_flag [get_license DC-Ultra-Opt]
#}
#set_ultra_optimization true

set license_flag [get_license DesignWare]
while {$license_flag!=1}  {
    exec sleep 10
    set license_flag [get_license DesignWare]
}

exec date +Start\ Time:\ %H:%M\ \(%D\)
# dc environment setting
source ./dc_script/dc.setup

# When following script has error, use -echo to debug
source ./dc_script/naming_rule.tcl

# generate gck automatically
###source -verbose ./dc_script/gck_autogen.tcl > ./log/gck_autogen.log

### Read RTL ###
source -verbose ./dc_script/read_design.tcl > ./log/read_design.log

### Apply budget
source ./sdc/ahblite2ahb.sdc > ./log/ahblite2ahb_sdc.log

uniquify > ./log/uniquify.log

compile -map_effort high > ./log/compile1.log
check_design > ./rpt/check_design.rpt
check_timing > ./rpt/check_timing.rpt
report_constraint -all_violators > ./rpt/summary_final.rpt
report_timing -max_path 1000 -net -cap -nworst 10 > ./rpt/timing.rpt

report_area > ./rpt/area.rpt

change_names -rules nds_core_rule -hierarchy
change_names -rules nds_core_rule_2 -hierarchy

write -format verilog -hierarchy -output ./netlist/${root_design}.vg
write_sdc ./netlist/${root_design}.sdc

if {[shell_is_in_xg_mode]==0} {
    write -format db  -hier -o ./db/${root_design}.db
} else {
    write -format ddc -hier -o ./ddc/${root_design}.ddc
}

exec date +End\ Time:\ %H:%M\ \(%D\)
exit
