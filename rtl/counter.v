
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
input  [7:0] i_soft_trigger_ctrl;   // to control the function of single/global_trigger, as a normal control signal or a softward trigger signal.
input  [SEL_WIDTH-1:0] i_src_sel_start;
input  [1:0] i_src_edge_start;
input  [SEL_WIDTH-1:0] i_src_sel_stop;
input  [1:0] i_src_edge_stop;
input  [SEL_WIDTH-1:0] i_src_sel_din0;
input  [1:0] i_src_edge_din0;
input  [SEL_WIDTH-1:0] i_src_sel_din1;
input  [1:0] i_src_edge_din1;
input  [3:0] i_ctrl_snap;
output [31:0] o_shadow_reg;
input  [5:0] i_target_reg_ctrl;
//[0]: when counters meet i_target_reg_a2, 1- keep the value,   0- reset the value.
//[1]: when counters meet i_target_reg_a2, 1- stop the counter, 0- restart the counter.
//[2]: when counters meet i_target_reg_b2, 1- keep the value,   0- reset the value.
//[3]: when counters meet i_target_reg_b2, 1- stop the counter, 0- restart the counter.
//[4]: dout_a reset value.
//[5]: dout_b reset value.
input  [31:0] i_target_reg_a0;
input  [31:0] i_target_reg_a1;
input  [31:0] i_target_reg_a2;
input  [31:0] i_target_reg_b0;
input  [31:0] i_target_reg_b1;
input  [31:0] i_target_reg_b2;
output [5:0] o_capture_reg_status;//(a2/a1/a0)bit2-bit0:1-active.(b2/b1/b0)bit5-bit3;
input  [5:0] i_capture_reg_read_flag;//(a2/a1/a0)bit2-bit0:1-active.(b2/b1/b0)bit5-bit3:
input  [5:0] i_capture_reg_overflow_ctrl;//bit5~bit0: 1-overwrite,0-discard.
output [31:0] o_capture_reg_a0;
output [31:0] o_capture_reg_a1;
output [31:0] o_capture_reg_a2;
output [31:0] o_capture_reg_b0;
output [31:0] o_capture_reg_b1;
output [31:0] o_capture_reg_b2;
input  [2:0] i_mode_sel;
//[0]: 0-capture_mode/shitin_mode, 1-waveform_mode/shiftout_mode.
//[1]: 0-count mode, 1-shift mode.
//[2]: 0-automatic switch mode disable. 1-enable.
input  [15:0] i_switch_mode_onebit_cnts;
input  [7:0] i_waveform_mode_cnts;//waveform/shiftout mode cnts.
input  [7:0] i_capture_mode_cnts;//capture/shiftin mode cnts.
input  i_waveform_mode_automatic_sw;//1-automatic switch to waveform mode enable,0-disable.
input  i_capture_mode_automatic_sw;//1-automatic switch to capture mode enable,0-disable.
input  i_shiftmode_ctrl;//0-bus_a(din_a/dout_a),1-bus_b(din_b/dout_b).
input  [31:0] i_shiftout_data;
input  [4:0] i_shiftout_data_ctrl_bitcnts;//n-> (n+1) bit;
input   i_shiftout_data_valid;//1->active.
output [31:0] o_shiftin_data;
output [31:0] o_shiftin_databits_updated;//1-> new data.
input  [4:0] i_shiftin_data_ctrl_bitcnts;//n-> (n+1) bit;

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
reg [31:0] lastbit_current_counter;
reg  [63:0] r1_shiftout_data;
reg  [63:0] r1_shiftout_databits_valid;
reg  i_shiftout_data_valid_dly;
wire  w1_shiftout_only_onebit_flag;
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
reg [3:0] i_ctrl_snap_dly;
reg [1:0] capture_cnts_a,capture_cnts_b;
reg [31:0] r1_shiftin_data;
reg [31:0] r1_shiftin_databits_updated;

//assign inner_din_shift = i_inner_din>>COUNTER_NUM-1;

always @(*) begin
    case(32'h1<<i_src_sel_start) 
        32'h1<<1:    counter_start = i_extern_din_a;
        32'h1<<2:    counter_start = i_extern_din_b;
        32'h1<<3:    counter_start = i_global_start_trigger & i_soft_trigger_ctrl[0];
        32'h1<<4:    counter_start = i_single_start_trigger & i_soft_trigger_ctrl[4];
        32'h1<<5:    counter_start = i_global_stop_trigger & i_soft_trigger_ctrl[1];
        32'h1<<6:    counter_start = i_single_stop_trigger & i_soft_trigger_ctrl[5];
        32'h1<<7:    counter_start = i_global_clear_trigger & i_soft_trigger_ctrl[2];
        32'h1<<8:    counter_start = i_single_clear_trigger & i_soft_trigger_ctrl[6];
        32'h1<<9:    counter_start = i_global_reset_trigger & i_soft_trigger_ctrl[3];
        32'h1<<10:   counter_start = i_single_reset_trigger & i_soft_trigger_ctrl[7];
        32'h1<<11:   counter_start = i_inner_din[0];
        32'h1<<12:   counter_start = (COUNTER_NUM>1)?i_inner_din[1]:1'b0;
        32'h1<<13:   counter_start = (COUNTER_NUM>2)?i_inner_din[2]:1'b0;
        32'h1<<14:   counter_start = (COUNTER_NUM>3)?i_inner_din[3]:1'b0;
        32'h1<<15:   counter_start = (COUNTER_NUM>4)?i_inner_din[4]:1'b0;
        default:     counter_start = (COUNTER_NUM>5)?i_inner_din[5]:1'b0;
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
        32'h1<<11:   counter_stop = i_inner_din[0];
        32'h1<<12:   counter_stop = (COUNTER_NUM>1)?i_inner_din[1]:1'b0;
        32'h1<<13:   counter_stop = (COUNTER_NUM>2)?i_inner_din[2]:1'b0;
        32'h1<<14:   counter_stop = (COUNTER_NUM>3)?i_inner_din[3]:1'b0;
        32'h1<<15:   counter_stop = (COUNTER_NUM>4)?i_inner_din[4]:1'b0;
        default:     counter_stop = (COUNTER_NUM>5)?i_inner_din[5]:1'b0;
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
        32'h1<<11:   counter_din0 = i_inner_din[0];
        32'h1<<12:   counter_din0 = (COUNTER_NUM>1)?i_inner_din[1]:1'b0;
        32'h1<<13:   counter_din0 = (COUNTER_NUM>2)?i_inner_din[2]:1'b0;
        32'h1<<14:   counter_din0 = (COUNTER_NUM>3)?i_inner_din[3]:1'b0;
        32'h1<<15:   counter_din0 = (COUNTER_NUM>4)?i_inner_din[4]:1'b0;
        default:     counter_din0 = (COUNTER_NUM>5)?i_inner_din[5]:1'b0;
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
        32'h1<<11:   counter_din1 = i_inner_din[0];
        32'h1<<12:   counter_din1 = (COUNTER_NUM>1)?i_inner_din[1]:1'b0;
        32'h1<<13:   counter_din1 = (COUNTER_NUM>2)?i_inner_din[2]:1'b0;
        32'h1<<14:   counter_din1 = (COUNTER_NUM>3)?i_inner_din[3]:1'b0;
        32'h1<<15:   counter_din1 = (COUNTER_NUM>4)?i_inner_din[4]:1'b0;
        default:     counter_din1 = (COUNTER_NUM>5)?i_inner_din[5]:1'b0;
    endcase
end



assign soft_start_flag = (i_global_start_trigger && !i_soft_trigger_ctrl[0]) || (i_single_start_trigger && !i_soft_trigger_ctrl[4]);
assign soft_stop_flag  = (i_global_stop_trigger  && !i_soft_trigger_ctrl[1]) || (i_single_stop_trigger  && !i_soft_trigger_ctrl[5]);
assign soft_clear_flag = (i_global_clear_trigger && !i_soft_trigger_ctrl[2]) || (i_single_clear_trigger && !i_soft_trigger_ctrl[6]);
assign soft_reset_flag = (i_global_reset_trigger && !i_soft_trigger_ctrl[3]) || (i_single_reset_trigger && !i_soft_trigger_ctrl[7]);

always @(posedge i_clk) begin
    counter_start_dly[1:0] <= {counter_start_dly[0],counter_start};
    counter_stop_dly[1:0]  <= {counter_stop_dly[0],counter_stop};
    counter_din0_dly[1:0]  <= {counter_din0_dly[0],counter_din0};
    counter_din1_dly[1:0]  <= {counter_din1_dly[0],counter_din1};
end

assign start_flag = i_src_edge_start[1] ? (i_src_edge_start[0] ? ^counter_start_dly[1:0] : 1'b0) : (i_src_edge_start[0] ? (!counter_start_dly[0] & counter_start_dly[1]) : (counter_start_dly[0] & !counter_start_dly[1]) );
assign stop_flag  = i_src_edge_stop[1] ?  (i_src_edge_start[0] ? ^counter_stop_dly[1:0]  : 1'b0) : (i_src_edge_stop[0] ? (!counter_stop_dly[0] & counter_stop_dly[1]) : (counter_stop_dly[0] & !counter_stop_dly[1]) );
assign din0_flag  = i_src_edge_din0[1] ?  (i_src_edge_start[0] ? ^counter_din0_dly[1:0]  : 1'b0) : (i_src_edge_din0[0] ? (!counter_din0_dly[0] & counter_din0_dly[1]) : (counter_din0_dly[0] & !counter_din0_dly[1]) );
assign din1_flag  = i_src_edge_din1[1] ?  (i_src_edge_start[0] ? ^counter_din1_dly[1:0]  : 1'b0) : (i_src_edge_din1[0] ? (!counter_din1_dly[0] & counter_din1_dly[1]) : (counter_din1_dly[0] & !counter_din1_dly[1]) );



always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n)
        current_counter <= 32'h0;
    else if(!i_enable || soft_reset_flag)
        current_counter <= 32'h0;
    else if(count_en)
        if(soft_clear_flag)
            current_counter <= 32'h0;
        else if(i_mode_sel[0]&& !i_mode_sel[1]&& (!i_target_reg_ctrl[1]&& (i_target_reg_a2==current_counter)) ||(!i_target_reg_ctrl[3]&&(i_target_reg_b2==current_counter))) //restart the counter,when in counter waveform mode and meets target_reg_a2/b2 .
            current_counter <= 32'h0;
        else
            current_counter <= current_counter + 1'b1;

end

always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n)
        count_en <= 1'h0;
    else if(i_enable) begin
        if(soft_reset_flag||soft_stop_flag||stop_flag)
            count_en <= 1'h0;
        else if(soft_start_flag||start_flag)
            count_en <= 1'h1;
        else if(i_mode_sel[0]&& !i_mode_sel[1] && (i_target_reg_ctrl[1]&& (i_target_reg_a2==current_counter)) ||(i_target_reg_ctrl[3]&&(i_target_reg_b2==current_counter))) //stop the counter,when in counter mode and meets target_reg_a2/b2 .
            count_en <= 1'h0;
    end
    else 
        count_en <= 1'h0;
end

//----------------------------------------------//
//----------------------------------------------//
//------waveform&shiftout mode counter  --------//
//----------------------------------------------//
//----------------------------------------------//



assign w1_shiftout_only_onebit_flag = (!(|r1_shiftout_databits_valid[31:1]))&&r1_shiftout_databits_valid[0];

always @(posedge i_clk) begin
    i_shiftout_data_valid_dly <= i_shiftout_data_valid;
end 

//i_shiftout_data_ctrl_bitcnts
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        r1_shiftout_data[63:32] <= 32'h0;
        r1_shiftout_databits_valid[63:32] <= 32'h0000;
    end
    else if(i_shiftout_data_valid&&!i_shiftout_data_valid_dly) begin
        r1_shiftout_data[63:32] <= i_shiftout_data[31:0];
        r1_shiftout_databits_valid[63:32] <= ~(32'hfffe<<i_shiftout_data_ctrl_bitcnts);
    end
end

always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        r1_shiftout_data[31:0] <= 32'h0;
        r1_shiftout_databits_valid[31:0] <= 32'hffff;
    end
    else if(soft_start_flag||start_flag) begin
        if(i_mode_sel[0] && i_mode_sel[1]) begin// shiftout mode.
            r1_shiftout_data[31:0] <= r1_shiftout_data[63:32];
            r1_shiftout_databits_valid[31:0]  <= r1_shiftout_databits_valid[63:32];     
        end
    end
    else if(shiftout_mode_en) begin
        if(w1_shiftout_only_onebit_flag) begin//only one bit.
            r1_shiftout_data[31:0] <= r1_shiftout_data[63:32];
            r1_shiftout_databits_valid[31:0]  <= r1_shiftout_databits_valid[63:32];         
        end
        else begin
            r1_shiftout_data[31:0] <= r1_shiftout_data[31:0]>>1;
            r1_shiftout_databits_valid[31:0]  <= r1_shiftout_databits_valid[31:0]>>1;
        end
    end
end

always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        o_extern_dout_a     <= 1'b0;
        o_extern_dout_b     <= 1'b0;
    end
    else if(i_enable) begin
        if(!i_mode_sel[0]&&!i_mode_sel[2]) begin//automatic switch mode disable , and output mode.
            o_extern_dout_a     <= 1'b0;
            o_extern_dout_b     <= 1'b0;
        end 
        else if(soft_start_flag||start_flag) begin
            if(i_mode_sel[0]) begin//counter waveform mode&shiftout mode//&&!i_mode_sel[1]
                o_extern_dout_a     <= i_target_reg_ctrl[4];//reset value.
                o_extern_dout_b     <= i_target_reg_ctrl[5];//reset value.
            end
        end
        else if(waveform_mode_en) begin //???,counter waveform mode.
            if(i_target_reg_a0==current_counter) 
                o_extern_dout_a <= 1'b0;
            else if(i_target_reg_a1==current_counter) 
                o_extern_dout_a <= 1'b1;
            else if(i_target_reg_a2==current_counter) begin
                if(i_target_reg_ctrl[0])
                    o_extern_dout_a <= o_extern_dout_a;//keep the value.
                else
                    o_extern_dout_a <= i_target_reg_ctrl[4];//reset value.
            end
            if(i_target_reg_b0==current_counter) 
                o_extern_dout_b <= 1'b0;
            else if(i_target_reg_b1==current_counter) 
                o_extern_dout_b <= 1'b1;
            else if(i_target_reg_b2==current_counter) begin
                if(i_target_reg_ctrl[2])
                    o_extern_dout_b <= o_extern_dout_b;//keep the value.
                else
                    o_extern_dout_b <= i_target_reg_ctrl[5];//reset value.
            end
                        
        end
        else if(shiftout_mode_en) begin
            if(i_shiftmode_ctrl)
                o_extern_dout_b <= r1_shiftout_data[0];
            else
                o_extern_dout_a <= r1_shiftout_data[0];
        end
    
    end
end

always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        waveform_mode_en <= 1'b0;
        o_extern_dout_a_oen <= 1'b1;
        o_extern_dout_b_oen <= 1'b1;
    end
    else if(i_enable) begin
        if(soft_reset_flag||soft_stop_flag||stop_flag) begin
            waveform_mode_en <= 1'b0;
            o_extern_dout_a_oen     <= 1'b1;
            o_extern_dout_a_oen     <= 1'b1;
        end
        else if(soft_start_flag||start_flag) begin
            if(i_mode_sel[0]&&!i_mode_sel[1]) begin//waveform count mode.
                waveform_mode_en <= 1'b1;
                o_extern_dout_a_oen     <= 1'b0;
                o_extern_dout_b_oen     <= 1'b0;            
            end 
            else if(i_mode_sel[0] && i_mode_sel[1]) begin// shiftout mode.
                waveform_mode_en <= 1'b0;
                o_extern_dout_a_oen     <= 1'b0;
                o_extern_dout_b_oen     <= 1'b0;    
            end
            else  begin//
                waveform_mode_en <= 1'b0;
                o_extern_dout_a_oen     <= 1'b1;
                o_extern_dout_a_oen     <= 1'b1;
            end
        end
        else if(!i_mode_sel[1]&&i_mode_sel[2]) begin //count mode  & automatic switch mode enable.
            if(data_sends_bits_cnts==i_waveform_mode_cnts && i_capture_mode_automatic_sw && waveform_mode_en) begin
                waveform_mode_en <= 1'b0;
                o_extern_dout_a_oen     <= 1'b1;
                o_extern_dout_b_oen     <= 1'b1;
            end
            else if(data_recs_bits_cnts==i_capture_mode_cnts && i_waveform_mode_automatic_sw && !waveform_mode_en) begin
                waveform_mode_en <= 1'b1;
                o_extern_dout_a_oen     <= 1'b0;
                o_extern_dout_b_oen     <= 1'b0;                
            end
                
        end
        // else begin //redundant case;?
            // waveform_mode_en <= 1'b0;
            // o_extern_dout_a_oen  <= 1'b1;
            // o_extern_dout_a_oen  <= 1'b1;
        // end
    end
    else begin
        waveform_mode_en <= 1'b0;
        o_extern_dout_a_oen <= 1'b1;
        o_extern_dout_b_oen <= 1'b1;    
    end
    
end

//----------------------------------------------//
//----------------------------------------------//
//-----------capture mode counter  -------------//
//----------------------------------------------//
//----------------------------------------------//

always @(posedge i_clk) 
    i_ctrl_snap_dly <= i_ctrl_snap;

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
        if(i_ctrl_snap[0]&&!i_ctrl_snap_dly[0]) begin
            o_shadow_reg     <= current_counter;
        end
        if(i_ctrl_snap[1]&&!i_ctrl_snap_dly[1]) begin
            o_capture_reg_status <= r1_capture_reg_status;
            o_capture_reg_a0 <= r1_capture_reg_a0;
            o_capture_reg_a1 <= r1_capture_reg_a1;
            o_capture_reg_a2 <= r1_capture_reg_a2;
            o_capture_reg_b0 <= r1_capture_reg_b0;
            o_capture_reg_b1 <= r1_capture_reg_b1;
            o_capture_reg_b2 <= r1_capture_reg_b2;
        end
        if(shiftin_complete_flag) begin
            o_shiftin_data              <= r1_shiftin_data;
            o_shiftin_databits_updated  <= r1_shiftin_databits_updated;
        end
        else if(i_ctrl_snap[2]&&!i_ctrl_snap_dly[2]) begin
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
            if(data_sends_bits_cnts==i_waveform_mode_cnts && i_capture_mode_automatic_sw && !capture_mode_en) begin
                capture_mode_en <= 1'b1;
            end
            else if(data_recs_bits_cnts==i_capture_mode_cnts && i_waveform_mode_automatic_sw && capture_mode_en) begin
                capture_mode_en <= 1'b0;                
            end
                
        end
    end
    else 
        capture_mode_en <= 1'h0;
end

// 

always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        r1_capture_reg_status[2:0] <= 3'h0;
        r1_capture_reg_a0 <= 32'h0;
        r1_capture_reg_a1 <= 32'h0;
        r1_capture_reg_a2 <= 32'h0;
        capture_cnts_a    <= 2'h0;
    end
    else if(!i_enable || soft_reset_flag ||soft_clear_flag) begin
        r1_capture_reg_status[2:0] <= 3'h0;
        r1_capture_reg_a0 <= 32'h0;
        r1_capture_reg_a1 <= 32'h0;
        r1_capture_reg_a2 <= 32'h0;
        capture_cnts_a    <= 2'h0;      
    end
    else if(capture_mode_en) begin
        r1_capture_reg_status[2:0] <= r1_capture_reg_status[2:0] && (~i_capture_reg_read_flag[2:0]);
        if(din0_flag) begin
            if(capture_cnts_a==2'h2)
                capture_cnts_a <= 2'h0;
            else
                capture_cnts_a <= capture_cnts_a + 2'h1;
        end
        if(din0_flag) begin
            r1_capture_reg_status[2:0] <= r1_capture_reg_status[2:0] && (~i_capture_reg_read_flag[2:0]) || (3'h1<<capture_cnts_a);
            if(capture_cnts_a==2'h0 && (!r1_capture_reg_status[0] || (r1_capture_reg_status[0]&&i_capture_reg_overflow_ctrl[0]))) // overflow overwrite. and a new edge.
                r1_capture_reg_a0 <= current_counter;
            else if(capture_cnts_a==2'h1 && (!r1_capture_reg_status[1] || (r1_capture_reg_status[1]&&i_capture_reg_overflow_ctrl[1])))
                r1_capture_reg_a1 <= current_counter;
            else if(capture_cnts_a==2'h2 && (!r1_capture_reg_status[2] || (r1_capture_reg_status[2]&&i_capture_reg_overflow_ctrl[2])))
                r1_capture_reg_a2 <= current_counter;
        end
        
    end
    else begin
        r1_capture_reg_status[2:0] <= r1_capture_reg_status[2:0] && (~i_capture_reg_read_flag[2:0]);
    end
end

always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        r1_capture_reg_status[5:3] <= 3'h0;
        r1_capture_reg_b0 <= 32'h0;
        r1_capture_reg_b1 <= 32'h0;
        r1_capture_reg_b2 <= 32'h0;
        capture_cnts_b    <= 2'h0;
    end
    else if(!i_enable || soft_reset_flag ||soft_clear_flag) begin
        r1_capture_reg_status[5:3] <= 3'h0;
        r1_capture_reg_b0 <= 32'h0;
        r1_capture_reg_b1 <= 32'h0;
        r1_capture_reg_b2 <= 32'h0;
        capture_cnts_b    <= 2'h0;      
    end
    else if(capture_mode_en) begin
        r1_capture_reg_status[5:3] <= r1_capture_reg_status[5:3] && (~i_capture_reg_read_flag[5:3]);
        if(din1_flag) begin
            if(capture_cnts_b==2'h2)
                capture_cnts_b <= 2'h0;
            else
                capture_cnts_b <= capture_cnts_b + 2'h1;
        end
        if(din1_flag) begin
            r1_capture_reg_status[5:3] <= r1_capture_reg_status[5:3] && (~i_capture_reg_read_flag[5:3]) || (3'h1<<capture_cnts_b);
            if(capture_cnts_b==2'h0 && (!r1_capture_reg_status[3] || (r1_capture_reg_status[3]&&i_capture_reg_overflow_ctrl[3])))
                r1_capture_reg_b0 <= current_counter;
            else if(capture_cnts_b==2'h1 && (!r1_capture_reg_status[4] || (r1_capture_reg_status[4]&&i_capture_reg_overflow_ctrl[4])))
                r1_capture_reg_b1 <= current_counter;
            else if(capture_cnts_b==2'h2 && (!r1_capture_reg_status[5] || (r1_capture_reg_status[5]&&i_capture_reg_overflow_ctrl[5])))
                r1_capture_reg_b2 <= current_counter;
        end
        
    end
    else begin
        r1_capture_reg_status[5:3] <= r1_capture_reg_status[5:3] && (~i_capture_reg_read_flag[5:3]);
           
    end
end

//----------------------------------------------//
//----------------------------------------------//
//-----------automatic switch mode counter  ----//
//----------------------------------------------//
//----------------------------------------------//
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        data_sends_bits_cnts <= 8'h0;
        data_recs_bits_cnts  <= 8'h0;
        lastbit_current_counter <= 32'h0;
    end
    else if(!i_enable) begin
        data_sends_bits_cnts <= 8'h0;
        data_recs_bits_cnts  <= 8'h0;
        lastbit_current_counter <= 32'h0;
    end
    else if(soft_reset_flag||soft_stop_flag||stop_flag) begin
        data_sends_bits_cnts <= 8'h0;
        data_recs_bits_cnts  <= 8'h0;
        lastbit_current_counter <= 32'h0;
    end
    else if(!i_mode_sel[1]&&i_mode_sel[2]) begin
        if(waveform_mode_en) begin
            data_recs_bits_cnts  <= 8'h0;
            if(current_counter==(lastbit_current_counter+i_switch_mode_onebit_cnts)) begin//overflow ?
                lastbit_current_counter <= current_counter;
                data_sends_bits_cnts <= data_sends_bits_cnts +1'b1;
            end
        end
        else if(capture_mode_en) begin
            data_sends_bits_cnts <= 8'h0;
            if(current_counter==(lastbit_current_counter+i_switch_mode_onebit_cnts)) begin//overflow ?
                lastbit_current_counter <= current_counter;
                data_recs_bits_cnts <= data_recs_bits_cnts +1'b1;
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
        //else if(i_mode_sel[1]&&i_mode_sel[2]) begin //count mode  & automatic switch mode enable.
        //    if(data_sends_bits_cnts==i_waveform_mode_cnts && i_capture_mode_automatic_sw && !shiftin_mode_en) begin
        //        shiftin_mode_en <= 1'b1;
        //    end
        //    else if(data_recs_bits_cnts==i_capture_mode_cnts && i_waveform_mode_automatic_sw && shiftin_mode_en) begin
        //        shiftin_mode_en <= 1'b0;                
        //    end
        //        
        //end
    end
    else 
        shiftin_mode_en <= 1'h0;
end


assign i_shiftin_data_ctrl_bitmap=32'hfffe<<i_shiftin_data_ctrl_bitcnts;
assign counter_shiftin_din= i_shiftmode_ctrl ? counter_din1 : counter_din0 ;
assign shiftin_complete_flag= &(r1_shiftin_databits_updated&i_shiftin_data_ctrl_bitmap);

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
        if(shiftin_complete_flag) begin
            r1_shiftin_databits_updated <= 32'b1; 
            r1_shiftin_data[31:0] <= {r1_shiftin_data[30:0],counter_shiftin_din};
        end
        else begin
            r1_shiftin_databits_updated <= {r1_shiftin_databits_updated[30:0],1'b1};
            r1_shiftin_data[31:0] <= {r1_shiftin_data[30:0],counter_shiftin_din};
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
        //else if(!i_mode_sel[1]&&i_mode_sel[2]) begin //count mode  & automatic switch mode enable.
        //    if(data_sends_bits_cnts==i_waveform_mode_cnts && i_capture_mode_automatic_sw && !shiftout_mode_en) begin
        //        shiftout_mode_en <= 1'b1;
        //    end
        //    else if(data_recs_bits_cnts==i_capture_mode_cnts && i_waveform_mode_automatic_sw && shiftout_mode_en) begin
        //        shiftout_mode_en <= 1'b0;                
        //    end
        //        
        //end
    end
    else 
        shiftout_mode_en <= 1'h0;
end




reg r1_capture_reg_status_dly_a;
reg r1_capture_reg_status_dly_b;
reg r1_current_counter_dly;
reg shiftin_complete_flag_dly;
reg r1_shiftout_only_onebit_flag_dly;

always @(posedge i_clk) begin
    r1_capture_reg_status_dly_a <= &r1_capture_reg_status[2:0];
    r1_capture_reg_status_dly_b <= &r1_capture_reg_status[5:3];
    r1_current_counter_dly      <= &current_counter[31:0];
    shiftin_complete_flag_dly   <= shiftin_complete_flag;
    r1_shiftout_only_onebit_flag_dly <= w1_shiftout_only_onebit_flag;
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
        if(w1_shiftout_only_onebit_flag && !r1_shiftout_only_onebit_flag_dly)   
            o_int[4] <= 1'b1;
        else
            o_int[4] <= 1'b0;
    end
end






endmodule
