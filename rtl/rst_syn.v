`timescale 1ns / 1ps 

`default_nettype none
module rst_syn(
    i_clk,
    i_rstn,
    o_rstn
);

input  wire i_clk;
input  wire i_rstn;
output wire  o_rstn;



reg [1:0] rstn_syn;

`ifdef FPGA

always @(posedge i_clk or negedge i_rstn) begin
    if(!i_rstn) 
        rstn_syn[1:0] <= 2'b11;
    else 
        rstn_syn[1:0] <= {rstn_syn[0],1'b1}
end
assign o_rstn = rstn_syn;

`else 

always @(posedge i_clk) begin
    rstn_syn <= i_rstn;
end
assign o_rstn = rstn_syn && i_rstn;

`endif








endmodule

`default_nettype wire
