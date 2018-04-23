
`timescale 1ns / 1ps 

module counter_data_syn(
        i_clk_din,
        i_rstn_din,
        i_din,
        i_clk_dout,
        i_rstn_dout,
        o_syn_dout
);
//
input  i_clk_din;
input  i_rstn_din;
input  i_din;
//
input  i_clk_dout;
input  i_rstn_dout;
output o_syn_dout;

reg   r1_din_syn;
reg   r1_dout_ack;

always @(posedge i_clk_din or negedge i_rstn_din)
if(!i_rstn_din) begin
    r1_din_syn <= 1'b0;
end
else if(i_din) begin
    r1_din_syn <= 1'b1;
end
else if(r1_dout_ack) begin
    r1_din_syn <= 1'b0;
end

//---need to modify;
always @(posedge i_clk_dout or negedge i_rstn_dout)
if(!i_rstn_dout) begin
    r1_dout_ack <= 1'b0;
end
else if(r1_din_syn) begin
    r1_dout_ack <= 1'b1;
end
else if(!r1_din_syn) begin
    r1_dout_ack <= 1'b0;
end


assign o_syn_dout = r1_din_syn;




endmodule