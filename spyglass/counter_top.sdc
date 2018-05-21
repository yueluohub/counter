
set F_COUNTER_CLK 32.000
set P_COUNTER_CLK [expr 1000.000/$F_COUNTER_CLK]
set F_APB_CLK 16.000
set P_APB_CLK [expr 1000.000/$F_APB_CLK]

create_clock -name clk0 -period $P_COUNTER_CLK [get_ports i_clk[0]]
create_clock -name clk1 -period $P_COUNTER_CLK [get_ports i_clk[1]]
create_clock -name clk2 -period $P_COUNTER_CLK [get_ports i_clk[2]]
create_clock -name clk3 -period $P_COUNTER_CLK [get_ports i_clk[3]]

create_clock -name apb_clk -period $P_APB_CLK [get_ports i_pclk]
set_clock_groups -asynchronous \
		-group "clk0" \
		-group "clk1" \
		-group "clk2" \
		-group "clk3" \
		-group "apb_clk" 
set_input_delay  [expr 0.6*$P_COUNTER_CLK] -clock clk0 -max [get_ports i_extern_din*[0] ]
set_input_delay  [expr 0.6*$P_COUNTER_CLK] -clock clk1 -max [get_ports i_extern_din*[1] ]
set_input_delay  [expr 0.6*$P_COUNTER_CLK] -clock clk2 -max [get_ports i_extern_din*[2] ]
set_input_delay  [expr 0.6*$P_COUNTER_CLK] -clock clk3 -max [get_ports i_extern_din*[3] ]
set_input_delay  [expr 0.6*$P_COUNTER_CLK] -clock clk0 -max [get_ports i_rst_n[0] ]
set_input_delay  [expr 0.6*$P_COUNTER_CLK] -clock clk1 -max [get_ports i_rst_n[1] ]
set_input_delay  [expr 0.6*$P_COUNTER_CLK] -clock clk2 -max [get_ports i_rst_n[2] ]
set_input_delay  [expr 0.6*$P_COUNTER_CLK] -clock clk3 -max [get_ports i_rst_n[3] ]

set_output_delay [expr 0.6*$P_COUNTER_CLK] -clock clk0 -max [get_ports o_extern_dout*[0]]
set_output_delay [expr 0.6*$P_COUNTER_CLK] -clock clk1 -max [get_ports o_extern_dout*[1]]
set_output_delay [expr 0.6*$P_COUNTER_CLK] -clock clk2 -max [get_ports o_extern_dout*[2]]
set_output_delay [expr 0.6*$P_COUNTER_CLK] -clock clk3 -max [get_ports o_extern_dout*[3]]


set_input_delay  [expr 0.6*$P_APB_CLK] -clock apb_clk -max [get_ports i_paddr* ]
set_input_delay  [expr 0.6*$P_APB_CLK] -clock apb_clk -max [get_ports i_pw* ]
set_input_delay  [expr 0.6*$P_APB_CLK] -clock apb_clk -max [get_ports i_psel ]
set_input_delay  [expr 0.6*$P_APB_CLK] -clock apb_clk -max [get_ports i_pen*]

set_output_delay [expr 0.6*$P_APB_CLK] -clock apb_clk -max [get_ports o_p* ]
set_output_delay [expr 0.6*$P_APB_CLK] -clock apb_clk -max [get_ports o_clk_c* ]
set_output_delay [expr 0.6*$P_APB_CLK] -clock apb_clk -max [get_ports o_en*]


set_false_path -from [get_cells counter_top.counter_all_apb_reg.\target_reg_a2_c*] -to  [get_pins counter_top.u_counter_all.\counter_loop[0].u_counter.*]
set_false_path -from [get_pins counter_top.counter_all_apb_reg.\*reg*] -to [get_pins counter_top.u_counter_all.\counter_loop[?].u_counter.*]

set_false_path -from [get_pins counter_top.counter_all_apb_reg.\*.CP] -to [get_pins counter_top.u_counter_all.\counter_loop[?].u_counter.\*]

set_false_path -from [get_pins counter_top.counter_all_apb_reg.\*target_reg_a2_c*.CP] 





