
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
reg [1:0]  r1_din_pose_req_dly;
reg [1:0]  r1_dout_pose_ack_dly;
reg [1:0]  r1_din_nege_req_dly;
reg [1:0]  r1_dout_nege_ack_dly;

always @(posedge i_clk_din) begin
    r1_din_dly <= i_din;
end

always @(posedge i_clk_din) begin
   r1_dout_pose_ack_dly[1:0] <= {r1_dout_pose_ack_dly[0],r1_dout_pose_ack};
   r1_dout_nege_ack_dly[1:0] <= {r1_dout_nege_ack_dly[0],r1_dout_nege_ack};
end

always @(posedge i_clk_dout ) begin
  r1_din_pose_req_dly[1:0] <= {r1_din_pose_req_dly[0],r1_din_pose_req};
  r1_din_nege_req_dly[1:0] <= {r1_din_nege_req_dly[0],r1_din_nege_req};
end


always @(posedge i_clk_din or negedge i_rstn_din)
if(!i_rstn_din) begin
    r1_din_pose_req <= 1'b0;
end
else if(i_din&&!r1_din_dly) begin
    r1_din_pose_req <= 1'b1;
end
else if(r1_dout_pose_ack_dly[1]) begin
    r1_din_pose_req <= 1'b0;
end

always @(posedge i_clk_din or negedge i_rstn_din)
if(!i_rstn_din) begin
    r1_din_nege_req <= 1'b0;
end
else if(!i_din&&r1_din_dly) begin
    r1_din_nege_req <= 1'b1;
end
else if(r1_dout_nege_ack_dly[1]) begin
    r1_din_nege_req <= 1'b0;
end

always @(posedge i_clk_dout or negedge i_rstn_dout)
if(!i_rstn_dout) begin
    r1_dout_pose_ack <= 1'b0;
end
else if(r1_din_pose_req_dly[1]) begin
    r1_dout_pose_ack <= 1'b1;
end
else if(!r1_din_pose_req_dly[1]) begin
    r1_dout_pose_ack <= 1'b0;
end

always @(posedge i_clk_dout or negedge i_rstn_dout)
if(!i_rstn_dout) begin
    r1_dout_nege_ack <= 1'b0;
end
else if(r1_din_nege_req_dly[1]) begin
    r1_dout_nege_ack <= 1'b1;
end
else if(!r1_din_nege_req_dly[1]) begin
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
reg  r2_dout_pose_ack_dly;
reg  r2_dout_nege_ack_dly;
always @(posedge i_clk_dout) begin
  r2_dout_pose_ack_dly <= r1_dout_pose_ack;
  r2_dout_nege_ack_dly <= r1_dout_nege_ack;
end



always @(posedge i_clk_dout or negedge i_rstn_dout)
if(!i_rstn_dout) begin
    r1_dout_ack  <= 1'b0;
    r1_din_pulse <= 1'b0;
end
else if(r1_din_pulse) begin
    r1_dout_ack <= ~r1_dout_ack;
    r1_din_pulse <= 1'b0;
end
else if(r1_dout_pose_ack&&!r2_dout_pose_ack_dly&&r1_dout_nege_ack&&!r2_dout_nege_ack_dly) begin
    r1_dout_ack <= ~r1_dout_ack;
    r1_din_pulse <= 1'b1;  
end
else if(r1_dout_pose_ack&&!r2_dout_pose_ack_dly) begin
    r1_dout_ack <= 1'b1;
end
else if(r1_dout_nege_ack&&!r2_dout_nege_ack_dly) begin
    r1_dout_ack <= 1'b0;
end


assign o_syn_dout = r1_dout_ack;




endmodule
`default_nettype wire
