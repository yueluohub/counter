
`timescale 1ns / 1ps 

module counter_top_tb_top( );



parameter   COUNTER_NUM=4;

wire  [COUNTER_NUM-1:0] w_clk;// counter clock domain.
wire  [COUNTER_NUM-1:0] w_rst_n;
//apb bus register clock domain.
wire       w_pclk;
wire       w_prst_n;

wire   [ 31 : 0 ] w_paddr;
wire   [ 31 : 0 ] w_pwdata;
wire              w_pwrite;
wire              w_psel;
wire              w_penable;
wire [ 31 : 0 ]   w_prdata;

//sync data & trigger
wire  [COUNTER_NUM-1:0] w_extern_din_a;
wire  [COUNTER_NUM-1:0] w_extern_din_b;

wire [COUNTER_NUM-1:0] w_extern_dout_a;
wire [COUNTER_NUM-1:0] w_extern_dout_a_oen;
wire [COUNTER_NUM-1:0] w_extern_dout_b;
wire [COUNTER_NUM-1:0] w_extern_dout_b_oen;

//configure register & status.
wire  [COUNTER_NUM*8-1:0] w_clk_ctrl;//
wire  [COUNTER_NUM-1:0]   w_enable;//

//interrupt.
wire  w_int;//

reg r_power_rstn;
reg r_apb_rstn;

wire [1:0] w_inner_clk;
wire [2:0] w_extern_clk;
wire [3:0] w_counter_douta;

reg clk_32m;
reg clk_32k;
reg clk_1m;
reg clk_5m;
reg clk_25m;
reg clk_200k;
reg clk_3m;

initial begin
r_power_rstn    <= 1'b0;
r_apb_rstn      <= 1'b0;
#50;
r_power_rstn    <= 1'b1;
#20;
r_apb_rstn      <= 1'b1;

end


initial begin
    clk_32m <= 1'b0;
    clk_32k <= 1'b1;
    clk_1m  <= 1'b1;
    clk_5m  <= 1'b0;
    clk_25m <= 1'b1;
    clk_200k <= 1'b1;
    clk_3m  <= 1'b0;
end

always #15.625      clk_32m     = ~clk_32m  ;
always #15625       clk_32k     = ~clk_32k  ;
always #500         clk_1m      = ~clk_1m   ;
always #100         clk_5m      = ~clk_5m   ;
always #20          clk_25m     = ~clk_25m  ;
always #2500        clk_200k    = ~clk_200k ;
always #166.7       clk_3m      = ~clk_3m   ;

assign w_pclk = clk_25m;
assign w_prst_n = r_apb_rstn;





counter_top_tb counter_top_tb(
        //counter clock domain.
        .i_clk      (w_clk    ),
        .i_rst_n    (w_rst_n  ),
        //apb bus register clock domain.
        .i_pclk     (w_pclk   ),
        .i_prst_n   (w_prst_n ),
        .o_paddr    (w_paddr  ),
        .o_pwdata   (w_pwdata ),
        .o_pwrite   (w_pwrite ),
        .o_psel     (w_psel   ),
        .o_penable  (w_penable),
        .i_prdata   (w_prdata ),
        //extern data & trigger
        .o_extern_din_a         (w_extern_din_a     ),
        .o_extern_din_b         (w_extern_din_b     ),
        .i_extern_dout_a        (w_extern_dout_a    ),
        .i_extern_dout_a_oen    (w_extern_dout_a_oen),
        .i_extern_dout_b        (w_extern_dout_b    ),
        .i_extern_dout_b_oen    (w_extern_dout_b_oen),
        //interrupt.
        .i_int                  (w_int)
);


counter_clkgen  counter_clkgen(
        .i_power_rstn       (r_power_rstn),
        .i_inner_clk        ({clk_32k,clk_32m}),
        .i_extern_clk       ({clk_200k,clk_1m,clk_3m}),
        .i_counter_douta    (w_extern_dout_a),
        //
        .i_clk_sel_c0       (w_clk_ctrl[3:0]),
        .i_clk_sel_c1       (w_clk_ctrl[11:8]),
        .i_clk_sel_c2       (w_clk_ctrl[19:16]),
        .i_clk_sel_c3       (w_clk_ctrl[27:24]),
        .i_clk_inv_en_c0    (w_clk_ctrl[4]),
        .i_clk_inv_en_c1    (w_clk_ctrl[12]),
        .i_clk_inv_en_c2    (w_clk_ctrl[20]),
        .i_clk_inv_en_c3    (w_clk_ctrl[28]),
        .i_clk_enable_c0    (w_clk_ctrl[5]),
        .i_clk_enable_c1    (w_clk_ctrl[13]),
        .i_clk_enable_c2    (w_clk_ctrl[21]),
        .i_clk_enable_c3    (w_clk_ctrl[29]),
        //
        .o_clk              (w_clk),
        .o_rstn             (w_rst_n)

);

counter_top counter_top(
        //counter clock domain.
        .i_clk          (w_clk    ),
        .i_rst_n        (w_rst_n  ),
        //apb bus register clock domain.
        .i_pclk         (w_pclk   ),
        .i_prst_n       (w_prst_n ),
        .i_paddr        (w_paddr  ),
        .i_pwdata       (w_pwdata ),
        .i_pwrite       (w_pwrite ),
        .i_psel         (w_psel   ),
        .i_penable      (w_penable),
        .o_prdata       (w_prdata ),
        //extern data & trigger
        .i_extern_din_a         (w_extern_din_a     ),
        .i_extern_din_b         (w_extern_din_b     ),
        .o_extern_dout_a        (w_extern_dout_a    ),
        .o_extern_dout_a_oen    (w_extern_dout_a_oen),
        .o_extern_dout_b        (w_extern_dout_b    ),
        .o_extern_dout_b_oen    (w_extern_dout_b_oen),
        //clock select ,enable, inv clock enable.
        .o_enable               (w_enable),
        .o_clk_ctrl             (w_clk_ctrl),
        .i_clk_ir_s             (w_clk),
        .i_rst_ir_n             (w_rst_n),
        //interrupt.
        .o_int                  (w_int)
);





`ifdef NC_SIM
initial begin
$shm_open("top.shm");
//$shm_probe(counter_top,"AC");
$shm_probe(counter_top_tb_top,"AC");
end
`endif

`ifdef VCS_SIM
initial begin
$vcdplusfile("top.vpd");
$vcdpluson(0,counter_top);
end
`endif

`ifdef VERI_SIM
initial begin
$fsdbDumpfile("top.fsdb");
$fsdbDumpvars(0,counter_top);
end
`endif







endmodule
