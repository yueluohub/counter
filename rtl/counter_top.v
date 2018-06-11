
`timescale 1ns / 1ps 

`default_nettype none
module counter_top(
        //counter clock domain.
        i_clk,
        i_rst_n,
        //apb bus register clock domain.
        i_pclk,
        i_prst_n,
        i_paddr,
        i_pwdata,
        i_pwrite,
        i_psel,
        i_penable,
        o_prdata,
        //extern data & trigger
        i_extern_din_a,
        i_extern_din_b,
        o_extern_dout_a,
        o_extern_dout_a_oen,
        o_extern_dout_b,
        o_extern_dout_b_oen,
        //clock select ,enable, inv clock enable.
        o_enable,
        o_clk_ctrl,
        //IR clk;
        i_clk_ir_s,
        i_rst_ir_n,
        //interrupt.
        o_int
);

parameter   COUNTER_NUM=4;
localparam SEL_WIDTH=$clog2(COUNTER_NUM+4+4+2);

input wire  [COUNTER_NUM-1:0] i_clk;// counter clock domain.
input wire  [COUNTER_NUM-1:0] i_rst_n;
//apb bus register clock domain.
input wire       i_pclk;
input wire       i_prst_n;

input wire   [ 31 : 0 ] i_paddr;
input wire   [ 31 : 0 ] i_pwdata;
input wire              i_pwrite;
input wire              i_psel;
input wire              i_penable;
output [ 31 : 0 ]  o_prdata;

//sync data & trigger
input wire  [COUNTER_NUM-1:0] i_extern_din_a;
input wire  [COUNTER_NUM-1:0] i_extern_din_b;

output wire [COUNTER_NUM-1:0] o_extern_dout_a;
output wire [COUNTER_NUM-1:0] o_extern_dout_a_oen;
output wire [COUNTER_NUM-1:0] o_extern_dout_b;
output wire [COUNTER_NUM-1:0] o_extern_dout_b_oen;

//configure register & status.
output wire [COUNTER_NUM*8-1:0] o_clk_ctrl;//
output wire [COUNTER_NUM-1:0]   o_enable;//

input  wire [COUNTER_NUM-1:0]       i_clk_ir_s;//
input  wire [COUNTER_NUM-1:0]       i_rst_ir_n;//

//interrupt.
output wire  o_int;//
reg [ 31 : 0 ]  o_prdata;


`include "counter_all_apb_reg_inst.inc"
//counter_all_apb_reg counter_all_apb_reg ();
assign haddr_11w  = i_psel ? i_paddr[31:2] : 32'h0;
assign hwdata_32w = i_psel && i_pwrite ? i_pwdata : 32'h0;
assign hwen = i_psel && i_pwrite && (!i_penable);
assign hren = i_psel && !i_pwrite && (!i_penable);
always @ ( posedge i_pclk or negedge i_prst_n) begin
  if (!i_prst_n) o_prdata <= 32'h0;
  else if (hren) o_prdata <= hrdata_32w;
end

//   wire              [ 31 : 0 ] sts_intr_status_counter;
//   wire              [ 31 : 0 ] sts_intr_mask_status_counter;
//   wire                         wen_intr_clr;
//   wire                         wen_intr_clr_d;
//   wire              [ 31 : 0 ] ctl_intr_clr_counter;
//   wire                         wen_intr_set;
//   wire                         wen_intr_set_d;
//   wire              [ 31 : 0 ] ctl_intr_set_counter;
//   wire                         wen_intr_mask_set;
//   wire                         wen_intr_mask_set_d;
//   wire              [ 31 : 0 ] ctl_intr_mask_set_counter;
//   wire                         wen_intr_mask_clr;
//   wire                         wen_intr_mask_clr_d;
//   wire              [ 31 : 0 ] ctl_intr_mask_clr_counter;

//   wire                         o_global_start_trigger;
//   wire                         o_global_stop_trigger;
//   wire                         o_global_clear_trigger;
//   wire                         o_global_reset_trigger;

//   wire                         o_single_start_trigger_c0;
//   wire                         o_single_stop_trigger_c0;
//   wire                         o_single_clear_trigger_c0;
//   wire                         o_single_reset_trigger_c0;

//   wire                         o_enable_c0;
//   wire              [  7 : 0 ] o_soft_trigger_ctrl_c0;
//   wire              [  3 : 0 ] o_src_sel_start_c0;
//   wire              [  1 : 0 ] o_src_edge_start_c0;
//   wire              [  3 : 0 ] o_src_sel_stop_c0;
//   wire              [  1 : 0 ] o_src_edge_stop_c0;
//   wire              [  3 : 0 ] o_src_sel_din0_c0;
//   wire              [  1 : 0 ] o_src_edge_din0_c0;
//   wire              [  3 : 0 ] o_src_sel_din1_c0;
//   wire              [  1 : 0 ] o_src_edge_din1_c0;
//   wire                         wen_ctrl_snap_c0;
//   wire                         wen_ctrl_snap_c0_d;
//   wire              [  3 : 0 ] o_ctrl_snap_c0;
//   wire              [ 31 : 0 ] i_shadow_reg_c0;
//   wire              [  2 : 0 ] o_mode_sel_c0;
//   wire              [  5 : 0 ] o_target_reg_ctrl_c0;
//   wire              [ 31 : 0 ] o_target_reg_a0_c0;
//   wire                         wen_target_reg_a1_c0;
//   wire                         wen_target_reg_a1_c0_d;
//   wire              [ 31 : 0 ] o_target_reg_a1_c0;
//   wire              [ 31 : 0 ] o_target_reg_a2_c0;
//   wire              [ 31 : 0 ] o_target_reg_b0_c0;
//   wire              [ 31 : 0 ] o_target_reg_b1_c0;
//   wire              [ 31 : 0 ] o_target_reg_b2_c0;
//   wire              [  5 : 0 ] i_capture_reg_status_c0;
//   wire              [  5 : 0 ] o_capture_reg_overflow_ctrl_c0;
//   wire                         ren_capture_reg_a0_c0;
//   wire                         ren_capture_reg_a0_c0_d;
//   wire              [ 31 : 0 ] i_capture_reg_a0_c0;
//   wire                         ren_capture_reg_a1_c0;
//   wire                         ren_capture_reg_a1_c0_d;
//   wire              [ 31 : 0 ] i_capture_reg_a1_c0;
//   wire                         ren_capture_reg_a2_c0;
//   wire                         ren_capture_reg_a2_c0_d;
//   wire              [ 31 : 0 ] i_capture_reg_a2_c0;
//   wire                         ren_capture_reg_b0_c0;
//   wire                         ren_capture_reg_b0_c0_d;
//   wire              [ 31 : 0 ] i_capture_reg_b0_c0;
//   wire                         ren_capture_reg_b1_c0;
//   wire                         ren_capture_reg_b1_c0_d;
//   wire              [ 31 : 0 ] i_capture_reg_b1_c0;
//   wire                         ren_capture_reg_b2_c0;
//   wire                         ren_capture_reg_b2_c0_d;
//   wire              [ 31 : 0 ] i_capture_reg_b2_c0;
//   wire              [ 15 : 0 ] o_switch_mode_onebit_cnts_c0;
//   wire              [  7 : 0 ] o_waveform_mode_cnts_c0;
//   wire              [  7 : 0 ] o_capture_mode_cnts_c0;
//   wire                         o_waveform_mode_automatic_sw_c0;
//   wire                         o_capture_mode_automatic_sw_c0;
//   wire                         o_shiftmode_ctrl_c0;
//   wire              [  4 : 0 ] o_shiftout_data_ctrl_bitcnts_c0;
//   wire              [ 31 : 0 ] o_shiftout_data_c0;
//   wire                         wen_shiftout_data_valid_c0;
//   wire                         wen_shiftout_data_valid_c0_d;
//   wire                         o_shiftout_data_valid_c0;
//   wire              [  4 : 0 ] o_shiftin_data_ctrl_bitcnts_c0;
//   wire              [ 31 : 0 ] i_shiftin_data_c0;
//   wire              [ 31 : 0 ] i_shiftin_databits_updated_c0;
//   wire              [  1 : 0 ] o_ir_din_bypass_c1;
//   wire              [ 31 : 0 ] o_ir_din_onecycle_value_a_c1;
//   wire              [ 31 : 0 ] o_ir_din_onecycle_value_b_c1;
//   wire              [  7 : 0 ] o_ir_dout_opts_c1;
//   wire              [  1 : 0 ] o_ir_dout_bypass_c1;

   
wire [COUNTER_NUM-1:0]   w_single_start_trigger ;
wire [COUNTER_NUM-1:0]   w_single_stop_trigger  ;
wire [COUNTER_NUM-1:0]   w_single_clear_trigger ;
wire [COUNTER_NUM-1:0]   w_single_reset_trigger ;
wire                     w_global_start_trigger ;
wire                     w_global_stop_trigger  ;
wire                     w_global_clear_trigger ;
wire                     w_global_reset_trigger ;

//configure register & status.
//wire  [COUNTER_NUM-1:0] o_enable;
wire  [COUNTER_NUM*COUNTER_NUM-1:0] w_mux_sel;
wire  [COUNTER_NUM*8-1:0] w_soft_trigger_ctrl;   // to control the function of single/global_trigger, as a normal control signal or a softward trigger signal.
wire  [COUNTER_NUM*SEL_WIDTH-1:0] w_src_sel_start;
wire  [COUNTER_NUM*2-1:0] w_src_edge_start;
wire  [COUNTER_NUM*SEL_WIDTH-1:0] w_src_sel_stop;
wire  [COUNTER_NUM*2-1:0] w_src_edge_stop;
wire  [COUNTER_NUM*SEL_WIDTH-1:0] w_src_sel_din0;
wire  [COUNTER_NUM*2-1:0] w_src_edge_din0;
wire  [COUNTER_NUM*SEL_WIDTH-1:0] w_src_sel_din1;
wire  [COUNTER_NUM*2-1:0] w_src_edge_din1;
wire  [COUNTER_NUM*4-1:0] w_ctrl_snap;
wire  [COUNTER_NUM*4-1:0] w_snap_status;
wire  [COUNTER_NUM-1:0]   w_clear_snap;

wire  [COUNTER_NUM*32-1:0] w_shadow_reg;
wire  [COUNTER_NUM*6-1:0] w_target_reg_ctrl;
wire  [COUNTER_NUM*32-1:0] w_target_reg_a0;
wire  [COUNTER_NUM*32-1:0] w_target_reg_a1;
wire  [COUNTER_NUM*32-1:0] w_target_reg_a2;
wire  [COUNTER_NUM*32-1:0] w_target_reg_b0;
wire  [COUNTER_NUM*32-1:0] w_target_reg_b1;
wire  [COUNTER_NUM*32-1:0] w_target_reg_b2;
wire [COUNTER_NUM*6-1:0] w_capture_reg_status;//(a2/a1/a0)bit2-bit0:1-active.(b2/b1/b0)bit5-bit3;
wire  [COUNTER_NUM*6-1:0] w_capture_reg_read_flag;//(a2/a1/a0)bit2-bit0:1-active.(b2/b1/b0)bit5-bit3:
wire  [COUNTER_NUM*6-1:0] w_capture_reg_overflow_ctrl;//bit5~bit0: 1-overwrite,0-discard.
wire [COUNTER_NUM*32-1:0] w_capture_reg_a0;
wire [COUNTER_NUM*32-1:0] w_capture_reg_a1;
wire [COUNTER_NUM*32-1:0] w_capture_reg_a2;
wire [COUNTER_NUM*32-1:0] w_capture_reg_b0;
wire [COUNTER_NUM*32-1:0] w_capture_reg_b1;
wire [COUNTER_NUM*32-1:0] w_capture_reg_b2;
wire  [COUNTER_NUM*3-1:0] w_mode_sel;
wire  [COUNTER_NUM*16-1:0] w_switch_mode_onebit_cnts;
wire  [COUNTER_NUM*8-1:0] w_waveform_mode_cnts;//waveform/shiftout mode cnts.
wire  [COUNTER_NUM*8-1:0] w_capture_mode_cnts;//capture/shiftin mode cnts.
wire  [COUNTER_NUM-1:0] w_waveform_mode_automatic_sw;//1-automatic switch to waveform mode enable,0-disable.
wire  [COUNTER_NUM-1:0] w_capture_mode_automatic_sw;//1-automatic switch to capture mode enable,0-disable.

wire  [COUNTER_NUM-1:0] w_capture_mode_automatic_validedge;
wire  [COUNTER_NUM-1:0] w_shiftmode_point_en;              
wire  [COUNTER_NUM*16-1:0] w_shiftmode_point_cnts;
            
wire  [COUNTER_NUM-1:0] w_shiftmode_ctrl;//0-bus_a(din_a/dout_a),1-bus_b(din_b/dout_b).
wire  [COUNTER_NUM*32-1:0] w_shiftout_data;
wire  [COUNTER_NUM*5-1:0] w_shiftout_data_ctrl_bitcnts;//n-> (n+1) bit;
wire  [COUNTER_NUM-1:0] w_shiftout_data_valid;//1->active.
wire  [COUNTER_NUM*32-1:0] w_shiftin_data;
wire  [COUNTER_NUM*32-1:0] w_shiftin_databits_updated;//1-> new data.
wire  [COUNTER_NUM*5-1:0] w_shiftin_data_ctrl_bitcnts;//n-> (n+1) bit;
// IR control register .


wire [COUNTER_NUM*32-1:0]    w_ir_din_onecycle_value_a;//
wire [COUNTER_NUM*32-1:0]    w_ir_din_onecycle_value_b;//
wire [COUNTER_NUM*2-1:0]     w_ir_din_bypass;
wire [COUNTER_NUM*8-1:0]     w_ir_dout_opts;//3~0 ->a,7~4 ->b;
wire [COUNTER_NUM*2-1:0]     w_ir_dout_bypass;//0->a,1->b.

//interrupt.
wire [COUNTER_NUM*8-1:0] w_int;//   


assign w_global_start_trigger  = o_global_start_trigger;
assign w_global_stop_trigger   = o_global_stop_trigger;
assign w_global_clear_trigger  = o_global_clear_trigger;
assign w_global_reset_trigger  = o_global_reset_trigger;

assign w_single_start_trigger  = {o_single_start_trigger_c3,o_single_start_trigger_c2,o_single_start_trigger_c1,o_single_start_trigger_c0};
assign w_single_stop_trigger   = {o_single_stop_trigger_c3,o_single_stop_trigger_c2,o_single_stop_trigger_c1,o_single_stop_trigger_c0};
assign w_single_clear_trigger  = {o_single_clear_trigger_c3,o_single_clear_trigger_c2,o_single_clear_trigger_c1,o_single_clear_trigger_c0};
assign w_single_reset_trigger  = {o_single_reset_trigger_c3,o_single_reset_trigger_c2,o_single_reset_trigger_c1,o_single_reset_trigger_c0};

assign o_enable     = {o_enable_c3,o_enable_c2,o_enable_c1,o_enable_c0};
assign o_clk_ctrl   = {o_clk_ctrl_c3,o_clk_ctrl_c2,o_clk_ctrl_c1,o_clk_ctrl_c0};//
assign w_mux_sel    = {o_mux_sel_c3,o_mux_sel_c2,o_mux_sel_c1,o_mux_sel_c0};//
assign w_soft_trigger_ctrl = {o_soft_trigger_ctrl_c3,o_soft_trigger_ctrl_c2,o_soft_trigger_ctrl_c1,o_soft_trigger_ctrl_c0};   
assign w_src_sel_start  = {o_src_sel_start_c3,o_src_sel_start_c2,o_src_sel_start_c1,o_src_sel_start_c0};
assign w_src_edge_start = {o_src_edge_start_c3,o_src_edge_start_c2,o_src_edge_start_c1,o_src_edge_start_c0};
assign w_src_sel_stop   = {o_src_sel_stop_c3,o_src_sel_stop_c2,o_src_sel_stop_c1,o_src_sel_stop_c0};
assign w_src_edge_stop  = {o_src_edge_stop_c3,o_src_edge_stop_c2,o_src_edge_stop_c1,o_src_edge_stop_c0};
assign w_src_sel_din0   = {o_src_sel_din0_c3,o_src_sel_din0_c2,o_src_sel_din0_c1,o_src_sel_din0_c0};
assign w_src_edge_din0  = {o_src_edge_din0_c3,o_src_edge_din0_c2,o_src_edge_din0_c1,o_src_edge_din0_c0};
assign w_src_sel_din1   = {o_src_sel_din1_c3,o_src_sel_din1_c2,o_src_sel_din1_c1,o_src_sel_din1_c0};
assign w_src_edge_din1  = {o_src_edge_din1_c3,o_src_edge_din1_c2,o_src_edge_din1_c1,o_src_edge_din1_c0};
assign w_ctrl_snap      = {o_ctrl_snap_c3,o_ctrl_snap_c2,o_ctrl_snap_c1,o_ctrl_snap_c0};//wen_ctrl_snap_c0
assign w_clear_snap     = {o_clear_snap_c3,o_clear_snap_c2,o_clear_snap_c1,o_clear_snap_c0};
assign {i_snap_status_c3,i_snap_status_c2,i_snap_status_c1,i_snap_status_c0} =  w_snap_status;
assign {i_shadow_reg_c3,i_shadow_reg_c2,i_shadow_reg_c1,i_shadow_reg_c0}    =   w_shadow_reg;
assign w_target_reg_ctrl = {o_target_reg_ctrl_c3,o_target_reg_ctrl_c2,o_target_reg_ctrl_c1,o_target_reg_ctrl_c0};

assign w_target_reg_a0  = {o_target_reg_a0_c3,o_target_reg_a0_c2,o_target_reg_a0_c1,o_target_reg_a0_c0};
assign w_target_reg_a1  = {o_target_reg_a1_c3,o_target_reg_a1_c2,o_target_reg_a1_c1,o_target_reg_a1_c0};
assign w_target_reg_a2  = {o_target_reg_a2_c3,o_target_reg_a2_c2,o_target_reg_a2_c1,o_target_reg_a2_c0};
assign w_target_reg_b0  = {o_target_reg_b0_c3,o_target_reg_b0_c2,o_target_reg_b0_c1,o_target_reg_b0_c0};
assign w_target_reg_b1  = {o_target_reg_b1_c3,o_target_reg_b1_c2,o_target_reg_b1_c1,o_target_reg_b1_c0};
assign w_target_reg_b2  = {o_target_reg_b2_c3,o_target_reg_b2_c2,o_target_reg_b2_c1,o_target_reg_b2_c0};
//assign w_capture_reg_status = {i_capture_reg_status_c3,i_capture_reg_status_c2,i_capture_reg_status_c1,i_capture_reg_status_c0};
assign {i_capture_reg_status_c3,i_capture_reg_status_c2,i_capture_reg_status_c1,i_capture_reg_status_c0} = w_capture_reg_status ;

assign w_capture_reg_read_flag = {ren_capture_reg_b2_c3_d,ren_capture_reg_b1_c3_d,ren_capture_reg_b0_c3_d,ren_capture_reg_a2_c3_d,ren_capture_reg_a1_c3_d,ren_capture_reg_a0_c3_d,
                                  ren_capture_reg_b2_c2_d,ren_capture_reg_b1_c2_d,ren_capture_reg_b0_c2_d,ren_capture_reg_a2_c2_d,ren_capture_reg_a1_c2_d,ren_capture_reg_a0_c2_d,
                                  ren_capture_reg_b2_c1_d,ren_capture_reg_b1_c1_d,ren_capture_reg_b0_c1_d,ren_capture_reg_a2_c1_d,ren_capture_reg_a1_c1_d,ren_capture_reg_a0_c1_d,
                                  ren_capture_reg_b2_c0_d,ren_capture_reg_b1_c0_d,ren_capture_reg_b0_c0_d,ren_capture_reg_a2_c0_d,ren_capture_reg_a1_c0_d,ren_capture_reg_a0_c0_d};
assign w_capture_reg_overflow_ctrl = {o_capture_reg_overflow_ctrl_c3,o_capture_reg_overflow_ctrl_c2,o_capture_reg_overflow_ctrl_c1,o_capture_reg_overflow_ctrl_c0};
assign {i_capture_reg_a0_c3,i_capture_reg_a0_c2,i_capture_reg_a0_c1,i_capture_reg_a0_c0} = w_capture_reg_a0;
assign {i_capture_reg_a1_c3,i_capture_reg_a1_c2,i_capture_reg_a1_c1,i_capture_reg_a1_c0} = w_capture_reg_a1;
assign {i_capture_reg_a2_c3,i_capture_reg_a2_c2,i_capture_reg_a2_c1,i_capture_reg_a2_c0} = w_capture_reg_a2;
assign {i_capture_reg_b0_c3,i_capture_reg_b0_c2,i_capture_reg_b0_c1,i_capture_reg_b0_c0} = w_capture_reg_b0;
assign {i_capture_reg_b1_c3,i_capture_reg_b1_c2,i_capture_reg_b1_c1,i_capture_reg_b1_c0} = w_capture_reg_b1;
assign {i_capture_reg_b2_c3,i_capture_reg_b2_c2,i_capture_reg_b2_c1,i_capture_reg_b2_c0} = w_capture_reg_b2;
assign w_mode_sel       = {o_mode_sel_c3,o_mode_sel_c2,o_mode_sel_c1,o_mode_sel_c0};
assign w_switch_mode_onebit_cnts = {o_switch_mode_onebit_cnts_c3,o_switch_mode_onebit_cnts_c2,o_switch_mode_onebit_cnts_c1,o_switch_mode_onebit_cnts_c0};
assign w_waveform_mode_cnts      = {o_waveform_mode_cnts_c3,o_waveform_mode_cnts_c2,o_waveform_mode_cnts_c1,o_waveform_mode_cnts_c0};
assign w_capture_mode_cnts       = {o_capture_mode_cnts_c3,o_capture_mode_cnts_c2,o_capture_mode_cnts_c1,o_capture_mode_cnts_c0};
assign w_waveform_mode_automatic_sw = {o_waveform_mode_automatic_sw_c3,o_waveform_mode_automatic_sw_c2,o_waveform_mode_automatic_sw_c1,o_waveform_mode_automatic_sw_c0};
assign w_capture_mode_automatic_sw  = {o_capture_mode_automatic_sw_c3,o_capture_mode_automatic_sw_c2,o_capture_mode_automatic_sw_c1,o_capture_mode_automatic_sw_c0};
assign w_shiftmode_ctrl = {o_shiftmode_ctrl_c3,o_shiftmode_ctrl_c2,o_shiftmode_ctrl_c1,o_shiftmode_ctrl_c0};
assign w_shiftout_data  = {o_shiftout_data_c3,o_shiftout_data_c2,o_shiftout_data_c1,o_shiftout_data_c0};
assign w_shiftout_data_ctrl_bitcnts = {o_shiftout_data_ctrl_bitcnts_c3,o_shiftout_data_ctrl_bitcnts_c2,o_shiftout_data_ctrl_bitcnts_c1,o_shiftout_data_ctrl_bitcnts_c0};
assign w_shiftout_data_valid = {wen_shiftout_data_valid_c3_d,wen_shiftout_data_valid_c2_d,wen_shiftout_data_valid_c1_d,wen_shiftout_data_valid_c0_d};
assign {i_shiftin_data_c3,i_shiftin_data_c2,i_shiftin_data_c1,i_shiftin_data_c0} = w_shiftin_data ;
assign  w_shiftin_data_ctrl_bitcnts = {o_shiftin_data_ctrl_bitcnts_c3,o_shiftin_data_ctrl_bitcnts_c2,o_shiftin_data_ctrl_bitcnts_c1,o_shiftin_data_ctrl_bitcnts_c0};
assign {i_shiftin_databits_updated_c3,i_shiftin_databits_updated_c2,i_shiftin_databits_updated_c1,i_shiftin_databits_updated_c0}= w_shiftin_databits_updated;

assign w_shiftmode_point_cnts = {o_shiftmode_point_cnts_c3,o_shiftmode_point_cnts_c2,o_shiftmode_point_cnts_c1,o_shiftmode_point_cnts_c0};
assign w_capture_mode_automatic_validedge = {o_capture_mode_automatic_validedge_c3,o_capture_mode_automatic_validedge_c2,o_capture_mode_automatic_validedge_c1,o_capture_mode_automatic_validedge_c0};
assign w_shiftmode_point_en = {o_shiftmode_point_en_c3,o_shiftmode_point_en_c2,o_shiftmode_point_en_c1,o_shiftmode_point_en_c0};  

assign w_ir_din_onecycle_value_a = {o_ir_din_onecycle_value_a_c3,o_ir_din_onecycle_value_a_c2,o_ir_din_onecycle_value_a_c1,o_ir_din_onecycle_value_a_c0};//
assign w_ir_din_onecycle_value_b = {o_ir_din_onecycle_value_b_c3,o_ir_din_onecycle_value_b_c2,o_ir_din_onecycle_value_b_c1,o_ir_din_onecycle_value_b_c0};//
assign w_ir_din_bypass = {o_ir_din_bypass_c3,o_ir_din_bypass_c2,o_ir_din_bypass_c1,o_ir_din_bypass_c0};
assign w_ir_dout_opts =  {o_ir_dout_opts_c3,o_ir_dout_opts_c2,o_ir_dout_opts_c1,o_ir_dout_opts_c0};//
assign w_ir_dout_bypass = {o_ir_dout_bypass_c3,o_ir_dout_bypass_c2,o_ir_dout_bypass_c1,o_ir_dout_bypass_c0};//


counter_all #(.COUNTER_NUM(COUNTER_NUM)) u_counter_all(
        .i_clk                              (i_clk                                      ),
        .i_rst_n                            (i_rst_n                                    ),
        .i_pclk                             (i_pclk                                     ),
        .i_prst_n                           (i_prst_n                                   ),
        //sync data & trigger                                                              
        .i_extern_din_a                     (i_extern_din_a                             ),
        .i_extern_din_b                     (i_extern_din_b                             ),
        .i_single_start_trigger             (w_single_start_trigger                     ),
        .i_single_stop_trigger              (w_single_stop_trigger                      ),
        .i_single_clear_trigger             (w_single_clear_trigger                     ),
        .i_single_reset_trigger             (w_single_reset_trigger                     ),
        .i_global_start_trigger             (w_global_start_trigger                     ),
        .i_global_stop_trigger              (w_global_stop_trigger                      ),
        .i_global_clear_trigger             (w_global_clear_trigger                     ),
        .i_global_reset_trigger             (w_global_reset_trigger                     ),
        .o_extern_dout_a                    (o_extern_dout_a                            ),
        .o_extern_dout_a_oen                (o_extern_dout_a_oen                        ),
        .o_extern_dout_b                    (o_extern_dout_b                            ),
        .o_extern_dout_b_oen                (o_extern_dout_b_oen                        ),
        //configure register & status.                                                     
        .i_enable                           (o_enable                                   ),
        .i_mux_sel                          (w_mux_sel                                  ),
        .i_soft_trigger_ctrl                (w_soft_trigger_ctrl                        ),
        .i_src_sel_start                    (w_src_sel_start                            ),       
        .i_src_edge_start                   (w_src_edge_start                           ),
        .i_src_sel_stop                     (w_src_sel_stop                             ),       
        .i_src_edge_stop                    (w_src_edge_stop                            ),
        .i_src_sel_din0                     (w_src_sel_din0                             ),       
        .i_src_edge_din0                    (w_src_edge_din0                            ),
        .i_src_sel_din1                     (w_src_sel_din1                             ),       
        .i_src_edge_din1                    (w_src_edge_din1                            ),
        .i_ctrl_snap                        (w_ctrl_snap                                ),
        .o_snap_status                      (w_snap_status                              ),
        .i_clear_snap                       (w_clear_snap                               ),
        .o_shadow_reg                       (w_shadow_reg                               ),
        .i_target_reg_ctrl                  (w_target_reg_ctrl                          ),
        .i_target_reg_a0                    (w_target_reg_a0                            ),
        .i_target_reg_a1                    (w_target_reg_a1                            ),
        .i_target_reg_a2                    (w_target_reg_a2                            ),
        .i_target_reg_b0                    (w_target_reg_b0                            ),
        .i_target_reg_b1                    (w_target_reg_b1                            ),
        .i_target_reg_b2                    (w_target_reg_b2                            ),
        .o_capture_reg_status               (w_capture_reg_status                       ),
        .i_capture_reg_read_flag            (w_capture_reg_read_flag                    ),
        .i_capture_reg_overflow_ctrl        (w_capture_reg_overflow_ctrl                ),
        .o_capture_reg_a0                   (w_capture_reg_a0                           ),
        .o_capture_reg_a1                   (w_capture_reg_a1                           ),
        .o_capture_reg_a2                   (w_capture_reg_a2                           ),
        .o_capture_reg_b0                   (w_capture_reg_b0                           ),
        .o_capture_reg_b1                   (w_capture_reg_b1                           ),
        .o_capture_reg_b2                   (w_capture_reg_b2                           ),
        .i_mode_sel                         (w_mode_sel                                 ),
        .i_switch_mode_onebit_cnts          (w_switch_mode_onebit_cnts                  ),
        .i_waveform_mode_cnts               (w_waveform_mode_cnts                       ),
        .i_capture_mode_cnts                (w_capture_mode_cnts                        ),
        .i_waveform_mode_automatic_sw       (w_waveform_mode_automatic_sw               ),
        .i_capture_mode_automatic_sw        (w_capture_mode_automatic_sw                ),
        .i_capture_mode_automatic_validedge (w_capture_mode_automatic_validedge         ),
        .i_shiftmode_point_en               (w_shiftmode_point_en                       ),
        .i_shiftmode_point_cnts             (w_shiftmode_point_cnts                     ),  
        .i_shiftmode_ctrl                   (w_shiftmode_ctrl                           ),
        .i_shiftout_data                    (w_shiftout_data                            ),
        .i_shiftout_data_ctrl_bitcnts       (w_shiftout_data_ctrl_bitcnts               ),
        .i_shiftout_data_valid              (w_shiftout_data_valid                      ),
        .o_shiftin_data                     (w_shiftin_data                             ),
        .o_shiftin_databits_updated         (w_shiftin_databits_updated                 ),
        .i_shiftin_data_ctrl_bitcnts        (w_shiftin_data_ctrl_bitcnts                ),
    //
    .i_clk_ir_s             (i_clk_ir_s                 ),
        .i_rst_ir_n             (i_rst_ir_n                 ),
        .i_ir_din_onecycle_value_a          (w_ir_din_onecycle_value_a          ),
        .i_ir_din_onecycle_value_b          (w_ir_din_onecycle_value_b          ),
        .i_ir_din_bypass                    (w_ir_din_bypass                ),
        .i_ir_dout_opts                     (w_ir_dout_opts             ),
        .i_ir_dout_bypass                   (w_ir_dout_bypass               ), 
        //interrupt.                                                                       
        .o_int                              (w_int                                      )

);

wire [31:0] intr_src_d;

genvar i;
generate for(i=0;i<COUNTER_NUM;i=i+1) begin:int_sync
counter_data_syn_param #(.BUS_WIDTH(8))    u_syn(
        .i_clk_din   (i_clk[i]),
        .i_rstn_din  (i_rst_n[i]),
        .i_din       (w_int[(i+1)*8-1:i*8]),
        .i_clk_dout  (i_pclk),
        .i_rstn_dout (i_prst_n),
        .o_syn_dout  (intr_src_d[(i+1)*8-1:i*8])
);
end
endgenerate


wire w_intrctrl_sreset = o_intrctrl_sreset;//
wire o_intr_lvl;

intrctrl #(
  .INTR_SRC_WIDTH   ( 32             ), 
  .MASK_DEFAULT_SET ( 1              )  
) u_intrctrl (
  .i_clk              ( i_pclk                          ), 
  .i_rst_n            ( i_prst_n                        ), 
  .i_sreset           ( w_intrctrl_sreset               ), 
        
  .i_intr_src         ( intr_src_d                      ), 
  .i_intr_reg_clr     ( ctl_intr_clr_counter            ), 
  .i_intr_reg_clr_wr  ( wen_intr_clr_d                  ), 
  .i_intr_reg_set     ( ctl_intr_set_counter            ), 
  .i_intr_reg_set_wr  ( wen_intr_mask_set_d             ), 
  .o_intr_status      ( sts_intr_status_counter         ), 

  .i_intr_mask_set    ( ctl_intr_mask_set_counter       ), 
  .i_intr_mask_set_wr ( wen_intr_mask_set_d             ), 
  .i_intr_mask_clr    ( ctl_intr_mask_clr_counter       ), 
  .i_intr_mask_clr_wr ( wen_intr_mask_clr_d             ), 
  .o_intr_mask        ( sts_intr_mask_status_counter    ), 
    
  .o_intr_lvl         ( o_intr_lvl                      ), 
  .o_intr_pls         (                                 )  
);

assign o_int = o_intr_lvl;



endmodule

`default_nettype wire
