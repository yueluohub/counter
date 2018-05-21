#!bin/bash

test_name="test01" 

ncverilog \
+incdir+../rtl/  \
-f counter_filelist.f  \
-f counter_tb_filelist.f \
-f int_filelist.f \
-sv -l sim.log \
-top counter_top_tb_top \
+access+rwc \
+define+NC_SIM \
-covfile ./covfile.ccf -covtest $test_name -covoverwrite
#+gui 

##+define+VERI_SIM \
##+loadpli1=debpli:novas_pli_boot \
##+gui
# -covfile ../../covfile.ccf -covtest $test_name -covoverwrite


#+define+NC_SIM \
#ncverilog \
#irun \
#+incdir+../rtl/ -f counter_filelist.f -f int_filelist.f -nctop counter_top -l sim.log
#irun +incdir+../rtl/  \
##+gui
# imc -gui & 
# imc -exec merge_cov.imc //merge -run_file merge.file   -out merged4 -metrics all
# imc -exec gen_cov_report.imc
# 
