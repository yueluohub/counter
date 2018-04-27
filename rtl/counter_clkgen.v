// just for counter clock generate bfm,
`timescale 1ns / 1ps 

`default_nettype none
module counter_clkgen(
        i_power_rstn,
        i_inner_clk,
        i_extern_clk,
        i_counter_douta,
        //
        i_clk_sel_c0,
        i_clk_sel_c1,
        i_clk_sel_c2,
        i_clk_sel_c3,
        i_clk_inv_en_c0,
        i_clk_inv_en_c1,
        i_clk_inv_en_c2,
        i_clk_inv_en_c3,
        i_clk_enable_c0,
        i_clk_enable_c1,
        i_clk_enable_c2,
        i_clk_enable_c3,
        //
        o_clk,
        o_rstn

);
//
input wire i_power_rstn;
input wire [1:0] i_inner_clk;
input wire [2:0] i_extern_clk;
input wire [3:0] i_counter_douta;

input wire [3:0] i_clk_sel_c0;
input wire [3:0] i_clk_sel_c1;
input wire [3:0] i_clk_sel_c2;
input wire [3:0] i_clk_sel_c3;
input wire  i_clk_inv_en_c0;
input wire  i_clk_inv_en_c1;
input wire  i_clk_inv_en_c2;
input wire  i_clk_inv_en_c3;

input wire  i_clk_enable_c0;
input wire  i_clk_enable_c1;
input wire  i_clk_enable_c2;
input wire  i_clk_enable_c3;

output wire [3:0] o_clk;
output wire [3:0] o_rstn;
//
wire w_clk_c0,w_clkinv_c0,w_clk_c0_rslt;

clk_mux81   u81_c0(.i_clk({i_counter_douta[3],i_counter_douta[2],i_counter_douta[1],i_extern_clk[2:0],i_inner_clk[1:0]}),.i_sel(i_clk_sel_c0[2:0]),.o_clk(w_clk_c0) );
clk_inv clk_inv_c0(.i_clk(w_clk_c0),.o_clk(w_clkinv_c0));
clk_mux21   u21_c0(.i_clk0(w_clk_c0),.i_clk1(w_clkinv_c0),.i_sel(i_clk_inv_en_c0),.o_clk(w_clk_c0_rslt) );
rst_syn rst_syn_c0(.i_clk(w_clk_c0_rslt),.i_rstn(i_power_rstn),.o_rstn(o_rstn[0]));
clk_en  clk_en_c0(.i_clk(w_clk_c0_rslt),.i_en(i_clk_enable_c0),.o_clk(o_clk[0]) );

wire w_clk_c1,w_clkinv_c1,w_clk_c1_rslt;

clk_mux81   u81_c1(.i_clk({i_counter_douta[3],i_counter_douta[2],i_counter_douta[0],i_extern_clk[2:0],i_inner_clk[1:0]}),.i_sel(i_clk_sel_c1[2:0]),.o_clk(w_clk_c1) );
clk_inv clk_inv_c1(.i_clk(w_clk_c1),.o_clk(w_clkinv_c1));
clk_mux21   u21_c1(.i_clk0(w_clk_c1),.i_clk1(w_clkinv_c1),.i_sel(i_clk_inv_en_c1),.o_clk(w_clk_c1_rslt) );
rst_syn rst_syn_c1(.i_clk(w_clk_c1_rslt),.i_rstn(i_power_rstn),.o_rstn(o_rstn[1]));
clk_en  clk_en_c1(.i_clk(w_clk_c1_rslt),.i_en(i_clk_enable_c1),.o_clk(o_clk[1]) );

wire w_clk_c2,w_clkinv_c2,w_clk_c2_rslt;

clk_mux81   u81_c2(.i_clk({i_counter_douta[3],i_counter_douta[1],i_counter_douta[0],i_extern_clk[2:0],i_inner_clk[1:0]}),.i_sel(i_clk_sel_c2[2:0]),.o_clk(w_clk_c2) );
clk_inv clk_inv_c2(.i_clk(w_clk_c2),.o_clk(w_clkinv_c2));
clk_mux21   u21_c2(.i_clk0(w_clk_c2),.i_clk1(w_clkinv_c2),.i_sel(i_clk_inv_en_c2),.o_clk(w_clk_c2_rslt) );
rst_syn rst_syn_c2(.i_clk(w_clk_c2_rslt),.i_rstn(i_power_rstn),.o_rstn(o_rstn[2]));
clk_en  clk_en_c2(.i_clk(w_clk_c2_rslt),.i_en(i_clk_enable_c2),.o_clk(o_clk[2]) );

wire w_clk_c3,w_clkinv_c3,w_clk_c3_rslt;

clk_mux81   u81_c3(.i_clk({i_counter_douta[2],i_counter_douta[1],i_counter_douta[0],i_extern_clk[2:0],i_inner_clk[1:0]}),.i_sel(i_clk_sel_c3[2:0]),.o_clk(w_clk_c3) );
clk_inv clk_inv_c3(.i_clk(w_clk_c3),.o_clk(w_clkinv_c3));
clk_mux21   u21_c3(.i_clk0(w_clk_c3),.i_clk1(w_clkinv_c3),.i_sel(i_clk_inv_en_c3),.o_clk(w_clk_c3_rslt) );
rst_syn rst_syn_c3(.i_clk(w_clk_c3_rslt),.i_rstn(i_power_rstn),.o_rstn(o_rstn[3]));
clk_en  clk_en_c3(.i_clk(w_clk_c3_rslt),.i_en(i_clk_enable_c3),.o_clk(o_clk[3]) );









endmodule
`default_nettype wire

