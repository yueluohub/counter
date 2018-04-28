vlib work
vlog -f counter_filelist.f \
    -f counter_tb_filelist.f \
    -f int_filelist.f \
+incdir+../rtl/  -work work -l sim.log

vsim work.counter_top_tb_top
