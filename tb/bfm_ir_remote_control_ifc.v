
`timescale 1ns / 1ns 

module bfm_ir_remote_control_ifc(
    output wire o_ir_dout
);

parameter P_CLK_30K=32'd33334;
parameter P_CLK_33K=32'd30303;
parameter P_CLK_36K=32'd27778;
parameter P_CLK_38K=32'd26315;
parameter P_CLK_40K=32'd25000;
parameter P_CLK_56K=32'd17857;


reg clk_30k;
reg clk_33k;
reg clk_36k;
reg clk_38k;
reg clk_40k;
reg clk_56k;

always if(clk_30k) begin #(P_CLK_30K/4) clk_30k = ~ clk_30k; end else begin #(P_CLK_30K*3/4) clk_30k = ~ clk_30k; end
always if(clk_33k) begin #(P_CLK_33K/4) clk_33k = ~ clk_33k; end else begin #(P_CLK_33K*3/4) clk_33k = ~ clk_33k; end
always if(clk_36k) begin #(P_CLK_36K/4) clk_36k = ~ clk_36k; end else begin #(P_CLK_36K*3/4) clk_36k = ~ clk_36k; end
always if(clk_38k) begin #(P_CLK_38K/4) clk_38k = ~ clk_38k; end else begin #(P_CLK_38K*3/4) clk_38k = ~ clk_38k; end
always if(clk_40k) begin #(P_CLK_40K/4) clk_40k = ~ clk_40k; end else begin #(P_CLK_40K*3/4) clk_40k = ~ clk_40k; end
always if(clk_56k) begin #(P_CLK_56K/4) clk_56k = ~ clk_56k; end else begin #(P_CLK_56K*3/4) clk_56k = ~ clk_56k; end


reg clk;
reg [2:0] clk_sel;

always @* begin
case(clk_sel)
3'h0: clk = clk_30k;
3'h1: clk = clk_33k;
3'h2: clk = clk_36k;
3'h3: clk = clk_38k;
3'h4: clk = clk_40k;
3'h5: clk = clk_56k;
default: clk = clk_56k;
endcase
end

initial begin
clk_30k = '0;
clk_33k = '0;
clk_36k = '0;
clk_38k = '0;
clk_40k = '0;
clk_56k = '0;

clk_sel =3'h0;
end



//o_ir_dout

reg r_ir_dout_or_high,r_ir_dout_and_low;
assign o_ir_dout = r_ir_dout_or_high|(clk & r_ir_dout_and_low);

task ir_value_1;
begin
    repeat (1) @(posedge clk);
    r_ir_dout_and_low = 1'b1;
    r_ir_dout_or_high = 1'b1;
    // repeat @(posedge clk);
end
endtask

task ir_value_0;
begin
    repeat (1) @(posedge clk);
    r_ir_dout_and_low = 1'b0;
    r_ir_dout_or_high = 1'b0;
    // repeat @(posedge clk);
end
endtask

task ir_value_wave;
begin
    repeat (1) @(posedge clk);
    r_ir_dout_and_low = 1'b1;
    r_ir_dout_or_high = 1'b0;
    // repeat @(posedge clk);
end
endtask

task ir_BI_phase_coding;
input value;
input [31:0] num;
begin
    if(value) begin
        ir_value_0;
        repeat(num) @(posedge clk);
        ir_value_wave;
        repeat(num) @(posedge clk);
    end
    else begin
        ir_value_wave;
        repeat(num) @(posedge clk);
        ir_value_0;
        repeat(num) @(posedge clk);
    end

end
endtask

task ir_pulse_distance_coding;
input value;
input [31:0] num0;//wave num;
input [31:0] num1;//value 0 zero num;
input [31:0] num2;//value 1 zero num;
begin
    if(!value) begin
        ir_value_wave;
        repeat(num0) @(posedge clk);
        ir_value_0;
        repeat(num1) @(posedge clk);
    end
    else begin
        ir_value_wave;
        repeat(num0) @(posedge clk);
        ir_value_0;
        repeat(num2) @(posedge clk);    
    end
end
endtask

task ir_pulse_length_coding;
input value;
input [31:0] num0;//wave value 0 num;
input [31:0] num1;//wave value 1 num;
input [31:0] num2;//value 0/1 zero num;
begin
    if(!value) begin
        ir_value_wave;
        repeat(num0) @(posedge clk);
        ir_value_0;
        repeat(num2) @(posedge clk);
    end
    else begin
        ir_value_wave;
        repeat(num1) @(posedge clk);
        ir_value_0;
        repeat(num2) @(posedge clk);    
    end
end
endtask

task ir_data_send;
input [1:0] mode_sel;//0(bi-phase),1(pulse-distance),2(pulse-length).
input [31:0] input_data;
input [5:0] data_bits_cnt;
reg [31:0] r_input_data;
begin
    r_input_data = input_data;
    if(mode_sel==0) begin
        repeat(data_bits_cnt) begin
            ir_BI_phase_coding(r_input_data[0],32);
            r_input_data=r_input_data>>1;
        end
    end
    else if(mode_sel==1) begin
        repeat(data_bits_cnt) begin
            ir_pulse_distance_coding(r_input_data[0],32,32,64);
            r_input_data=r_input_data>>1;
        end    
    end
    else if(mode_sel==1) begin
        repeat(data_bits_cnt) begin
            ir_pulse_length_coding(r_input_data[0],32,64,32);
            r_input_data=r_input_data>>1;
        end    
    end
end
endtask

reg [31:0] tmp0;

initial begin
    r_ir_dout_and_low = 1'b0;
    r_ir_dout_or_high = 1'b0;
    #10_000_000;
    repeat(2) begin
        tmp0[5:0]={$random}%256;
        ir_data_send(0,{tmp0[5:0],5'b0,1'b1,2'b00},5'd14);
        ir_value_0;
        #90_000_000;
    end
    $stop;
    
end



























endmodule