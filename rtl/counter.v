
`timescale 1ns / 1ps 

module counter(
        i_clk,
        i_rst_n,
        //sync data & trigger
        i_extern_din_a,
        i_extern_din_b,
        i_inner_din,
        i_single_start_trigger,
        i_single_stop_trigger,
        i_single_clear_trigger,
        i_single_reset_trigger,
        i_global_start_trigger,
        i_global_stop_trigger,
        i_global_clear_trigger,
        i_global_reset_trigger,
        o_extern_dout_a,
        o_extern_dout_a_oen,
        o_extern_dout_b,
        o_extern_dout_b_oen,
        //configure register & status.
        i_enable,
        i_src_sel_start,
        i_src_edge_start,
        i_src_sel_stop,
        i_src_edge_stop,
        i_src_sel_din0,
        i_src_edge_din0,
        i_src_sel_din1,
        i_src_edge_din1,
        i_ctrl_snap,
        o_shadow_reg,
        i_target_reg_ctrl,
        i_target_reg_a0,
        i_target_reg_a1,
        i_target_reg_a2,
        i_target_reg_b0,
        i_target_reg_b1,
        i_target_reg_b2,
        o_capture_reg_status,
        i_capture_reg_read_flag,
        i_capture_reg_overflow_ctrl,
        o_capture_reg_a0,
        o_capture_reg_a1,
        o_capture_reg_a2,
        o_capture_reg_b0,
        o_capture_reg_b1,
        o_capture_reg_b2,
        i_mode_sel,
        i_switch_mode_onebit_cnts,
        i_waveform_mode_cnts,
        i_capture_mode_cnts,
        i_waveform_mode_automatic_sw,
        i_capture_mode_automatic_sw,
        i_shiftmode_ctrl,
        i_shiftout_data,
        o_shiftin_data,
        //interrupt.
        o_int

);

parameter   COUNTER_NUM=4,
            CURRENT_COUNTER_NUM=0;

parameter SEL_WIDTH=$clog2(COUNTER_NUM+4+4+2);//innter din+single_trigger+global_trigger+external din.
            
input  i_clk;
input  i_rst_n;
//sync data & trigger
input  i_extern_din_a;
input  i_extern_din_b;
input  [COUNTER_NUM-1:0] i_inner_din;
input  i_single_start_trigger;
input  i_single_stop_trigger;
input  i_single_clear_trigger;
input  i_single_reset_trigger;
input  i_global_start_trigger;
input  i_global_stop_trigger;
input  i_global_clear_trigger;
input  i_global_reset_trigger;
output o_extern_dout_a;
output o_extern_dout_a_oen;
output o_extern_dout_b;
output o_extern_dout_b_oen;
//configure register & status.
input  i_enable;
input  [SEL_WIDTH-1:0] i_src_sel_start;
input  [1:0] i_src_edge_start;
input  [SEL_WIDTH-1:0] i_src_sel_stop;
input  [1:0] i_src_edge_stop;
input  [SEL_WIDTH-1:0] i_src_sel_din0;
input  [1:0] i_src_edge_din0;
input  [SEL_WIDTH-1:0] i_src_sel_din1;
input  [1:0] i_src_edge_din1;
input  i_ctrl_snap;
output [31:0] o_shadow_reg;
input  [5:0] i_target_reg_ctrl;
input  [31:0] i_target_reg_a0;
input  [31:0] i_target_reg_a1;
input  [31:0] i_target_reg_a2;
input  [31:0] i_target_reg_b0;
input  [31:0] i_target_reg_b1;
input  [31:0] i_target_reg_b2;
output [5:0] o_capture_reg_status;
input  [5:0] i_capture_reg_read_flag;
input  [5:0] i_capture_reg_overflow_ctrl;
output [31:0] o_capture_reg_a0;
output [31:0] o_capture_reg_a1;
output [31:0] o_capture_reg_a2;
output [31:0] o_capture_reg_b0;
output [31:0] o_capture_reg_b1;
output [31:0] o_capture_reg_b2;
input  [2:0] i_mode_sel;
input  [15:0] i_switch_mode_onebit_cnts;
input  [7:0] i_waveform_mode_cnts;
input  [7:0] i_capture_mode_cnts;
input  i_waveform_mode_automatic_sw;
input  i_capture_mode_automatic_sw;
input  i_shiftmode_ctrl;
input  [31:0] i_shiftout_data;
output [31:0] o_shiftin_data;
//interrupt.
output [3:0] o_int;

//
wire  counter_start;
wire  counter_stop;
wire  counter_din0;
wire  counter_din1;






endmodule