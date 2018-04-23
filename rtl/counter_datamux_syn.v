
`timescale 1ns / 1ps 

module counter_datamux_syn(
        i_clk_din,
        i_rstn_din,
        i_mux_sel,
        i_inner_din_a,
        i_inner_din_b,
        i_clk_dout,
        i_rstn_dout,
        o_mux_dout
);

parameter   COUNTER_NUM=4;
input [COUNTER_NUM-1:0] i_clk_din;
input [COUNTER_NUM-1:0] i_rstn_din;
input [COUNTER_NUM-1:0] i_mux_sel;
//[0]:0->i_inner_din_a[0],1->i_inner_din_b[0];
//[1]:0->i_inner_din_a[1],1->i_inner_din_b[1];
//[n]:0->i_inner_din_a[n],1->i_inner_din_b[n];
input [COUNTER_NUM-1:0] i_inner_din_a;
input [COUNTER_NUM-1:0] i_inner_din_b;
output [COUNTER_NUM-1:0] o_mux_dout;
input   i_clk_dout;
input   i_rstn_dout;

wire [COUNTER_NUM-1:0] w1_inner_din;

genvar i;
generate for(i=0;i<COUNTER_NUM;i=i+1) begin:mux_syn_loop

assign w1_inner_din[i] =  i_mux_sel[i] ? i_inner_din_b[i] : i_inner_din_a;

counter_data_syn    u0_syn(
        .i_clk_din   (i_clk_din[i]),
        .i_rstn_din  (i_rstn_din[i]),
        .i_din       (w1_inner_din[i]),
        .i_clk_dout  (i_clk_dout),
        .i_rstn_dout (i_rstn_dout),
        .o_syn_dout  (o_mux_dout[i])
);

end
endgenerate











endmodule