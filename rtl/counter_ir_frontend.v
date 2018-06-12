`timescale 1ns / 1ps 
`default_nettype none

module counter_ir_frontend(
        i_clk,
        i_rst_n,
        i_ir_din_onecycle_value_a,
        i_ir_din_onecycle_value_b,
        i_ir_din_bypass,
        i_extern_din_a,
        i_extern_din_b,
        o_ir_extern_din_a,
        o_ir_extern_din_b,
        i_ir_dout_opts,
        i_ir_dout_bypass,
        i_extern_dout_a,
        i_extern_dout_b,
        o_ir_extern_dout_a,
        o_ir_extern_dout_b
);

input  wire i_clk;
input  wire i_rst_n;
input  wire [31:0] i_ir_din_onecycle_value_a;
input  wire [31:0] i_ir_din_onecycle_value_b;
input  wire [1:0] i_ir_din_bypass;
input  wire i_extern_din_a;
input  wire i_extern_din_b;
output wire o_ir_extern_din_a;
output wire o_ir_extern_din_b;
input  wire [7:0] i_ir_dout_opts;//3~0 ->a,7~4 ->b;
input  wire [1:0] i_ir_dout_bypass;//0->a,1->b.
input  wire i_extern_dout_a;
input  wire i_extern_dout_b;
output wire o_ir_extern_dout_a;
output wire o_ir_extern_dout_b;


reg r1_ir_extern_din_a;
reg r1_ir_extern_din_b;
assign o_ir_extern_din_a = i_ir_din_bypass[0] ? i_extern_din_a : r1_ir_extern_din_a;
assign o_ir_extern_din_b = i_ir_din_bypass[1] ? i_extern_din_b : r1_ir_extern_din_b;

reg r1_ir_opts_extern_dout_a;
reg r1_ir_opts_extern_dout_b;

assign o_ir_extern_dout_a = i_ir_dout_bypass[0] ? i_extern_dout_a : r1_ir_opts_extern_dout_a;
assign o_ir_extern_dout_b = i_ir_dout_bypass[1] ? i_extern_dout_b : r1_ir_opts_extern_dout_b;

always @*
begin
case(i_ir_dout_opts[3:0])
    4'h0 :      r1_ir_opts_extern_dout_a = i_extern_dout_a & i_extern_dout_b;
    4'h1 :      r1_ir_opts_extern_dout_a = i_extern_dout_a | i_extern_dout_b;
    4'h2 :      r1_ir_opts_extern_dout_a = i_extern_dout_a ^ i_extern_dout_b;
    default:    r1_ir_opts_extern_dout_a = i_extern_dout_a ^ i_extern_dout_b;
endcase    
end

always @*
begin
case(i_ir_dout_opts[7:4])
    4'h0 :      r1_ir_opts_extern_dout_b = i_extern_dout_a & i_extern_dout_b;
    4'h1 :      r1_ir_opts_extern_dout_b = i_extern_dout_a | i_extern_dout_b;
    4'h2 :      r1_ir_opts_extern_dout_b = i_extern_dout_a ^ i_extern_dout_b;
    default:    r1_ir_opts_extern_dout_b = i_extern_dout_a ^ i_extern_dout_b;
endcase
end

reg r1_extern_din_a_dly;
reg r1_extern_din_b_dly;
always @(posedge i_clk) begin
    r1_extern_din_a_dly <= i_extern_din_a;
    r1_extern_din_b_dly <= i_extern_din_b;
end

reg [31:0] r1_ir_extern_din_a_cnts;
reg [31:0] r1_ir_extern_din_b_cnts;

always @(posedge i_clk or negedge i_rst_n)
if(!i_rst_n) begin
    r1_ir_extern_din_a_cnts <= 32'b0;
end
else if(i_extern_din_a&&!r1_extern_din_a_dly)
    r1_ir_extern_din_a_cnts <= 32'b0;
else if(r1_ir_extern_din_a_cnts==i_ir_din_onecycle_value_a)
    r1_ir_extern_din_a_cnts <= 32'b0;
else 
    r1_ir_extern_din_a_cnts <= r1_ir_extern_din_a_cnts + 32'b1;


always @(posedge i_clk or negedge i_rst_n)
if(!i_rst_n) begin
    r1_ir_extern_din_a <= 1'b0;
end
else if(r1_ir_extern_din_a_cnts==i_ir_din_onecycle_value_a)
    r1_ir_extern_din_a <= 1'b0;
else if(i_extern_din_a&&!r1_extern_din_a_dly)
    r1_ir_extern_din_a <= 1'b1;


always @(posedge i_clk or negedge i_rst_n)
if(!i_rst_n) begin
    r1_ir_extern_din_b_cnts <= 32'b0;
end
else if(i_extern_din_b&&!r1_extern_din_b_dly)
    r1_ir_extern_din_b_cnts <= 32'b0;
else if(r1_ir_extern_din_b_cnts==i_ir_din_onecycle_value_b)
    r1_ir_extern_din_b_cnts <= 32'b0;
else 
    r1_ir_extern_din_b_cnts <= r1_ir_extern_din_b_cnts + 32'b1;


always @(posedge i_clk or negedge i_rst_n)
if(!i_rst_n) begin
    r1_ir_extern_din_b <= 1'b0;
end
else if(r1_ir_extern_din_b_cnts==i_ir_din_onecycle_value_b)
    r1_ir_extern_din_b <= 1'b0;
else if(i_extern_din_b&&!r1_extern_din_b_dly)
    r1_ir_extern_din_b <= 1'b1;



endmodule

`default_nettype wire

