`timescale 1ns / 1ps 
`default_nettype none

module clk_en(
    i_clk,
    i_en,
    o_clk
);

input  wire i_clk;
input  wire i_en;
output wire  o_clk;


assign o_clk = i_clk & i_en;













endmodule
`default_nettype wire