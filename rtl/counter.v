
`timescale 1ns / 1ps 
`default_nettype none

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
        //interrupt.
        o_int

);

parameter   COUNTER_NUM=4,
            CURRENT_COUNTER_NUM=0;

localparam SEL_WIDTH=$clog2(COUNTER_NUM+4+4+2);//innter din+single_trigger+global_trigger+external din.
//parameter SEL_WIDTH=$clog2(COUNTER_NUM+4+4+2);//innter din+single_trigger+global_trigger+external din.

 
input wire   i_clk;
input wire   i_rst_n;
//sync data & trigger
input wire   i_extern_din_a;
input wire   i_extern_din_b;
input wire   [COUNTER_NUM-1:0] i_inner_din;
input wire   i_single_start_trigger;
input wire   i_single_stop_trigger;
input wire   i_single_clear_trigger;
input wire   i_single_reset_trigger;
input wire   i_global_start_trigger;
input wire   i_global_stop_trigger;
input wire   i_global_clear_trigger;
input wire   i_global_reset_trigger;
output o_extern_dout_a;
output o_extern_dout_a_oen;
output o_extern_dout_b;
output o_extern_dout_b_oen;
//configure register & status.
input wire   i_enable;
input wire   [7:0] i_soft_trigger_ctrl;   
// to control the function of single/global_trigger, as a normal control signal or a softward trigger signal.
// every bit means the same. 1--> softward trigger signal, 0--> normal control signal. 
// [0]:set for signal o_global_start_trigger. 
// [1]:set for signal o_global_stop_trigger. 
// [2]:set for signal o_global_clear_trigger. 
// [3]:set for signal o_global_reset_trigger. 
// [4]:set for signal o_single_start_trigger. 
input wire   [SEL_WIDTH-1:0] i_src_sel_start;
input wire   [1:0] i_src_edge_start;
input wire   [SEL_WIDTH-1:0] i_src_sel_stop;
input wire   [1:0] i_src_edge_stop;
input wire   [SEL_WIDTH-1:0] i_src_sel_din0;
input wire   [1:0] i_src_edge_din0;
input wire   [SEL_WIDTH-1:0] i_src_sel_din1;
input wire   [1:0] i_src_edge_din1;
input wire   [3:0] i_ctrl_snap;
output reg   [7:0] o_snap_status;
input wire         i_clear_snap;
output [31:0] o_shadow_reg;
input wire   [5:0] i_target_reg_ctrl;
//[0]: when counters meet i_target_reg_a2, 1- keep the value,   0- reset the value.
//[1]: when counters meet i_target_reg_a2, 1- stop the counter, 0- restart the counter.
//[2]: when counters meet i_target_reg_b2, 1- keep the value,   0- reset the value.
//[3]: when counters meet i_target_reg_b2, 1- stop the counter, 0- restart the counter.
//[4]: dout_a reset value.
//[5]: dout_b reset value.
input wire   [31:0] i_target_reg_a0;
input wire   [31:0] i_target_reg_a1;
input wire   [31:0] i_target_reg_a2;
input wire   [31:0] i_target_reg_b0;
input wire   [31:0] i_target_reg_b1;
input wire   [31:0] i_target_reg_b2;
output [5:0] o_capture_reg_status;//(a2/a1/a0)bit2-bit0:1-active.(b2/b1/b0)bit5-bit3;
input wire   [5:0] i_capture_reg_read_flag;//(a2/a1/a0)bit2-bit0:1-active.(b2/b1/b0)bit5-bit3:
input wire   [5:0] i_capture_reg_overflow_ctrl;//bit5~bit0: 1-overwrite,0-discard.
output [31:0] o_capture_reg_a0;
output [31:0] o_capture_reg_a1;
output [31:0] o_capture_reg_a2;
output [31:0] o_capture_reg_b0;
output [31:0] o_capture_reg_b1;
output [31:0] o_capture_reg_b2;
input wire   [2:0] i_mode_sel;
//[0]: 0-capture_mode/shitin_mode, 1-waveform_mode/shiftout_mode.
//[1]: 0-count mode, 1-shift mode.
//[2]: 0-automatic switch mode disable. 1-enable.
input wire   [15:0] i_switch_mode_onebit_cnts;
input wire   [7:0] i_waveform_mode_cnts;//waveform/shiftout mode cnts.
input wire   [7:0] i_capture_mode_cnts;//capture/shiftin mode cnts.
input wire   i_waveform_mode_automatic_sw;//1-automatic switch to waveform mode enable,0-disable.
input wire   i_capture_mode_automatic_sw;//1-automatic switch to capture mode enable,0-disable.

input wire   i_capture_mode_automatic_validedge;//1-automatic capture mode first valid edge enable,0-disable.
input wire   i_shiftmode_point_en;//shiftin data in this cnts or shiftout data in the cnts enable ,1 is active.
input wire   [15:0] i_shiftmode_point_cnts;//shiftin data in this cnts or shiftout data in the cnts.

input wire   i_shiftmode_ctrl;//0-bus_a(din_a/dout_a),1-bus_b(din_b/dout_b).
input wire   [31:0] i_shiftout_data;
input wire   [4:0] i_shiftout_data_ctrl_bitcnts;//n-> (n+1) bit;
input wire    i_shiftout_data_valid;//1->active.
output [31:0] o_shiftin_data;
output [31:0] o_shiftin_databits_updated;//1-> new data.
input wire   [4:0] i_shiftin_data_ctrl_bitcnts;//n-> (n+1) bit;

//interrupt.
output [7:0] o_int;//
//
reg o_extern_dout_a;
reg o_extern_dout_a_oen;
reg o_extern_dout_b;
reg o_extern_dout_b_oen;
reg [31:0] o_shadow_reg;
reg [5:0] o_capture_reg_status;
reg [31:0] o_capture_reg_a0;
reg [31:0] o_capture_reg_a1;
reg [31:0] o_capture_reg_a2;
reg [31:0] o_capture_reg_b0;
reg [31:0] o_capture_reg_b1;
reg [31:0] o_capture_reg_b2;
reg [31:0] o_shiftin_data;
reg [31:0] o_shiftin_databits_updated;
reg [7:0] o_int;

reg [5:0]  r1_capture_reg_status;
reg [31:0] r1_capture_reg_a0;
reg [31:0] r1_capture_reg_a1;
reg [31:0] r1_capture_reg_a2;
reg [31:0] r1_capture_reg_b0;
reg [31:0] r1_capture_reg_b1;
reg [31:0] r1_capture_reg_b2;

//
reg  counter_start;
reg  counter_stop;
reg  counter_din0;
reg  counter_din1;

wire inner_din_shift;
reg [31:0] current_counter;
reg count_en;
reg waveform_mode_en; //
reg capture_mode_en;
reg shiftin_mode_en,shiftout_mode_en;//
reg [7:0] data_sends_bits_cnts;
reg [7:0] data_recs_bits_cnts;
reg [32:0] lastbit_current_counter;
reg [32:0] last_current_counter_a;
reg [32:0] last_current_counter_b;
reg [5:0]   r1_target_reg_status;
wire [32:0] current_counter_target_reg_a;
wire [32:0] current_counter_target_reg_b;

reg  [63:0] r1_shiftout_data;
reg  [63:0] r1_shiftout_databits_valid;
reg  r1_shiftout_data_valid_dly;
wire  w1_shiftout_only_onebit_flag;
// reg   r1_shiftout_start_onebit_flag;
wire [31:0] i_shiftin_data_ctrl_bitmap;
wire  counter_shiftin_din;
wire  shiftin_complete_flag;

reg [1:0] counter_start_dly;
reg [1:0] counter_stop_dly;
reg [1:0] counter_din0_dly;
reg [1:0] counter_din1_dly;
wire start_flag;
wire stop_flag;
wire din0_flag;
wire din1_flag;
wire soft_start_flag;
wire soft_stop_flag;
wire soft_clear_flag;
wire soft_reset_flag;
reg [3:0]  r1_ctrl_snap_dly;
wire [3:0] w_ctrl_snap_posedge;
reg [1:0] r1_clear_snap_dly;
wire w_clear_snap_posedge;
reg [1:0] capture_cnts_a,capture_cnts_b;
reg [31:0] r1_shiftin_data;
reg [31:0] r1_shiftin_databits_updated;
reg    [5:0] r1_capture_reg_read_flag_dly;//(a2/a1/a0)bit2-bit0:1-active.(b2/b1/b0)bit5-bit3:
wire   [5:0] w_capture_reg_read_flag_posedge;//(a2/a1/a0)bit2-bit0:1-active.(b2/b1/b0)bit5-bit3:
wire w_count_overflow_flag;
wire [32:0] current_counter_automatic;
wire w1_waveform_match_reg3;

//assign inner_din_shift = i_inner_din>>COUNTER_NUM-1;
wire [5:0] w1_inner_din;
assign w1_inner_din = {{(6-COUNTER_NUM){1'b0}},i_inner_din[COUNTER_NUM-1:0]};

always @(*) begin
    case(32'h1<<i_src_sel_start) 
        32'h1<<1 :   counter_start = i_extern_din_a;
        32'h1<<2 :   counter_start = i_extern_din_b;
        32'h1<<3 :   counter_start = i_global_start_trigger & i_soft_trigger_ctrl[0];
        32'h1<<4 :   counter_start = i_single_start_trigger & i_soft_trigger_ctrl[4];
        32'h1<<5 :   counter_start = i_global_stop_trigger & i_soft_trigger_ctrl[1];
        32'h1<<6 :   counter_start = i_single_stop_trigger & i_soft_trigger_ctrl[5];
        32'h1<<7 :   counter_start = i_global_clear_trigger & i_soft_trigger_ctrl[2];
        32'h1<<8 :   counter_start = i_single_clear_trigger & i_soft_trigger_ctrl[6];
        32'h1<<9 :   counter_start = i_global_reset_trigger & i_soft_trigger_ctrl[3];
        32'h1<<10:   counter_start = i_single_reset_trigger & i_soft_trigger_ctrl[7];
        32'h1<<11:   counter_start = w1_inner_din[0];
        32'h1<<12:   counter_start = w1_inner_din[1];
        32'h1<<13:   counter_start = w1_inner_din[2];
        32'h1<<14:   counter_start = w1_inner_din[3];
        32'h1<<15:   counter_start = w1_inner_din[4];
        default:     counter_start = w1_inner_din[5];
    endcase
end

always @(*) begin
    case(32'h1<<i_src_sel_stop) 
        32'h1<<1:    counter_stop = i_extern_din_a;
        32'h1<<2:    counter_stop = i_extern_din_b;
        32'h1<<3:    counter_stop = i_global_start_trigger & i_soft_trigger_ctrl[0];
        32'h1<<4:    counter_stop = i_single_start_trigger & i_soft_trigger_ctrl[4];
        32'h1<<5:    counter_stop = i_global_stop_trigger & i_soft_trigger_ctrl[1];
        32'h1<<6:    counter_stop = i_single_stop_trigger & i_soft_trigger_ctrl[5];
        32'h1<<7:    counter_stop = i_global_clear_trigger & i_soft_trigger_ctrl[2];
        32'h1<<8:    counter_stop = i_single_clear_trigger & i_soft_trigger_ctrl[6];
        32'h1<<9:    counter_stop = i_global_reset_trigger & i_soft_trigger_ctrl[3];
        32'h1<<10:   counter_stop = i_single_reset_trigger & i_soft_trigger_ctrl[7];
        32'h1<<11:   counter_stop = w1_inner_din[0];
        32'h1<<12:   counter_stop = w1_inner_din[1];
        32'h1<<13:   counter_stop = w1_inner_din[2];
        32'h1<<14:   counter_stop = w1_inner_din[3];
        32'h1<<15:   counter_stop = w1_inner_din[4];
        default:     counter_stop = w1_inner_din[5];
    endcase
end

always @(*) begin
    case(32'h1<<i_src_sel_din0) 
        32'h1<<1:    counter_din0 = i_extern_din_a;
        32'h1<<2:    counter_din0 = i_extern_din_b;
        32'h1<<3:    counter_din0 = i_global_start_trigger & i_soft_trigger_ctrl[0];
        32'h1<<4:    counter_din0 = i_single_start_trigger & i_soft_trigger_ctrl[4];
        32'h1<<5:    counter_din0 = i_global_stop_trigger & i_soft_trigger_ctrl[1];
        32'h1<<6:    counter_din0 = i_single_stop_trigger & i_soft_trigger_ctrl[5];
        32'h1<<7:    counter_din0 = i_global_clear_trigger & i_soft_trigger_ctrl[2];
        32'h1<<8:    counter_din0 = i_single_clear_trigger & i_soft_trigger_ctrl[6];
        32'h1<<9:    counter_din0 = i_global_reset_trigger & i_soft_trigger_ctrl[3];
        32'h1<<10:   counter_din0 = i_single_reset_trigger & i_soft_trigger_ctrl[7];
        32'h1<<11:   counter_din0 = w1_inner_din[0];
        32'h1<<12:   counter_din0 = w1_inner_din[1];
        32'h1<<13:   counter_din0 = w1_inner_din[2];
        32'h1<<14:   counter_din0 = w1_inner_din[3];
        32'h1<<15:   counter_din0 = w1_inner_din[4];
        default:     counter_din0 = w1_inner_din[5];
    endcase
end

always @(*) begin
    case(32'h1<<i_src_sel_din1) 
        32'h1<<1:    counter_din1 = i_extern_din_a;
        32'h1<<2:    counter_din1 = i_extern_din_b;
        32'h1<<3:    counter_din1 = i_global_start_trigger & i_soft_trigger_ctrl[0];
        32'h1<<4:    counter_din1 = i_single_start_trigger & i_soft_trigger_ctrl[4];
        32'h1<<5:    counter_din1 = i_global_stop_trigger & i_soft_trigger_ctrl[1];
        32'h1<<6:    counter_din1 = i_single_stop_trigger & i_soft_trigger_ctrl[5];
        32'h1<<7:    counter_din1 = i_global_clear_trigger & i_soft_trigger_ctrl[2];
        32'h1<<8:    counter_din1 = i_single_clear_trigger & i_soft_trigger_ctrl[6];
        32'h1<<9:    counter_din1 = i_global_reset_trigger & i_soft_trigger_ctrl[3];
        32'h1<<10:   counter_din1 = i_single_reset_trigger & i_soft_trigger_ctrl[7];
        32'h1<<11:   counter_din1 = w1_inner_din[0];
        32'h1<<12:   counter_din1 = w1_inner_din[1];
        32'h1<<13:   counter_din1 = w1_inner_din[2];
        32'h1<<14:   counter_din1 = w1_inner_din[3];
        32'h1<<15:   counter_din1 = w1_inner_din[4];
        default:     counter_din1 = w1_inner_din[5];
    endcase
end

reg r1_global_start_trigger ;
reg r1_global_stop_trigger  ;
reg r1_global_clear_trigger ;
reg r1_global_reset_trigger ;
reg r1_single_start_trigger ;
reg r1_single_stop_trigger  ;
reg r1_single_clear_trigger ;
reg r1_single_reset_trigger ;


always @(posedge i_clk) begin
     r1_global_start_trigger <= i_global_start_trigger;
     r1_global_stop_trigger  <= i_global_stop_trigger ;
     r1_global_clear_trigger <= i_global_clear_trigger;
     r1_global_reset_trigger <= i_global_reset_trigger;
     r1_single_start_trigger <= i_single_start_trigger;
     r1_single_stop_trigger  <= i_single_stop_trigger ;
     r1_single_clear_trigger <= i_single_clear_trigger;
     r1_single_reset_trigger <= i_single_reset_trigger;     
end

assign soft_start_flag = ((i_global_start_trigger^r1_global_start_trigger) && !i_soft_trigger_ctrl[0]) || ((i_single_start_trigger^r1_single_start_trigger) && !i_soft_trigger_ctrl[4]);
assign soft_stop_flag  = ((i_global_stop_trigger ^r1_global_stop_trigger ) && !i_soft_trigger_ctrl[1]) || ((i_single_stop_trigger ^r1_single_stop_trigger ) && !i_soft_trigger_ctrl[5]);
assign soft_clear_flag = ((i_global_clear_trigger^r1_global_clear_trigger) && !i_soft_trigger_ctrl[2]) || ((i_single_clear_trigger^r1_single_clear_trigger) && !i_soft_trigger_ctrl[6]);
assign soft_reset_flag = ((i_global_reset_trigger^r1_global_reset_trigger) && !i_soft_trigger_ctrl[3]) || ((i_single_reset_trigger^r1_single_reset_trigger) && !i_soft_trigger_ctrl[7]);



always @(posedge i_clk) begin
    counter_start_dly[1:0] <= {counter_start_dly[0],counter_start};
    counter_stop_dly[1:0]  <= {counter_stop_dly[0],counter_stop};
    counter_din0_dly[1:0]  <= {counter_din0_dly[0],counter_din0};
    counter_din1_dly[1:0]  <= {counter_din1_dly[0],counter_din1};
end

assign start_flag = i_src_edge_start[1] ?  (!i_src_edge_start[0] ? (^counter_start_dly[1:0]) : 1'b0) : (i_src_edge_start[0] ? (!counter_start_dly[0] & counter_start_dly[1]) : (counter_start_dly[0] & !counter_start_dly[1]) );
assign stop_flag  = i_src_edge_stop[1]  ?  (!i_src_edge_stop[0] ? (^counter_stop_dly[1:0])  : 1'b0) : (i_src_edge_stop[0] ? (!counter_stop_dly[0] & counter_stop_dly[1]) : (counter_stop_dly[0] & !counter_stop_dly[1]) );
assign din0_flag  = i_src_edge_din0[1]  ?  (!i_src_edge_din0[0] ? (^counter_din0_dly[1:0])  : 1'b0) : (i_src_edge_din0[0] ? (!counter_din0_dly[0] & counter_din0_dly[1]) : (counter_din0_dly[0] & !counter_din0_dly[1]) );
assign din1_flag  = i_src_edge_din1[1]  ?  (!i_src_edge_din1[0] ? (^counter_din1_dly[1:0])  : 1'b0) : (i_src_edge_din1[0] ? (!counter_din1_dly[0] & counter_din1_dly[1]) : (counter_din1_dly[0] & !counter_din1_dly[1]) );



always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n)
        current_counter <= 32'h0;
    else if(!i_enable || soft_reset_flag || soft_clear_flag)
        current_counter <= 32'h0;
    //else if(soft_start_flag||start_flag)
    //    current_counter <= current_counter + 1'b1;
    else if(count_en)
        current_counter <= current_counter + 1'b1;

end

always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n)
        count_en <= 1'h0;
    else if(i_enable) begin
        //if(soft_reset_flag||soft_stop_flag||stop_flag)
        //    count_en <= 1'h0;
        //else if(soft_start_flag||start_flag)
        //    count_en <= 1'h1;
        //else 
            count_en <= 1'h1;

    end
    else 
        count_en <= 1'h0;
end



assign w_count_overflow_flag = &current_counter[31:0];

reg r1_count_overflow_flag_target_reg_a;
reg r1_count_overflow_flag_target_reg_b;
reg r1_count_overflow_flag_automatic;
// reg [5:0] r1_target_reg_status_dly;
reg r1_count_flag_automatic_update;
reg r1_count_flag_automatic_update_dly;

reg r1_capture_reg_status_dly_a;
reg r1_capture_reg_status_dly_b;
reg r1_current_counter_dly;
reg shiftin_complete_flag_dly;
reg r1_shiftout_only_onebit_flag_dly;
reg r1_waveform_match_reg3_dly;
reg r1_switch_sendmode_dly;
reg r1_switch_recmode_dly;

always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        r1_count_overflow_flag_target_reg_a <= 1'b0;
        r1_count_overflow_flag_target_reg_b <= 1'b0;
        r1_count_overflow_flag_automatic    <= 1'b0;
    end
    else if(!i_enable) begin
        r1_count_overflow_flag_target_reg_a <= 1'b0;
        r1_count_overflow_flag_target_reg_b <= 1'b0;
        r1_count_overflow_flag_automatic    <= 1'b0;    
    end
    else if(soft_reset_flag||soft_clear_flag) begin
        r1_count_overflow_flag_target_reg_a <= 1'b0;
        r1_count_overflow_flag_target_reg_b <= 1'b0;
        r1_count_overflow_flag_automatic    <= 1'b0;    
    end
    else begin
    if(waveform_mode_en||i_mode_sel[2]) begin
        if(w_count_overflow_flag)
            r1_count_overflow_flag_target_reg_a <= 1'b1;
        // else if(|((~r1_target_reg_status[1:0])&r1_target_reg_status_dly[1:0])) 
        else if(((i_target_reg_a2+last_current_counter_a)==current_counter_target_reg_a) && (!r1_target_reg_status[2])&&(!i_target_reg_ctrl[1])) 
            r1_count_overflow_flag_target_reg_a <= 1'b0;
        if(w_count_overflow_flag)
            r1_count_overflow_flag_target_reg_b <= 1'b1;
        // else if(|((~r1_target_reg_status[4:3])&r1_target_reg_status_dly[4:3])) 
        else if(((i_target_reg_b2+last_current_counter_b)==current_counter_target_reg_b) && (!r1_target_reg_status[5])&&(!i_target_reg_ctrl[3]))        
            r1_count_overflow_flag_target_reg_b <= 1'b0;
    end
    if(i_mode_sel[2]) begin//automatic switch enable.
        if(w_count_overflow_flag)
            r1_count_overflow_flag_automatic    <= 1'b1;
        // else if(r1_count_flag_automatic_update^r1_count_flag_automatic_update_dly) 
        else if(current_counter_automatic==(lastbit_current_counter+i_switch_mode_onebit_cnts)) 
            r1_count_overflow_flag_automatic    <= 1'b0;
    end
    end
end
        
//always @(posedge i_clk) begin
//    // r1_target_reg_status_dly <= r1_target_reg_status;
//    r1_count_flag_automatic_update_dly <= r1_count_flag_automatic_update;
//end
        
        

//----------------------------------------------//
//----------------------------------------------//
//------waveform&shiftout mode counter  --------//
//----------------------------------------------//
//----------------------------------------------//



assign w1_shiftout_only_onebit_flag = (!(|r1_shiftout_databits_valid[31:1]))&&r1_shiftout_databits_valid[0];
assign w_capture_reg_read_flag_posedge = i_capture_reg_read_flag & (~r1_capture_reg_read_flag_dly);

always @(posedge i_clk) begin
    r1_shiftout_data_valid_dly      <= i_shiftout_data_valid;
    r1_capture_reg_read_flag_dly    <= i_capture_reg_read_flag;
end 


//i_shiftout_data_ctrl_bitcnts
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        r1_shiftout_data[63:32] <= 32'h0;
        r1_shiftout_databits_valid[63:32] <= 32'h0000;
    end
    else if(i_shiftout_data_valid&&!r1_shiftout_data_valid_dly) begin
        r1_shiftout_data[63:32] <= i_shiftout_data[31:0];
        r1_shiftout_databits_valid[63:32] <= ~(32'hfffffffe<<i_shiftout_data_ctrl_bitcnts);
    end
end

reg r1_shiftout_mode_en_dly;
reg r1_shiftin_mode_en_dly;
reg r1_waveform_mode_en_dly;
reg r1_capture_mode_en_dly;
always @(posedge i_clk) begin
    r1_shiftout_mode_en_dly <= shiftout_mode_en;
    r1_shiftin_mode_en_dly  <= shiftin_mode_en;
    r1_waveform_mode_en_dly     <= waveform_mode_en;
    r1_capture_mode_en_dly      <= capture_mode_en;
end

always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        r1_shiftout_data[31:0] <= 32'h0;
        r1_shiftout_databits_valid[31:0] <= 32'hffffffff;
        // r1_shiftout_start_onebit_flag <= 1'b0;
    end
    //else if(soft_start_flag||start_flag) begin
    //    if(i_mode_sel[0] && i_mode_sel[1]) begin// shiftout mode.
    //        r1_shiftout_data[31:0] <= r1_shiftout_data[63:32];
    //        r1_shiftout_databits_valid[31:0]  <= r1_shiftout_databits_valid[63:32];     
    //    end
    //end
    else if(shiftout_mode_en) begin
    if(!r1_shiftout_mode_en_dly) begin//only one bit.
            r1_shiftout_data[31:0] <= r1_shiftout_data[63:32];
            r1_shiftout_databits_valid[31:0]  <= r1_shiftout_databits_valid[63:32];    
    end
    else if(!i_shiftmode_point_en) begin
        if(w1_shiftout_only_onebit_flag) begin//only one bit.
            r1_shiftout_data[31:0] <= r1_shiftout_data[63:32];
            r1_shiftout_databits_valid[31:0]  <= r1_shiftout_databits_valid[63:32];         
        end
        else begin
            r1_shiftout_data[31:0] <= r1_shiftout_data[31:0]>>1;                
            r1_shiftout_databits_valid[31:0]  <= r1_shiftout_databits_valid[31:0]>>1;
        end    
    end
    else if(i_shiftmode_point_en &&(current_counter_automatic==(lastbit_current_counter+i_switch_mode_onebit_cnts))) begin// i_shiftmode_point_cnts
        if(w1_shiftout_only_onebit_flag) begin//only one bit.
            // r1_shiftout_start_onebit_flag <= 1'b1;
            r1_shiftout_data[31:0] <= r1_shiftout_data[63:32];
            r1_shiftout_databits_valid[31:0]  <= r1_shiftout_databits_valid[63:32];         
        end
        else begin
            // r1_shiftout_start_onebit_flag <= 1'b0;
            r1_shiftout_data[31:0] <= r1_shiftout_data[31:0]>>1;                
            r1_shiftout_databits_valid[31:0]  <= r1_shiftout_databits_valid[31:0]>>1;
        end
    end
    end
    else begin
        // r1_shiftout_start_onebit_flag <= 1'b0;
        r1_shiftout_data[31:0] <= 32'h0;
        r1_shiftout_databits_valid[31:0] <= 32'hffffffff;
    end
end


assign current_counter_target_reg_a = {r1_count_overflow_flag_target_reg_a,current_counter};
assign current_counter_target_reg_b = {r1_count_overflow_flag_target_reg_b,current_counter};

always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        o_extern_dout_a     <= 1'b0;
        o_extern_dout_b     <= 1'b0;
        r1_target_reg_status <= 6'b0;
        last_current_counter_a <= 32'h0;
        last_current_counter_b <= 32'h0;
    end
    else if(!i_enable) begin
        o_extern_dout_a     <= 1'b0;
        o_extern_dout_b     <= 1'b0;
        r1_target_reg_status <= 6'b0; 
        last_current_counter_a <= 32'h0;
        last_current_counter_b <= 32'h0;        
    end
    else begin
        if(!i_mode_sel[0]&&!i_mode_sel[2]) begin//automatic switch mode disable , and input mode.
            o_extern_dout_a     <= 1'b0;
            o_extern_dout_b     <= 1'b0;
            r1_target_reg_status <= 6'b0; 
            last_current_counter_a <= 32'h0;
            last_current_counter_b <= 32'h0;            
        end 
        // else if(soft_start_flag||start_flag) begin
        //     if(i_mode_sel[0]) begin//counter waveform mode&shiftout mode//&&!i_mode_sel[1]
        //         o_extern_dout_a     <= i_target_reg_ctrl[4];//reset value.
        //         o_extern_dout_b     <= i_target_reg_ctrl[5];//reset value.
        //         r1_target_reg_status <= 6'b0;    
        //         // last_current_counter_a <= current_counter;
        //         // last_current_counter_b <= current_counter;                
        //     end
        // end
        // else if(data_recs_bits_cnts==(i_capture_mode_cnts-8'h1) && (current_counter_automatic==(lastbit_current_counter+i_switch_mode_onebit_cnts))&& i_waveform_mode_automatic_sw && !waveform_mode_en && capture_mode_en) begin
        //         o_extern_dout_a     <= i_target_reg_ctrl[4];//reset value.
        //         o_extern_dout_b     <= i_target_reg_ctrl[5];//reset value.
        //         r1_target_reg_status <= 6'b0; 
        //         // last_current_counter_a <= current_counter;
        //         // last_current_counter_b <= current_counter;
        // end 
        else if(waveform_mode_en) begin //counter waveform mode.
            if(!r1_waveform_mode_en_dly) begin
                r1_target_reg_status[2:0] <= 6'b0;
                o_extern_dout_a     <= i_target_reg_ctrl[4];//reset value.
                last_current_counter_a <= current_counter;
            end
            else if(((i_target_reg_a0+last_current_counter_a)==current_counter_target_reg_a) && (!r1_target_reg_status[0])) begin //
                o_extern_dout_a         <= 1'b0;
                r1_target_reg_status[0] <= 1'b1;  
            end
            else if(((i_target_reg_a1+last_current_counter_a)==current_counter_target_reg_a) && (!r1_target_reg_status[1])) begin
                o_extern_dout_a <= 1'b1;
                r1_target_reg_status[1] <= 1'b1;  
            end
            else if(((i_target_reg_a2+last_current_counter_a)==current_counter_target_reg_a) && (!r1_target_reg_status[2])) begin
                if(i_target_reg_ctrl[1])
                    r1_target_reg_status[2] <= 1'b1;  //stop wave. control signal.
                else begin
                    r1_target_reg_status[2:0] <= 3'b000; //periodic signal. etc ,clock signal.
					last_current_counter_a <= current_counter;
				end
                if(i_target_reg_ctrl[0])
                    o_extern_dout_a <= o_extern_dout_a;//keep the value.
                else 
                    o_extern_dout_a <= i_target_reg_ctrl[4];//reset value.
            end
            //
            if(!r1_waveform_mode_en_dly) begin
                r1_target_reg_status[5:3] <= 3'b0;
                o_extern_dout_b     <= i_target_reg_ctrl[5];//reset value.                
                last_current_counter_b <= current_counter;    
            end            
            else if(((i_target_reg_b0+last_current_counter_b)==current_counter_target_reg_b) && (!r1_target_reg_status[3])) begin
                o_extern_dout_b <= 1'b0;
                r1_target_reg_status[3] <= 1'b1;
            end
            else if(((i_target_reg_b1+last_current_counter_b)==current_counter_target_reg_b) && (!r1_target_reg_status[4])) begin
                o_extern_dout_b <= 1'b1;
                r1_target_reg_status[4] <= 1'b1;
            end
            else if(((i_target_reg_b2+last_current_counter_b)==current_counter_target_reg_b) && (!r1_target_reg_status[5])) begin
                
                if(i_target_reg_ctrl[3])
                    r1_target_reg_status[5] <= 1'b1;  //stop wave. control signal.
                else begin
                    r1_target_reg_status[5:3] <= 3'b000; //periodic signal. etc ,clock signal.
					last_current_counter_b <= current_counter;
				end
                if(i_target_reg_ctrl[2])
                    o_extern_dout_b <= o_extern_dout_b;//keep the value.
                else
                    o_extern_dout_b <= i_target_reg_ctrl[5];//reset value.
            end
            //            
        end
        else if(shiftout_mode_en) begin
          if(!i_shiftmode_point_en) begin
            if(w1_shiftout_only_onebit_flag||!r1_shiftout_mode_en_dly) begin//only one bit or start bit or start mode.
                if(i_shiftmode_ctrl)
                    o_extern_dout_b <= r1_shiftout_data[32];
                else
                    o_extern_dout_a <= r1_shiftout_data[32];
            end
            else begin
                if(i_shiftmode_ctrl)
                    o_extern_dout_b <= r1_shiftout_data[1];
                else
                    o_extern_dout_a <= r1_shiftout_data[1];
            end        
          end
          else begin
            if((w1_shiftout_only_onebit_flag&&(current_counter_automatic==(lastbit_current_counter+i_switch_mode_onebit_cnts)))||!r1_shiftout_mode_en_dly) begin//only one bit or start bit or start mode.
                if(i_shiftmode_ctrl)
                    o_extern_dout_b <= r1_shiftout_data[32];
                else
                    o_extern_dout_a <= r1_shiftout_data[32];
            end
            else begin
                if(i_shiftmode_ctrl)
                    o_extern_dout_b <= r1_shiftout_data[0];
                else
                    o_extern_dout_a <= r1_shiftout_data[0];
            end        
          
          end
            
        end
    
    end
end

always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        waveform_mode_en <= 1'b0;
        //o_extern_dout_a_oen <= 1'b1;
        //o_extern_dout_b_oen <= 1'b1;
    end
    else if(i_enable) begin
        if(soft_reset_flag||soft_stop_flag||stop_flag) begin
            waveform_mode_en <= 1'b0;
            //o_extern_dout_a_oen     <= 1'b1;
            //o_extern_dout_b_oen     <= 1'b1;
        end
        else if(soft_start_flag||start_flag) begin
            if(i_mode_sel[0]&&!i_mode_sel[1]) begin//waveform count mode.
                waveform_mode_en <= 1'b1;
                //o_extern_dout_a_oen     <= 1'b0;
                //o_extern_dout_b_oen     <= 1'b0;            
            end 
            else  begin//
                waveform_mode_en <= 1'b0;
                //o_extern_dout_a_oen     <= 1'b1;
                //o_extern_dout_b_oen     <= 1'b1;
            end
        end
        else if(!i_mode_sel[1]&&i_mode_sel[2]) begin //count mode  & automatic switch mode enable.
            if(data_sends_bits_cnts==(i_waveform_mode_cnts-8'h1) &&(current_counter_automatic==(lastbit_current_counter+i_switch_mode_onebit_cnts)) && waveform_mode_en) begin //&& i_capture_mode_automatic_sw 
                waveform_mode_en <= 1'b0;
                //o_extern_dout_a_oen     <= 1'b1;
                //o_extern_dout_b_oen     <= 1'b1;
            end
            else if(data_recs_bits_cnts==(i_capture_mode_cnts-8'h1) && (current_counter_automatic==(lastbit_current_counter+i_switch_mode_onebit_cnts))&& i_waveform_mode_automatic_sw && !waveform_mode_en) begin
                waveform_mode_en <= 1'b1;
                //o_extern_dout_a_oen     <= 1'b0;
                //o_extern_dout_b_oen     <= 1'b0;                
            end
                
        end
        // else begin //redundant case;?
            // waveform_mode_en <= 1'b0;
            // //o_extern_dout_a_oen  <= 1'b1;
            // //o_extern_dout_b_oen  <= 1'b1;
        // end
    end
    else begin
        waveform_mode_en <= 1'b0;
        //o_extern_dout_a_oen <= 1'b1;
        //o_extern_dout_b_oen <= 1'b1;    
    end
    
end

always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        o_extern_dout_a_oen <= 1'b1;
        o_extern_dout_b_oen <= 1'b1;
    end
    else if(waveform_mode_en) begin
        o_extern_dout_a_oen <= 1'b0;
        o_extern_dout_b_oen <= 1'b0;    
    end
    else if(shiftout_mode_en) begin
        if(!i_shiftmode_ctrl)
            o_extern_dout_a_oen     <= 1'b0;
        else
            o_extern_dout_b_oen     <= 1'b0;    
    end
    else begin
        o_extern_dout_a_oen <= 1'b1;
        o_extern_dout_b_oen <= 1'b1;
    end
end

//----------------------------------------------//
//----------------------------------------------//
//-----------capture mode counter  -------------//
//----------------------------------------------//
//----------------------------------------------//

//assign w_ctrl_snap_posedge = i_ctrl_snap & (~r1_ctrl_snap_dly);
assign w_ctrl_snap_posedge = i_ctrl_snap ^ (r1_ctrl_snap_dly);
assign w_clear_snap_posedge = r1_clear_snap_dly[0]^(r1_clear_snap_dly[1]);
//o_snap_status
//i_clear_snap
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        o_snap_status[3:0] <= 4'h0;
    end
    else if(|w_ctrl_snap_posedge) begin
        o_snap_status[3:0] <= w_ctrl_snap_posedge;
    end
    else if(w_clear_snap_posedge) begin
        o_snap_status[3:0] <= 32'h0;
    end
end

always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        o_snap_status[7:4] <= 4'h0;
    end
    else begin
        o_snap_status[7:4] <= {r1_shiftout_mode_en_dly,r1_shiftin_mode_en_dly,r1_waveform_mode_en_dly,r1_capture_mode_en_dly};
    end
end


always @(posedge i_clk) begin
    r1_ctrl_snap_dly  <= i_ctrl_snap;
    r1_clear_snap_dly[1:0] <= {r1_clear_snap_dly[0],i_clear_snap};
end
    
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        o_shadow_reg     <= 32'h0;
        o_capture_reg_status <= 6'h0;
        o_capture_reg_a0 <= 32'h0;
        o_capture_reg_a1 <= 32'h0;
        o_capture_reg_a2 <= 32'h0;
        o_capture_reg_b0 <= 32'h0;
        o_capture_reg_b1 <= 32'h0;
        o_capture_reg_b2 <= 32'h0;
        o_shiftin_data   <= 32'h0;
        o_shiftin_databits_updated <= 32'h0;
    end
    else begin
        // if(soft_stop_flag || stop_flag || soft_start_flag || start_flag)  begin
        if(capture_mode_en^r1_capture_mode_en_dly || r1_waveform_mode_en_dly^waveform_mode_en  )  begin
            o_shadow_reg     <= current_counter;
        end
        else if(w_ctrl_snap_posedge[0]) begin
            o_shadow_reg     <= current_counter;
        end
        if((&r1_capture_reg_status[5:3])&&!r1_capture_reg_status_dly_b) begin //
            o_capture_reg_status[5:3] <= r1_capture_reg_status[5:3];
	    if(!o_capture_reg_status[3]||(o_capture_reg_status[3]&&i_capture_reg_overflow_ctrl[3]))
              o_capture_reg_b0 <= r1_capture_reg_b0;
	    if(!o_capture_reg_status[4]||(o_capture_reg_status[4]&&i_capture_reg_overflow_ctrl[4]))
              o_capture_reg_b1 <= r1_capture_reg_b1;
	    if(!o_capture_reg_status[5]||(o_capture_reg_status[5]&&i_capture_reg_overflow_ctrl[5]))
              o_capture_reg_b2 <= r1_capture_reg_b2;
        end
	else if(|w_capture_reg_read_flag_posedge[5:3]) begin
            o_capture_reg_status[5:3] <= o_capture_reg_status[5:3] & (~w_capture_reg_read_flag_posedge[5:3]);
	end
        else if(w_ctrl_snap_posedge[2]) begin
            o_capture_reg_status[5:3] <= r1_capture_reg_status[5:3];
            o_capture_reg_b0 <= r1_capture_reg_b0;
            o_capture_reg_b1 <= r1_capture_reg_b1;
            o_capture_reg_b2 <= r1_capture_reg_b2;
        end
        if((&r1_capture_reg_status[2:0])&&!r1_capture_reg_status_dly_a) begin //
            o_capture_reg_status[2:0] <= r1_capture_reg_status[2:0];
	    if(!o_capture_reg_status[0]||(o_capture_reg_status[0]&&i_capture_reg_overflow_ctrl[0]))
              o_capture_reg_a0 <= r1_capture_reg_a0;
	    if(!o_capture_reg_status[1]||(o_capture_reg_status[1]&&i_capture_reg_overflow_ctrl[1]))
              o_capture_reg_a1 <= r1_capture_reg_a1;
	    if(!o_capture_reg_status[2]||(o_capture_reg_status[2]&&i_capture_reg_overflow_ctrl[2]))
              o_capture_reg_a2 <= r1_capture_reg_a2;        
        end
	else if(|w_capture_reg_read_flag_posedge[2:0]) begin
            o_capture_reg_status[2:0] <= o_capture_reg_status[2:0] & (~w_capture_reg_read_flag_posedge[2:0]);
	end
        else if(w_ctrl_snap_posedge[1]) begin
            o_capture_reg_status[2:0] <= r1_capture_reg_status[2:0];
            o_capture_reg_a0 <= r1_capture_reg_a0;
            o_capture_reg_a1 <= r1_capture_reg_a1;
            o_capture_reg_a2 <= r1_capture_reg_a2;
        end        
        if(shiftin_complete_flag) begin
            o_shiftin_data              <= r1_shiftin_data;
            o_shiftin_databits_updated  <= r1_shiftin_databits_updated;
        end
        else if(w_ctrl_snap_posedge[3]) begin
            o_shiftin_data              <= r1_shiftin_data;
            o_shiftin_databits_updated  <= r1_shiftin_databits_updated;
        end
    end
end
//


always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n)
        capture_mode_en <= 1'h0;
    else if(i_enable) begin
        if(soft_reset_flag||soft_stop_flag||stop_flag)
            capture_mode_en <= 1'h0;
        else if(soft_start_flag||start_flag) begin  
            if(!i_mode_sel[0] && !i_mode_sel[1])// capture count mode.
                capture_mode_en <= 1'h1;
            else 
                capture_mode_en <= 1'h0;
        end
        else if(!i_mode_sel[1]&&i_mode_sel[2]) begin //count mode  & automatic switch mode enable.
            if(data_sends_bits_cnts==(i_waveform_mode_cnts-8'h1) &&(current_counter_automatic==(lastbit_current_counter+i_switch_mode_onebit_cnts)) && i_capture_mode_automatic_sw && !capture_mode_en) begin
                capture_mode_en <= 1'b1;
            end
            else if(data_recs_bits_cnts==(i_capture_mode_cnts-8'h1)&& (current_counter_automatic==(lastbit_current_counter+i_switch_mode_onebit_cnts))  && capture_mode_en) begin //&& i_waveform_mode_automatic_sw
                capture_mode_en <= 1'b0;                
            end
                
        end
    end
    else 
        capture_mode_en <= 1'h0;
end

// 
reg r1_capture_reg_a_first_valid_edge;
reg r1_capture_reg_b_first_valid_edge;
reg r1_capture_reg_a_first_valid_edge_dly;
reg r1_capture_reg_b_first_valid_edge_dly;


always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        r1_capture_reg_status[2:0] <= 3'h0;
        r1_capture_reg_a0 <= 32'h0;
        r1_capture_reg_a1 <= 32'h0;
        r1_capture_reg_a2 <= 32'h0;
        capture_cnts_a    <= 2'h0;
        r1_capture_reg_a_first_valid_edge <= 1'b0;
    end
    else if(!i_enable || soft_reset_flag ||soft_clear_flag) begin
        r1_capture_reg_status[2:0] <= 3'h0;
        r1_capture_reg_a0 <= 32'h0;
        r1_capture_reg_a1 <= 32'h0;
        r1_capture_reg_a2 <= 32'h0;
        capture_cnts_a    <= 2'h0;      
        r1_capture_reg_a_first_valid_edge <= 1'b0;
    end
    else if(capture_mode_en) begin
    if(din0_flag) 
        r1_capture_reg_a_first_valid_edge <= 1'b1;
    //    
	if(w_ctrl_snap_posedge[1]||((&r1_capture_reg_status[2:0])&&!r1_capture_reg_status_dly_a))
          if(din0_flag) 
	    r1_capture_reg_status[2:0] <= (3'h1<<capture_cnts_a);
	  else
	    r1_capture_reg_status[2:0] <= 3'b0;
	else if(din0_flag) 
            r1_capture_reg_status[2:0] <= r1_capture_reg_status[2:0] | (3'h1<<capture_cnts_a);
	 
        if(din0_flag) begin
            if(capture_cnts_a==2'h2)
                capture_cnts_a <= 2'h0;
            else
                capture_cnts_a <= capture_cnts_a + 2'h1;
        end
        if(din0_flag) begin
            if(capture_cnts_a==2'h0 && (!r1_capture_reg_status[0] || w_capture_reg_read_flag_posedge[0] || (r1_capture_reg_status[0]&&i_capture_reg_overflow_ctrl[0]))) // overflow overwrite. and a new edge.
                r1_capture_reg_a0 <= current_counter;
            else if(capture_cnts_a==2'h1 && (!r1_capture_reg_status[1] || w_capture_reg_read_flag_posedge[1] || (r1_capture_reg_status[1]&&i_capture_reg_overflow_ctrl[1])))
                r1_capture_reg_a1 <= current_counter;
            else if(capture_cnts_a==2'h2 && (!r1_capture_reg_status[2] || w_capture_reg_read_flag_posedge[2] || (r1_capture_reg_status[2]&&i_capture_reg_overflow_ctrl[2])))
                r1_capture_reg_a2 <= current_counter;
        end
        
    end
    else begin
        r1_capture_reg_status[2:0] <= r1_capture_reg_status[2:0] & (~w_capture_reg_read_flag_posedge[2:0]);
        r1_capture_reg_a_first_valid_edge <= 1'b0;
    end
end

always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        r1_capture_reg_status[5:3] <= 3'h0;
        r1_capture_reg_b0 <= 32'h0;
        r1_capture_reg_b1 <= 32'h0;
        r1_capture_reg_b2 <= 32'h0;
        capture_cnts_b    <= 2'h0;
        r1_capture_reg_b_first_valid_edge <= 1'b0;
    end
    else if(!i_enable || soft_reset_flag ||soft_clear_flag) begin
        r1_capture_reg_status[5:3] <= 3'h0;
        r1_capture_reg_b0 <= 32'h0;
        r1_capture_reg_b1 <= 32'h0;
        r1_capture_reg_b2 <= 32'h0;
        capture_cnts_b    <= 2'h0;      
        r1_capture_reg_b_first_valid_edge <= 1'b0;
    end
    else if(capture_mode_en) begin
    if(din1_flag)
        r1_capture_reg_b_first_valid_edge <= 1'b1;
    //
	if(w_ctrl_snap_posedge[2]||((&r1_capture_reg_status[5:3])&&!r1_capture_reg_status_dly_b))
	  if(din1_flag) begin
		r1_capture_reg_status[5:3] <= (3'h1<<capture_cnts_b);
	  end
	  else begin
		r1_capture_reg_status[5:3] <= 3'b0;
	  end
	else if(din1_flag)
            r1_capture_reg_status[5:3] <= r1_capture_reg_status[5:3] | (3'h1<<capture_cnts_b);
        if(din1_flag) begin
            if(capture_cnts_b==2'h2)
                capture_cnts_b <= 2'h0;
            else
                capture_cnts_b <= capture_cnts_b + 2'h1;
        end
        if(din1_flag) begin
            if(capture_cnts_b==2'h0 && (!r1_capture_reg_status[3] || w_capture_reg_read_flag_posedge[3] || (r1_capture_reg_status[3]&&i_capture_reg_overflow_ctrl[3])))
                r1_capture_reg_b0 <= current_counter;
            else if(capture_cnts_b==2'h1 && (!r1_capture_reg_status[4] || w_capture_reg_read_flag_posedge[4] || (r1_capture_reg_status[4]&&i_capture_reg_overflow_ctrl[4])))
                r1_capture_reg_b1 <= current_counter;
            else if(capture_cnts_b==2'h2 && (!r1_capture_reg_status[5] || w_capture_reg_read_flag_posedge[5] || (r1_capture_reg_status[5]&&i_capture_reg_overflow_ctrl[5])))
                r1_capture_reg_b2 <= current_counter;
        end
        
    end
    else begin
        r1_capture_reg_status[5:3] <= r1_capture_reg_status[5:3] & (~w_capture_reg_read_flag_posedge[5:3]);
        r1_capture_reg_b_first_valid_edge <= 1'b0;
    end
end

//----------------------------------------------//
//----------------------------------------------//
//-----------automatic switch mode counter  ----//
//----------------------------------------------//
//----------------------------------------------//
assign current_counter_automatic = {r1_count_overflow_flag_automatic,current_counter};

always @(posedge i_clk) begin
    r1_capture_reg_a_first_valid_edge_dly <= r1_capture_reg_a_first_valid_edge;
    r1_capture_reg_b_first_valid_edge_dly <= r1_capture_reg_b_first_valid_edge;
end

always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        data_sends_bits_cnts <= 8'h0;
        data_recs_bits_cnts  <= 8'h0;
        lastbit_current_counter <= 32'h0;
        r1_count_flag_automatic_update <= 1'b0;
    end
    else if(!i_enable) begin
        data_sends_bits_cnts <= 8'h0;
        data_recs_bits_cnts  <= 8'h0;
        lastbit_current_counter <= 32'h0;
        //r1_count_flag_automatic_update <= 1'b0;
    end
    else if(soft_reset_flag||soft_stop_flag||stop_flag||soft_clear_flag) begin
        data_sends_bits_cnts <= 8'h0;
        data_recs_bits_cnts  <= 8'h0;
        lastbit_current_counter <= 32'h0;
    end
    // else if(capture_mode_en&&!r1_capture_mode_en_dly || waveform_mode_en&&!r1_waveform_mode_en_dly) begin
        // data_sends_bits_cnts <= 8'h0;
        // data_recs_bits_cnts  <= 8'h0;
        // lastbit_current_counter <= current_counter;
    // end
    else if(i_mode_sel[2]) begin//!i_mode_sel[1]&&
        if(waveform_mode_en||shiftout_mode_en) begin
            data_recs_bits_cnts  <= 8'h0;
            if(waveform_mode_en&&!r1_waveform_mode_en_dly || shiftout_mode_en&&!r1_shiftout_mode_en_dly) begin
                // data_sends_bits_cnts <= 8'h0;
                // data_recs_bits_cnts  <= 8'h0;
                lastbit_current_counter <= current_counter;
            end
            else if(current_counter_automatic==(lastbit_current_counter+i_switch_mode_onebit_cnts)) begin//
                lastbit_current_counter <= current_counter;
                data_sends_bits_cnts <= data_sends_bits_cnts +1'b1;
                r1_count_flag_automatic_update <= ~r1_count_flag_automatic_update;
            end
        end
        else if(capture_mode_en||shiftin_mode_en) begin
            data_sends_bits_cnts <= 8'h0;
            if(capture_mode_en&&!r1_capture_mode_en_dly || shiftin_mode_en&&!r1_shiftin_mode_en_dly) begin
                // data_sends_bits_cnts <= 8'h0;
                // data_recs_bits_cnts  <= 8'h0;
                lastbit_current_counter <= current_counter;
            end
            else if(capture_mode_en&&i_capture_mode_automatic_validedge) begin
                if((r1_capture_reg_a_first_valid_edge&&!r1_capture_reg_a_first_valid_edge_dly||r1_capture_reg_b_first_valid_edge&&!r1_capture_reg_b_first_valid_edge_dly) ) begin
                    lastbit_current_counter <= current_counter;
                    data_recs_bits_cnts <= 8'h0;
                end
                else if(r1_capture_reg_a_first_valid_edge||r1_capture_reg_b_first_valid_edge) begin
                    if(current_counter_automatic==(lastbit_current_counter+i_switch_mode_onebit_cnts)) begin//
                        lastbit_current_counter <= current_counter;
                        data_recs_bits_cnts <= data_recs_bits_cnts +1'b1;
                        r1_count_flag_automatic_update <= ~r1_count_flag_automatic_update;
                    end  
                
                end
            end
            else if(current_counter_automatic==(lastbit_current_counter+i_switch_mode_onebit_cnts)) begin//
                lastbit_current_counter <= current_counter;
                data_recs_bits_cnts <= data_recs_bits_cnts +1'b1;
                r1_count_flag_automatic_update <= ~r1_count_flag_automatic_update;
            end         
        end
        else begin
            data_sends_bits_cnts <= 8'h0;
            data_recs_bits_cnts  <= 8'h0;           
        end
    end
    else begin
        data_sends_bits_cnts <= 8'h0;
        data_recs_bits_cnts  <= 8'h0;
        lastbit_current_counter <= 32'h0;
    end
end

//----------------------------------------------//
//----------------------------------------------//
//-----------shift  mode counter  --------------//
//----------------------------------------------//
//----------------------------------------------//



always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n)
        shiftin_mode_en <= 1'h0;
    else if(i_enable) begin
        if(soft_reset_flag||soft_stop_flag||stop_flag)
            shiftin_mode_en <= 1'h0;
        else if(soft_start_flag||start_flag) begin  
            if(!i_mode_sel[0] && i_mode_sel[1])// shiftin count mode.
                shiftin_mode_en <= 1'h1;
            else 
                shiftin_mode_en <= 1'h0;
        end
        else if(i_mode_sel[1]&&i_mode_sel[2]) begin //shift mode  & automatic switch mode enable.
            if(data_sends_bits_cnts==(i_waveform_mode_cnts-8'h1)&&(current_counter_automatic==(lastbit_current_counter+i_switch_mode_onebit_cnts)) && i_capture_mode_automatic_sw && !shiftin_mode_en) begin
                shiftin_mode_en <= 1'b1;
            end
            else if(data_recs_bits_cnts==(i_capture_mode_cnts-8'h1)&&(current_counter_automatic==(lastbit_current_counter+i_switch_mode_onebit_cnts))  && shiftin_mode_en) begin //&& i_waveform_mode_automatic_sw
                shiftin_mode_en <= 1'b0;                
            end
                
        end
    end
    else 
        shiftin_mode_en <= 1'h0;
end


assign i_shiftin_data_ctrl_bitmap=32'hfffffffe<<i_shiftin_data_ctrl_bitcnts;
assign counter_shiftin_din= i_shiftmode_ctrl ? counter_din1 : counter_din0 ;
assign shiftin_complete_flag= &(r1_shiftin_databits_updated|i_shiftin_data_ctrl_bitmap);

always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        r1_shiftin_data <= 32'h0;
        r1_shiftin_databits_updated <= 32'h0;
    end
    else if(!i_enable || soft_reset_flag ||soft_clear_flag) begin
        r1_shiftin_data <= 32'h0;
        r1_shiftin_databits_updated <= 32'h0;
    end
    else if(shiftin_mode_en) begin
    if(!i_shiftmode_point_en || (i_shiftmode_point_en &&(current_counter_automatic==(lastbit_current_counter+i_shiftmode_point_cnts)))) begin
        if(shiftin_complete_flag||!r1_shiftin_mode_en_dly) begin
            r1_shiftin_databits_updated <= 32'b1; 
            r1_shiftin_data[31:0] <= {r1_shiftin_data[30:0],counter_shiftin_din};
        end
        else begin
            r1_shiftin_databits_updated <= {r1_shiftin_databits_updated[30:0],1'b1};
            r1_shiftin_data[31:0] <= {r1_shiftin_data[30:0],counter_shiftin_din};
        end
    end
    end
end




always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n)
        shiftout_mode_en <= 1'h0;
    else if(i_enable) begin
        if(soft_reset_flag||soft_stop_flag||stop_flag)
            shiftout_mode_en <= 1'h0;
        else if(soft_start_flag||start_flag) begin  
            if(i_mode_sel[0] && i_mode_sel[1])// shiftout mode.
                shiftout_mode_en <= 1'h1;
            else 
                shiftout_mode_en <= 1'h0;
        end
        else if(i_mode_sel[1]&&i_mode_sel[2]) begin //shift mode  & automatic switch mode enable.
            if(data_sends_bits_cnts==(i_waveform_mode_cnts-8'h1)&&(current_counter_automatic==(lastbit_current_counter+i_switch_mode_onebit_cnts))  && shiftout_mode_en) begin //&& i_capture_mode_automatic_sw
                shiftout_mode_en <= 1'b0;
            end
            else if(data_recs_bits_cnts==(i_capture_mode_cnts-8'h1)&&(current_counter_automatic==(lastbit_current_counter+i_switch_mode_onebit_cnts)) && i_waveform_mode_automatic_sw && !shiftout_mode_en) begin
                shiftout_mode_en <= 1'b1;                
            end
                
        end
    end
    else 
        shiftout_mode_en <= 1'h0;
end


assign w1_waveform_match_reg3 = waveform_mode_en && ((i_target_reg_ctrl[1]&& ((i_target_reg_a2+last_current_counter_a)==current_counter_target_reg_a)) ||(i_target_reg_ctrl[3]&&((i_target_reg_b2+last_current_counter_b)==current_counter_target_reg_b)));




always @(posedge i_clk) begin
    r1_capture_reg_status_dly_a <= &r1_capture_reg_status[2:0];
    r1_capture_reg_status_dly_b <= &r1_capture_reg_status[5:3];
    r1_current_counter_dly      <= &current_counter[31:0];
    shiftin_complete_flag_dly   <= shiftin_complete_flag;
    r1_shiftout_only_onebit_flag_dly <= w1_shiftout_only_onebit_flag;
    r1_waveform_match_reg3_dly <= w1_waveform_match_reg3;
    r1_switch_sendmode_dly     <= (data_sends_bits_cnts==i_waveform_mode_cnts);
    r1_switch_recmode_dly      <= (data_recs_bits_cnts==i_capture_mode_cnts);
end

always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        o_int <= 8'h0;
    end
    else begin
        if((&r1_capture_reg_status[2:0]) && !r1_capture_reg_status_dly_a) //capture register a0/a1/a2 had all updated, then generate interrupt.
            o_int[0] <= 1'b1;
        else 
            o_int[0] <= 1'b0;
        if((&r1_capture_reg_status[5:3])&& !r1_capture_reg_status_dly_b)//capture register b0/b1/b2 had all updated, then generate interrupt.
            o_int[1] <= 1'b1;
        else
            o_int[1] <= 1'b0;
        if(!(&current_counter[31:0]) && r1_current_counter_dly) // counter overflow, generate interrupt.
            o_int[2] <= 1'b1;
        else
            o_int[2] <= 1'b0;
        if(shiftin_complete_flag&& !shiftin_complete_flag_dly)  // shiftin complete, generate interrupt.
            o_int[3] <= 1'b1;
        else
            o_int[3] <= 1'b0;
        if(w1_shiftout_only_onebit_flag && !r1_shiftout_only_onebit_flag_dly) //shiftout data ,need new data.   
            o_int[4] <= 1'b1;
        else
            o_int[4] <= 1'b0;
        if(w1_waveform_match_reg3&&!r1_waveform_match_reg3_dly) //waveform, when counters meet i_target_reg_a2/b2, and stop the counter, generate interrupt. 
            o_int[5] <= 1'b1;
        else
            o_int[5] <= 1'b0;
        if(i_mode_sel[2]&& (data_recs_bits_cnts==i_capture_mode_cnts) &&!r1_switch_recmode_dly)//shift in & capture mode, with automatic switch mode enable. when this mode end. generate interrupt.
            o_int[6] <= 1'b1;
        else
            o_int[6] <= 1'b0;
        if(i_mode_sel[2]&& (data_sends_bits_cnts==i_waveform_mode_cnts) &&!r1_switch_sendmode_dly)//shift out & waveform mode, with automatic switch mode enable. when this mode end. generate interrupt.
            o_int[7] <= 1'b1;
        else
            o_int[7] <= 1'b0;            
        
    end
end






endmodule
`default_nettype wire
