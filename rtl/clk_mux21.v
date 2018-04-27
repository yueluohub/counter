
`timescale 1ns / 1ps 
`default_nettype none

module clk_mux21(
    i_clk0,
    i_clk1,
    i_sel,
    o_clk
);

input	wire i_clk0;
input	wire i_clk1;
input	wire i_sel;
output	wire o_clk;


assign o_clk = i_sel ? i_clk1 : i_clk0;















endmodule
`default_nettype wire