
`timescale 1ns / 1ps 


`define     BASE_ADDR               32'h44120000
`define     INTR_STATUS 	        `BASE_ADDR+32'h000
`define     INTR_MASK_STATUS 	    `BASE_ADDR+32'h004
`define     INTR_CLR 	            `BASE_ADDR+32'h008
`define     INTR_SET 	            `BASE_ADDR+32'h00C
`define     INTR_MASK_SET 	        `BASE_ADDR+32'h010
`define     INTR_MASK_CLR 	        `BASE_ADDR+32'h014
`define     INTR_SRESET 	        `BASE_ADDR+32'h018
`define     GLOBAL_START_TRIGGER 	`BASE_ADDR+32'h040
`define     GLOBAL_STOP_TRIGGER 	`BASE_ADDR+32'h044
`define     GLOBAL_CLEAR_TRIGGER 	`BASE_ADDR+32'h048
`define     GLOBAL_RESET_TRIGGER 	`BASE_ADDR+32'h04C
`define     SINGLE_START_TRIGGER_C0 	    `BASE_ADDR+32'h080
`define     SINGLE_STOP_TRIGGER_C0 	        `BASE_ADDR+32'h084
`define     SINGLE_CLEAR_TRIGGER_C0 	    `BASE_ADDR+32'h088
`define     SINGLE_RESET_TRIGGER_C0 	    `BASE_ADDR+32'h08C
`define     ENABLE_C0 	                    `BASE_ADDR+32'h090
`define     SOFT_TRIGGER_CTRL_C0 	        `BASE_ADDR+32'h094
`define     MUX_SEL_C0 	                    `BASE_ADDR+32'h098
`define     SRC_SEL_EDGE_C0 	            `BASE_ADDR+32'h09C
`define     SNAP_STATUS_C0 	                `BASE_ADDR+32'h0A0
`define     CTRL_SNAP_C0 	                `BASE_ADDR+32'h0A4
`define     SHADOW_REG_C0 	                `BASE_ADDR+32'h0A8
`define     MODE_SEL_C0 	                `BASE_ADDR+32'h0AC
`define     TARGET_REG_CTRL_C0 	            `BASE_ADDR+32'h0B0
`define     TARGET_REG_A0_C0 	            `BASE_ADDR+32'h0B4
`define     TARGET_REG_A1_C0 	            `BASE_ADDR+32'h0B8
`define     TARGET_REG_A2_C0 	            `BASE_ADDR+32'h0BC
`define     TARGET_REG_B0_C0 	            `BASE_ADDR+32'h0C0
`define     TARGET_REG_B1_C0 	            `BASE_ADDR+32'h0C4
`define     TARGET_REG_B2_C0 	            `BASE_ADDR+32'h0C8
`define     CAPTURE_REG_STATUS_C0 	        `BASE_ADDR+32'h0CC
`define     CAPTURE_REG_OVERFLOW_CTRL_C0 	`BASE_ADDR+32'h0D0
`define     CAPTURE_REG_A0_C0 	            `BASE_ADDR+32'h0D8
`define     CAPTURE_REG_A1_C0 	            `BASE_ADDR+32'h0DC
`define     CAPTURE_REG_A2_C0 	            `BASE_ADDR+32'h0E0
`define     CAPTURE_REG_B0_C0 	            `BASE_ADDR+32'h0E4
`define     CAPTURE_REG_B1_C0 	            `BASE_ADDR+32'h0E8
`define     CAPTURE_REG_B2_C0 	            `BASE_ADDR+32'h0EC
`define     SWITCH_MODE_ONEBIT_CNTS_C0 	    `BASE_ADDR+32'h0F0
`define     WAVEFORM_MODE_AUTOMATIC_C0 	    `BASE_ADDR+32'h0F4
`define     SHIFTMODE_CTRL_C0 	            `BASE_ADDR+32'h0F8
`define     SHIFTOUT_DATA_CTRL_BITCNTS_C0 	`BASE_ADDR+32'h0FC
`define     SHIFTOUT_DATA_C0 	            `BASE_ADDR+32'h100
`define     SHIFTOUT_DATA_VALID_C0 	        `BASE_ADDR+32'h104
`define     SHIFTIN_DATA_CTRL_BITCNTS_C0 	`BASE_ADDR+32'h108
`define     SHIFTIN_DATA_C0 	            `BASE_ADDR+32'h10C
`define     SHIFTIN_DATABITS_UPDATED_C0 	`BASE_ADDR+32'h110

`include "sim_define.v"

module counter_top_tb(
        //counter clock domain.
        i_clk,
        i_rst_n,
        //apb bus register clock domain.
        i_pclk,
        i_prst_n,
        o_paddr,
        o_pwdata,
        o_pwrite,
        o_psel,
        o_penable,
        i_prdata,
        //extern data & trigger
        o_extern_din_a,
        o_extern_din_b,
        i_extern_dout_a,
        i_extern_dout_a_oen,
        i_extern_dout_b,
        i_extern_dout_b_oen,
        //interrupt.
        i_int
);

parameter   COUNTER_NUM=4;
//localparam SEL_WIDTH=$clog2(COUNTER_NUM+4+4+2);

input  [COUNTER_NUM-1:0] i_clk;// counter clock domain.
input  [COUNTER_NUM-1:0] i_rst_n;
//apb bus register clock domain.
input       i_pclk;
input       i_prst_n;

output   [ 31 : 0 ] o_paddr;
output   [ 31 : 0 ] o_pwdata;
output              o_pwrite;
output              o_psel;
output              o_penable;
input   [ 31 : 0 ]  i_prdata;

//sync data & trigger
output  [COUNTER_NUM-1:0] o_extern_din_a;
output  [COUNTER_NUM-1:0] o_extern_din_b;

input [COUNTER_NUM-1:0] i_extern_dout_a;
input [COUNTER_NUM-1:0] i_extern_dout_a_oen;
input [COUNTER_NUM-1:0] i_extern_dout_b;
input [COUNTER_NUM-1:0] i_extern_dout_b_oen;

//interrupt.
input  i_int;//
//register
reg [ 31 : 0 ] o_paddr;
reg [ 31 : 0 ] o_pwdata;
reg            o_pwrite;
reg            o_psel;
reg            o_penable;

reg  [COUNTER_NUM-1:0] o_extern_din_a;
reg  [COUNTER_NUM-1:0] o_extern_din_b;
reg  apb_hand_on;
reg  apb_hand_on_0;

//assign o_extern_din_a = '0;
//assign o_extern_din_b = '0;

task apb_write;
input [31:0] w_addr;
input [31:0] w_data;
begin
    wait(!apb_hand_on);
    apb_hand_on ='1;
    @(posedge i_pclk);
    o_paddr   = w_addr;
    o_pwdata  = w_data;
    o_pwrite  = 1'b1;
    o_psel    = 1'b1;
    o_penable = 1'b0;
    @(posedge i_pclk);
    o_penable = 1'b1;
    @(posedge i_pclk);
    o_paddr   = '0;
    o_pwdata  = '0;
    o_psel    = 1'b0;
    o_penable = 1'b0;
    // apb_hand_on ='0;
    @(posedge i_pclk);
    apb_hand_on ='0;
    
end
endtask

task apb_read;
input  [31:0] r_addr;
output [31:0] r_data;
begin
    wait(!apb_hand_on);
    apb_hand_on ='1;
    @(posedge i_pclk);
    o_paddr   = r_addr;
    o_pwrite  = 1'b0;
    o_psel    = 1'b1;
    o_penable = 1'b0;
    @(posedge i_pclk);
    o_penable = 1'b1;
    @(posedge i_pclk);
    o_paddr   = '0;
    o_penable = 1'b0;
    r_data    = i_prdata;
    o_psel    = 1'b0;
    // apb_hand_on ='0;
    @(posedge i_pclk);
    apb_hand_on ='0;
        
end
endtask

task apb_write_read;
input  [31:0] addr;
input  [31:0] data_in;
output [31:0] data_out;
begin
    apb_write(addr,data_in);
    apb_read(addr,data_out);
end
endtask

reg stop_event;
reg [31:0] addr;
reg [31:0] data,data_1;
reg [7:0] i,j;
reg [31:0] tmp_i,tmp0,tmp1,tmp2,tmp3;
reg [31:0] count0,count1,count2,count3;
localparam  base_c0=32'h000,
            base_c1=32'h100,
            base_c2=32'h200,
            base_c3=32'h300;

reg [31:0] addr_base;
reg  int_flag_en;
reg [31:0] int_status,int_status0;
reg [31:0] base_addr_int;
reg [31:0] cap_count_a,cap_count_b;
reg [31:0] cap_count_a_c0,cap_count_b_c0;
reg [31:0] cap_count_a_c1,cap_count_b_c1;
reg [31:0] cap_count_a_c2,cap_count_b_c2;
reg [31:0] cap_count_a_c3,cap_count_b_c3;


initial begin
    apb_hand_on ='0;
    apb_hand_on_0 = 0;
    //
//   #2_000;
//   forever begin
//   // #2_000;
//   fork
//       //apb_read (`TARGET_REG_A0_C0,data);
//       //apb_write(`TARGET_REG_A0_C0,data|32'h2100);//c0,enable.//32k
//       //apb_read (`TARGET_REG_A0_C0,data);
//       apb_write(`TARGET_REG_A0_C0,$random);
//       apb_write(`TARGET_REG_A1_C0,$random);
//       apb_write(`TARGET_REG_A2_C0,$random);
//       //apb_write_read(`TARGET_REG_B0_C0,$random,data);
//       //apb_write_read(`TARGET_REG_B1_C0,$random,data);
//       //apb_write_read(`TARGET_REG_B2_C0,$random,data);
//   join
//   end
    //
end

//initial begin
//forever begin
//fork
//        //apb_write_read(`TARGET_REG_B0_C0,$random,data);
//        //apb_write_read(`TARGET_REG_B1_C0,$random,data);
//        //apb_write_read(`TARGET_REG_B2_C0,$random,data);
//        apb_write_read(`TARGET_REG_B0_C0,$random,data);
//        $display("one one one");
//        $display("two two two");
//join
//end
//end
//






initial begin
    o_paddr     <= '0;
    o_pwdata    <= '0;
    o_pwrite    <= '0;
    o_psel      <= '0;
    o_penable   <= '0;
    addr        <= '0;
    data        <= '0;
    i           <= '0;
    tmp_i       <= '0;
    stop_event  <= '0;
    addr_base   <= base_c0;
    int_flag_en <= '0;
    #2000;
    apb_write(32'h8,32'hff);
    apb_read(32'h8,data);
    apb_read (base_c0+`ENABLE_C0,data);
    #2000;
    // apb_read (base_c1+`ENABLE_C0,data);
    // apb_write(base_c1+`ENABLE_C0,data|32'h2000);//c1
    // apb_read (base_c2+`ENABLE_C0,data);
    // apb_write(base_c2+`ENABLE_C0,data|32'h2000);//c2
    // apb_read (base_c3+`ENABLE_C0,data);
    // apb_write(base_c3+`ENABLE_C0,data|32'h2000);//c3
    // apb_read (base_c3+`ENABLE_C0,data);
    // addr_base   = base_c0;

`ifdef   COUNTER_NUM
    if(`COUNTER_NUM==0)
    addr_base   = base_c0;
    else if(`COUNTER_NUM==1)
    addr_base   = base_c1;
    else if(`COUNTER_NUM==2)
    addr_base   = base_c2;
    else if(`COUNTER_NUM==3)
    addr_base   = base_c3;
    else 
    addr_base   = base_c0;
`else
    addr_base   = base_c0;
`endif

   //apb_read (addr_base+`ENABLE_C0,data);
   //// apb_write(addr_base+`ENABLE_C0,data|32'h2000);//c0,enable.,32m.
   //apb_write(addr_base+`ENABLE_C0,data|32'h2100);//c0,enable.//32k    
   apb_write_read(`INTR_MASK_CLR,32'hffffffff,data);

    
    //
   `ifdef	TESTCASE_C0_WAVEFORM_0
    `define CLK_32M
    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);
    apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b000001,data);
    apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h100,data);
    apb_write_read(addr_base+`TARGET_REG_A1_C0,32'h200,data);
    apb_write_read(addr_base+`TARGET_REG_A2_C0,32'h300,data);
    apb_write_read(addr_base+`TARGET_REG_B0_C0,32'h100,data);
    apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h200,data);
    apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h300,data);
    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
    //
    apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,32'b1,data);//start;
    #200_000;
    apb_write_read(addr_base+`SINGLE_STOP_TRIGGER_C0,32'b1,data);//stop;
    #20_000;
    apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    #20_000;
    apb_read(addr_base+`SINGLE_STOP_TRIGGER_C0,data);//stop;
    apb_write_read(addr_base+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
    #20_000;
    apb_write_read(addr_base+`SINGLE_CLEAR_TRIGGER_C0,32'h1,data);//clear;
    #20_000;
    apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    #20_000;
    apb_read(addr_base+`SINGLE_RESET_TRIGGER_C0,data);//start;
    apb_write_read(addr_base+`SINGLE_RESET_TRIGGER_C0,~data,data);//clear;
   `endif

   `ifdef	TESTCASE_C0_WAVEFORM_1
    `define CLK_32M

    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);
    apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b110110,data);
    apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h100,data);
    apb_write_read(addr_base+`TARGET_REG_A1_C0,32'h200,data);
    apb_write_read(addr_base+`TARGET_REG_A2_C0,32'h300,data);
    apb_write_read(addr_base+`TARGET_REG_B0_C0,32'h200,data);
    apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h300,data);
    apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h400,data);
    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
    //
    apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,32'b1,data);//start;
    
    int_flag_en = 1;
    #200_000;
    //apb_read(addr_base+`SINGLE_STOP_TRIGGER_C0,data);//stop;
    //apb_write_read(addr_base+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
    //#20_000;
    
   `endif
   
    `ifdef	TESTCASE_C0_WAVEFORM_2
     `define CLK_32M

    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);
    apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b010001,data);
    apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h100,data);
    apb_write_read(addr_base+`TARGET_REG_A1_C0,32'h200,data);
    apb_write_read(addr_base+`TARGET_REG_A2_C0,32'h300,data);
    apb_write_read(addr_base+`TARGET_REG_B0_C0,32'h0,data);
    // apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h20,data);
    // apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h3f,data);
    apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h1,data);
    apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h2,data);//  
    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
    //
    apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,32'b1,data);//start;
    #200_000;
    //apb_read(addr_base+`SINGLE_STOP_TRIGGER_C0,data);//stop;
    //apb_write_read(addr_base+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
    //#20_000;

   `endif

    `ifdef	TESTCASE_C0_WAVEFORM_3
     `define CLK_32M

    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);
    apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b010001,data);
    apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h1000,data);
    apb_write_read(addr_base+`TARGET_REG_A1_C0,32'h1800,data);
    apb_write_read(addr_base+`TARGET_REG_A2_C0,32'h2500,data);
    apb_write_read(addr_base+`TARGET_REG_B0_C0,32'h5000,data);
    // apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h20,data);
    // apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h3f,data);
    apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h10000,data);
    apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h15000,data);//  
    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
    //
    apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,32'b1,data);//start;
    #200_000;
    //apb_read(addr_base+`SINGLE_STOP_TRIGGER_C0,data);//stop;
    //apb_write_read(addr_base+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
    //#20_000;
	#5_000_000;
    //for(i=0;i<4;i++) begin
    //if(`COUNTER_NUM)
	force counter_top_tb_top.counter_top.u_counter_all.counter_loop[`COUNTER_NUM].u_counter.current_counter        = 32'b11111111111100000000000000000000;
	force counter_top_tb_top.counter_top.u_counter_all.counter_loop[`COUNTER_NUM].u_counter.last_current_counter_a = 33'b011111111111100000000000000000000;
	force counter_top_tb_top.counter_top.u_counter_all.counter_loop[`COUNTER_NUM].u_counter.last_current_counter_b = 33'b011111111111100000000000000000000;
	#2_000;
	release counter_top_tb_top.counter_top.u_counter_all.counter_loop[`COUNTER_NUM].u_counter.current_counter        ; 
    release counter_top_tb_top.counter_top.u_counter_all.counter_loop[`COUNTER_NUM].u_counter.last_current_counter_a ; 
    release counter_top_tb_top.counter_top.u_counter_all.counter_loop[`COUNTER_NUM].u_counter.last_current_counter_b ; 
    //end
    
   `endif   
 
    `ifdef	TESTCASE_C0_SW_COUNTMODE_0
     `define CLK_32M

    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(addr_base+`MODE_SEL_C0,32'b101,data);//count switch 
    apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b110001,data);
    apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h10,data);
    apb_write_read(addr_base+`TARGET_REG_A1_C0,32'h20,data);
    apb_write_read(addr_base+`TARGET_REG_A2_C0,32'h30,data);
    apb_write_read(addr_base+`TARGET_REG_B0_C0,32'h1,data);
    // apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h20,data);
    // apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h3f,data);
    apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h2,data);
    apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h3,data);//  
//
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h01220000,data);
    apb_write_read(addr_base+`SWITCH_MODE_ONEBIT_CNTS_C0,32'h1,data);//one bit represent how many cycle.
    apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h01010208,data);//enable switch to waveform and capture mode.
//        
    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
    //
    apb_read(addr_base+`CTRL_SNAP_C0,data);
    apb_write_read(addr_base+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
    apb_read(addr_base+`SNAP_STATUS_C0,data);
    while(!(|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);
    apb_read(addr_base+`CTRL_SNAP_C0,data);
    apb_write_read(addr_base+`CTRL_SNAP_C0,{~data[31:16],data[15:0]},data);//
    apb_read(addr_base+`SNAP_STATUS_C0,data);
    while((|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);  
//    
    apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,32'b1,data);//start;
    #2_000_000;
    apb_read(addr_base+`SINGLE_STOP_TRIGGER_C0,data);//stop;
    apb_write_read(addr_base+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
    #20_000;

   `endif 

    `ifdef	TESTCASE_C0_SW_COUNTMODE_1
     `define CLK_32M

    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(addr_base+`MODE_SEL_C0,32'b101,data);//count switch 
    apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b110001,data);
    apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h10,data);
    apb_write_read(addr_base+`TARGET_REG_A1_C0,32'h20,data);
    apb_write_read(addr_base+`TARGET_REG_A2_C0,32'h30,data);
    apb_write_read(addr_base+`TARGET_REG_B0_C0,32'h1,data);
    // apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h20,data);
    // apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h3f,data);
    apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h2,data);
    apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h3,data);//  
    apb_write_read(addr_base+`CAPTURE_REG_OVERFLOW_CTRL_C0,32'h3f,data);//overflow,control.
//
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h01220000,data);
    apb_write_read(addr_base+`SWITCH_MODE_ONEBIT_CNTS_C0,32'h10,data);//one bit represent how many cycle.
    // apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h01010808,data);//enable switch to waveform and capture mode.
    apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h01000808,data);//enable switch to waveform and capture mode.
//        
    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
    //
    apb_read(addr_base+`CTRL_SNAP_C0,data);
    apb_write_read(addr_base+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
    apb_read(addr_base+`SNAP_STATUS_C0,data);
    while(!(|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);
    apb_read(addr_base+`CTRL_SNAP_C0,data);
    apb_write_read(addr_base+`CTRL_SNAP_C0,{~data[31:16],data[15:0]},data);//
    apb_read(addr_base+`SNAP_STATUS_C0,data);
    while((|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);  
//    
    apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,32'b1,data);//start;
    #2_000_000;
    // apb_read(addr_base+`SINGLE_STOP_TRIGGER_C0,data);//stop;
    // apb_write_read(addr_base+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
    // #20_000;

   `endif 

    `ifdef	TESTCASE_C0_SW_COUNTMODE_2
     `define CLK_32M

    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(addr_base+`MODE_SEL_C0,32'b100,data);//count switch 
    apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b110001,data);
    apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h10,data);
    apb_write_read(addr_base+`TARGET_REG_A1_C0,32'h20,data);
    apb_write_read(addr_base+`TARGET_REG_A2_C0,32'h30,data);
    apb_write_read(addr_base+`TARGET_REG_B0_C0,32'h1,data);
    // apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h20,data);
    // apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h3f,data);
    apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h2,data);
    apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h3,data);//  
    apb_write_read(addr_base+`CAPTURE_REG_OVERFLOW_CTRL_C0,32'h3f,data);//overflow,control.
//
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h01220000,data);
    apb_write_read(addr_base+`SWITCH_MODE_ONEBIT_CNTS_C0,32'h10,data);//one bit represent how many cycle.
    apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h01010808,data);//enable switch to waveform and capture mode.
    // apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h00010808,data);//enable switch to waveform and capture mode.
//        
    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
    //
    apb_read(addr_base+`CTRL_SNAP_C0,data);
    apb_write_read(addr_base+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
    apb_read(addr_base+`SNAP_STATUS_C0,data);
    while(!(|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);
    apb_read(addr_base+`CTRL_SNAP_C0,data);
    apb_write_read(addr_base+`CTRL_SNAP_C0,{~data[31:16],data[15:0]},data);//
    apb_read(addr_base+`SNAP_STATUS_C0,data);
    while((|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);  
//    
    apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,32'b1,data);//start;
    int_flag_en = 1;
    #2_000_000;
    // apb_read(addr_base+`SINGLE_STOP_TRIGGER_C0,data);//stop;
    // apb_write_read(addr_base+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
    // #20_000;

   `endif    
   
   
    `ifdef	TESTCASE_C0_SW_SHIFTMODE_0

    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(addr_base+`MODE_SEL_C0,32'b111,data);//shift switch .
    //
    apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h7,data);
    // apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h3,data);
     // apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h1,data);
     // apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h0,data);
    //
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h12210000,data);

    //apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'd31,data);
      // apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'd15,data);
     apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h7,data);
     // apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h3,data);
     // apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h1,data);
     // apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h0,data);
    apb_write_read(addr_base+`SHIFTMODE_CTRL_C0,32'h1,data);
    
    apb_write_read(addr_base+`SHIFTOUT_DATA_C0,32'h55aa55aa,data);
 	apb_write(addr_base+`SHIFTOUT_DATA_VALID_C0,32'h0);    
    

//
    // apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h01220000,data);
    apb_write_read(addr_base+`SWITCH_MODE_ONEBIT_CNTS_C0,32'h1,data);//one bit represent how many cycle.
    // apb_write_read(addr_base+`SWITCH_MODE_ONEBIT_CNTS_C0,32'h2,data);//one bit represent how many cycle.
    apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h01010808,data);//enable switch to shiftin and shiftout mode.
        
    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
//
    apb_read(addr_base+`CTRL_SNAP_C0,data);
    apb_write_read(addr_base+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
    apb_read(addr_base+`SNAP_STATUS_C0,data);
    while(!(|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);
    apb_read(addr_base+`CTRL_SNAP_C0,data);
    apb_write_read(addr_base+`CTRL_SNAP_C0,{~data[31:16],data[15:0]},data);//
    apb_read(addr_base+`SNAP_STATUS_C0,data);
    while((|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);  
    //
    apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,32'b1,data);//start;
    #200_000;
    //apb_read(addr_base+`SINGLE_STOP_TRIGGER_C0,data);//stop;
    //apb_write_read(addr_base+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
    //#20_000;

   `endif    

    `ifdef	TESTCASE_C0_SW_SHIFTMODE_1

    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(addr_base+`MODE_SEL_C0,32'b111,data);//shift switch .
    //
    apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h7,data);
    // apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h3,data);
     // apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h1,data);
     // apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h0,data);
    //
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h12210000,data);

    //apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'd31,data);
      // apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'd15,data);
     apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h7,data);
     // apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h3,data);
     // apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h1,data);
     // apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h0,data);
    apb_write_read(addr_base+`SHIFTMODE_CTRL_C0,32'h1,data);
    
    apb_write_read(addr_base+`SHIFTOUT_DATA_C0,32'h55aa55aa,data);
 	apb_write(addr_base+`SHIFTOUT_DATA_VALID_C0,32'h0);    
    

//
    apb_write_read(addr_base+`SWITCH_MODE_ONEBIT_CNTS_C0,32'h1,data);//one bit represent how many cycle.
    // apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h01010208,data);//enable switch to shiftin and shiftout mode.
    // apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h01010108,data);//enable switch to shiftin and shiftout mode.
        apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h01000108,data);//enable switch to shiftin and shiftout mode.
    
    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
//
    apb_read(addr_base+`CTRL_SNAP_C0,data);
    apb_write_read(addr_base+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
    apb_read(addr_base+`SNAP_STATUS_C0,data);
    while(!(|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);
    apb_read(addr_base+`CTRL_SNAP_C0,data);
    apb_write_read(addr_base+`CTRL_SNAP_C0,{~data[31:16],data[15:0]},data);//
    apb_read(addr_base+`SNAP_STATUS_C0,data);
    while((|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);  
    //
    apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,32'b1,data);//start;
    #2000_000;
    apb_read(addr_base+`SINGLE_STOP_TRIGGER_C0,data);//stop;
    apb_write_read(addr_base+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
    #20_000;

   `endif       
   
    `ifdef	TESTCASE_C0_SW_SHIFTMODE_2

    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(addr_base+`MODE_SEL_C0,32'b110,data);//shift switch .
    //
    apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h7,data);
    //
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h12210000,data);
    apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h7,data);
    apb_write_read(addr_base+`SHIFTMODE_CTRL_C0,32'h1,data);
    
    apb_write_read(addr_base+`SHIFTOUT_DATA_C0,32'h55aa55aa,data);
 	apb_write(addr_base+`SHIFTOUT_DATA_VALID_C0,32'h0);    
    

//
    apb_write_read(addr_base+`SWITCH_MODE_ONEBIT_CNTS_C0,32'h1,data);//one bit represent how many cycle.
    apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h01010808,data);//enable switch to shiftin and shiftout mode.
    // apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h01010802,data);//enable switch to shiftin and shiftout mode.
    // apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h00010801,data);//enable switch to shiftin and shiftout mode.
    
    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
//
    apb_read(addr_base+`CTRL_SNAP_C0,data);
    apb_write_read(addr_base+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
    apb_read(addr_base+`SNAP_STATUS_C0,data);
    while(!(|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);
    apb_read(addr_base+`CTRL_SNAP_C0,data);
    apb_write_read(addr_base+`CTRL_SNAP_C0,{~data[31:16],data[15:0]},data);//
    apb_read(addr_base+`SNAP_STATUS_C0,data);
    while((|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);  
    //
    apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,32'b1,data);//start;
    int_flag_en = 1;
    tmp_i=32'h7;
    while(1) begin
    wait(i_int);
    tmp_i=32'h7;
    wait(!i_int);
    end
    #200_000;
    //apb_read(addr_base+`SINGLE_STOP_TRIGGER_C0,data);//stop;
    //apb_write_read(addr_base+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
    //#20_000;

   `endif
   
    `ifdef	TESTCASE_C0_CAPTURE_0
    `define CLK_32M
    `define CAPTURE_DATA_IN

        apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
        apb_write_read(addr_base+`MODE_SEL_C0,32'b000,data);
        apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h01220000,data);
        // apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h12210000,data);
    
    
        apb_read (addr_base+`ENABLE_C0,data);
        apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
        //
        //apb_write_read(addr_base+`CAPTURE_REG_OVERFLOW_CTRL_C0,32'h3f,data);//overflow,control.
        apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
        apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;
        #1000_000;
        apb_read(addr_base+`SINGLE_STOP_TRIGGER_C0,data);//stop;
        apb_write_read(addr_base+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
        #20_000;
        //#20_000;
        // tmp_i = 10;
    `endif
   
    `ifdef	TESTCASE_C0_CAPTURE_1
    `define CLK_32M
    `define CAPTURE_DATA_IN
    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(addr_base+`MODE_SEL_C0,32'b000,data);
    // apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h02110000,data);
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h22210000,data);
    // apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h12210000,data);

    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
    //
    //apb_write_read(addr_base+`CAPTURE_REG_OVERFLOW_CTRL_C0,32'h3f,data);//overflow,control.
    apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    int_flag_en <= '1;
    #200_000;
    //apb_read(addr_base+`SINGLE_STOP_TRIGGER_C0,data);//stop;
    //apb_write_read(addr_base+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
    //#20_000;
    // tmp_i = 10;
    
    //while(1) begin
    //  wait(i_int);
    //  apb_read(addr_base+`INTR_STATUS,data_1);
    //  if(|data_1[7:0]) begin
    //      apb_write_read(addr_base+`INTR_CLR,data_1,data);
    //      //CTRL_SNAP_C0
    //      //apb_read(addr_base+`CTRL_SNAP_C0,data);
    //      //apb_write_read(addr_base+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
    //      //repeat (2) @(posedge i_pclk);
    //      apb_read(addr_base+`CAPTURE_REG_STATUS_C0,data_1);
    //      if(&data_1[2:0]) begin
    //          apb_read(addr_base+`CAPTURE_REG_A0_C0,data);
    //          apb_read(addr_base+`CAPTURE_REG_A1_C0,data);
    //          apb_read(addr_base+`CAPTURE_REG_A2_C0,data); 
    //      end
    //      if(&data_1[5:3]) begin
    //          apb_read(addr_base+`CAPTURE_REG_B0_C0,data);
    //          apb_read(addr_base+`CAPTURE_REG_B1_C0,data);
    //          apb_read(addr_base+`CAPTURE_REG_B2_C0,data);
    //      end
    //  end
    //end
    
   `endif

   `ifdef	TESTCASE_C0_CAPTURE_2
    `define CLK_32M
    `define CAPTURE_DATA_IN
    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(addr_base+`MODE_SEL_C0,32'b000,data);
    //apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b110110,data);
    //apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h02110000,data);
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h12210000,data);


    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
    //
    apb_write_read(addr_base+`CAPTURE_REG_OVERFLOW_CTRL_C0,32'h3f,data);//overflow,control.
    apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    #200_000;
    //apb_read(addr_base+`SINGLE_STOP_TRIGGER_C0,data);//stop;
    //apb_write_read(addr_base+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
    //#20_000;
    //#20_000;
    tmp_i = 10;
    int_flag_en = 1;
    while(tmp_i--) begin
        wait(i_int);
        wait(!i_int);
    end
    int_flag_en = 0;
    //while(tmp_i--) begin
    //  wait(i_int);
    //  apb_read(addr_base+`INTR_STATUS,data_1);
    //  if(|data_1[7:0]) begin
    //      apb_write_read(addr_base+`INTR_CLR,data_1,data);
    //      //CTRL_SNAP_C0
    //      apb_read(addr_base+`CTRL_SNAP_C0,data);
    //      apb_write_read(addr_base+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
    //      apb_read(addr_base+`SNAP_STATUS_C0,data);
    //      if(|data) begin
    //        $display("new capture register comes");
    //      end 
    //      else begin
    //        while(!(|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);
    //        $display("new capture register don't come,please wait and read");
    //      end
    //      apb_read(addr_base+`CTRL_SNAP_C0,data);
    //      apb_write_read(addr_base+`CTRL_SNAP_C0,{~data[31:16],data[15:0]},data);//
    //      apb_read(addr_base+`SNAP_STATUS_C0,data);
    //      while((|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);
    //      $display("capture register status clear");
    //      //
    //      repeat (2) @(posedge i_pclk);
    //      apb_read(addr_base+`CAPTURE_REG_STATUS_C0,data_1);
    //      if(&data_1[2:0]) begin
    //          apb_read(addr_base+`CAPTURE_REG_A0_C0,data);
    //          apb_read(addr_base+`CAPTURE_REG_A1_C0,data);
    //          apb_read(addr_base+`CAPTURE_REG_A2_C0,data); 
    //      end
    //      if(&data_1[5:3]) begin
    //          apb_read(addr_base+`CAPTURE_REG_B0_C0,data);
    //          apb_read(addr_base+`CAPTURE_REG_B1_C0,data);
    //          apb_read(addr_base+`CAPTURE_REG_B2_C0,data);
    //      end
    //  end
    //end
        apb_read(addr_base+`CAPTURE_REG_OVERFLOW_CTRL_C0,data);//overflow,control.
        apb_write_read(addr_base+`CAPTURE_REG_OVERFLOW_CTRL_C0,{data[30:0],1'b0},data);//overflow,control.
        #500_000;
    repeat (6) begin
        apb_read(addr_base+`CAPTURE_REG_OVERFLOW_CTRL_C0,data);//overflow,control.
        apb_write_read(addr_base+`CAPTURE_REG_OVERFLOW_CTRL_C0,{data[30:0],1'h1},data);//overflow,control.
        #500_000;
    
    end
    
   `endif
   
   `ifdef TESTCASE_C0_SHIFTIN_0
   `define SHIFT_DATA_IN
    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(addr_base+`MODE_SEL_C0,32'b010,data);//shift in mode.
    apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'd31,data);
    // apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'd15,data);
    // apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h7,data);
    // apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h3,data);
     // apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h1,data);
     // apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h0,data);


    //
    //apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b110110,data);
    //apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h02110000,data);
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h12210000,data);
    //
    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
    //
    apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    #1000_000;
    apb_read(addr_base+`SINGLE_STOP_TRIGGER_C0,data);//stop;
    apb_write_read(addr_base+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
    #100_000;    
    //
    apb_write_read(addr_base+`SINGLE_CLEAR_TRIGGER_C0,32'h1,data);//clear;
    #300_000;
    apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    #100_000;
    apb_read(addr_base+`SINGLE_RESET_TRIGGER_C0,data);//start;
    apb_write_read(addr_base+`SINGLE_RESET_TRIGGER_C0,~data,data);//clear; 
    //
    #500_000;
   `endif
   
    `ifdef TESTCASE_C0_SHIFTIN_1
    `define SHIFT_DATA_IN
    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(addr_base+`MODE_SEL_C0,32'b010,data);//shift in mode.
    // apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'd31,data);
    // apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'd15,data);
    apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h7,data);
    // apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h3,data);
     // apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h1,data);
     // apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h0,data);
    //
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h12210000,data);
    //
    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
    //
    apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    //#100_000;
    int_flag_en = 1;
    #200_000;
    //while(1) begin
    //  wait(i_int);
    //  apb_read(addr_base+`INTR_STATUS,data_1);
    //  if(|data_1[7:0]) begin
    //      data_1 = data_1>>8*0;
    //      apb_write_read(addr_base+`INTR_CLR,data_1,data);
    //      ////CTRL_SNAP_C0
    //      //apb_read(addr_base+`CTRL_SNAP_C0,data);
    //      //apb_write_read(addr_base+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
    //      //repeat (2) @(posedge i_pclk);
    //      if(data_1[3]) begin
    //          apb_read(addr_base+`SHIFTIN_DATA_C0,data);
    //          apb_read(addr_base+`SHIFTIN_DATABITS_UPDATED_C0,data_1);
    //          $display("new shiftin data = %h",data&data_1);
    //      end
    //      else begin
    //          $display("int number is wrong");            
    //      end
    //  end
    //end
    //
   `endif  

    `ifdef TESTCASE_C0_SHIFTIN_2
    `define SHIFT_DATA_IN
    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(addr_base+`MODE_SEL_C0,32'b010,data);//shift in mode.
    // apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'd31,data);
    // apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'd15,data);
    apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h7,data);
    // apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h3,data);
     // apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h1,data);
     // apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h0,data);
    apb_write_read(addr_base+`SHIFTMODE_CTRL_C0,32'h1,data);
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h12210000,data);
    //
    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
    //
    apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    //#100_000;
    int_flag_en = 1;
    //while(1) begin
    //  wait(i_int);
    //  apb_read(addr_base+`INTR_STATUS,data_1);
    //  if(|data_1[7:0]) begin
    //      data_1 = data_1>>8*0;
    //      apb_write_read(addr_base+`INTR_CLR,data_1,data);
    //      //CTRL_SNAP_C0
    //      apb_read(addr_base+`CTRL_SNAP_C0,data);
    //      apb_write_read(addr_base+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
    //      repeat (2) @(posedge i_pclk);
    //      // apb_read(addr_base+`CAPTURE_REG_STATUS_C0,data_1);
    //      if(data_1[3]) begin
    //          apb_read(addr_base+`SHIFTIN_DATA_C0,data);
    //          apb_read(addr_base+`SHIFTIN_DATABITS_UPDATED_C0,data_1);
    //          $display("new shiftin data = %h",data&data_1);
    //      end
    //      else begin
    //          $display("int number is wrong");            
    //      end
    //  end
    //end
    //
   `endif  
   
   `ifdef TESTCASE_C0_SHIFTOUT_0
    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(addr_base+`MODE_SEL_C0,32'b011,data);//shift out mode.
    apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'd31,data);
    //  apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'd15,data);
    //  apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h7,data);
    //  apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h3,data);
     // apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h1,data);
     // apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h0,data);
    apb_write_read(addr_base+`SHIFTOUT_DATA_C0,32'h55aa55aa,data);
 	apb_write(addr_base+`SHIFTOUT_DATA_VALID_C0,32'h0);
    //
    //apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b110110,data);
    //apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h02110000,data);
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h12210000,data);
    //
    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
    //
          //CTRL_SNAP_C0
    apb_read(addr_base+`CTRL_SNAP_C0,data);
    apb_write_read(addr_base+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
    apb_read(addr_base+`SNAP_STATUS_C0,data);
    while(!(|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);
    apb_read(addr_base+`CTRL_SNAP_C0,data);
    apb_write_read(addr_base+`CTRL_SNAP_C0,{~data[31:16],data[15:0]},data);//
    apb_read(addr_base+`SNAP_STATUS_C0,data);
    while((|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);
    //$display("capture register status clear");
    
    //
    apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    #1000_000;
    apb_read(addr_base+`SINGLE_STOP_TRIGGER_C0,data);//stop;
    apb_write_read(addr_base+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
    #100_000;    
    //
    apb_write_read(addr_base+`SINGLE_CLEAR_TRIGGER_C0,32'h1,data);//clear;
    #300_000;
    apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    #100_000;
    apb_read(addr_base+`SINGLE_RESET_TRIGGER_C0,data);//reset;
    apb_write_read(addr_base+`SINGLE_RESET_TRIGGER_C0,~data,data);//; 
    #300_000;
    apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    //
    #500_000;
   `endif   
   
   `ifdef TESTCASE_C0_SHIFTOUT_1
    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(addr_base+`MODE_SEL_C0,32'b011,data);//shift out mode.
    //apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'd31,data);
      apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'd15,data);
     // apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h7,data);
     // apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h3,data);
     // apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h1,data);
     // apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h0,data);
    apb_write_read(addr_base+`SHIFTMODE_CTRL_C0,32'h1,data);
    
    apb_write_read(addr_base+`SHIFTOUT_DATA_C0,32'h55aa55aa,data);
 	apb_write(addr_base+`SHIFTOUT_DATA_VALID_C0,32'h0);
    //
    //apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b110110,data);
    //apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h02110000,data);
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h12210000,data);
    //
    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
    //
    //CTRL_SNAP_C0
    apb_read(addr_base+`CTRL_SNAP_C0,data);
    apb_write_read(addr_base+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
    apb_read(addr_base+`SNAP_STATUS_C0,data);
    while(!(|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);
    apb_read(addr_base+`CTRL_SNAP_C0,data);
    apb_write_read(addr_base+`CTRL_SNAP_C0,{~data[31:16],data[15:0]},data);//
    apb_read(addr_base+`SNAP_STATUS_C0,data);
    while((|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);
    //$display("capture register status clear");
    //
    apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    //
    apb_write_read(addr_base+`SHIFTOUT_DATA_C0,32'h00ff00ff,data);
 	apb_write(addr_base+`SHIFTOUT_DATA_VALID_C0,32'h0);
    tmp_i=32'd31;
    int_flag_en = 1;
    //while(1) begin
    //  wait(i_int);
    //  apb_read(addr_base+`INTR_STATUS,data_1);
    //  if(|data_1[7:0]) begin
    //      data_1 = data_1>>8*0;
    //      apb_write_read(addr_base+`INTR_CLR,data_1,data);
    //      // CTRL_SNAP_C0
    //      // apb_read(addr_base+`CTRL_SNAP_C0,data);
    //      // apb_write_read(addr_base+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
    //      repeat (2) @(posedge i_pclk);
    //      if(data_1[4]) begin
    //          data=$random;
    //          apb_write_read(addr_base+`SHIFTOUT_DATA_C0,data,data);
    //          apb_write(addr_base+`SHIFTOUT_DATA_VALID_C0,32'h0);
    //          $display("new shiftout data = %h",data);
    //      end
    //      else begin
    //          $display("int number is wrong,shiftout mode");            
    //      end
    //  end
    //end
    
    //
    // #500_000;
   `endif      
   
    `ifdef TESTCASE_C0_SHIFTOUT_2
    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(addr_base+`MODE_SEL_C0,32'b011,data);//shift out mode.
    apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'd31,data);
      // apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'd15,data);
     // apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h7,data);
     // apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h3,data);
     // apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h1,data);
     // apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h0,data);
    // apb_write_read(addr_base+`SHIFTMODE_CTRL_C0,32'h1,data);
    
    apb_write_read(addr_base+`SHIFTOUT_DATA_C0,32'h55aa55aa,data);
 	apb_write(addr_base+`SHIFTOUT_DATA_VALID_C0,32'h0);
    //
    //apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b110110,data);
    //apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h02110000,data);
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h12210000,data);
    //
    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
    //
    //CTRL_SNAP_C0
    apb_read(addr_base+`CTRL_SNAP_C0,data);
    apb_write_read(addr_base+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
    apb_read(addr_base+`SNAP_STATUS_C0,data);
    while(!(|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);
    apb_read(addr_base+`CTRL_SNAP_C0,data);
    apb_write_read(addr_base+`CTRL_SNAP_C0,{~data[31:16],data[15:0]},data);//
    apb_read(addr_base+`SNAP_STATUS_C0,data);
    while((|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);
    //$display("capture register status clear");
    //
    apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    //
    apb_write_read(addr_base+`SHIFTOUT_DATA_C0,32'h00ff00ff,data);
 	apb_write(addr_base+`SHIFTOUT_DATA_VALID_C0,32'h0);
    tmp_i=32'd30;
    int_flag_en = 1;
    while(1) begin
     wait(i_int);
    tmp_i--; 
    wait(!i_int);
    end
    //while(1) begin
    //  wait(i_int);
    //  apb_read(addr_base+`INTR_STATUS,data_1);
    //  if(|data_1[7:0]) begin
    //      data_1 = data_1>>8*0;
    //      apb_write_read(addr_base+`INTR_CLR,data_1,data);
    //      // CTRL_SNAP_C0
    //      // apb_read(addr_base+`CTRL_SNAP_C0,data);
    //      // apb_write_read(addr_base+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
    //      repeat (2) @(posedge i_pclk);
    //      if(data_1[4]) begin
    //          data_1=$random;
    //          apb_write_read(addr_base+`SHIFTOUT_DATA_C0,data_1,data);
    //          apb_write(addr_base+`SHIFTOUT_DATA_VALID_C0,32'h0);
    //          apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,tmp_i--,data);
    //          $display("new shiftout data = %h,bits=%d",data_1,tmp_i[4:0]);
    //      end
    //      else begin
    //          $display("int number is wrong,shiftout mode");            
    //      end
    //  end
    //end
    `endif
   
    //
    
    stop_event  <= '1;
    #500_000;
    //$stop;

end

`ifdef  TESTCASE_ALL_SHIFTMODE_0
`define CAPTURE_DATA_CASECADE

initial begin
wait (stop_event) ;
for(i=0;i<4;i++) begin
    addr_base=base_c1*i;
    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    if(i==0)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b011,data);//shift out .
    else if(i==1)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b010,data);//shift in .    
    else if(i==2)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b011,data);//shift out.
    else if(i==3)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b010,data);//shift in .
    
    //
    apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'd31,data);
    //
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h12210000,data);
    apb_write_read(addr_base+`SHIFTMODE_CTRL_C0,32'h0,data);
    
    apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'd31,data);
    //apb_write_read(addr_base+`SHIFTOUT_DATA_C0,32'h55aa55aa,data);
    apb_write_read(addr_base+`SHIFTOUT_DATA_C0,32'hffffffff,data);
 	apb_write(addr_base+`SHIFTOUT_DATA_VALID_C0,32'h0);    
    if(i==0||i==2)
    // $display("new shiftout data = %h,bits=%d,counter num=%d",count_reverse(data,5'd31),5'd31,i);
    $display("new shiftout data = %h,src data = %h , bits=%d,counter num =%d",count_reverse(data,5'd31),data,5'd31,i);

//
    apb_write_read(addr_base+`SWITCH_MODE_ONEBIT_CNTS_C0,32'h1,data);//one bit represent how many cycle.
    //apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h01010808,data);//enable switch to shiftin and shiftout mode.
    // apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h01010802,data);//enable switch to shiftin and shiftout mode.
    // apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h00010801,data);//enable switch to shiftin and shiftout mode.
    
    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
//
  
end    
    //
    apb_read(`GLOBAL_START_TRIGGER,data);//start;
    apb_write_read(`GLOBAL_START_TRIGGER,~data,data);//start;
    //i=0;

        addr_base=base_c1*0;
        apb_read(addr_base+`CTRL_SNAP_C0,data);
        apb_write_read(addr_base+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
        apb_read(addr_base+`SNAP_STATUS_C0,data);
        while(!(|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);
        apb_read(addr_base+`CTRL_SNAP_C0,data);
        apb_write_read(addr_base+`CTRL_SNAP_C0,{~data[31:16],data[15:0]},data);//
        apb_read(addr_base+`SNAP_STATUS_C0,data);
        while((|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);  
        //
    for(i=0;i<4;i++) begin
        // $display("new shiftout counter num=%d",i);
        if(i==0||i==2) begin
            addr_base=base_c1*i;
            apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'd30,data);
            //apb_write_read(addr_base+`SHIFTOUT_DATA_C0,32'hff0000ff,data);
            apb_write_read(addr_base+`SHIFTOUT_DATA_C0,32'hffffffff,data);
            apb_write(addr_base+`SHIFTOUT_DATA_VALID_C0,32'h0);  
            
            //$display("new shiftout data = %h,bits=%d,counter num=%d",count_reverse(data,5'd30),5'd30,i);
            $display("new shiftout data = %h,src data = %h , bits=%d,counter num =%d",count_reverse(data,5'd30),data,5'd30,i);
        end
    end    
    int_flag_en = 1;
    while(1) begin
    wait(i_int);
    tmp_i=32'h1f;
    wait(!i_int);
    end
    #200_000;
    //apb_read(`GLOBAL_STOP_TRIGGER,data);//stop;
    //apb_write_read(`GLOBAL_STOP_TRIGGER,~data,data);//stop;
    //#20_000;


end
`endif

`ifdef  TESTCASE_ALL_SHIFTMODE_1
`define CAPTURE_DATA_CASECADE

initial begin
wait (stop_event) ;
for(i=0;i<4;i++) begin
    addr_base=base_c1*i;
    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    if(i==0)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b010,data);//shift in .
    else if(i==1)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b011,data);//shift out .    
    else if(i==2)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b010,data);//shift in.
    else if(i==3)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b011,data);//shift out .
    
    //
    apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'd31,data);
    //
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h12210000,data);
    apb_write_read(addr_base+`SHIFTMODE_CTRL_C0,32'h0,data);
    
    apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'd31,data);
    //apb_write_read(addr_base+`SHIFTOUT_DATA_C0,32'h55aa55aa,data);
    apb_write_read(addr_base+`SHIFTOUT_DATA_C0,32'hffffffff,data);
 	apb_write(addr_base+`SHIFTOUT_DATA_VALID_C0,32'h0);    
    if(i==1||i==3)
    // $display("new shiftout data = %h,bits=%d,counter num=%d",count_reverse(data,5'd31),5'd31,i);
    $display("new shiftout data = %h,src data = %h , bits=%d,counter num =%d",count_reverse(data,5'd31),data,5'd31,i);

//
    apb_write_read(addr_base+`SWITCH_MODE_ONEBIT_CNTS_C0,32'h1,data);//one bit represent how many cycle.
    //apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h01010808,data);//enable switch to shiftin and shiftout mode.
    // apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h01010802,data);//enable switch to shiftin and shiftout mode.
    // apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h00010801,data);//enable switch to shiftin and shiftout mode.
    
    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
//
  
end    
    //
    apb_read(`GLOBAL_START_TRIGGER,data);//start;
    apb_write_read(`GLOBAL_START_TRIGGER,~data,data);//start;
    //i=0;

        addr_base=base_c1*0;
        apb_read(addr_base+`CTRL_SNAP_C0,data);
        apb_write_read(addr_base+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
        apb_read(addr_base+`SNAP_STATUS_C0,data);
        while(!(|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);
        apb_read(addr_base+`CTRL_SNAP_C0,data);
        apb_write_read(addr_base+`CTRL_SNAP_C0,{~data[31:16],data[15:0]},data);//
        apb_read(addr_base+`SNAP_STATUS_C0,data);
        while((|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);  
        //
    for(i=0;i<4;i++) begin
        // $display("new shiftout counter num=%d",i);
        if(i==1||i==3) begin
            addr_base=base_c1*i;
            apb_write_read(addr_base+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'd30,data);
            //apb_write_read(addr_base+`SHIFTOUT_DATA_C0,32'hff0000ff,data);
            apb_write_read(addr_base+`SHIFTOUT_DATA_C0,32'hffffffff,data);
            apb_write(addr_base+`SHIFTOUT_DATA_VALID_C0,32'h0);  
            
            //$display("new shiftout data = %h,bits=%d,counter num=%d",count_reverse(data,5'd30),5'd30,i);
            $display("new shiftout data = %h,src data = %h , bits=%d,counter num =%d",count_reverse(data,5'd30),data,5'd30,i);
        end
    end    
    int_flag_en = 1;
    count0=16;
    while(count0--) begin
    wait(i_int);
    tmp_i=32'h1f;
    //
    wait(!i_int);
    end
    #20_000;
    apb_read(`GLOBAL_STOP_TRIGGER,data);//stop;
    apb_write_read(`GLOBAL_STOP_TRIGGER,~data,data);//stop;
    #20_000;
    //apb_read(`GLOBAL_STOP_TRIGGER,data);//stop;
    //apb_write_read(`GLOBAL_STOP_TRIGGER,~data,data);//stop;
    //#100_000;    
    //
    apb_read(`GLOBAL_CLEAR_TRIGGER,data);//
    apb_write_read(`GLOBAL_CLEAR_TRIGGER,~data,data);//clear;
    #300_000;
    apb_read(`GLOBAL_START_TRIGGER,data);//
    apb_write_read(`GLOBAL_START_TRIGGER,~data,data);//start;
    #100_000;
    apb_read(`GLOBAL_RESET_TRIGGER,data);//
    apb_write_read(`GLOBAL_RESET_TRIGGER,~data,data);//reset; 
    #300_000;
    apb_read(`GLOBAL_START_TRIGGER,data);//start;
    apb_write_read(`GLOBAL_START_TRIGGER,~data,data);//start;

end
`endif

`ifdef  TESTCASE_ALL_COUNTERMODE_0
`define CAPTURE_DATA_CASECADE
//`define CLK_32M
initial begin
wait (stop_event) ;
for(i=0;i<4;i++) begin
    addr_base=base_c1*i;
    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    if(i==0)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b000,data);//count in .
    else if(i==1)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);//count out .    
    else if(i==2)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b000,data);//count in.
    else if(i==3)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);//count out .
    
    //
    apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'd31,data);
    //
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h12210000,data);
    if(i==1) begin
    apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b000100,data);
    apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h10,data);
    apb_write_read(addr_base+`TARGET_REG_A1_C0,32'h20,data);
    apb_write_read(addr_base+`TARGET_REG_A2_C0,32'h30,data);
    apb_write_read(addr_base+`TARGET_REG_B0_C0,32'h10,data);
    apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h20,data);
    apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h30,data);
    // $display("new shiftout data = %h,src data = %h , bits=%d,counter num =%d",count_reverse(data,5'd31),data,5'd31,i);
    end
    if(i==3) begin
    apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b000001,data);
    apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h5,data);
    apb_write_read(addr_base+`TARGET_REG_A1_C0,32'h15,data);
    apb_write_read(addr_base+`TARGET_REG_A2_C0,32'h25,data);
    apb_write_read(addr_base+`TARGET_REG_B0_C0,32'h10,data);
    apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h27,data);
    apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h51,data);
    // $display("new shiftout data = %h,src data = %h , bits=%d,counter num =%d",count_reverse(data,5'd31),data,5'd31,i);
    end
    //if(i==1||i==3)
    // $display("new shiftout data = %h,bits=%d,counter num=%d",count_reverse(data,5'd31),5'd31,i);
    if(i==0||i==2) begin
        apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h22210000,data);
        apb_write_read(addr_base+`CAPTURE_REG_OVERFLOW_CTRL_C0,32'h3f,data);//overflow,control.
    end
//
    apb_write_read(addr_base+`SWITCH_MODE_ONEBIT_CNTS_C0,32'h1,data);//one bit represent how many cycle.
    //apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h01010808,data);//enable switch to shiftin and shiftout mode.
    // apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h01010802,data);//enable switch to shiftin and shiftout mode.
    // apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h00010801,data);//enable switch to shiftin and shiftout mode.
    
    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
//
  
end    
    //
    apb_read(`GLOBAL_START_TRIGGER,data);//start;
    apb_write_read(`GLOBAL_START_TRIGGER,~data,data);//start;
    //i=0;

        addr_base=base_c1*0;
        apb_read(addr_base+`CTRL_SNAP_C0,data);
        apb_write_read(addr_base+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
        apb_read(addr_base+`SNAP_STATUS_C0,data);
        while(!(|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);
        apb_read(addr_base+`CTRL_SNAP_C0,data);
        apb_write_read(addr_base+`CTRL_SNAP_C0,{~data[31:16],data[15:0]},data);//
        apb_read(addr_base+`SNAP_STATUS_C0,data);
        while((|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);  
        //
   
    int_flag_en = 1;
    //count0=16;
    while(1) begin
    wait(i_int);
    tmp_i=32'h1f;
    //
    wait(!i_int);
    end
    #20_000;
    //apb_read(`GLOBAL_STOP_TRIGGER,data);//stop;
    //apb_write_read(`GLOBAL_STOP_TRIGGER,~data,data);//stop;
    //#20_000;  
    //apb_read(`GLOBAL_CLEAR_TRIGGER,data);//
    //apb_write_read(`GLOBAL_CLEAR_TRIGGER,~data,data);//clear;
    //#300_000;
    //apb_read(`GLOBAL_START_TRIGGER,data);//
    //apb_write_read(`GLOBAL_START_TRIGGER,~data,data);//start;
    //#100_000;
    //apb_read(`GLOBAL_RESET_TRIGGER,data);//
    //apb_write_read(`GLOBAL_RESET_TRIGGER,~data,data);//reset; 
    //#300_000;
    //apb_read(`GLOBAL_START_TRIGGER,data);//
    //apb_write_read(`GLOBAL_START_TRIGGER,~data,data);//start;

end
`endif

`ifdef  TESTCASE_ALL_COUNTERMODE_1
`define CAPTURE_DATA_CASECADE
//`define CLK_32M
initial begin
wait (stop_event) ;
for(i=0;i<4;i++) begin
    addr_base=base_c1*i;
    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    if(i==1)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b000,data);//count in .
    else if(i==2)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);//count out .    
    else if(i==3)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b000,data);//count in.
    else if(i==0)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);//count out .
    
    //
    apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'd31,data);
    //
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h12210000,data);
    if(i==0) begin
    apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b000100,data);
    apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h10,data);
    apb_write_read(addr_base+`TARGET_REG_A1_C0,32'h20,data);
    apb_write_read(addr_base+`TARGET_REG_A2_C0,32'h30,data);
    apb_write_read(addr_base+`TARGET_REG_B0_C0,32'h10,data);
    apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h20,data);
    apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h30,data);
    // $display("new shiftout data = %h,src data = %h , bits=%d,counter num =%d",count_reverse(data,5'd31),data,5'd31,i);
    end
    if(i==2) begin
    apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b000001,data);
    apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h5,data);
    apb_write_read(addr_base+`TARGET_REG_A1_C0,32'h15,data);
    apb_write_read(addr_base+`TARGET_REG_A2_C0,32'h25,data);
    apb_write_read(addr_base+`TARGET_REG_B0_C0,32'h10,data);
    apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h27,data);
    apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h51,data);
    // $display("new shiftout data = %h,src data = %h , bits=%d,counter num =%d",count_reverse(data,5'd31),data,5'd31,i);
    end
    //if(i==1||i==3)
    // $display("new shiftout data = %h,bits=%d,counter num=%d",count_reverse(data,5'd31),5'd31,i);
    if(i==1||i==3) begin
        apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h22210000,data);
        apb_write_read(addr_base+`CAPTURE_REG_OVERFLOW_CTRL_C0,32'h3f,data);//overflow,control.
    end
//
    apb_write_read(addr_base+`SWITCH_MODE_ONEBIT_CNTS_C0,32'h1,data);//one bit represent how many cycle.
    //apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h01010808,data);//enable switch to shiftin and shiftout mode.
    // apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h01010802,data);//enable switch to shiftin and shiftout mode.
    // apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h00010801,data);//enable switch to shiftin and shiftout mode.
    
    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
//
  
end    
    //
    apb_read(`GLOBAL_START_TRIGGER,data);//start;
    apb_write_read(`GLOBAL_START_TRIGGER,~data,data);//start;
    //i=0;

        addr_base=base_c1*0;
        apb_read(addr_base+`CTRL_SNAP_C0,data);
        apb_write_read(addr_base+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
        apb_read(addr_base+`SNAP_STATUS_C0,data);
        while(!(|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);
        apb_read(addr_base+`CTRL_SNAP_C0,data);
        apb_write_read(addr_base+`CTRL_SNAP_C0,{~data[31:16],data[15:0]},data);//
        apb_read(addr_base+`SNAP_STATUS_C0,data);
        while((|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);  
        //
   
    int_flag_en = 1;
    count0=16;
    while(count0--) begin
    wait(i_int);
    tmp_i=32'h1f;
    //
    wait(!i_int);
    end
    #20_000;
    apb_read(`GLOBAL_STOP_TRIGGER,data);//stop;
    apb_write_read(`GLOBAL_STOP_TRIGGER,~data,data);//stop;
    #20_000;  
    apb_read(`GLOBAL_CLEAR_TRIGGER,data);//
    apb_write_read(`GLOBAL_CLEAR_TRIGGER,~data,data);//clear;
    #300_000;
    apb_read(`GLOBAL_START_TRIGGER,data);//
    apb_write_read(`GLOBAL_START_TRIGGER,~data,data);//start;
    #100_000;
    apb_read(`GLOBAL_RESET_TRIGGER,data);//
    apb_write_read(`GLOBAL_RESET_TRIGGER,~data,data);//reset; 
    #300_000;
    apb_read(`GLOBAL_START_TRIGGER,data);//
    apb_write_read(`GLOBAL_START_TRIGGER,~data,data);//start;

end
`endif

`ifdef  TESTCASE_ALL_COUNTERMODE_2
//`define CLK_32M
//inner channel casecade
initial begin
wait (stop_event) ;
for(i=0;i<4;i++) begin
    addr_base=base_c1*i;
    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    if(i==0)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b000,data);//count in .
    else if(i==1)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);//count out .    
    else if(i==2)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b000,data);//count in.
    else if(i==3)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);//count out .
    
    //
    apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'd31,data);
    //
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h12210000,data);
    if(i==1) begin
    apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b000100,data);
    apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h10,data);
    apb_write_read(addr_base+`TARGET_REG_A1_C0,32'h20,data);
    apb_write_read(addr_base+`TARGET_REG_A2_C0,32'h30,data);
    apb_write_read(addr_base+`TARGET_REG_B0_C0,32'h10,data);
    apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h20,data);
    apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h30,data);
    // $display("new shiftout data = %h,src data = %h , bits=%d,counter num =%d",count_reverse(data,5'd31),data,5'd31,i);
    end
    if(i==3) begin
    apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b000001,data);
    apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h5,data);
    apb_write_read(addr_base+`TARGET_REG_A1_C0,32'h15,data);
    apb_write_read(addr_base+`TARGET_REG_A2_C0,32'h25,data);
    apb_write_read(addr_base+`TARGET_REG_B0_C0,32'h10,data);
    apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h27,data);
    apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h51,data);
    // $display("new shiftout data = %h,src data = %h , bits=%d,counter num =%d",count_reverse(data,5'd31),data,5'd31,i);
    end
    //if(i==1||i==3)
    // $display("new shiftout data = %h,bits=%d,counter num=%d",count_reverse(data,5'd31),5'd31,i);
    if(i==0) begin
        //
        apb_write_read(addr_base+`MUX_SEL_C0,32'b0000,data);
        apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h2e2c0000,data);
        apb_write_read(addr_base+`CAPTURE_REG_OVERFLOW_CTRL_C0,32'h3f,data);//overflow,control.
    end
    if(i==2) begin
        //
        apb_write_read(addr_base+`MUX_SEL_C0,32'b1111,data);
        apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h2e2c0000,data);
        apb_write_read(addr_base+`CAPTURE_REG_OVERFLOW_CTRL_C0,32'h3f,data);//overflow,control.
    end    
//
    apb_write_read(addr_base+`SWITCH_MODE_ONEBIT_CNTS_C0,32'h1,data);//one bit represent how many cycle.
    //apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h01010808,data);//enable switch to shiftin and shiftout mode.
    // apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h01010802,data);//enable switch to shiftin and shiftout mode.
    // apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h00010801,data);//enable switch to shiftin and shiftout mode.
    
    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
//
  
end    
    //
    apb_read(`GLOBAL_START_TRIGGER,data);//start;
    apb_write_read(`GLOBAL_START_TRIGGER,~data,data);//start;
    //i=0;

        addr_base=base_c1*0;
        apb_read(addr_base+`CTRL_SNAP_C0,data);
        apb_write_read(addr_base+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
        apb_read(addr_base+`SNAP_STATUS_C0,data);
        while(!(|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);
        apb_read(addr_base+`CTRL_SNAP_C0,data);
        apb_write_read(addr_base+`CTRL_SNAP_C0,{~data[31:16],data[15:0]},data);//
        apb_read(addr_base+`SNAP_STATUS_C0,data);
        while((|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);  
        //
   
    int_flag_en = 1;
    //count0=16;
    while(1) begin
    wait(i_int);
    tmp_i=32'h1f;
    //
    wait(!i_int);
    end
    #20_000;
    //apb_read(`GLOBAL_STOP_TRIGGER,data);//stop;
    //apb_write_read(`GLOBAL_STOP_TRIGGER,~data,data);//stop;
    //#20_000;  
    //apb_read(`GLOBAL_CLEAR_TRIGGER,data);//
    //apb_write_read(`GLOBAL_CLEAR_TRIGGER,~data,data);//clear;
    //#300_000;
    //apb_read(`GLOBAL_START_TRIGGER,data);//
    //apb_write_read(`GLOBAL_START_TRIGGER,~data,data);//start;
    //#100_000;
    //apb_read(`GLOBAL_RESET_TRIGGER,data);//
    //apb_write_read(`GLOBAL_RESET_TRIGGER,~data,data);//reset; 
    //#300_000;
    //apb_read(`GLOBAL_START_TRIGGER,data);//
    //apb_write_read(`GLOBAL_START_TRIGGER,~data,data);//start;

end
`endif

`ifdef  TESTCASE_ALL_COUNTERMODE_3
//`define CLK_32M
//inner channel casecade
initial begin
wait (stop_event) ;
for(i=0;i<4;i++) begin
    addr_base=base_c1*i;
    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    if(i==1)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b000,data);//count in .
    else if(i==2)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);//count out .    
    else if(i==3)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b000,data);//count in.
    else if(i==0)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);//count out .
    
    //
    apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'd31,data);
    //
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h12210000,data);
    if(i==0) begin
    apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b000100,data);
    apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h10,data);
    apb_write_read(addr_base+`TARGET_REG_A1_C0,32'h20,data);
    apb_write_read(addr_base+`TARGET_REG_A2_C0,32'h30,data);
    //apb_write_read(addr_base+`TARGET_REG_A2_C0,32'ha0,data);
    apb_write_read(addr_base+`TARGET_REG_B0_C0,32'h10,data);
    apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h20,data);
    apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h30,data);
    //apb_write_read(addr_base+`TARGET_REG_B2_C0,32'ha0,data);
    // $display("new shiftout data = %h,src data = %h , bits=%d,counter num =%d",count_reverse(data,5'd31),data,5'd31,i);
    end
    if(i==2) begin
    apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b000001,data);
    apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h55,data);
    apb_write_read(addr_base+`TARGET_REG_A1_C0,32'he5,data);
    apb_write_read(addr_base+`TARGET_REG_A2_C0,32'hf0,data);
    apb_write_read(addr_base+`TARGET_REG_B0_C0,32'h90,data);
    apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h97,data);
    apb_write_read(addr_base+`TARGET_REG_B2_C0,32'hf1,data);
    // $display("new shiftout data = %h,src data = %h , bits=%d,counter num =%d",count_reverse(data,5'd31),data,5'd31,i);
    end
    //if(i==1||i==3)
    // $display("new shiftout data = %h,bits=%d,counter num=%d",count_reverse(data,5'd31),5'd31,i);
    if(i==1) begin
        //
        apb_write_read(addr_base+`MUX_SEL_C0,32'b0000,data);
        apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h2d2b0000,data);
        //apb_write_read(addr_base+`CAPTURE_REG_OVERFLOW_CTRL_C0,32'h3f,data);//overflow,control.
        apb_write_read(addr_base+`CAPTURE_REG_OVERFLOW_CTRL_C0,32'h00,data);//overflow,control.
    end
    if(i==3) begin
        //
        apb_write_read(addr_base+`MUX_SEL_C0,32'b1111,data);
        apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h2d2b0000,data);
        apb_write_read(addr_base+`CAPTURE_REG_OVERFLOW_CTRL_C0,32'h3f,data);//overflow,control.
    end    
//
    apb_write_read(addr_base+`SWITCH_MODE_ONEBIT_CNTS_C0,32'h1,data);//one bit represent how many cycle.
    //apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h01010808,data);//enable switch to shiftin and shiftout mode.
    // apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h01010802,data);//enable switch to shiftin and shiftout mode.
    // apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h00010801,data);//enable switch to shiftin and shiftout mode.
    
    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
//
  
end    
    apb_read (base_c0+`ENABLE_C0,data);
    apb_write(base_c0+`ENABLE_C0,data|32'h2100);//c0,enable.//32M
    apb_read (base_c1+`ENABLE_C0,data);
    apb_write(base_c1+`ENABLE_C0,data|32'h2000);//c0,enable.//32k
    apb_read (base_c2+`ENABLE_C0,data);
    apb_write(base_c2+`ENABLE_C0,data|32'h2100);//c0,enable.//32M
    apb_read (base_c3+`ENABLE_C0,data);
    apb_write(base_c3+`ENABLE_C0,data|32'h2000);//c0,enable.//32k
    //
    apb_read(`GLOBAL_START_TRIGGER,data);//start;
    apb_write_read(`GLOBAL_START_TRIGGER,~data,data);//start;
    //i=0;
    if(1) begin
        addr_base=base_c1*0;
        apb_read(addr_base+`CTRL_SNAP_C0,data);
        apb_write_read(addr_base+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
        apb_read(addr_base+`SNAP_STATUS_C0,data);
        while(!(|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);
        apb_read(addr_base+`CTRL_SNAP_C0,data);
        apb_write_read(addr_base+`CTRL_SNAP_C0,{~data[31:16],data[15:0]},data);//
        apb_read(addr_base+`SNAP_STATUS_C0,data);
        while((|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);  
     end
        //
   
    int_flag_en = 1;
    tmp_i=32'h1f;

    tmp0=0;
    addr_base=base_c1*1;
    while(1) begin
        wait(i_int);	
	tmp0++;
        wait(!i_int);	
	if(tmp0[4:0]==2'b00) begin
        addr_base=base_c1*1;
        apb_read(addr_base+`CTRL_SNAP_C0,data);
        apb_write_read(addr_base+`CTRL_SNAP_C0,{data[31:4],{data[3],data[2],~data[1],data[0]}},data);//
        apb_read(addr_base+`SNAP_STATUS_C0,data);
        while(!(|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);
	cap_count_a = cap_count_a_c1 ;
	apb_read(addr_base+`CAPTURE_REG_STATUS_C0,data_1);
            if(data_1[0]) begin
                apb_read(addr_base+`CAPTURE_REG_A0_C0,data);
                $display("counter num =%0d , in bus a ,new capture edge time = %h,pluse width = %0h ",i,data,data-cap_count_a);
                cap_count_a = data;
            end
            if(data_1[1]) begin
                apb_read(addr_base+`CAPTURE_REG_A1_C0,data);
                $display("counter num =%0d , in bus a ,new capture edge time = %h,pluse width = %0h ",i,data,data-cap_count_a);
                cap_count_a = data;
            end
            if(data_1[2]) begin
                apb_read(addr_base+`CAPTURE_REG_A2_C0,data); 
                $display("counter num =%0d , in bus a ,new capture edge time = %h,pluse width = %0h ",i,data,data-cap_count_a);
                cap_count_a = data;
                
            end
	cap_count_a_c1 = cap_count_a;
        apb_read(addr_base+`CTRL_SNAP_C0,data);
        apb_write_read(addr_base+`CTRL_SNAP_C0,{~data[31:16],data[15:0]},data);//
        apb_read(addr_base+`SNAP_STATUS_C0,data);
        while((|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);  
        apb_read(addr_base+`CTRL_SNAP_C0,data);
        apb_write_read(addr_base+`CTRL_SNAP_C0,{data[31:4],{data[3],~data[2],data[1],data[0]}},data);//
        apb_read(addr_base+`SNAP_STATUS_C0,data);
        while(!(|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);
            cap_count_b = cap_count_b_c1 ;          
	apb_read(addr_base+`CAPTURE_REG_STATUS_C0,data_1);
            if(data_1[3]) begin
                apb_read(addr_base+`CAPTURE_REG_B0_C0,data);
                $display("counter num =%0d , in bus b ,new capture edge time = %h,pluse width = %0h ",i,data,data-cap_count_b);
                cap_count_b = data;
            end
            if(data_1[4]) begin
                apb_read(addr_base+`CAPTURE_REG_B1_C0,data);
                $display("counter num =%0d , in bus b ,new capture edge time = %h,pluse width = %0h ",i,data,data-cap_count_b);
                cap_count_b = data;
            end
            if(data_1[5]) begin
                apb_read(addr_base+`CAPTURE_REG_B2_C0,data);
                $display("counter num =%0d , in bus b ,new capture edge time = %h,pluse width = %0h ",i,data,data-cap_count_b);
                cap_count_b = data;
            end
            cap_count_b_c1 = cap_count_b;          
        apb_read(addr_base+`CTRL_SNAP_C0,data);
        apb_write_read(addr_base+`CTRL_SNAP_C0,{~data[31:16],data[15:0]},data);//
        apb_read(addr_base+`SNAP_STATUS_C0,data);
        while((|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);  
	end
     end
    ////count0=16;
    //while(1) begin
    //wait(i_int);
    //tmp_i=32'h1f;
    ////
    //wait(!i_int);
    //end
    //#20_000;
    //apb_read(`GLOBAL_STOP_TRIGGER,data);//stop;
    //apb_write_read(`GLOBAL_STOP_TRIGGER,~data,data);//stop;
    //#20_000;  
    //apb_read(`GLOBAL_CLEAR_TRIGGER,data);//
    //apb_write_read(`GLOBAL_CLEAR_TRIGGER,~data,data);//clear;
    //#300_000;
    //apb_read(`GLOBAL_START_TRIGGER,data);//
    //apb_write_read(`GLOBAL_START_TRIGGER,~data,data);//start;
    //#100_000;
    //apb_read(`GLOBAL_RESET_TRIGGER,data);//
    //apb_write_read(`GLOBAL_RESET_TRIGGER,~data,data);//reset; 
    //#300_000;
    //apb_read(`GLOBAL_START_TRIGGER,data);//
    //apb_write_read(`GLOBAL_START_TRIGGER,~data,data);//start;

end
`endif

`ifdef  TESTCASE_ALL_COUNTERMODE_4
`define SOFT_SINGLE_TRIGGER
//`define CLK_32M
//soft trigger. 
initial begin
wait (stop_event) ;
for(i=0;i<4;i++) begin
    addr_base=base_c1*i;
    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b11110000,data);//single triger enable.
    if(i==1)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b000,data);//count in .
    else if(i==2)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b000,data);//count in .    
    else if(i==3)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b000,data);//count in.
    else if(i==0)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b000,data);//count in .
    
    //
    apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'd31,data);
    //
    // apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h12210000,data);
    //if(i==1||i==3)
    // $display("new shiftout data = %h,bits=%d,counter num=%d",count_reverse(data,5'd31),5'd31,i);
    if(1) begin
        //
        apb_write_read(addr_base+`MUX_SEL_C0,32'b0000,data);
        apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h24240000,data);
        apb_write_read(addr_base+`CAPTURE_REG_OVERFLOW_CTRL_C0,32'h3f,data);//overflow,control.
    end
  
//
    apb_write_read(addr_base+`SWITCH_MODE_ONEBIT_CNTS_C0,32'h1,data);//one bit represent how many cycle.
  
    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
//
  
end    
    //
    apb_read(`GLOBAL_START_TRIGGER,data);//start;
    apb_write_read(`GLOBAL_START_TRIGGER,~data,data);//start;
    //i=0;

        addr_base=base_c1*0;
        apb_read(addr_base+`CTRL_SNAP_C0,data);
        apb_write_read(addr_base+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
        apb_read(addr_base+`SNAP_STATUS_C0,data);
        while(!(|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);
        apb_read(addr_base+`CTRL_SNAP_C0,data);
        apb_write_read(addr_base+`CTRL_SNAP_C0,{~data[31:16],data[15:0]},data);//
        apb_read(addr_base+`SNAP_STATUS_C0,data);
        while((|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);  
        //
   
    int_flag_en = 1;
    //count0=16;
    while(1) begin
    //wait(i_int);
    tmp_i=32'h1f;
    //repeat(20) @(posedge i_clk[i]);
`ifdef   COUNTER_NUM
    if(`COUNTER_NUM==0)
    j  = 0;
    else if(`COUNTER_NUM==1)
    j  = 1;
    else if(`COUNTER_NUM==2)
    j  = 2;
    else if(`COUNTER_NUM==3)
    j  = 3;
    else 
    j=0;
`else
    for(j=0;j<4;j++) 
`endif
    begin
        $display("counter: j=%h",j);
        for(i=0;i<4;i++) begin
        wait(!apb_hand_on_0);
        apb_hand_on_0 = 1;
        addr_base=base_c1*i;
        data = (32'h24240000+((32'h0202*j)<<16));
        apb_write_read(addr_base+`SRC_SEL_EDGE_C0,data,data);
        apb_hand_on_0 = 0;
        end
        if(j==0) $display("counters %0h, start-trigger start",i);
        if(j==1) $display("counters %0h, stop-trigger start",i);
        if(j==2) $display("counters %0h, clear-trigger start",i);
        if(j==3) $display("counters %0h, reset-trigger start",i);
        #10_000_000;
        if(j==0) $display("counters %0h, start-trigger stop",i);
        if(j==1) $display("counters %0h, stop-trigger stop",i);
        if(j==2) $display("counters %0h, clear-trigger stop",i);
        if(j==3) $display("counters %0h, reset-trigger stop",i);
     
    end

    //wait(!i_int);
    end
    #20_000;
    //apb_read(`GLOBAL_STOP_TRIGGER,data);//stop;
    //apb_write_read(`GLOBAL_STOP_TRIGGER,~data,data);//stop;
    //#20_000;  
    //apb_read(`GLOBAL_CLEAR_TRIGGER,data);//
    //apb_write_read(`GLOBAL_CLEAR_TRIGGER,~data,data);//clear;
    //#300_000;
    //apb_read(`GLOBAL_START_TRIGGER,data);//
    //apb_write_read(`GLOBAL_START_TRIGGER,~data,data);//start;
    //#100_000;
    //apb_read(`GLOBAL_RESET_TRIGGER,data);//
    //apb_write_read(`GLOBAL_RESET_TRIGGER,~data,data);//reset; 
    //#300_000;
    //apb_read(`GLOBAL_START_TRIGGER,data);//
    //apb_write_read(`GLOBAL_START_TRIGGER,~data,data);//start;

end
`endif

`ifdef  TESTCASE_ALL_COUNTERMODE_5
//`define SOFT_GLOBAL_TRIGGER
//`define CLK_32M
//soft trigger. 
initial begin
wait (stop_event) ;
for(i=0;i<4;i++) begin
    addr_base=base_c1*i;
    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b00001111,data);//global triger enable.
    if(i==1)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b000,data);//count in .
    else if(i==2)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b000,data);//count in .    
    else if(i==3)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b000,data);//count in.
    else if(i==0)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b000,data);//count in .
    
    //
    apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'd31,data);
    //
    // apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h12210000,data);
    //if(i==1||i==3)
    // $display("new shiftout data = %h,bits=%d,counter num=%d",count_reverse(data,5'd31),5'd31,i);
    if(1) begin
        //
        apb_write_read(addr_base+`MUX_SEL_C0,32'b0000,data);
        apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h24240000,data);
        apb_write_read(addr_base+`CAPTURE_REG_OVERFLOW_CTRL_C0,32'h3f,data);//overflow,control.
    end
  
//
    apb_write_read(addr_base+`SWITCH_MODE_ONEBIT_CNTS_C0,32'h1,data);//one bit represent how many cycle.
  
    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
//
  
end    
    //
for(i=0;i<4;i++) begin
    addr_base=base_c1*i;
    apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;
end
    //i=0;

     // addr_base=base_c1*0;
     // apb_read(addr_base+`CTRL_SNAP_C0,data);
     // apb_write_read(addr_base+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
     // apb_read(addr_base+`SNAP_STATUS_C0,data);
     // while(!(|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);
     // apb_read(addr_base+`CTRL_SNAP_C0,data);
     // apb_write_read(addr_base+`CTRL_SNAP_C0,{~data[31:16],data[15:0]},data);//
     // apb_read(addr_base+`SNAP_STATUS_C0,data);
     // while((|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);  
        //
   
    int_flag_en = 1;
    //count0=16;
    while(1) begin
    //wait(i_int);
    tmp_i=32'h1f;
    //repeat(20) @(posedge i_clk[i]);
`ifdef   COUNTER_NUM
    if(`COUNTER_NUM==0)
    j  = 0;
    else if(`COUNTER_NUM==1)
    j  = 1;
    else if(`COUNTER_NUM==2)
    j  = 2;
    else if(`COUNTER_NUM==3)
    j  = 3;
    else 
    j=0;
`else
    for(j=0;j<4;j++) 
`endif
    begin
        $display("counter: j=%h",j);
        for(i=0;i<4;i++) begin
        wait(!apb_hand_on_0);
        apb_hand_on_0 = 1;
        addr_base=base_c1*i;
        data = (32'h23230000+((32'h0202*j)<<16));
        apb_write_read(addr_base+`SRC_SEL_EDGE_C0,data,data);
        apb_hand_on_0 = 0;
        end
        if(j==0) $display("counters %0h, global start-trigger start",i);
        if(j==1) $display("counters %0h, global stop-trigger start",i);
        if(j==2) $display("counters %0h, global clear-trigger start",i);
        if(j==3) $display("counters %0h, global reset-trigger start",i);
        #10_000_000;
        if(j==0) $display("counters %0h, global start-trigger stop",i);
        if(j==1) $display("counters %0h, global stop-trigger stop",i);
        if(j==2) $display("counters %0h, global clear-trigger stop",i);
        if(j==3) $display("counters %0h, global reset-trigger stop",i);
     
    end

    //wait(!i_int);
    end
    #20_000;
    //apb_read(`GLOBAL_STOP_TRIGGER,data);//stop;
    //apb_write_read(`GLOBAL_STOP_TRIGGER,~data,data);//stop;
    //#20_000;  
    //apb_read(`GLOBAL_CLEAR_TRIGGER,data);//
    //apb_write_read(`GLOBAL_CLEAR_TRIGGER,~data,data);//clear;
    //#300_000;
    //apb_read(`GLOBAL_START_TRIGGER,data);//
    //apb_write_read(`GLOBAL_START_TRIGGER,~data,data);//start;
    //#100_000;
    //apb_read(`GLOBAL_RESET_TRIGGER,data);//
    //apb_write_read(`GLOBAL_RESET_TRIGGER,~data,data);//reset; 
    //#300_000;
    //apb_read(`GLOBAL_START_TRIGGER,data);//
    //apb_write_read(`GLOBAL_START_TRIGGER,~data,data);//start;

end
`endif

`ifdef  TESTCASE_ALL_COUNTERMODE_6
`define CAPTURE_DATA_IN
`define SOFT_GLOBAL_TRIGGER
`define SOFT_SINGLE_TRIGGER
//input start/stop signal. 
initial begin
wait (stop_event) ;
for(i=0;i<4;i++) begin
    addr_base=base_c1*i;
    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b11111111,data);//global triger enable.
    if(i==1)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);//count out .
    else if(i==2)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);//count out .    
    else if(i==3)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);//count out.
    else if(i==0)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);//count out .
    
    //
    apb_write_read(addr_base+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'd31,data);
    //
    // apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h12210000,data);
    //if(i==1||i==3)
    // $display("new shiftout data = %h,bits=%d,counter num=%d",count_reverse(data,5'd31),5'd31,i);
    apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b000101,data);
    apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h10+i,data);
    apb_write_read(addr_base+`TARGET_REG_A1_C0,32'h20+i,data);
    apb_write_read(addr_base+`TARGET_REG_A2_C0,32'h30+i,data);
    apb_write_read(addr_base+`TARGET_REG_B0_C0,32'h1+i,data);
    apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h2+i,data);
    apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h3+i,data);
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h20201101,data);

//
    apb_write_read(addr_base+`SWITCH_MODE_ONEBIT_CNTS_C0,32'h1,data);//one bit represent how many cycle.
  
    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
//
  
end    
    //
//for(i=0;i<4;i++) begin
//    addr_base=base_c1*i;
//    apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
//    apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;
//end
   
    int_flag_en = 1;
    //count0=16;
    while(1) begin
    //wait(i_int);
    tmp_i=32'h1f;
    //repeat(20) @(posedge i_clk[i]);
    for(j=0;j<16;j++) 
    begin
        $display("counter: source j=%h",j);

`ifdef   COUNTER_NUM
    if(`COUNTER_NUM==0)
    i  = 0;
    else if(`COUNTER_NUM==1)
    i  = 1;
    else if(`COUNTER_NUM==2)
    i  = 2;
    else if(`COUNTER_NUM==3)
    i  = 3;
    else 
    i  = 0;
`else        
        for(i=0;i<4;i++) 
`endif
        begin
        wait(!apb_hand_on_0);
        apb_hand_on_0 = 1;
        addr_base=base_c1*i;
        data = (32'h20201000+((32'h0101*(j))));
        apb_write_read(addr_base+`SRC_SEL_EDGE_C0,data,data);
        apb_hand_on_0 = 0;
        end
        // if(j==0) $display("counters %0h, global start-trigger start",i);
        // if(j==1) $display("counters %0h, global stop-trigger start",i);
        // if(j==2) $display("counters %0h, global clear-trigger start",i);
        // if(j==3) $display("counters %0h, global reset-trigger start",i);
        #10_000_000;

    end

    //wait(!i_int);
    end
    #20_000;
    //apb_read(`GLOBAL_STOP_TRIGGER,data);//stop;
    //apb_write_read(`GLOBAL_STOP_TRIGGER,~data,data);//stop;
    //#20_000;  
    //apb_read(`GLOBAL_CLEAR_TRIGGER,data);//
    //apb_write_read(`GLOBAL_CLEAR_TRIGGER,~data,data);//clear;
    //#300_000;
    //apb_read(`GLOBAL_START_TRIGGER,data);//
    //apb_write_read(`GLOBAL_START_TRIGGER,~data,data);//start;
    //#100_000;
    //apb_read(`GLOBAL_RESET_TRIGGER,data);//
    //apb_write_read(`GLOBAL_RESET_TRIGGER,~data,data);//reset; 
    //#300_000;
    //apb_read(`GLOBAL_START_TRIGGER,data);//
    //apb_write_read(`GLOBAL_START_TRIGGER,~data,data);//start;

end
`endif


`ifdef TESTCASE_ALL_ISO7816_IFC //count mode.
`define CLK_32M

//output  [COUNTER_NUM-1:0] o_extern_din_a;
//input [COUNTER_NUM-1:0] i_extern_dout_a;
//input [COUNTER_NUM-1:0] i_extern_dout_a_oen;

wire w_bfm_iso7816_vdd;
wire w_bfm_iso7816_clk;
wire w_bfm_iso7816_rstn;
wire w_bfm_iso7816_io_data;

reg [9:0] rec_data0;
reg [9:0] rec_data1;

pulldown U0(w_bfm_iso7816_vdd);
pulldown U1(w_bfm_iso7816_clk);
pulldown U2(w_bfm_iso7816_rstn);
pullup U3(w_bfm_iso7816_io_data);

assign w_bfm_iso7816_vdd =      !i_extern_dout_a_oen[0]  ? i_extern_dout_a[0] : 'z;
assign w_bfm_iso7816_clk =      !i_extern_dout_a_oen[1]  ? i_extern_dout_a[1] : 'z;
assign w_bfm_iso7816_rstn =     !i_extern_dout_a_oen[2]  ? i_extern_dout_a[2] : 'z;
assign w_bfm_iso7816_io_data =  !i_extern_dout_a_oen[3]  ? i_extern_dout_a[3] : 'z;
always @* o_extern_din_a[3:0] = {w_bfm_iso7816_io_data,w_bfm_iso7816_rstn,w_bfm_iso7816_clk,w_bfm_iso7816_vdd};

bfm_ifc_iso7816_3   U_bfm_ifc_iso7816_3(
    .i_vdd(w_bfm_iso7816_vdd),
    .i_clk(w_bfm_iso7816_clk),
    .i_rstn(w_bfm_iso7816_rstn),
    .io_data(w_bfm_iso7816_io_data)
);

reg stop_flag0;

initial begin
rec_data0 = '1;
stop_flag0 = '0;
rec_data1 = '0;
wait (stop_event) ;
for(i=0;i<4;i++) begin
    addr_base=base_c1*i;
    //apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b00001111,data);//global triger enable.
    if(i==0)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);//count out
    else if(i==1)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);//count out .    
    else if(i==2)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);//count out
    else if(i==3)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b100,data);//count in . switch en;
    if(i==0) begin
        //
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h20201000,data);
    apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b001111,data);
    apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h10,data);
    apb_write_read(addr_base+`TARGET_REG_A1_C0,32'd500,data);
    apb_write_read(addr_base+`TARGET_REG_A2_C0,32'h1000,data);
    //apb_write_read(addr_base+`TARGET_REG_A2_C0,32'ha0,data);
    apb_write_read(addr_base+`TARGET_REG_B0_C0,32'h10,data);
    apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h500,data);
    apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h1000,data);
    end
    if(i==2) begin//0-->2;
        //
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h2020000b,data);
    apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b001111,data);
    apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h10,data);
    apb_write_read(addr_base+`TARGET_REG_A1_C0,32'd400*2,data);
    apb_write_read(addr_base+`TARGET_REG_A2_C0,32'd40000*2,data);
    //apb_write_read(addr_base+`TARGET_REG_A2_C0,32'ha0,data);
    apb_write_read(addr_base+`TARGET_REG_B0_C0,32'h10,data);
    apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h20,data);
    apb_write_read(addr_base+`TARGET_REG_B2_C0,32'd800*2,data);
    end
    
    if(i==1) begin//clk //0-->1;
        //
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h2020100b,data);
    apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b000100,data);
    apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h0,data);
    apb_write_read(addr_base+`TARGET_REG_A1_C0,32'h1,data);
    apb_write_read(addr_base+`TARGET_REG_A2_C0,32'h2,data);
    //apb_write_read(addr_base+`TARGET_REG_A2_C0,32'ha0,data);
    apb_write_read(addr_base+`TARGET_REG_B0_C0,32'h10,data);
    apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h20,data);
    apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h30,data);
    end
    if(i==3) begin//io
    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    // apb_write_read(addr_base+`MODE_SEL_C0,32'b101,data);//count switch 
    apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b110001,data);
    apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h10,data);
    apb_write_read(addr_base+`TARGET_REG_A1_C0,32'h20,data);
    apb_write_read(addr_base+`TARGET_REG_A2_C0,32'h30,data);
    apb_write_read(addr_base+`TARGET_REG_B0_C0,32'h1,data);
    // apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h20,data);
    // apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h3f,data);
    apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h2,data);
    apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h3,data);//  
//
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h2221000d,data);
    apb_write_read(addr_base+`SWITCH_MODE_ONEBIT_CNTS_C0,32'd372*2,data);//one bit represent how many cycle.
    apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h00000a02,data);//enable switch to waveform and capture mode.
//        
    end
//
    // apb_write_read(addr_base+`SWITCH_MODE_ONEBIT_CNTS_C0,32'h1,data);//one bit represent how many cycle.
  
    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
//
  
end    
    //
// for(i=0;i<4;i++) begin
    addr_base=base_c1*0;
    apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    //addr_base=base_c1*3;
    //apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
    //apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;    
// end
    //i=0;
        //
   
    int_flag_en = 0;
    tmp_i=32'h1f;
    apb_read(`INTR_STATUS,int_status0);
    while(~(|int_status0)) apb_read(`INTR_STATUS,int_status0);
    //repeat(1) @(posedge i_pclk);//
    if(int_status0[21])  
      apb_write_read(`INTR_CLR,int_status0,data);   

        i=3;
        addr_base=base_c1*3;
        apb_read(addr_base+`SHADOW_REG_C0,data);
        cap_count_a = data;
        $display("counter num =%0d , in bus a ,new start capture time = %h",3,cap_count_a);
        // $display("counter num =%0d , in bus a ,new capture edge time = %h,pluse width = %0h ",3,data,data-cap_count_a);
    apb_read(`INTR_STATUS,int_status0);
    //while(~(|int_status0)) apb_read(`INTR_STATUS,int_status0);        
    if(int_status0[30])  begin
      apb_write_read(`INTR_CLR,int_status0,data);   
      stop_flag0 = '1;
    end
    rec_data1[9:0] = {rec_data0[9:1],rec_data0[0]};
    while(!stop_flag0) begin   
        i=3;
        addr_base=base_c1*3;    
        apb_read(addr_base+`CTRL_SNAP_C0,data);
        apb_write_read(addr_base+`CTRL_SNAP_C0,{data[31:4],data[3],data[2],~data[1],data[0]},data);//
        apb_read(addr_base+`SNAP_STATUS_C0,data);
        
        while(!(|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);
        apb_read(addr_base+`CAPTURE_REG_STATUS_C0,data_1);
                if(data_1[0]) begin
                    apb_read(addr_base+`CAPTURE_REG_A0_C0,data);
                    $display("counter num =%0d , in bus a ,new capture edge time = %h,pluse width = %0h ",i,data,data-cap_count_a);
                    //cap_count_a = data;
                    // rec_data1[9:0]=rec_data0[9:0];
                    repeat(1) @(posedge i_pclk);//
                    while((data>cap_count_a)) begin
                        if(((372*2-37)<=(data-cap_count_a))) begin
                            rec_data0[9:0]={rec_data0[8:0],rec_data1[0]};
                            cap_count_a = cap_count_a +372*2;
                            $display("counter num =%0d , rec_data0 = %b ",i,rec_data0);
                            repeat(1) @(posedge i_pclk);//
                        end
                        else 
                            cap_count_a = data;
                    end
                    rec_data1[9:0] = {rec_data0[9:1],~rec_data0[0]};
                    repeat(1) @(posedge i_pclk);//
                    cap_count_a = data;
                    // $display("counter num =%0d , rec_data0 = %b ",i,rec_data0);
                end
                if(data_1[1]) begin
                    apb_read(addr_base+`CAPTURE_REG_A1_C0,data);
                    $display("counter num =%0d , in bus a ,new capture edge time = %h,pluse width = %0h ",i,data,data-cap_count_a);
                    // rec_data1[9:0]=rec_data0[9:0];
                    repeat(1) @(posedge i_pclk);//
                    while((data>cap_count_a)) begin
                        if(((372*2-37)<=(data-cap_count_a))) begin
                            rec_data0[9:0]={rec_data0[8:0],rec_data1[0]};
                            cap_count_a = cap_count_a +372*2;
                            $display("counter num =%0d , rec_data0 = %b ",i,rec_data0);
                            repeat(1) @(posedge i_pclk);//
                        end
                        else 
                            cap_count_a = data;
                    end
                    rec_data1[9:0] = {rec_data0[9:1],~rec_data0[0]};
                    repeat(1) @(posedge i_pclk);//
                    cap_count_a = data;
                    // $display("counter num =%0d , rec_data0 = %b ",i,rec_data0);
                end
                if(data_1[2]) begin
                    apb_read(addr_base+`CAPTURE_REG_A2_C0,data); 
                    $display("counter num =%0d , in bus a ,new capture edge time = %h,pluse width = %0h ",i,data,data-cap_count_a);
                    // rec_data1[9:0]=rec_data0[9:0];
                    repeat(1) @(posedge i_pclk);//
                    while((data>cap_count_a)) begin
                        if(((372*2-37)<=(data-cap_count_a))) begin
                            rec_data0[9:0]={rec_data0[8:0],rec_data1[0]};
                            cap_count_a = cap_count_a +372*2;
                            $display("counter num =%0d , rec_data0 = %b ",i,rec_data0);
                            repeat(1) @(posedge i_pclk);//
                        end
                        else 
                            cap_count_a = data;
                    end
                    rec_data1[9:0] = {rec_data0[9:1],~rec_data0[0]};    
                    repeat(1) @(posedge i_pclk);//                    
                    cap_count_a = data;
                    // $display("counter num =%0d , rec_data0 = %b ",i,rec_data0);
                end
        apb_read(addr_base+`CTRL_SNAP_C0,data);
        apb_write_read(addr_base+`CTRL_SNAP_C0,{~data[31:16],data[15:0]},data);//
        apb_read(addr_base+`SNAP_STATUS_C0,data);
        while((|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);  
        apb_read(`INTR_STATUS,int_status0);
        //while(~(|int_status0)) apb_read(`INTR_STATUS,int_status0);        
        if(int_status0[30])  begin
        apb_write_read(`INTR_CLR,int_status0,data);   
        stop_flag0 = '1;
        end
    end
        i=3;
        addr_base=base_c1*3;
        apb_read(addr_base+`SHADOW_REG_C0,data);
        $display("counter num =%0d , in bus a ,new capture edge time = %h,pluse width = %0h ",i,data,data-cap_count_a);
        // rec_data1[9:0]=rec_data0[9:0];
                    // $display("counter num =%0d , rec_data1 = %b ",i,rec_data1);
                    repeat(1) @(posedge i_pclk);//
                    while((data>cap_count_a)) begin
                        if(((372*2-37)<=(data-cap_count_a))) begin
                            rec_data0[9:0]={rec_data0[8:0],rec_data1[0]};
                            cap_count_a = cap_count_a +372*2;
                            $display("counter num =%0d , rec_data0 = %b ",i,rec_data0);
                            repeat(1) @(posedge i_pclk);//
                        end
                        else 
                            cap_count_a = data;
                    end
       rec_data1[9:0] = {rec_data0[9:1],~rec_data0[0]};
       if((^rec_data0[8:1])==rec_data0[0]) begin
         $display("counter num =%0d , rec_data0 = %b , parity is right",i,rec_data0);
                    i=3;
           addr_base=base_c1*i;
           apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);//count out
           apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h2020000b,data);
           apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b110011,data);
           apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h372*4+1,data);
           apb_write_read(addr_base+`TARGET_REG_A1_C0,32'd10,data);
           apb_write_read(addr_base+`TARGET_REG_A2_C0,(32'd372*4),data);
           //
           apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
           apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;       
         
       end
       else  begin
           i=3;
           addr_base=base_c1*i;
           apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);//count out
           apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h2020000b,data);
           apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b000011,data);
           apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h10,data);
           apb_write_read(addr_base+`TARGET_REG_A1_C0,32'd372*4-1,data);
           apb_write_read(addr_base+`TARGET_REG_A2_C0,32'd372*4,data);
           //
           apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
           apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;          
       end
    apb_read(`INTR_STATUS,int_status0);
    while(~(|int_status0)) apb_read(`INTR_STATUS,int_status0);        
    if(int_status0[29])  begin
      apb_write_read(`INTR_CLR,int_status0,data);   
      apb_read(addr_base+`SINGLE_STOP_TRIGGER_C0,data);//stop;
      apb_write_read(addr_base+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
    end
    tmp0[8:1]=8'h55;
    //tmp0[8:1]={$random}%256;
    tmp0[9]=1'b0;
    tmp0[0]=^tmp0[8:1];
    tmp0[11:10]=2'b11;
    // apb_write_read(addr_base+`MODE_SEL_C0,32'b101,data);//count out
    // apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h0000020c,data);//enable switch to waveform and capture mode.
   for(i=0;i<12;i++) begin
    if(tmp0[11]) begin
        addr_base=base_c1*3;
        apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);//count out
        apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h2020000b,data);
        apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b110011,data);
        apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h372*2+1,data);
        apb_write_read(addr_base+`TARGET_REG_A1_C0,32'd10,data);
        apb_write_read(addr_base+`TARGET_REG_A2_C0,(32'd372*2),data);
        //
        apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
        apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;    
        //
        apb_read(`INTR_STATUS,int_status0);
        while(~(|int_status0)) apb_read(`INTR_STATUS,int_status0);        
        if(int_status0[29])  begin
        apb_write_read(`INTR_CLR,int_status0,data);   
        apb_read(addr_base+`SINGLE_STOP_TRIGGER_C0,data);//stop;
        apb_write_read(addr_base+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
        end
    end
    else begin
        addr_base=base_c1*3;
        apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);//count out
        apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h2020000b,data);
        apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b110011,data);
        apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h1,data);
        apb_write_read(addr_base+`TARGET_REG_A1_C0,32'd372*2+1,data);
        apb_write_read(addr_base+`TARGET_REG_A2_C0,(32'd372*2),data);
        //
        apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
        apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;    
        //
        apb_read(`INTR_STATUS,int_status0);
        while(~(|int_status0)) apb_read(`INTR_STATUS,int_status0);        
        if(int_status0[29])  begin
        apb_write_read(`INTR_CLR,int_status0,data);   
        apb_read(addr_base+`SINGLE_STOP_TRIGGER_C0,data);//stop;
        apb_write_read(addr_base+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
        end
    end
    tmp0[11:0]=tmp0[11:0]<<1;
   end
    apb_read(addr_base+`SINGLE_STOP_TRIGGER_C0,data);//stop;
    apb_write_read(addr_base+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
    #20_000;
    //apb_read(`GLOBAL_STOP_TRIGGER,data);//stop;
    //apb_write_read(`GLOBAL_STOP_TRIGGER,~data,data);//stop;
    //#20_000;  

end

`endif


`ifdef TESTCASE_ALL_SHIFTMODE_ISO7816_IFC //shift mode.
`define CLK_32M

//output  [COUNTER_NUM-1:0] o_extern_din_a;
//input [COUNTER_NUM-1:0] i_extern_dout_a;
//input [COUNTER_NUM-1:0] i_extern_dout_a_oen;

wire w_bfm_iso7816_vdd;
wire w_bfm_iso7816_clk;
wire w_bfm_iso7816_rstn;
wire w_bfm_iso7816_io_data;

reg [9:0] rec_data0;
reg [9:0] rec_data1;

pulldown U0(w_bfm_iso7816_vdd);
pulldown U1(w_bfm_iso7816_clk);
pulldown U2(w_bfm_iso7816_rstn);
pullup U3(w_bfm_iso7816_io_data);

assign w_bfm_iso7816_vdd =      !i_extern_dout_a_oen[0]  ? i_extern_dout_a[0] : 'z;
assign w_bfm_iso7816_clk =      !i_extern_dout_a_oen[1]  ? i_extern_dout_a[1] : 'z;
assign w_bfm_iso7816_rstn =     !i_extern_dout_a_oen[2]  ? i_extern_dout_a[2] : 'z;
assign w_bfm_iso7816_io_data =  !i_extern_dout_a_oen[3]  ? i_extern_dout_a[3] : 'z;
always @* o_extern_din_a[3:0] = {w_bfm_iso7816_io_data,w_bfm_iso7816_rstn,w_bfm_iso7816_clk,w_bfm_iso7816_vdd};

bfm_ifc_iso7816_3   U_bfm_ifc_iso7816_3(
    .i_vdd(w_bfm_iso7816_vdd),
    .i_clk(w_bfm_iso7816_clk),
    .i_rstn(w_bfm_iso7816_rstn),
    .io_data(w_bfm_iso7816_io_data)
);

reg stop_flag0;

initial begin
rec_data0 = '1;
stop_flag0 = '0;
rec_data1 = '0;
wait (stop_event) ;
for(i=0;i<4;i++) begin
    addr_base=base_c1*i;
    //apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b00001111,data);//global triger enable.
    if(i==0)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);//count out
    else if(i==1)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);//count out .    
    else if(i==2)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);//count out
    else if(i==3)
        apb_write_read(addr_base+`MODE_SEL_C0,32'b100,data);//count in . switch en;
    if(i==0) begin
        //
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h20201000,data);
    apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b001111,data);
    apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h10,data);
    apb_write_read(addr_base+`TARGET_REG_A1_C0,32'd500,data);
    apb_write_read(addr_base+`TARGET_REG_A2_C0,32'h1000,data);
    //apb_write_read(addr_base+`TARGET_REG_A2_C0,32'ha0,data);
    apb_write_read(addr_base+`TARGET_REG_B0_C0,32'h10,data);
    apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h500,data);
    apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h1000,data);
    end
    if(i==2) begin//0-->2;
        //
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h2020000b,data);
    apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b001111,data);
    apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h10,data);
    apb_write_read(addr_base+`TARGET_REG_A1_C0,32'd400*2,data);
    apb_write_read(addr_base+`TARGET_REG_A2_C0,32'd40000*2,data);
    //apb_write_read(addr_base+`TARGET_REG_A2_C0,32'ha0,data);
    apb_write_read(addr_base+`TARGET_REG_B0_C0,32'h10,data);
    apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h20,data);
    apb_write_read(addr_base+`TARGET_REG_B2_C0,32'd800*2,data);
    end
    
    if(i==1) begin//clk //0-->1;
        //
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h2020100b,data);
    apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b000100,data);
    apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h0,data);
    apb_write_read(addr_base+`TARGET_REG_A1_C0,32'h1,data);
    apb_write_read(addr_base+`TARGET_REG_A2_C0,32'h2,data);
    //apb_write_read(addr_base+`TARGET_REG_A2_C0,32'ha0,data);
    apb_write_read(addr_base+`TARGET_REG_B0_C0,32'h10,data);
    apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h20,data);
    apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h30,data);
    end
    if(i==3) begin//io
    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    // apb_write_read(addr_base+`MODE_SEL_C0,32'b101,data);//count switch 
    apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b110001,data);
    apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h10,data);
    apb_write_read(addr_base+`TARGET_REG_A1_C0,32'h20,data);
    apb_write_read(addr_base+`TARGET_REG_A2_C0,32'h30,data);
    apb_write_read(addr_base+`TARGET_REG_B0_C0,32'h1,data);
    // apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h20,data);
    // apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h3f,data);
    apb_write_read(addr_base+`TARGET_REG_B1_C0,32'h2,data);
    apb_write_read(addr_base+`TARGET_REG_B2_C0,32'h3,data);//  
//
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h2221000d,data);
    apb_write_read(addr_base+`SWITCH_MODE_ONEBIT_CNTS_C0,32'd372*2,data);//one bit represent how many cycle.
    apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h00000a02,data);//enable switch to waveform and capture mode.
//        
    end
//
    // apb_write_read(addr_base+`SWITCH_MODE_ONEBIT_CNTS_C0,32'h1,data);//one bit represent how many cycle.
  
    apb_read (addr_base+`ENABLE_C0,data);
    apb_write(addr_base+`ENABLE_C0,data|32'h0001);//c0,enable.
//
  
end    
    //
// for(i=0;i<4;i++) begin
    addr_base=base_c1*0;
    apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    //addr_base=base_c1*3;
    //apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
    //apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;    
// end
    //i=0;
        //
   
    int_flag_en = 0;
    tmp_i=32'h1f;
    apb_read(`INTR_STATUS,int_status0);
    while(~(|int_status0)) apb_read(`INTR_STATUS,int_status0);
    //repeat(1) @(posedge i_pclk);//
    if(int_status0[21])  
      apb_write_read(`INTR_CLR,int_status0,data);   

        i=3;
        addr_base=base_c1*3;
        apb_read(addr_base+`SHADOW_REG_C0,data);
        cap_count_a = data;
        $display("counter num =%0d , in bus a ,new start capture time = %h",3,cap_count_a);
        // $display("counter num =%0d , in bus a ,new capture edge time = %h,pluse width = %0h ",3,data,data-cap_count_a);
    apb_read(`INTR_STATUS,int_status0);
    //while(~(|int_status0)) apb_read(`INTR_STATUS,int_status0);        
    if(int_status0[30])  begin
      apb_write_read(`INTR_CLR,int_status0,data);   
      stop_flag0 = '1;
    end
    rec_data1[9:0] = {rec_data0[9:1],rec_data0[0]};
    while(!stop_flag0) begin   
        i=3;
        addr_base=base_c1*3;    
        apb_read(addr_base+`CTRL_SNAP_C0,data);
        apb_write_read(addr_base+`CTRL_SNAP_C0,{data[31:4],data[3],data[2],~data[1],data[0]},data);//
        apb_read(addr_base+`SNAP_STATUS_C0,data);
        
        while(!(|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);
        apb_read(addr_base+`CAPTURE_REG_STATUS_C0,data_1);
                if(data_1[0]) begin
                    apb_read(addr_base+`CAPTURE_REG_A0_C0,data);
                    $display("counter num =%0d , in bus a ,new capture edge time = %h,pluse width = %0h ",i,data,data-cap_count_a);
                    //cap_count_a = data;
                    // rec_data1[9:0]=rec_data0[9:0];
                    repeat(1) @(posedge i_pclk);//
                    while((data>cap_count_a)) begin
                        if(((372*2-37)<=(data-cap_count_a))) begin
                            rec_data0[9:0]={rec_data0[8:0],rec_data1[0]};
                            cap_count_a = cap_count_a +372*2;
                            $display("counter num =%0d , rec_data0 = %b ",i,rec_data0);
                            repeat(1) @(posedge i_pclk);//
                        end
                        else 
                            cap_count_a = data;
                    end
                    rec_data1[9:0] = {rec_data0[9:1],~rec_data0[0]};
                    repeat(1) @(posedge i_pclk);//
                    cap_count_a = data;
                    // $display("counter num =%0d , rec_data0 = %b ",i,rec_data0);
                end
                if(data_1[1]) begin
                    apb_read(addr_base+`CAPTURE_REG_A1_C0,data);
                    $display("counter num =%0d , in bus a ,new capture edge time = %h,pluse width = %0h ",i,data,data-cap_count_a);
                    // rec_data1[9:0]=rec_data0[9:0];
                    repeat(1) @(posedge i_pclk);//
                    while((data>cap_count_a)) begin
                        if(((372*2-37)<=(data-cap_count_a))) begin
                            rec_data0[9:0]={rec_data0[8:0],rec_data1[0]};
                            cap_count_a = cap_count_a +372*2;
                            $display("counter num =%0d , rec_data0 = %b ",i,rec_data0);
                            repeat(1) @(posedge i_pclk);//
                        end
                        else 
                            cap_count_a = data;
                    end
                    rec_data1[9:0] = {rec_data0[9:1],~rec_data0[0]};
                    repeat(1) @(posedge i_pclk);//
                    cap_count_a = data;
                    // $display("counter num =%0d , rec_data0 = %b ",i,rec_data0);
                end
                if(data_1[2]) begin
                    apb_read(addr_base+`CAPTURE_REG_A2_C0,data); 
                    $display("counter num =%0d , in bus a ,new capture edge time = %h,pluse width = %0h ",i,data,data-cap_count_a);
                    // rec_data1[9:0]=rec_data0[9:0];
                    repeat(1) @(posedge i_pclk);//
                    while((data>cap_count_a)) begin
                        if(((372*2-37)<=(data-cap_count_a))) begin
                            rec_data0[9:0]={rec_data0[8:0],rec_data1[0]};
                            cap_count_a = cap_count_a +372*2;
                            $display("counter num =%0d , rec_data0 = %b ",i,rec_data0);
                            repeat(1) @(posedge i_pclk);//
                        end
                        else 
                            cap_count_a = data;
                    end
                    rec_data1[9:0] = {rec_data0[9:1],~rec_data0[0]};    
                    repeat(1) @(posedge i_pclk);//                    
                    cap_count_a = data;
                    // $display("counter num =%0d , rec_data0 = %b ",i,rec_data0);
                end
        apb_read(addr_base+`CTRL_SNAP_C0,data);
        apb_write_read(addr_base+`CTRL_SNAP_C0,{~data[31:16],data[15:0]},data);//
        apb_read(addr_base+`SNAP_STATUS_C0,data);
        while((|data)) apb_read(addr_base+`SNAP_STATUS_C0,data);  
        apb_read(`INTR_STATUS,int_status0);
        //while(~(|int_status0)) apb_read(`INTR_STATUS,int_status0);        
        if(int_status0[30])  begin
        apb_write_read(`INTR_CLR,int_status0,data);   
        stop_flag0 = '1;
        end
    end
        i=3;
        addr_base=base_c1*3;
        apb_read(addr_base+`SHADOW_REG_C0,data);
        $display("counter num =%0d , in bus a ,new capture edge time = %h,pluse width = %0h ",i,data,data-cap_count_a);
        // rec_data1[9:0]=rec_data0[9:0];
                    // $display("counter num =%0d , rec_data1 = %b ",i,rec_data1);
                    repeat(1) @(posedge i_pclk);//
                    while((data>cap_count_a)) begin
                        if(((372*2-37)<=(data-cap_count_a))) begin
                            rec_data0[9:0]={rec_data0[8:0],rec_data1[0]};
                            cap_count_a = cap_count_a +372*2;
                            $display("counter num =%0d , rec_data0 = %b ",i,rec_data0);
                            repeat(1) @(posedge i_pclk);//
                        end
                        else 
                            cap_count_a = data;
                    end
       rec_data1[9:0] = {rec_data0[9:1],~rec_data0[0]};
       if((^rec_data0[8:1])==rec_data0[0]) begin
         $display("counter num =%0d , rec_data0 = %b , parity is right",i,rec_data0);
                    i=3;
           addr_base=base_c1*i;
           apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);//count out
           apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h2020000b,data);
           apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b110011,data);
           apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h372*4+1,data);
           apb_write_read(addr_base+`TARGET_REG_A1_C0,32'd10,data);
           apb_write_read(addr_base+`TARGET_REG_A2_C0,(32'd372*4),data);
           //
           apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
           apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;       
         
       end
       else  begin
           i=3;
           addr_base=base_c1*i;
           apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);//count out
           apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h2020000b,data);
           apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b000011,data);
           apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h10,data);
           apb_write_read(addr_base+`TARGET_REG_A1_C0,32'd372*4-1,data);
           apb_write_read(addr_base+`TARGET_REG_A2_C0,32'd372*4,data);
           //
           apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
           apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;          
       end
    apb_read(`INTR_STATUS,int_status0);
    while(~(|int_status0)) apb_read(`INTR_STATUS,int_status0);        
    if(int_status0[29])  begin
      apb_write_read(`INTR_CLR,int_status0,data);   
      apb_read(addr_base+`SINGLE_STOP_TRIGGER_C0,data);//stop;
      apb_write_read(addr_base+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
    end
    tmp0[8:1]=8'h55;
    //tmp0[8:1]={$random}%256;
    tmp0[9]=1'b0;
    tmp0[0]=^tmp0[8:1];
    tmp0[11:10]=2'b11;
    // apb_write_read(addr_base+`MODE_SEL_C0,32'b101,data);//count out
    // apb_write_read(addr_base+`WAVEFORM_MODE_AUTOMATIC_C0,32'h0000020c,data);//enable switch to waveform and capture mode.
   for(i=0;i<12;i++) begin
    if(tmp0[11]) begin
        addr_base=base_c1*3;
        apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);//count out
        apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h2020000b,data);
        apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b110011,data);
        apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h372*2+1,data);
        apb_write_read(addr_base+`TARGET_REG_A1_C0,32'd10,data);
        apb_write_read(addr_base+`TARGET_REG_A2_C0,(32'd372*2),data);
        //
        apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
        apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;    
        //
        apb_read(`INTR_STATUS,int_status0);
        while(~(|int_status0)) apb_read(`INTR_STATUS,int_status0);        
        if(int_status0[29])  begin
        apb_write_read(`INTR_CLR,int_status0,data);   
        apb_read(addr_base+`SINGLE_STOP_TRIGGER_C0,data);//stop;
        apb_write_read(addr_base+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
        end
    end
    else begin
        addr_base=base_c1*3;
        apb_write_read(addr_base+`MODE_SEL_C0,32'b001,data);//count out
        apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h2020000b,data);
        apb_write_read(addr_base+`TARGET_REG_CTRL_C0,32'b110011,data);
        apb_write_read(addr_base+`TARGET_REG_A0_C0,32'h1,data);
        apb_write_read(addr_base+`TARGET_REG_A1_C0,32'd372*2+1,data);
        apb_write_read(addr_base+`TARGET_REG_A2_C0,(32'd372*2),data);
        //
        apb_read(addr_base+`SINGLE_START_TRIGGER_C0,data);//start;
        apb_write_read(addr_base+`SINGLE_START_TRIGGER_C0,~data,data);//start;    
        //
        apb_read(`INTR_STATUS,int_status0);
        while(~(|int_status0)) apb_read(`INTR_STATUS,int_status0);        
        if(int_status0[29])  begin
        apb_write_read(`INTR_CLR,int_status0,data);   
        apb_read(addr_base+`SINGLE_STOP_TRIGGER_C0,data);//stop;
        apb_write_read(addr_base+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
        end
    end
    tmp0[11:0]=tmp0[11:0]<<1;
   end
    apb_read(addr_base+`SINGLE_STOP_TRIGGER_C0,data);//stop;
    apb_write_read(addr_base+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
    #20_000;
    //apb_read(`GLOBAL_STOP_TRIGGER,data);//stop;
    //apb_write_read(`GLOBAL_STOP_TRIGGER,~data,data);//stop;
    //#20_000;  

end

`endif

///


`ifdef SOFT_GLOBAL_TRIGGER
//
reg [3:0] trigger_g;//

initial begin
    //i=0;
    trigger_g[0]=1'b0;
    repeat(20) @(posedge i_clk[0]);
    
forever begin
    tmp0[7:0]={$random}%64;
    tmp0[7:0]+=10;
    repeat(tmp0[7:0]) @(posedge i_clk[0]);
    trigger_g[0]=~trigger_g[0];
    wait(!apb_hand_on_0); apb_hand_on_0 = 1;
    apb_read(base_c1*0+`GLOBAL_START_TRIGGER,data);//start;
    apb_write_read(base_c1*0+`GLOBAL_START_TRIGGER,trigger_g[0],data);//start;
    apb_hand_on_0 = 0;
    $display("counter_all: global start trigger width = %0h",tmp0[7:0]);
end
end

initial begin
    //i=0;
    trigger_g[1]=1'b0;
    repeat(20) @(posedge i_clk[0]);
forever begin
    tmp1[7:0]={$random}%64;
    tmp1[7:0]+=10;
    repeat(tmp1[7:0]) @(posedge i_clk[0]);
    trigger_g[1]=~trigger_g[1];
    wait(!apb_hand_on_0); apb_hand_on_0 = 1;
    apb_read(base_c1*0+`GLOBAL_STOP_TRIGGER,data);//;
    apb_write_read(base_c1*0+`GLOBAL_STOP_TRIGGER,trigger_g[1],data);//stop;
    apb_hand_on_0 = 0;
    $display("counter_all: global stop  trigger width = %0h",tmp1[7:0]);
end
end

initial begin
    //i=0;
    trigger_g[2]=1'b0;
    repeat(20) @(posedge i_clk[0]);
forever begin
    tmp2[7:0]={$random}%64;
    tmp2[7:0]+=10;
    repeat(tmp2[7:0]) @(posedge i_clk[0]);
    trigger_g[2]=~trigger_g[2];
    wait(!apb_hand_on_0); apb_hand_on_0 = 1;
    apb_read(base_c1*0+`GLOBAL_CLEAR_TRIGGER,data);//;
    apb_write_read(base_c1*0+`GLOBAL_CLEAR_TRIGGER,trigger_g[2],data);//clear;
    apb_hand_on_0 = 0;
    $display("counter_all: global clear trigger width = %0h",tmp2[7:0]);
end
end

initial begin
    //i=0;
    trigger_g[3]=1'b0;
    repeat(20) @(posedge i_clk[0]);
forever begin
    tmp3[7:0]={$random}%64;
    tmp3[7:0]+=10;
    repeat(tmp3[7:0]) @(posedge i_clk[0]);
    trigger_g[3]=~trigger_g[3];
    wait(!apb_hand_on_0); apb_hand_on_0 = 1;
    apb_read(base_c1*0+`GLOBAL_RESET_TRIGGER,data);//;
    apb_write_read(base_c1*0+`GLOBAL_RESET_TRIGGER,trigger_g[3],data);//reset;
    apb_hand_on_0 = 0;
    $display("counter_all: global reset trigger width = %0h",tmp3[7:0]);
end
end

`endif

`ifdef SOFT_SINGLE_TRIGGER
//
reg [3:0] trigger_c0,trigger_c1,trigger_c2,trigger_c3;

initial begin
    //i=0;
    trigger_c0[0]=1'b0;
    repeat(20) @(posedge i_clk[0]);
    
forever begin
    tmp0[7:0]={$random}%64;
    tmp0[7:0]+=10;
    repeat(tmp0[7:0]) @(posedge i_clk[0]);
    trigger_c0[0]=~trigger_c0[0];
    wait(!apb_hand_on_0); apb_hand_on_0 = 1;
    apb_read(base_c1*0+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(base_c1*0+`SINGLE_START_TRIGGER_C0,trigger_c0[0],data);//start;
    apb_hand_on_0 = 0;
    $display("counter0: single start trigger width = %0h",tmp0[7:0]);
end
end

initial begin
    //i=0;
    trigger_c0[1]=1'b0;
    repeat(20) @(posedge i_clk[0]);
forever begin
    tmp1[7:0]={$random}%64;
    tmp1[7:0]+=10;
    repeat(tmp1[7:0]) @(posedge i_clk[0]);
    trigger_c0[1]=~trigger_c0[1];
    wait(!apb_hand_on_0); apb_hand_on_0 = 1;
    apb_read(base_c1*0+`SINGLE_STOP_TRIGGER_C0,data);//;
    apb_write_read(base_c1*0+`SINGLE_STOP_TRIGGER_C0,trigger_c0[1],data);//stop;
    apb_hand_on_0 = 0;
    $display("counter0: single stop  trigger width = %0h",tmp1[7:0]);
end
end

initial begin
    //i=0;
    trigger_c0[2]=1'b0;
    repeat(20) @(posedge i_clk[0]);
forever begin
    tmp2[7:0]={$random}%64;
    tmp2[7:0]+=10;
    repeat(tmp2[7:0]) @(posedge i_clk[0]);
    trigger_c0[2]=~trigger_c0[2];
    wait(!apb_hand_on_0); apb_hand_on_0 = 1;
    apb_read(base_c1*0+`SINGLE_CLEAR_TRIGGER_C0,data);//;
    apb_write_read(base_c1*0+`SINGLE_CLEAR_TRIGGER_C0,trigger_c0[2],data);//clear;
    apb_hand_on_0 = 0;
    $display("counter0: single clear trigger width = %0h",tmp2[7:0]);
end
end

initial begin
    //i=0;
    trigger_c0[3]=1'b0;
    repeat(20) @(posedge i_clk[0]);
forever begin
    tmp3[7:0]={$random}%64;
    tmp3[7:0]+=10;
    repeat(tmp3[7:0]) @(posedge i_clk[0]);
    trigger_c0[3]=~trigger_c0[3];
    wait(!apb_hand_on_0); apb_hand_on_0 = 1;
    apb_read(base_c1*0+`SINGLE_RESET_TRIGGER_C0,data);//;
    apb_write_read(base_c1*0+`SINGLE_RESET_TRIGGER_C0,trigger_c0[3],data);//reset;
    apb_hand_on_0 = 0;
    $display("counter0: single reset trigger width = %0h",tmp3[7:0]);
end
end

//-------------------
initial begin
    //i=0;
    trigger_c1[0]=1'b0;
    repeat(20) @(posedge i_clk[1]);
forever begin
    tmp0[15:8]={$random}%64;
    tmp0[15:8]+=10;
    repeat(tmp0[15:8]) @(posedge i_clk[1]);
    trigger_c1[0]=~trigger_c1[0];
    wait(!apb_hand_on_0); apb_hand_on_0 = 1;
    apb_read(base_c1*1+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(base_c1*1+`SINGLE_START_TRIGGER_C0,trigger_c1[0],data);//start;
    apb_hand_on_0 = 0;
    $display("counter1: single start trigger width = %0h",tmp0[15:8]);
end
end

initial begin
    //i=0;
    trigger_c1[1]=1'b0;
    repeat(20) @(posedge i_clk[1]);
forever begin
    tmp1[15:8]={$random}%64;
    tmp1[15:8]+=10;
    repeat(tmp1[15:8]) @(posedge i_clk[1]);
    trigger_c1[1]=~trigger_c1[1];
    wait(!apb_hand_on_0); apb_hand_on_0 = 1;
    apb_read(base_c1*1+`SINGLE_STOP_TRIGGER_C0,data);//;
    apb_write_read(base_c1*1+`SINGLE_STOP_TRIGGER_C0,trigger_c1[1],data);//stop;
    apb_hand_on_0 = 0;
    $display("counter1: single stop  trigger width = %0h",tmp1[15:8]);
end
end

initial begin
    //i=0;
    trigger_c1[2]=1'b0;
    repeat(20) @(posedge i_clk[1]);
forever begin
    tmp2[15:8]={$random}%64;
    tmp2[15:8]+=10;
    repeat(tmp2[15:8]) @(posedge i_clk[1]);
    trigger_c1[2]=~trigger_c1[2];
    wait(!apb_hand_on_0); apb_hand_on_0 = 1;
    apb_read(base_c1*1+`SINGLE_CLEAR_TRIGGER_C0,data);//;
    apb_write_read(base_c1*1+`SINGLE_CLEAR_TRIGGER_C0,trigger_c1[2],data);//clear;
    apb_hand_on_0 = 0;
    $display("counter1: single clear trigger width = %0h",tmp2[15:8]);
end
end

initial begin
    //i=0;
    trigger_c1[3]=1'b0;
    repeat(20) @(posedge i_clk[1]);
forever begin
    tmp3[15:8]={$random}%64;
    tmp3[15:8]+=10;
    repeat(tmp3[15:8]) @(posedge i_clk[1]);
    trigger_c1[3]=~trigger_c1[3];
    wait(!apb_hand_on_0); apb_hand_on_0 = 1;
    apb_read(base_c1*1+`SINGLE_RESET_TRIGGER_C0,data);//;
    apb_write_read(base_c1*1+`SINGLE_RESET_TRIGGER_C0,trigger_c1[3],data);//reset;
    apb_hand_on_0 = 0;
    $display("counter1: single reset trigger width = %0h",tmp3[15:8]);
end
end
//-------------------
//-------------------
initial begin
    //i=0;
    trigger_c2[0]=1'b0;
    repeat(20) @(posedge i_clk[2]);
forever begin
    tmp0[23:16]={$random}%64;
    tmp0[23:16]+=10;
    repeat(tmp0[23:16]) @(posedge i_clk[2]);
    trigger_c2[0]=~trigger_c2[0];
    wait(!apb_hand_on_0); apb_hand_on_0 = 1;
    apb_read(base_c1*2+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(base_c1*2+`SINGLE_START_TRIGGER_C0,trigger_c2[0],data);//start;
    apb_hand_on_0 = 0;
    $display("counter2: single start trigger width = %0h",tmp0[23:16]);
end
end

initial begin
    //i=0;
    trigger_c2[1]=1'b0;
    repeat(20) @(posedge i_clk[2]);
forever begin
    tmp1[23:16]={$random}%64;
    tmp1[23:16]+=10;
    repeat(tmp1[23:16]) @(posedge i_clk[2]);
    trigger_c2[1]=~trigger_c2[1];
    wait(!apb_hand_on_0); apb_hand_on_0 = 1;
    apb_read(base_c1*2+`SINGLE_STOP_TRIGGER_C0,data);//;
    apb_write_read(base_c1*2+`SINGLE_STOP_TRIGGER_C0,trigger_c2[1],data);//stop;
    apb_hand_on_0 = 0;
    $display("counter2: single stop  trigger width = %0h",tmp1[23:16]);
end
end

initial begin
    //i=0;
    trigger_c2[2]=1'b0;
    repeat(20) @(posedge i_clk[2]);
forever begin
    tmp2[23:16]={$random}%64;
    tmp2[23:16]+=10;
    repeat(tmp2[23:16]) @(posedge i_clk[2]);
    trigger_c2[2]=~trigger_c2[2];
    wait(!apb_hand_on_0); apb_hand_on_0 = 1;
    apb_read(base_c1*2+`SINGLE_CLEAR_TRIGGER_C0,data);//;
    apb_write_read(base_c1*2+`SINGLE_CLEAR_TRIGGER_C0,trigger_c2[2],data);//clear;
    apb_hand_on_0 = 0;
    $display("counter2: single clear trigger width = %0h",tmp2[23:16]);
end
end

initial begin
    //i=0;
    trigger_c2[3]=1'b0;
    repeat(20) @(posedge i_clk[2]);
forever begin
    tmp3[23:16]={$random}%64;
    tmp3[23:16]+=10;
    repeat(tmp3[23:16]) @(posedge i_clk[2]);
    trigger_c2[3]=~trigger_c2[3];
    wait(!apb_hand_on_0); apb_hand_on_0 = 1;
    apb_read(base_c1*2+`SINGLE_RESET_TRIGGER_C0,data);//;
    apb_write_read(base_c1*2+`SINGLE_RESET_TRIGGER_C0,trigger_c2[3],data);//reset;
    apb_hand_on_0 = 0;
    $display("counter2: single reset trigger width = %0h",tmp3[23:16]);
end
end
//-------------------
//-------------------
initial begin
    //i=0;
    trigger_c3[0]=1'b0;
    repeat(20) @(posedge i_clk[3]);
forever begin
    tmp0[31:24]={$random}%64;
    tmp0[31:24]+=10;
    repeat(tmp0[31:24]) @(posedge i_clk[3]);
    trigger_c3[0]=~trigger_c3[0];
    wait(!apb_hand_on_0); apb_hand_on_0 = 1;
    apb_read(base_c1*3+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(base_c1*3+`SINGLE_START_TRIGGER_C0,trigger_c3[0],data);//start;
    apb_hand_on_0 = 0;
    $display("counter3: single start trigger width = %0h",tmp0[31:24]);
end
end

initial begin
    //i=0;
    trigger_c3[1]=1'b0;
    repeat(20) @(posedge i_clk[3]);
forever begin
    tmp1[31:24]={$random}%64;
    tmp1[31:24]+=10;
    repeat(tmp1[31:24]) @(posedge i_clk[3]);
    trigger_c3[1]=~trigger_c3[1];
    wait(!apb_hand_on_0); apb_hand_on_0 = 1;
    apb_read(base_c1*3+`SINGLE_STOP_TRIGGER_C0,data);//;
    apb_write_read(base_c1*3+`SINGLE_STOP_TRIGGER_C0,trigger_c3[1],data);//stop;
    apb_hand_on_0 = 0;
    $display("counter3: single stop  trigger width = %0h",tmp1[31:24]);
end
end

initial begin
    //i=0;
    trigger_c3[2]=1'b0;
    repeat(20) @(posedge i_clk[3]);
forever begin
    tmp2[31:24]={$random}%64;
    tmp2[31:24]+=10;
    repeat(tmp2[31:24]) @(posedge i_clk[3]);
    trigger_c3[2]=~trigger_c3[2];
    wait(!apb_hand_on_0); apb_hand_on_0 = 1;
    apb_read(base_c1*3+`SINGLE_CLEAR_TRIGGER_C0,data);//;
    apb_write_read(base_c1*3+`SINGLE_CLEAR_TRIGGER_C0,trigger_c3[2],data);//clear;
    apb_hand_on_0 = 0;
    $display("counter3: single clear trigger width = %0h",tmp2[31:24]);
end
end

initial begin
    //i=0;
    trigger_c3[3]=1'b0;
    repeat(20) @(posedge i_clk[3]);
forever begin
    tmp3[31:24]={$random}%64;
    tmp3[31:24]+=10;
    repeat(tmp3[31:24]) @(posedge i_clk[3]);
    trigger_c3[3]=~trigger_c3[3];
    wait(!apb_hand_on_0); apb_hand_on_0 = 1;
    apb_read(base_c1*3+`SINGLE_RESET_TRIGGER_C0,data);//;
    apb_write_read(base_c1*3+`SINGLE_RESET_TRIGGER_C0,trigger_c3[3],data);//reset;
    apb_hand_on_0 = 0;
    $display("counter3: single reset trigger width = %0h",tmp3[31:24]);
end
end
//-------------------


`endif



initial begin
    #2500;
    apb_read (base_c0+`ENABLE_C0,data);
    `ifdef  CLK_32M
    apb_write(base_c0+`ENABLE_C0,data|32'h2000);//c0,enable.,32m.
    apb_write(base_c1+`ENABLE_C0,data|32'h2000);//c0,enable.,32m.
    apb_write(base_c2+`ENABLE_C0,data|32'h2000);//c0,enable.,32m.
    apb_write(base_c3+`ENABLE_C0,data|32'h2000);//c0,enable.,32m.    
    `else 
    apb_write(base_c0+`ENABLE_C0,data|32'h2100);//c0,enable.//32k
    apb_write(base_c1+`ENABLE_C0,data|32'h2100);//c0,enable.//32k
    apb_write(base_c2+`ENABLE_C0,data|32'h2100);//c0,enable.//32k
    apb_write(base_c3+`ENABLE_C0,data|32'h2100);//c0,enable.//32k
    `endif
end


`ifdef CAPTURE_DATA_CASECADE
always @* begin
//0-》1-》2-》3-》0 。
for(i=0;i<4;i++) begin
if(!i_extern_dout_a_oen[i])
    if(i!=3)
        o_extern_din_a[i+1] = i_extern_dout_a[i];
    else
        o_extern_din_a[0] = i_extern_dout_a[i];
else 
    if(i!=3)
        o_extern_din_a[i+1] = 1'b1;
    else
        o_extern_din_a[0] = 1'b1;
if(!i_extern_dout_b_oen[i])
    if(i!=3)
        o_extern_din_b[i+1] = i_extern_dout_b[i];
    else
        o_extern_din_b[0] = i_extern_dout_b[i];
else 
    if(i!=3)
        o_extern_din_b[i+1] = 1'b1;
    else
        o_extern_din_b[0] = 1'b1;
end
end
`elsif CAPTURE_DATA_IN
reg [31:0] tmp_a,tmp_b;

genvar i_l0;
generate for(i_l0=0;i_l0<4;i_l0++) begin:loop
initial begin
    o_extern_din_a[i_l0] = 1'b0;
    repeat(20) @(posedge i_clk[i_l0]);
forever begin
    tmp_a[8*(i_l0+1)-1:8*i_l0]={$random}%64;
    tmp_a[8*(i_l0+1)-1:8*i_l0]+=10;
    repeat(tmp_a[8*(i_l0+1)-1:8*i_l0]) @(posedge i_clk[i_l0]);
    o_extern_din_a[i_l0] = ~ o_extern_din_a[i_l0];
    $display("counter%0h: extern_din_a width = %0h",i_l0,tmp_a[8*(i_l0+1)-1:8*i_l0]);
end
end

initial begin
    o_extern_din_b[i_l0] = 1'b0;
    repeat(20) @(posedge i_clk[i_l0]);
forever begin
    tmp_b[8*(i_l0+1)-1:8*i_l0]={$random}%64;
    tmp_b[8*(i_l0+1)-1:8*i_l0]+=10;
    repeat(tmp_b[8*(i_l0+1)-1:8*i_l0]) @(posedge i_clk[i_l0]);
    o_extern_din_b[i_l0] = ~ o_extern_din_b[i_l0];
    $display("counter%0h: extern_din_b width = %0h",i_l0,tmp_b[8*(i_l0+1)-1:8*i_l0]);
end
end

end
endgenerate 



`elsif SHIFT_DATA_IN
initial begin
o_extern_din_a = 1'b0;
o_extern_din_b = 1'b0;
forever begin
`ifdef  CLK_32M
#20_000;
 repeat (5) @(posedge i_clk);
`else 
repeat (1) @(posedge i_clk);
`endif
`ifdef  COUNTER_NUM
o_extern_din_a[`COUNTER_NUM] = $random;
// o_extern_din_b = $random;
o_extern_din_b[`COUNTER_NUM] = ~o_extern_din_b[`COUNTER_NUM];
`else 
o_extern_din_a = $random;
// o_extern_din_b = $random;
o_extern_din_b = ~o_extern_din_b;
`endif
end
end

`endif




// `ifdef INT_HAND

//reg [31:0] int_status,int_status0;
//reg [31:0] base_addr_int;
//reg [31:0] cap_count_a,cap_count_b;
//reg [31:0] cap_count_a_c0,cap_count_b_c0;
//reg [31:0] cap_count_a_c1,cap_count_b_c1;
//reg [31:0] cap_count_a_c2,cap_count_b_c2;
//reg [31:0] cap_count_a_c3,cap_count_b_c3;


initial begin
    apb_write_read(`INTR_MASK_CLR,32'hffffffff,data);
    // $display("interrupt process ,stage 1 ");
    cap_count_a=32'h0;
    cap_count_b=32'h0;
    cap_count_a_c0=32'h0;
    cap_count_b_c0=32'h0;    
    cap_count_a_c1=32'h0;
    cap_count_b_c1=32'h0;   
    cap_count_a_c2=32'h0;
    cap_count_b_c2=32'h0;   
    cap_count_a_c3=32'h0;
    cap_count_b_c3=32'h0;       
    while(1) begin
    wait(int_flag_en);
    // $display("interrupt process ,stage 2");
    wait(i_int);
    // $display("interrupt process ,stage 3");
    wait(!apb_hand_on_0); apb_hand_on_0 = 1;
    apb_read(`INTR_STATUS,int_status0);
    repeat(1) @(posedge i_pclk);//
    if(|int_status0)  begin
      apb_write_read(`INTR_CLR,int_status0,data);
    for(i=0;i<4;i++) begin    
      repeat(1) @(posedge i_pclk);//
      int_status = int_status0>>8*i;
      base_addr_int=base_c1*i;
      if(|int_status[7:0]) begin
          //apb_read(base_addr_int+`CTRL_SNAP_C0,data);
          //apb_write_read(base_addr_int+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
          //apb_read(base_addr_int+`SNAP_STATUS_C0,data);
          //if(|data) begin
          //  $display("new capture register comes");
          //end 
          //else begin
          //while(!(|data)) apb_read(base_addr_int+`SNAP_STATUS_C0,data);
          //  $display("new capture register don't come,please wait and read");
          //end
          //apb_read(base_addr_int+`CTRL_SNAP_C0,data);
          //apb_write_read(base_addr_int+`CTRL_SNAP_C0,{~data[31:16],data[15:0]},data);//
          //apb_read(base_addr_int+`SNAP_STATUS_C0,data);
          //while((|data)) apb_read(base_addr_int+`SNAP_STATUS_C0,data);
          //$display("capture register status clear");
          //
          //repeat (2) @(posedge i_pclk);
          if(int_status[0]) begin
          if(i==0) begin
            cap_count_a = cap_count_a_c0 ;
          end 
          else if(i==1) begin
            cap_count_a = cap_count_a_c1 ;
          end
          else if(i==2) begin
            cap_count_a = cap_count_a_c2 ;
          end
          else if(i==3) begin
            cap_count_a = cap_count_a_c3 ;
          end           
            apb_read(base_addr_int+`CAPTURE_REG_STATUS_C0,data_1);
            if(&data_1[2:0]) begin
                apb_read(base_addr_int+`CAPTURE_REG_A0_C0,data);
                $display("counter num =%0d , in bus a ,new capture edge time = %h,pluse width = %0h ",i,data,data-cap_count_a);
                cap_count_a = data;
                apb_read(base_addr_int+`CAPTURE_REG_A1_C0,data);
                $display("counter num =%0d , in bus a ,new capture edge time = %h,pluse width = %0h ",i,data,data-cap_count_a);
                cap_count_a = data;
                apb_read(base_addr_int+`CAPTURE_REG_A2_C0,data); 
                $display("counter num =%0d , in bus a ,new capture edge time = %h,pluse width = %0h ",i,data,data-cap_count_a);
                cap_count_a = data;
                
            end            
            data_1 = '0;
          if(i==0) begin
            cap_count_a_c0 = cap_count_a;
          end 
          else if(i==1) begin
            cap_count_a_c1 = cap_count_a;
          end
          else if(i==2) begin
            cap_count_a_c2 = cap_count_a;
          end
          else if(i==3) begin
            cap_count_a_c3 = cap_count_a;
          end            
          end
          //
         
          if(int_status[1]) begin
          if(i==0) begin
            cap_count_b = cap_count_b_c0 ;
          end 
          else if(i==1) begin
            cap_count_b = cap_count_b_c1 ;          
          end
          else if(i==2) begin
            cap_count_b = cap_count_b_c2 ;          
          end
          else if(i==3) begin
            cap_count_b = cap_count_b_c3 ;          
          end           
            apb_read(base_addr_int+`CAPTURE_REG_STATUS_C0,data_1);
            if(&data_1[5:3]) begin
                apb_read(base_addr_int+`CAPTURE_REG_B0_C0,data);
                $display("counter num =%0d , in bus b ,new capture edge time = %h,pluse width = %0h ",i,data,data-cap_count_b);
                cap_count_b = data;
                apb_read(base_addr_int+`CAPTURE_REG_B1_C0,data);
                $display("counter num =%0d , in bus b ,new capture edge time = %h,pluse width = %0h ",i,data,data-cap_count_b);
                cap_count_b = data;
                apb_read(base_addr_int+`CAPTURE_REG_B2_C0,data);
                $display("counter num =%0d , in bus b ,new capture edge time = %h,pluse width = %0h ",i,data,data-cap_count_b);
                cap_count_b = data;
            end
            
            data_1 = '0;
          if(i==0) begin
            cap_count_b_c0 = cap_count_b;
          end 
          else if(i==1) begin
            cap_count_b_c1 = cap_count_b;          
          end
          else if(i==2) begin
            cap_count_b_c2 = cap_count_b;          
          end
          else if(i==3) begin
            cap_count_b_c3 = cap_count_b;          
          end            
          end
          //
          if(int_status[2]) begin
              $display("counter overflow data,counter num =%d",i);
          end
          if(int_status[3]) begin
              apb_read(base_addr_int+`SHIFTIN_DATA_C0,data);
              apb_read(base_addr_int+`SHIFTIN_DATABITS_UPDATED_C0,data_1);
              $display("new shiftin data = %h,src data = %h , bits=%0d,counter num =%d",data,count_reverse(data,count_valid_cnts(data_1)),count_valid_cnts(data_1),i);
              data_1 = '0;
          end
          //
          if(int_status[4]) begin
              data_1=$random;
              apb_write_read(base_addr_int+`SHIFTOUT_DATA_C0,data_1,data);
              apb_write(base_addr_int+`SHIFTOUT_DATA_VALID_C0,32'h0);
              //if(tmp_i!=31)
              //  tmp_i--;               
              apb_write_read(base_addr_int+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,tmp_i,data);
              $display("new shiftout data = %h,src data = %h , bits=%d,counter num =%d",count_reverse(data_1,tmp_i[4:0]),data_1,tmp_i[4:0],i);
              data_1 = '0;
          end
          if(int_status[5]) begin
              $display("counter waveform mode reach target register 3,counter num =%d",i);
          end
          if(int_status[6]) begin
              $display("counter automatic switch to shiftout/waveform mode,counter num =%d",i);
          end
          if(int_status[7]) begin
              $display("counter automatic switch to shiftin/capture mode,counter num =%d",i);
          end
          //
      end
      //


    end
   end
   apb_hand_on_0 = 0;
   end
    
end
// `endif

`ifdef SIM_FINISH_MS
initial begin
#(1_000_000*`SIM_FINISH_MS);
`ifdef AUTO_FINISH
$finish;
`else
$stop;
`endif

end
`endif

function unsigned [31:0] count_reverse;
input [31:0] data_in;
input [31:0] bit_cnts;
//output [31:0] data_out;
integer i;
begin
count_reverse = 32'h0;
for(i=0;i<=bit_cnts;i++) begin
    count_reverse[bit_cnts-i]=data_in[i];
end
end
endfunction

function unsigned [31:0] count_valid_cnts;
input [31:0] data_in;
//output [31:0] data_out;
integer i;
begin
count_valid_cnts = 32'h0;
for(i=0;i<=31;i++) begin
    count_valid_cnts+=data_in[i];
end
count_valid_cnts-=1;
end
endfunction

`ifdef APB_BUS_MONITOR

wire write_flag;
wire read_flag;
reg  [31:0] r1_apb_addr;
reg  [31:0] r1_wdata;
reg  [31:0] r1_rdata;
reg r1_psel_dly;
reg r1_penable_dly;
reg r1_write_flag_dly;
reg r1_read_flag_dly;
reg r1_pwrite_dly;
always @(posedge i_pclk) begin
    r1_psel_dly     <= o_psel;
    r1_penable_dly  <= o_penable;
    r1_write_flag_dly <= write_flag;
    r1_read_flag_dly  <= read_flag;
    r1_pwrite_dly <= o_pwrite;
    r1_apb_addr	   <= o_paddr;
    r1_wdata   <= o_pwdata;
end

assign write_flag = r1_pwrite_dly  && r1_psel_dly && o_psel && o_penable;
assign read_flag  = !r1_pwrite_dly && r1_psel_dly && o_psel && o_penable;


always @(posedge i_pclk) begin
if(write_flag)
    $display("APB WRITE: ADDR = %h, DATA = %h",r1_apb_addr,r1_wdata);
else if(read_flag)
    $display("APB  READ: ADDR = %h, DATA = %h",r1_apb_addr,i_prdata);
end



`endif





endmodule
