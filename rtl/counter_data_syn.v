
`timescale 1ns / 1ps 
`default_nettype none

module counter_data_syn(
        i_clk_din,
        i_rstn_din,
        i_din,
        i_clk_dout,
        i_rstn_dout,
        o_syn_dout
);
//
input  wire i_clk_din;
input  wire i_rstn_din;
input  wire i_din;
//     
input  wire i_clk_dout;
input  wire i_rstn_dout;
output wire o_syn_dout;

reg     r1_din_syn;
reg     r1_dout_ack;
reg     r1_din_dly;
reg     r1_din_pulse;
reg     r1_din_pose_req;
reg     r1_dout_pose_ack;
reg     r1_din_nege_req;
reg     r1_dout_nege_ack;

always @(posedge i_clk_din) begin
    r1_din_dly <= i_din;
end


always @(posedge i_clk_din or negedge i_rstn_din)
if(!i_rstn_din) begin
    r1_din_pose_req <= 1'b0;
end
else if(i_din&&!r1_din_dly) begin
    r1_din_pose_req <= 1'b1;
end
else if(r1_dout_pose_ack) begin
    r1_din_pose_req <= 1'b0;
end

always @(posedge i_clk_din or negedge i_rstn_din)
if(!i_rstn_din) begin
    r1_din_nege_req <= 1'b0;
end
else if(!i_din&&r1_din_dly) begin
    r1_din_nege_req <= 1'b1;
end
else if(r1_dout_nege_ack) begin
    r1_din_nege_req <= 1'b0;
end

always @(posedge i_clk_dout or negedge i_rstn_dout)
if(!i_rstn_dout) begin
    r1_dout_pose_ack <= 1'b0;
end
else if(r1_din_pose_req) begin
    r1_dout_pose_ack <= 1'b1;
end
else if(!r1_din_pose_req) begin
    r1_dout_pose_ack <= 1'b0;
end

always @(posedge i_clk_dout or negedge i_rstn_dout)
if(!i_rstn_dout) begin
    r1_dout_nege_ack <= 1'b0;
end
else if(r1_din_nege_req) begin
    r1_dout_nege_ack <= 1'b1;
end
else if(!r1_din_nege_req) begin
    r1_dout_nege_ack <= 1'b0;
end

// always @(posedge i_clk_din or negedge i_rstn_din)
// if(!i_rstn_din) begin
    // r1_din_syn <= 1'b0;
// end
// else if(i_din) begin
    // r1_din_syn <= 1'b1;
// end
// else if(r1_dout_ack) begin
    // r1_din_syn <= 1'b0;
// end

//
always @(posedge i_clk_dout or negedge i_rstn_dout)
if(!i_rstn_dout) begin
    r1_dout_ack  <= 1'b0;
    r1_din_pulse <= 1'b0;
end
else if(r1_din_pulse) begin
    r1_dout_ack <= ~r1_dout_ack;
    r1_din_pulse <= 1'b0;
end
else if(r1_dout_pose_ack&&r1_dout_nege_ack) begin
    r1_dout_ack <= ~r1_dout_ack;
    r1_din_pulse <= 1'b1;  
end
else if(r1_dout_pose_ack) begin
    r1_dout_ack <= 1'b1;
end
else if(r1_dout_nege_ack) begin
    r1_dout_ack <= 1'b0;
end


assign o_syn_dout = r1_dout_ack;




endmodule
`default_nettype wire