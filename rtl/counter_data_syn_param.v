
`timescale 1ns / 1ps 
`default_nettype none

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
input  wire  i_clk_din;
input  wire  i_rstn_din;
input  wire [BUS_WIDTH-1:0] i_din;
//      
input  wire  i_clk_dout;
input  wire  i_rstn_dout;
output wire  [BUS_WIDTH-1:0] o_syn_dout;

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
`default_nettype wire
