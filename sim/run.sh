ncverilog \
+incdir+../rtl/  \
-f counter_filelist.f  \
-f counter_tb_filelist.f \
-f int_filelist.f \
-sv -l sim.log \
-top counter_top_tb_top \
+access+rwc \
+define+NC_SIM \
#+gui 

##+define+VERI_SIM \
##+loadpli1=debpli:novas_pli_boot \
##+gui

#+define+NC_SIM \
#ncverilog \
#irun \
#+incdir+../rtl/ -f counter_filelist.f -f int_filelist.f -nctop counter_top -l sim.log
#irun +incdir+../rtl/  \
##+gui
