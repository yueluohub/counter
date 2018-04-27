
`timescale 1ns / 1ps 
`default_nettype none

module clk_mux81(
    i_clk,
    i_sel,
    o_clk
);

input wire [7:0] i_clk;
input wire [2:0] i_sel;
output	reg o_clk;


always @* begin
case(i_sel)
    3'h0: o_clk = i_clk[0];
    3'h1: o_clk = i_clk[1];
    3'h2: o_clk = i_clk[2];
    3'h3: o_clk = i_clk[3];
    3'h4: o_clk = i_clk[4];
    3'h5: o_clk = i_clk[5];
    3'h6: o_clk = i_clk[6];
    3'h7: o_clk = i_clk[7];
endcase
end














endmodule

`default_nettype wire

