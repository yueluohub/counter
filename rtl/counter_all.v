
`timescale 1ns / 1ps 
`default_nettype none

module counter_all(
        //counter clock domain.
        i_clk,
        i_rst_n,
        //apb bus register clock domain.
        i_pclk,
        i_prst_n,
        //sync data & trigger
        i_extern_din_a,
        i_extern_din_b,
        //i_inner_din,
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
        i_mux_sel,
        i_soft_trigger_ctrl,
        i_src_sel_start,
        i_src_edge_start,
        i_src_sel_stop,
        i_src_edge_stop,
        i_src_sel_din0,
        i_src_edge_din0,
        i_src_sel_din1,
        i_src_edge_din1,
        i_ctrl_snap,
        o_snap_status,
        i_clear_snap,        
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
        i_capture_mode_automatic_validedge,
        i_shiftmode_point_en,
        i_shiftmode_point_cnts,         
        i_shiftmode_ctrl,
        i_shiftout_data,
        i_shiftout_data_ctrl_bitcnts,
        i_shiftout_data_valid,
        o_shiftin_data,
        o_shiftin_databits_updated,
        i_shiftin_data_ctrl_bitcnts,
        //IR remote control ifc.
        i_clk_ir_s,
        i_rst_ir_n,
        i_ir_din_onecycle_value_a,
        i_ir_din_onecycle_value_b,
        i_ir_din_bypass,
        i_ir_dout_opts,
        i_ir_dout_bypass,   
        //interrupt.
        o_int
);

parameter   COUNTER_NUM=4;
localparam SEL_WIDTH=$clog2(COUNTER_NUM+4+4+2);

input wire [COUNTER_NUM-1:0] i_clk;// counter clock domain.
input wire [COUNTER_NUM-1:0] i_rst_n;
//apb bus register clock domain.
input wire      i_pclk;
input wire      i_prst_n;
//sync data & trigger
input wire [COUNTER_NUM-1:0] i_extern_din_a;
input wire [COUNTER_NUM-1:0] i_extern_din_b;
//input  [COUNTER_NUM*COUNTER_NUM-1:0] i_inner_din;
input wire [COUNTER_NUM-1:0] i_single_start_trigger;
input wire [COUNTER_NUM-1:0] i_single_stop_trigger;
input wire [COUNTER_NUM-1:0] i_single_clear_trigger;
input wire [COUNTER_NUM-1:0] i_single_reset_trigger;
input wire                   i_global_start_trigger;
input wire                   i_global_stop_trigger;
input wire                   i_global_clear_trigger;
input wire                   i_global_reset_trigger;
output  wire [COUNTER_NUM-1:0] o_extern_dout_a;
output  wire [COUNTER_NUM-1:0] o_extern_dout_a_oen;
output  wire [COUNTER_NUM-1:0] o_extern_dout_b;
output  wire [COUNTER_NUM-1:0] o_extern_dout_b_oen;
//

//configure register & status.
input  wire [COUNTER_NUM-1:0] i_enable;
input  wire [COUNTER_NUM*COUNTER_NUM-1:0] i_mux_sel;
input  wire [COUNTER_NUM*8-1:0] i_soft_trigger_ctrl;   // to control the function of single/global_trigger, as a normal control signal or a softward trigger signal.
input  wire [COUNTER_NUM*SEL_WIDTH-1:0] i_src_sel_start;
input  wire [COUNTER_NUM*2-1:0] i_src_edge_start;
input  wire [COUNTER_NUM*SEL_WIDTH-1:0] i_src_sel_stop;
input  wire [COUNTER_NUM*2-1:0] i_src_edge_stop;
input  wire [COUNTER_NUM*SEL_WIDTH-1:0] i_src_sel_din0;
input  wire [COUNTER_NUM*2-1:0] i_src_edge_din0;
input  wire [COUNTER_NUM*SEL_WIDTH-1:0] i_src_sel_din1;
input  wire [COUNTER_NUM*2-1:0] i_src_edge_din1;
input  wire [COUNTER_NUM*4-1:0] i_ctrl_snap;
output wire [COUNTER_NUM*8-1:0] o_snap_status;
input  wire [COUNTER_NUM-1:0]   i_clear_snap;
output wire [COUNTER_NUM*32-1:0] o_shadow_reg;
input  wire [COUNTER_NUM*6-1:0] i_target_reg_ctrl;
//[0]: when counters meet i_target_reg_a2, 1- keep the value,   0- reset the value.
//[1]: when counters meet i_target_reg_a2, 1- stop the counter, 0- restart the counter.
//[2]: when counters meet i_target_reg_b2, 1- keep the value,   0- reset the value.
//[3]: when counters meet i_target_reg_b2, 1- stop the counter, 0- restart the counter.
//[4]: dout_a reset value.
//[5]: dout_b reset value.
input  wire [COUNTER_NUM*32-1:0] i_target_reg_a0;
input  wire [COUNTER_NUM*32-1:0] i_target_reg_a1;
input  wire [COUNTER_NUM*32-1:0] i_target_reg_a2;
input  wire [COUNTER_NUM*32-1:0] i_target_reg_b0;
input  wire [COUNTER_NUM*32-1:0] i_target_reg_b1;
input  wire [COUNTER_NUM*32-1:0] i_target_reg_b2;
output wire [COUNTER_NUM*6-1:0] o_capture_reg_status;//(a2/a1/a0)bit2-bit0:1-active.(b2/b1/b0)bit5-bit3;
input  wire [COUNTER_NUM*6-1:0] i_capture_reg_read_flag;//(a2/a1/a0)bit2-bit0:1-active.(b2/b1/b0)bit5-bit3:
input  wire [COUNTER_NUM*6-1:0] i_capture_reg_overflow_ctrl;//bit5~bit0: 1-overwrite,0-discard.
output wire [COUNTER_NUM*32-1:0] o_capture_reg_a0;
output wire [COUNTER_NUM*32-1:0] o_capture_reg_a1;
output wire [COUNTER_NUM*32-1:0] o_capture_reg_a2;
output wire [COUNTER_NUM*32-1:0] o_capture_reg_b0;
output wire [COUNTER_NUM*32-1:0] o_capture_reg_b1;
output wire [COUNTER_NUM*32-1:0] o_capture_reg_b2;
input  wire [COUNTER_NUM*3-1:0] i_mode_sel;
//[0]: 0-capture_mode/shitin_mode, 1-waveform_mode/shiftout_mode.
//[1]: 0-count mode, 1-shift mode.
//[2]: 0-automatic switch mode disable. 1-enable.
input  wire [COUNTER_NUM*16-1:0] i_switch_mode_onebit_cnts;
input  wire [COUNTER_NUM*8-1:0] i_waveform_mode_cnts;//waveform/shiftout mode cnts.
input  wire [COUNTER_NUM*8-1:0] i_capture_mode_cnts;//capture/shiftin mode cnts.
input  wire [COUNTER_NUM-1:0] i_waveform_mode_automatic_sw;//1-automatic switch to waveform mode enable,0-disable.
input  wire [COUNTER_NUM-1:0] i_capture_mode_automatic_sw;//1-automatic switch to capture mode enable,0-disable.
input  wire [COUNTER_NUM-1:0] i_shiftmode_ctrl;//0-bus_a(din_a/dout_a),1-bus_b(din_b/dout_b).
input wire  [COUNTER_NUM-1:0] i_capture_mode_automatic_validedge;//1-automatic capture mode first valid edge enable,0-disable.
input wire  [COUNTER_NUM-1:0] i_shiftmode_point_en;//shiftin data in this cnts or shiftout data in the cnts enable ,1 is active.
input wire  [COUNTER_NUM*16-1:0] i_shiftmode_point_cnts;//shiftin data in this cnts or shiftout data in the cnts.

input  wire [COUNTER_NUM*32-1:0] i_shiftout_data;
input  wire [COUNTER_NUM*5-1:0] i_shiftout_data_ctrl_bitcnts;//n-> (n+1) bit;
input  wire [COUNTER_NUM-1:0] i_shiftout_data_valid;//1->active.
output wire [COUNTER_NUM*32-1:0] o_shiftin_data;
output wire [COUNTER_NUM*32-1:0] o_shiftin_databits_updated;//1-> new data.
input  wire [COUNTER_NUM*5-1:0] i_shiftin_data_ctrl_bitcnts;//n-> (n+1) bit;

input  wire [COUNTER_NUM-1:0]       i_clk_ir_s;//
input  wire [COUNTER_NUM-1:0]       i_rst_ir_n;//
input  wire [COUNTER_NUM*32-1:0]    i_ir_din_onecycle_value_a;//
input  wire [COUNTER_NUM*32-1:0]    i_ir_din_onecycle_value_b;//
input  wire [COUNTER_NUM*2-1:0]     i_ir_din_bypass;
input  wire [COUNTER_NUM*8-1:0]     i_ir_dout_opts;//3~0 ->a,7~4 ->b;
input  wire [COUNTER_NUM*2-1:0]     i_ir_dout_bypass;//0->a,1->b.

//interrupt.
output wire [COUNTER_NUM*8-1:0] o_int;//

wire [COUNTER_NUM*COUNTER_NUM-1:0] w_inner_din;

wire [COUNTER_NUM-1:0]      w_syn_single_start_trigger;
wire [COUNTER_NUM-1:0]      w_syn_single_stop_trigger;
wire [COUNTER_NUM-1:0]      w_syn_single_clear_trigger;
wire [COUNTER_NUM-1:0]      w_syn_single_reset_trigger;
wire [COUNTER_NUM-1:0]      w_syn_global_start_trigger;
wire [COUNTER_NUM-1:0]      w_syn_global_stop_trigger;
wire [COUNTER_NUM-1:0]      w_syn_global_clear_trigger;
wire [COUNTER_NUM-1:0]      w_syn_global_reset_trigger;
wire [COUNTER_NUM-1:0]      w_syn_enable;
wire [COUNTER_NUM*4-1:0]    w_syn_ctrl_snap;
wire [COUNTER_NUM-1:0]      w_syn_shiftout_data_valid;
wire [COUNTER_NUM*6-1:0]    w_syn_capture_reg_read_flag;//(a2/a1/a0)bit2-bit0:1-active.(b2/b1/b0)bit5-bit3:

//wire [COUNTER_NUM*4-1:0] w_syn_ctrl_snap;
wire [COUNTER_NUM*4-1:0] w_syn_snap_status;
wire [COUNTER_NUM-1:0]   w_syn_clear_snap;

wire [COUNTER_NUM-1:0] w_ir_extern_din_a;
wire [COUNTER_NUM-1:0] w_ir_extern_din_b;
wire [COUNTER_NUM-1:0] w_ir_extern_dout_a;
wire [COUNTER_NUM-1:0] w_ir_extern_dout_b;

genvar i;
generate for(i=0;i<COUNTER_NUM;i=i+1) begin:counter_loop



counter_data_syn_param #(.BUS_WIDTH(21))    u_syn_bus(
        .i_clk_din   (i_pclk),
        .i_rstn_din  (i_prst_n),
        .i_din       ({ i_single_start_trigger[i],
                        i_single_stop_trigger[i],
                        i_single_clear_trigger[i],
                        i_single_reset_trigger[i],
                        i_global_start_trigger,
                        i_global_stop_trigger,
                        i_global_clear_trigger,
                        i_global_reset_trigger,
                        i_enable[i],
                        i_ctrl_snap[(i+1)*4-1:i*4],
                        i_clear_snap[i],
                        i_capture_reg_read_flag[(i+1)*6-1:i*6],
                        i_shiftout_data_valid[i]}
                        ),
        .i_clk_dout  (i_clk[i]),
        .i_rstn_dout (i_rst_n[i]),
        .o_syn_dout  ({ w_syn_single_start_trigger[i],
                        w_syn_single_stop_trigger[i],
                        w_syn_single_clear_trigger[i],
                        w_syn_single_reset_trigger[i],
                        w_syn_global_start_trigger[i],
                        w_syn_global_stop_trigger[i],
                        w_syn_global_clear_trigger[i],
                        w_syn_global_reset_trigger[i],
                        w_syn_enable[i],
                        w_syn_ctrl_snap[(i+1)*4-1:i*4],
                        w_syn_clear_snap[i],
                        w_syn_capture_reg_read_flag[(i+1)*6-1:i*6],
                        w_syn_shiftout_data_valid[i]}
                        )
);




counter #(.COUNTER_NUM(COUNTER_NUM)) u_counter(
        .i_clk                              (i_clk[i]                                      ),
        .i_rst_n                            (i_rst_n[i]                                    ),
        //sync data & trigger                                                              
        .i_extern_din_a                     (w_ir_extern_din_a[i]                          ),
        .i_extern_din_b                     (w_ir_extern_din_b[i]                          ),
        .i_inner_din                        (w_inner_din[COUNTER_NUM*(i+1)-1:COUNTER_NUM*i]),           
        .i_single_start_trigger             (w_syn_single_start_trigger[i]                 ),
        .i_single_stop_trigger              (w_syn_single_stop_trigger[i]                  ),
        .i_single_clear_trigger             (w_syn_single_clear_trigger[i]                 ),
        .i_single_reset_trigger             (w_syn_single_reset_trigger[i]                 ),
        .i_global_start_trigger             (w_syn_global_start_trigger[i]                 ),
        .i_global_stop_trigger              (w_syn_global_stop_trigger[i]                  ),
        .i_global_clear_trigger             (w_syn_global_clear_trigger[i]                 ),
        .i_global_reset_trigger             (w_syn_global_reset_trigger[i]                 ),
        .o_extern_dout_a                    (w_ir_extern_dout_a[i]                         ),
        .o_extern_dout_a_oen                (o_extern_dout_a_oen[i]                        ),
        .o_extern_dout_b                    (w_ir_extern_dout_b[i]                         ),
        .o_extern_dout_b_oen                (o_extern_dout_b_oen[i]                        ),
        //configure register & status.                                                     
        .i_enable                           (w_syn_enable[i]                               ),
        .i_soft_trigger_ctrl                (i_soft_trigger_ctrl[(i+1)*8-1:i*8]            ),
        .i_src_sel_start                    (i_src_sel_start[(i+1)*SEL_WIDTH-1:i*SEL_WIDTH]),       
        .i_src_edge_start                   (i_src_edge_start[(i+1)*2-1:i*2]               ),
        .i_src_sel_stop                     (i_src_sel_stop[(i+1)*SEL_WIDTH-1:i*SEL_WIDTH] ),       
        .i_src_edge_stop                    (i_src_edge_stop[(i+1)*2-1:i*2]                ),
        .i_src_sel_din0                     (i_src_sel_din0[(i+1)*SEL_WIDTH-1:i*SEL_WIDTH] ),       
        .i_src_edge_din0                    (i_src_edge_din0[(i+1)*2-1:i*2]                ),
        .i_src_sel_din1                     (i_src_sel_din1[(i+1)*SEL_WIDTH-1:i*SEL_WIDTH] ),       
        .i_src_edge_din1                    (i_src_edge_din1[(i+1)*2-1:i*2]                ),
        .i_ctrl_snap                        (w_syn_ctrl_snap[(i+1)*4-1:i*4]                ),
        .o_snap_status                      (o_snap_status[(i+1)*8-1:i*8]                  ),
        .i_clear_snap                       (w_syn_clear_snap[i]                           ),
        .o_shadow_reg                       (o_shadow_reg[(i+1)*32-1:i*32]                 ),
        .i_target_reg_ctrl                  (i_target_reg_ctrl[(i+1)*6-1:i*6]              ),
        .i_target_reg_a0                    (i_target_reg_a0[(i+1)*32-1:i*32]              ),
        .i_target_reg_a1                    (i_target_reg_a1[(i+1)*32-1:i*32]              ),
        .i_target_reg_a2                    (i_target_reg_a2[(i+1)*32-1:i*32]              ),
        .i_target_reg_b0                    (i_target_reg_b0[(i+1)*32-1:i*32]              ),
        .i_target_reg_b1                    (i_target_reg_b1[(i+1)*32-1:i*32]              ),
        .i_target_reg_b2                    (i_target_reg_b2[(i+1)*32-1:i*32]              ),
        .o_capture_reg_status               (o_capture_reg_status[(i+1)*6-1:i*6]           ),
        .i_capture_reg_read_flag            (w_syn_capture_reg_read_flag[(i+1)*6-1:i*6]    ),
        .i_capture_reg_overflow_ctrl        (i_capture_reg_overflow_ctrl[(i+1)*6-1:i*6]    ),
        .o_capture_reg_a0                   (o_capture_reg_a0[(i+1)*32-1:i*32]             ),
        .o_capture_reg_a1                   (o_capture_reg_a1[(i+1)*32-1:i*32]             ),
        .o_capture_reg_a2                   (o_capture_reg_a2[(i+1)*32-1:i*32]             ),
        .o_capture_reg_b0                   (o_capture_reg_b0[(i+1)*32-1:i*32]             ),
        .o_capture_reg_b1                   (o_capture_reg_b1[(i+1)*32-1:i*32]             ),
        .o_capture_reg_b2                   (o_capture_reg_b2[(i+1)*32-1:i*32]             ),
        .i_mode_sel                         (i_mode_sel[(i+1)*3-1:i*3]                     ),
        .i_switch_mode_onebit_cnts          (i_switch_mode_onebit_cnts[(i+1)*16-1:i*16]    ),
        .i_waveform_mode_cnts               (i_waveform_mode_cnts[(i+1)*8-1:i*8]           ),
        .i_capture_mode_cnts                (i_capture_mode_cnts[(i+1)*8-1:i*8]            ),
        .i_waveform_mode_automatic_sw       (i_waveform_mode_automatic_sw[i]               ),
        .i_capture_mode_automatic_sw        (i_capture_mode_automatic_sw[i]                ),
        .i_capture_mode_automatic_validedge (i_capture_mode_automatic_validedge[i]         ),
        .i_shiftmode_point_en               (i_shiftmode_point_en[i]                       ),
        .i_shiftmode_point_cnts             (i_shiftmode_point_cnts[(i+1)*16-1:i*16]       ),  
        .i_shiftmode_ctrl                   (i_shiftmode_ctrl[i]                           ),
        .i_shiftout_data                    (i_shiftout_data[(i+1)*32-1:i*32]              ),
        .i_shiftout_data_ctrl_bitcnts       (i_shiftout_data_ctrl_bitcnts[(i+1)*5-1:i*5]   ),
        .i_shiftout_data_valid              (w_syn_shiftout_data_valid[i]                  ),
        .o_shiftin_data                     (o_shiftin_data[(i+1)*32-1:i*32]               ),
        .o_shiftin_databits_updated         (o_shiftin_databits_updated[(i+1)*32-1:i*32]   ),
        .i_shiftin_data_ctrl_bitcnts        (i_shiftin_data_ctrl_bitcnts[(i+1)*5-1:i*5]    ),
        //interrupt.                                                                       
        .o_int                              (o_int[(i+1)*8-1:i*8]                          )

);

counter_datamux_syn #(.COUNTER_NUM(COUNTER_NUM)) u_mux_syn(
        .i_clk_din     (i_clk[COUNTER_NUM-1:0]                          ),
        .i_rstn_din    (i_rst_n[COUNTER_NUM-1:0]                        ),
        .i_mux_sel     (i_mux_sel[COUNTER_NUM*(i+1)-1:COUNTER_NUM*i]    ),
        .i_inner_din_a (o_extern_dout_a[COUNTER_NUM-1:0]                ),
        .i_inner_din_b (o_extern_dout_b[COUNTER_NUM-1:0]                ),
        .i_clk_dout    (i_clk[i]                                        ),
        .i_rstn_dout   (i_rst_n[i]                                      ),
        .o_mux_dout    (w_inner_din[COUNTER_NUM*(i+1)-1:COUNTER_NUM*i]  )
);


counter_ir_frontend u_counter_ir_frontend(
        .i_clk                      (i_clk_ir_s[i]                                  ),
        .i_rst_n                    (i_rst_ir_n[i]                                  ),
        .i_ir_din_onecycle_value_a  (i_ir_din_onecycle_value_a[(i+1)*32-1:i*32]     ),
        .i_ir_din_onecycle_value_b  (i_ir_din_onecycle_value_b[(i+1)*32-1:i*32]     ),
        .i_ir_din_bypass            (i_ir_din_bypass[2*(i+1)-1:2*i]                 ),
        .i_extern_din_a             (i_extern_din_a[i]                              ),
        .i_extern_din_b             (i_extern_din_b[i]                              ),
        .o_ir_extern_din_a          (w_ir_extern_din_a[i]                           ),
        .o_ir_extern_din_b          (w_ir_extern_din_b[i]                           ),
        .i_ir_dout_opts             (i_ir_dout_opts[8*(i+1)-1:8*i]                  ),
        .i_ir_dout_bypass           (i_ir_dout_bypass[2*(i+1)-1:2*i]                ),
        .i_extern_dout_a            (w_ir_extern_dout_a[i]                          ),
        .i_extern_dout_b            (w_ir_extern_dout_b[i]                          ),
        .o_ir_extern_dout_a         (o_extern_dout_a[i]                             ),
        .o_ir_extern_dout_b         (o_extern_dout_b[i]                             )
);


end
endgenerate


















endmodule
`default_nettype wire
