
`timescale 1ns / 1ps 


`define     BASE_ADDR               32'h44108000
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
    apb_hand_on ='0;
    @(posedge i_pclk);
    
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
    apb_hand_on ='0;
    @(posedge i_pclk);
        
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
reg [3:0] i;
reg [31:0] tmp_i;
reg [31:0] count0,count1,count2,count3;
localparam  base_c0=32'h000,
            base_c1=32'h100,
            base_c2=32'h200,
            base_c3=32'h300;

reg [31:0] addr_base;
reg  int_flag_en;

initial begin
    apb_hand_on ='0;
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
<<<<<<< HEAD
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
=======
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
>>>>>>> tmp
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
    apb_write_read(addr_base+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(addr_base+`MODE_SEL_C0,32'b000,data);
    apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h02110000,data);
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
    $stop;

end

`ifdef  TESTCASE_ALL_SHIFTMODE_0
<<<<<<< HEAD
=======
`define CAPTURE_DATA_CASECADE
>>>>>>> tmp

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
<<<<<<< HEAD


end
`endif

`ifdef  TESTCASE_ALL_SHIFTMODE_1

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
=======
>>>>>>> tmp

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

<<<<<<< HEAD
=======
`ifdef  TESTCASE_ALL_SHIFTMODE_1
`define CAPTURE_DATA_CASECADE
>>>>>>> tmp


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
`else 
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
    if(i==1) begin
        //
        apb_write_read(addr_base+`MUX_SEL_C0,32'b0000,data);
        apb_write_read(addr_base+`SRC_SEL_EDGE_C0,32'h2d2b0000,data);
        apb_write_read(addr_base+`CAPTURE_REG_OVERFLOW_CTRL_C0,32'h3f,data);//overflow,control.
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
`else 
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

<<<<<<< HEAD



// `ifdef INT_HAND
=======
>>>>>>> tmp

reg [31:0] int_status,int_status0;
reg [31:0] base_addr_int;
reg [31:0] cap_count_a,cap_count_b;
reg [31:0] cap_count_a_c0,cap_count_b_c0;
reg [31:0] cap_count_a_c1,cap_count_b_c1;
reg [31:0] cap_count_a_c2,cap_count_b_c2;
reg [31:0] cap_count_a_c3,cap_count_b_c3;


<<<<<<< HEAD
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
      apb_read(`INTR_STATUS,int_status0);
    if(|int_status0)  begin
      apb_write_read(`INTR_CLR,int_status0,data);
    for(i=0;i<4;i++) begin    
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
         
          if(|int_status[1:0]) begin
          if(i==0) begin
            cap_count_a = cap_count_a_c0 ;
            cap_count_b = cap_count_b_c0 ;
          end 
          else if(i==1) begin
            cap_count_a = cap_count_a_c1 ;
            cap_count_b = cap_count_b_c1 ;          
          end
          else if(i==2) begin
            cap_count_a = cap_count_a_c2 ;
            cap_count_b = cap_count_b_c2 ;          
          end
          else if(i==3) begin
            cap_count_a = cap_count_a_c3 ;
            cap_count_b = cap_count_b_c3 ;          
          end           
            apb_read(base_addr_int+`CAPTURE_REG_STATUS_C0,data_1);
            if(&data_1[2:0]) begin
                apb_read(base_addr_int+`CAPTURE_REG_A0_C0,data);
                $display("in bus a ,new capture edge time = %h,pluse width = %h ,counter num =%d",data,data-cap_count_a,i);
                cap_count_a = data;
                apb_read(base_addr_int+`CAPTURE_REG_A1_C0,data);
                $display("in bus a ,new capture edge time = %h,pluse width = %h ,counter num =%d",data,data-cap_count_a,i);
                cap_count_a = data;
                apb_read(base_addr_int+`CAPTURE_REG_A2_C0,data); 
                $display("in bus a ,new capture edge time = %h,pluse width = %h ,counter num =%d",data,data-cap_count_a,i);
                cap_count_a = data;
                
            end
            if(&data_1[5:3]) begin
                apb_read(base_addr_int+`CAPTURE_REG_B0_C0,data);
                $display("in bus b ,new capture edge time = %h,pluse width = %h ,counter num =%d",data,data-cap_count_b,i);
                cap_count_b = data;
                apb_read(base_addr_int+`CAPTURE_REG_B1_C0,data);
                $display("in bus b ,new capture edge time = %h,pluse width = %h ,counter num =%d",data,data-cap_count_b,i);
                cap_count_b = data;
                apb_read(base_addr_int+`CAPTURE_REG_B2_C0,data);
                $display("in bus b ,new capture edge time = %h,pluse width = %h ,counter num =%d",data,data-cap_count_b,i);
                cap_count_b = data;
            end
            
            data_1 = '0;
          if(i==0) begin
            cap_count_a_c0 = cap_count_a;
            cap_count_b_c0 = cap_count_b;
          end 
          else if(i==1) begin
            cap_count_a_c1 = cap_count_a;
            cap_count_b_c1 = cap_count_b;          
          end
          else if(i==2) begin
            cap_count_a_c2 = cap_count_a;
            cap_count_b_c2 = cap_count_b;          
          end
          else if(i==3) begin
            cap_count_a_c3 = cap_count_a;
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
=======
// `ifdef INT_HAND
>>>>>>> tmp

reg [31:0] int_status,int_status0;
reg [31:0] base_addr_int;
reg [31:0] cap_count_a,cap_count_b;
reg [31:0] cap_count_a_c0,cap_count_b_c0;
reg [31:0] cap_count_a_c1,cap_count_b_c1;
reg [31:0] cap_count_a_c2,cap_count_b_c2;
reg [31:0] cap_count_a_c3,cap_count_b_c3;

    end
   end
   end

<<<<<<< HEAD
=======
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
      apb_read(`INTR_STATUS,int_status0);
    if(|int_status0)  begin
      apb_write_read(`INTR_CLR,int_status0,data);
    for(i=0;i<4;i++) begin    
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
                $display("in bus a ,new capture edge time = %h,pluse width = %h ,counter num =%d",data,data-cap_count_a,i);
                cap_count_a = data;
                apb_read(base_addr_int+`CAPTURE_REG_A1_C0,data);
                $display("in bus a ,new capture edge time = %h,pluse width = %h ,counter num =%d",data,data-cap_count_a,i);
                cap_count_a = data;
                apb_read(base_addr_int+`CAPTURE_REG_A2_C0,data); 
                $display("in bus a ,new capture edge time = %h,pluse width = %h ,counter num =%d",data,data-cap_count_a,i);
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
                $display("in bus b ,new capture edge time = %h,pluse width = %h ,counter num =%d",data,data-cap_count_b,i);
                cap_count_b = data;
                apb_read(base_addr_int+`CAPTURE_REG_B1_C0,data);
                $display("in bus b ,new capture edge time = %h,pluse width = %h ,counter num =%d",data,data-cap_count_b,i);
                cap_count_b = data;
                apb_read(base_addr_int+`CAPTURE_REG_B2_C0,data);
                $display("in bus b ,new capture edge time = %h,pluse width = %h ,counter num =%d",data,data-cap_count_b,i);
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
   end

>>>>>>> tmp
end
// `endif


initial begin
#6_000_000;
$stop;
end

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



endmodule
