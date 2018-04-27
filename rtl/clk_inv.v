`timescale 1ns / 1ps 
`default_nettype none

module clk_inv(
    i_clk,
    o_clk
);
input  wire i_clk;
output wire o_clk;


assign o_clk = !i_clk ;













endmodule
`default_nettype wire