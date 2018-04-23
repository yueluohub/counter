
`timescale 1ns / 1ps 

module counter_data_syn_param(
        i_clk_din,
        i_rstn_din,
        i_din,
        i_clk_dout,
        i_rstn_dout,
        o_syn_dout
);

parameter BUS_WIDTH=4;

//
input  i_clk_din;
input  i_rstn_din;
input [BUS_WIDTH-1:0] i_din;
//
input  i_clk_dout;
input  i_rstn_dout;
output [BUS_WIDTH-1:0] o_syn_dout;

genvar i;
generate for(i=0;i<BUS_WIDTH;i=i+1) begin:bus_syn_loop


counter_data_syn    u0_syn(
        .i_clk_din   (i_clk_din),
        .i_rstn_din  (i_rstn_din),
        .i_din       (i_din[i]),
        .i_clk_dout  (i_clk_dout),
        .i_rstn_dout (i_rstn_dout),
        .o_syn_dout  (o_syn_dout[i])
);

end
endgenerate



endmodule