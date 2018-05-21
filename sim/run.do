vlib work
vlog -sv -f counter_filelist.f \
    -f counter_tb_filelist.f \
    -f int_filelist.f \
+incdir+../../work_git1/rtl/  \
+incdir+../../work_git1/sim/  \
-work work -l sim.log

vsim work.counter_top_tb_top

#add wave /counter_top_tb_top/counter_top/u_counter_all/counter_loop\[0\]/u_counter/*
#add wave /counter_top_tb_top/counter_top/u_counter_all/counter_loop\[1\]/u_counter/*
#add wave /counter_top_tb_top/counter_top/u_counter_all/counter_loop\[2\]/u_counter/*
#add wave /counter_top_tb_top/counter_top/u_counter_all/counter_loop\[3\]/u_counter/*
#add wave /counter_top_tb_top/counter_top/counter_all_apb_reg/*
#add wave /counter_top_tb_top/counter_top/*
#add wave /counter_top_tb_top/counter_top/u_counter_all/*

do wave.do

run -all
