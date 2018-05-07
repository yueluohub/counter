
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
//assign o_extern_din_a = '0;
//assign o_extern_din_b = '0;

task apb_write;
input [31:0] w_addr;
input [31:0] w_data;
begin
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
end
endtask

task apb_read;
input  [31:0] r_addr;
output [31:0] r_data;
begin
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
localparam  base_c0=32'h000,
            base_c1=32'h100,
            base_c2=32'h200,
            base_c3=32'h300;

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
    #2000;
    apb_write(32'h8,32'hff);
    apb_read(32'h8,data);
    apb_read (base_c0+`ENABLE_C0,data);
    //apb_write(base_c0+`ENABLE_C0,data|32'h2000);//c0,enable.,32m.
    apb_write(base_c0+`ENABLE_C0,data|32'h2100);//c0,enable.//32k
    apb_read (base_c1+`ENABLE_C0,data);
    apb_write(base_c1+`ENABLE_C0,data|32'h2000);//c1
    apb_read (base_c2+`ENABLE_C0,data);
    apb_write(base_c2+`ENABLE_C0,data|32'h2000);//c2
    apb_read (base_c3+`ENABLE_C0,data);
    apb_write(base_c3+`ENABLE_C0,data|32'h2000);//c3
    apb_read (base_c3+`ENABLE_C0,data);
    apb_write_read(base_c0+`INTR_MASK_CLR,32'hffffffff,data);
    //
   `ifdef	TESTCASE_C0_WAVEFORM_0
    apb_write_read(base_c0+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(base_c0+`MODE_SEL_C0,32'b001,data);
    apb_write_read(base_c0+`TARGET_REG_CTRL_C0,32'b000001,data);
    apb_write_read(base_c0+`TARGET_REG_A0_C0,32'h100,data);
    apb_write_read(base_c0+`TARGET_REG_A1_C0,32'h200,data);
    apb_write_read(base_c0+`TARGET_REG_A2_C0,32'h300,data);
    apb_write_read(base_c0+`TARGET_REG_B0_C0,32'h100,data);
    apb_write_read(base_c0+`TARGET_REG_B1_C0,32'h200,data);
    apb_write_read(base_c0+`TARGET_REG_B2_C0,32'h300,data);
    apb_read (base_c0+`ENABLE_C0,data);
    apb_write(base_c0+`ENABLE_C0,data|32'h0001);//c0,enable.
    //
    apb_write_read(base_c0+`SINGLE_START_TRIGGER_C0,32'b1,data);//start;
    #200_000;
    apb_write_read(base_c0+`SINGLE_STOP_TRIGGER_C0,32'b1,data);//stop;
    #20_000;
    apb_read(base_c0+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(base_c0+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    #20_000;
    apb_read(base_c0+`SINGLE_STOP_TRIGGER_C0,data);//stop;
    apb_write_read(base_c0+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
    #20_000;
    apb_write_read(base_c0+`SINGLE_CLEAR_TRIGGER_C0,32'h1,data);//clear;
    #20_000;
    apb_read(base_c0+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(base_c0+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    #20_000;
    apb_read(base_c0+`SINGLE_RESET_TRIGGER_C0,data);//start;
    apb_write_read(base_c0+`SINGLE_RESET_TRIGGER_C0,~data,data);//clear;
   `endif

   `ifdef	TESTCASE_C0_WAVEFORM_1

    apb_write_read(base_c0+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(base_c0+`MODE_SEL_C0,32'b001,data);
    apb_write_read(base_c0+`TARGET_REG_CTRL_C0,32'b110110,data);
    apb_write_read(base_c0+`TARGET_REG_A0_C0,32'h100,data);
    apb_write_read(base_c0+`TARGET_REG_A1_C0,32'h200,data);
    apb_write_read(base_c0+`TARGET_REG_A2_C0,32'h300,data);
    apb_write_read(base_c0+`TARGET_REG_B0_C0,32'h200,data);
    apb_write_read(base_c0+`TARGET_REG_B1_C0,32'h300,data);
    apb_write_read(base_c0+`TARGET_REG_B2_C0,32'h400,data);
    apb_read (base_c0+`ENABLE_C0,data);
    apb_write(base_c0+`ENABLE_C0,data|32'h0001);//c0,enable.
    //
    apb_write_read(base_c0+`SINGLE_START_TRIGGER_C0,32'b1,data);//start;
    #200_000;
    //apb_read(base_c0+`SINGLE_STOP_TRIGGER_C0,data);//stop;
    //apb_write_read(base_c0+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
    //#20_000;

   `endif
   
      `ifdef	TESTCASE_C0_WAVEFORM_2

    apb_write_read(base_c0+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(base_c0+`MODE_SEL_C0,32'b001,data);
    apb_write_read(base_c0+`TARGET_REG_CTRL_C0,32'b110010,data);
    apb_write_read(base_c0+`TARGET_REG_A0_C0,32'h10,data);
    apb_write_read(base_c0+`TARGET_REG_A1_C0,32'h20,data);
    apb_write_read(base_c0+`TARGET_REG_A2_C0,32'h50,data);
    apb_write_read(base_c0+`TARGET_REG_B0_C0,32'h0,data);
    // apb_write_read(base_c0+`TARGET_REG_B1_C0,32'h20,data);
    // apb_write_read(base_c0+`TARGET_REG_B2_C0,32'h3f,data);
    apb_write_read(base_c0+`TARGET_REG_B1_C0,32'h1,data);
    apb_write_read(base_c0+`TARGET_REG_B2_C0,32'h1,data);//divide by 2,    
    apb_read (base_c0+`ENABLE_C0,data);
    apb_write(base_c0+`ENABLE_C0,data|32'h0001);//c0,enable.
    //
    apb_write_read(base_c0+`SINGLE_START_TRIGGER_C0,32'b1,data);//start;
    #200_000;
    //apb_read(base_c0+`SINGLE_STOP_TRIGGER_C0,data);//stop;
    //apb_write_read(base_c0+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
    //#20_000;

   `endif
   
   
    `ifdef	TESTCASE_C0_CAPTURE_0
        apb_write_read(base_c0+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
        apb_write_read(base_c0+`MODE_SEL_C0,32'b000,data);
        apb_write_read(base_c0+`SRC_SEL_EDGE_C0,32'h01220000,data);
        // apb_write_read(base_c0+`SRC_SEL_EDGE_C0,32'h12210000,data);
    
    
        apb_read (base_c0+`ENABLE_C0,data);
        apb_write(base_c0+`ENABLE_C0,data|32'h0001);//c0,enable.
        //
        //apb_write_read(base_c0+`CAPTURE_REG_OVERFLOW_CTRL_C0,32'h3f,data);//overflow,control.
        apb_read(base_c0+`SINGLE_START_TRIGGER_C0,data);//start;
        apb_write_read(base_c0+`SINGLE_START_TRIGGER_C0,~data,data);//start;
        #1000_000;
        apb_read(base_c0+`SINGLE_STOP_TRIGGER_C0,data);//stop;
        apb_write_read(base_c0+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
        #20_000;
        //#20_000;
        // tmp_i = 10;
    `endif
   
    `ifdef	TESTCASE_C0_CAPTURE_1
    apb_write_read(base_c0+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(base_c0+`MODE_SEL_C0,32'b000,data);
    apb_write_read(base_c0+`SRC_SEL_EDGE_C0,32'h02110000,data);
    // apb_write_read(base_c0+`SRC_SEL_EDGE_C0,32'h12210000,data);

    apb_read (base_c0+`ENABLE_C0,data);
    apb_write(base_c0+`ENABLE_C0,data|32'h0001);//c0,enable.
    //
    //apb_write_read(base_c0+`CAPTURE_REG_OVERFLOW_CTRL_C0,32'h3f,data);//overflow,control.
    apb_read(base_c0+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(base_c0+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    #200_000;
    //apb_read(base_c0+`SINGLE_STOP_TRIGGER_C0,data);//stop;
    //apb_write_read(base_c0+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
    //#20_000;
    // tmp_i = 10;
    while(1) begin
      wait(i_int);
      apb_read(base_c0+`INTR_STATUS,data_1);
      if(|data_1[7:0]) begin
          apb_write_read(base_c0+`INTR_CLR,data_1,data);
          //CTRL_SNAP_C0
          //apb_read(base_c0+`CTRL_SNAP_C0,data);
          //apb_write_read(base_c0+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
          //repeat (2) @(posedge i_pclk);
          apb_read(base_c0+`CAPTURE_REG_STATUS_C0,data_1);
          if(&data_1[2:0]) begin
              apb_read(base_c0+`CAPTURE_REG_A0_C0,data);
              apb_read(base_c0+`CAPTURE_REG_A1_C0,data);
              apb_read(base_c0+`CAPTURE_REG_A2_C0,data); 
          end
          if(&data_1[5:3]) begin
              apb_read(base_c0+`CAPTURE_REG_B0_C0,data);
              apb_read(base_c0+`CAPTURE_REG_B1_C0,data);
              apb_read(base_c0+`CAPTURE_REG_B2_C0,data);
          end
      end
    end
    
   `endif

   `ifdef	TESTCASE_C0_CAPTURE_2
    apb_write_read(base_c0+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(base_c0+`MODE_SEL_C0,32'b000,data);
    //apb_write_read(base_c0+`TARGET_REG_CTRL_C0,32'b110110,data);
    //apb_write_read(base_c0+`SRC_SEL_EDGE_C0,32'h02110000,data);
    apb_write_read(base_c0+`SRC_SEL_EDGE_C0,32'h12210000,data);


    apb_read (base_c0+`ENABLE_C0,data);
    apb_write(base_c0+`ENABLE_C0,data|32'h0001);//c0,enable.
    //
    apb_write_read(base_c0+`CAPTURE_REG_OVERFLOW_CTRL_C0,32'h3f,data);//overflow,control.
    apb_read(base_c0+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(base_c0+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    #200_000;
    //apb_read(base_c0+`SINGLE_STOP_TRIGGER_C0,data);//stop;
    //apb_write_read(base_c0+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
    //#20_000;
    //#20_000;
    tmp_i = 10;
    while(tmp_i--) begin
      wait(i_int);
      apb_read(base_c0+`INTR_STATUS,data_1);
      if(|data_1[7:0]) begin
          apb_write_read(base_c0+`INTR_CLR,data_1,data);
          //CTRL_SNAP_C0
          apb_read(base_c0+`CTRL_SNAP_C0,data);
          apb_write_read(base_c0+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
          apb_read(base_c0+`SNAP_STATUS_C0,data);
          if(|data) begin
            $display("new capture register comes");
          end 
          else begin
            while(!(|data)) apb_read(base_c0+`SNAP_STATUS_C0,data);
            $display("new capture register don't come,please wait and read");
          end
          apb_read(base_c0+`CTRL_SNAP_C0,data);
          apb_write_read(base_c0+`CTRL_SNAP_C0,{~data[31:16],data[15:0]},data);//
          apb_read(base_c0+`SNAP_STATUS_C0,data);
          while((|data)) apb_read(base_c0+`SNAP_STATUS_C0,data);
          $display("capture register status clear");
          //
          repeat (2) @(posedge i_pclk);
          apb_read(base_c0+`CAPTURE_REG_STATUS_C0,data_1);
          if(&data_1[2:0]) begin
              apb_read(base_c0+`CAPTURE_REG_A0_C0,data);
              apb_read(base_c0+`CAPTURE_REG_A1_C0,data);
              apb_read(base_c0+`CAPTURE_REG_A2_C0,data); 
          end
          if(&data_1[5:3]) begin
              apb_read(base_c0+`CAPTURE_REG_B0_C0,data);
              apb_read(base_c0+`CAPTURE_REG_B1_C0,data);
              apb_read(base_c0+`CAPTURE_REG_B2_C0,data);
          end
      end
    end
        apb_read(base_c0+`CAPTURE_REG_OVERFLOW_CTRL_C0,data);//overflow,control.
        apb_write_read(base_c0+`CAPTURE_REG_OVERFLOW_CTRL_C0,{data[30:0],1'b0},data);//overflow,control.
        #500_000;
    repeat (6) begin
        apb_read(base_c0+`CAPTURE_REG_OVERFLOW_CTRL_C0,data);//overflow,control.
        apb_write_read(base_c0+`CAPTURE_REG_OVERFLOW_CTRL_C0,{data[30:0],1'h1},data);//overflow,control.
        #500_000;
    
    end
    
   `endif
   
   `ifdef TESTCASE_C0_SHIFTIN_0
    apb_write_read(base_c0+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(base_c0+`MODE_SEL_C0,32'b010,data);//shift in mode.
    apb_write_read(base_c0+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'd31,data);
    // apb_write_read(base_c0+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'd15,data);
    // apb_write_read(base_c0+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h7,data);
    // apb_write_read(base_c0+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h3,data);
     // apb_write_read(base_c0+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h1,data);
     // apb_write_read(base_c0+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h0,data);


    //
    //apb_write_read(base_c0+`TARGET_REG_CTRL_C0,32'b110110,data);
    //apb_write_read(base_c0+`SRC_SEL_EDGE_C0,32'h02110000,data);
    apb_write_read(base_c0+`SRC_SEL_EDGE_C0,32'h12210000,data);
    //
    apb_read (base_c0+`ENABLE_C0,data);
    apb_write(base_c0+`ENABLE_C0,data|32'h0001);//c0,enable.
    //
    apb_read(base_c0+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(base_c0+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    #1000_000;
    apb_read(base_c0+`SINGLE_STOP_TRIGGER_C0,data);//stop;
    apb_write_read(base_c0+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
    #100_000;    
    //
    apb_write_read(base_c0+`SINGLE_CLEAR_TRIGGER_C0,32'h1,data);//clear;
    #300_000;
    apb_read(base_c0+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(base_c0+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    #100_000;
    apb_read(base_c0+`SINGLE_RESET_TRIGGER_C0,data);//start;
    apb_write_read(base_c0+`SINGLE_RESET_TRIGGER_C0,~data,data);//clear; 
    //
    #500_000;
   `endif
   
    `ifdef TESTCASE_C0_SHIFTIN_1
    apb_write_read(base_c0+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(base_c0+`MODE_SEL_C0,32'b010,data);//shift in mode.
    // apb_write_read(base_c0+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'd31,data);
    // apb_write_read(base_c0+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'd15,data);
    apb_write_read(base_c0+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h7,data);
    // apb_write_read(base_c0+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h3,data);
     // apb_write_read(base_c0+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h1,data);
     // apb_write_read(base_c0+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h0,data);
    //
    apb_write_read(base_c0+`SRC_SEL_EDGE_C0,32'h12210000,data);
    //
    apb_read (base_c0+`ENABLE_C0,data);
    apb_write(base_c0+`ENABLE_C0,data|32'h0001);//c0,enable.
    //
    apb_read(base_c0+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(base_c0+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    //#100_000;
    while(1) begin
      wait(i_int);
      apb_read(base_c0+`INTR_STATUS,data_1);
      if(|data_1[7:0]) begin
          data_1 = data_1>>8*0;
          apb_write_read(base_c0+`INTR_CLR,data_1,data);
          ////CTRL_SNAP_C0
          //apb_read(base_c0+`CTRL_SNAP_C0,data);
          //apb_write_read(base_c0+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
          //repeat (2) @(posedge i_pclk);
          if(data_1[3]) begin
              apb_read(base_c0+`SHIFTIN_DATA_C0,data);
              apb_read(base_c0+`SHIFTIN_DATABITS_UPDATED_C0,data_1);
              $display("new shiftin data = %h",data&data_1);
          end
          else begin
              $display("int number is wrong");            
          end
      end
    end
    //
   `endif  

    `ifdef TESTCASE_C0_SHIFTIN_2
    apb_write_read(base_c0+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(base_c0+`MODE_SEL_C0,32'b010,data);//shift in mode.
    // apb_write_read(base_c0+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'd31,data);
    // apb_write_read(base_c0+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'd15,data);
    apb_write_read(base_c0+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h7,data);
    // apb_write_read(base_c0+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h3,data);
     // apb_write_read(base_c0+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h1,data);
     // apb_write_read(base_c0+`SHIFTIN_DATA_CTRL_BITCNTS_C0,32'h0,data);
    apb_write_read(base_c0+`SHIFTMODE_CTRL_C0,32'h1,data);
    apb_write_read(base_c0+`SRC_SEL_EDGE_C0,32'h12210000,data);
    //
    apb_read (base_c0+`ENABLE_C0,data);
    apb_write(base_c0+`ENABLE_C0,data|32'h0001);//c0,enable.
    //
    apb_read(base_c0+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(base_c0+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    //#100_000;
    while(1) begin
      wait(i_int);
      apb_read(base_c0+`INTR_STATUS,data_1);
      if(|data_1[7:0]) begin
          data_1 = data_1>>8*0;
          apb_write_read(base_c0+`INTR_CLR,data_1,data);
          //CTRL_SNAP_C0
          apb_read(base_c0+`CTRL_SNAP_C0,data);
          apb_write_read(base_c0+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
          repeat (2) @(posedge i_pclk);
          // apb_read(base_c0+`CAPTURE_REG_STATUS_C0,data_1);
          if(data_1[3]) begin
              apb_read(base_c0+`SHIFTIN_DATA_C0,data);
              apb_read(base_c0+`SHIFTIN_DATABITS_UPDATED_C0,data_1);
              $display("new shiftin data = %h",data&data_1);
          end
          else begin
              $display("int number is wrong");            
          end
      end
    end
    //
   `endif  
   
   `ifdef TESTCASE_C0_SHIFTOUT_0
    apb_write_read(base_c0+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(base_c0+`MODE_SEL_C0,32'b011,data);//shift out mode.
    apb_write_read(base_c0+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'd31,data);
    //  apb_write_read(base_c0+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'd15,data);
    //  apb_write_read(base_c0+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h7,data);
    //  apb_write_read(base_c0+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h3,data);
     // apb_write_read(base_c0+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h1,data);
     // apb_write_read(base_c0+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h0,data);
    apb_write_read(base_c0+`SHIFTOUT_DATA_C0,32'h55aa55aa,data);
 	apb_write(base_c0+`SHIFTOUT_DATA_VALID_C0,32'h0);
    //
    //apb_write_read(base_c0+`TARGET_REG_CTRL_C0,32'b110110,data);
    //apb_write_read(base_c0+`SRC_SEL_EDGE_C0,32'h02110000,data);
    apb_write_read(base_c0+`SRC_SEL_EDGE_C0,32'h12210000,data);
    //
    apb_read (base_c0+`ENABLE_C0,data);
    apb_write(base_c0+`ENABLE_C0,data|32'h0001);//c0,enable.
    //
          //CTRL_SNAP_C0
    apb_read(base_c0+`CTRL_SNAP_C0,data);
    apb_write_read(base_c0+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
    apb_read(base_c0+`SNAP_STATUS_C0,data);
    while(!(|data)) apb_read(base_c0+`SNAP_STATUS_C0,data);
    apb_read(base_c0+`CTRL_SNAP_C0,data);
    apb_write_read(base_c0+`CTRL_SNAP_C0,{~data[31:16],data[15:0]},data);//
    apb_read(base_c0+`SNAP_STATUS_C0,data);
    while((|data)) apb_read(base_c0+`SNAP_STATUS_C0,data);
    //$display("capture register status clear");
    
    //
    apb_read(base_c0+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(base_c0+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    #1000_000;
    apb_read(base_c0+`SINGLE_STOP_TRIGGER_C0,data);//stop;
    apb_write_read(base_c0+`SINGLE_STOP_TRIGGER_C0,~data,data);//stop;
    #100_000;    
    //
    apb_write_read(base_c0+`SINGLE_CLEAR_TRIGGER_C0,32'h1,data);//clear;
    #300_000;
    apb_read(base_c0+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(base_c0+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    #100_000;
    apb_read(base_c0+`SINGLE_RESET_TRIGGER_C0,data);//reset;
    apb_write_read(base_c0+`SINGLE_RESET_TRIGGER_C0,~data,data);//; 
    #300_000;
    apb_read(base_c0+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(base_c0+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    //
    #500_000;
   `endif   
   
   `ifdef TESTCASE_C0_SHIFTOUT_1
    apb_write_read(base_c0+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(base_c0+`MODE_SEL_C0,32'b011,data);//shift out mode.
    //apb_write_read(base_c0+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'd31,data);
      apb_write_read(base_c0+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'd15,data);
     // apb_write_read(base_c0+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h7,data);
     // apb_write_read(base_c0+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h3,data);
     // apb_write_read(base_c0+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h1,data);
     // apb_write_read(base_c0+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h0,data);
    apb_write_read(base_c0+`SHIFTMODE_CTRL_C0,32'h1,data);
    
    apb_write_read(base_c0+`SHIFTOUT_DATA_C0,32'h55aa55aa,data);
 	apb_write(base_c0+`SHIFTOUT_DATA_VALID_C0,32'h0);
    //
    //apb_write_read(base_c0+`TARGET_REG_CTRL_C0,32'b110110,data);
    //apb_write_read(base_c0+`SRC_SEL_EDGE_C0,32'h02110000,data);
    apb_write_read(base_c0+`SRC_SEL_EDGE_C0,32'h12210000,data);
    //
    apb_read (base_c0+`ENABLE_C0,data);
    apb_write(base_c0+`ENABLE_C0,data|32'h0001);//c0,enable.
    //
    //CTRL_SNAP_C0
    apb_read(base_c0+`CTRL_SNAP_C0,data);
    apb_write_read(base_c0+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
    apb_read(base_c0+`SNAP_STATUS_C0,data);
    while(!(|data)) apb_read(base_c0+`SNAP_STATUS_C0,data);
    apb_read(base_c0+`CTRL_SNAP_C0,data);
    apb_write_read(base_c0+`CTRL_SNAP_C0,{~data[31:16],data[15:0]},data);//
    apb_read(base_c0+`SNAP_STATUS_C0,data);
    while((|data)) apb_read(base_c0+`SNAP_STATUS_C0,data);
    //$display("capture register status clear");
    //
    apb_read(base_c0+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(base_c0+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    //
    apb_write_read(base_c0+`SHIFTOUT_DATA_C0,32'h00ff00ff,data);
 	apb_write(base_c0+`SHIFTOUT_DATA_VALID_C0,32'h0);
    while(1) begin
      wait(i_int);
      apb_read(base_c0+`INTR_STATUS,data_1);
      if(|data_1[7:0]) begin
          data_1 = data_1>>8*0;
          apb_write_read(base_c0+`INTR_CLR,data_1,data);
          // CTRL_SNAP_C0
          // apb_read(base_c0+`CTRL_SNAP_C0,data);
          // apb_write_read(base_c0+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
          repeat (2) @(posedge i_pclk);
          if(data_1[4]) begin
              data=$random;
              apb_write_read(base_c0+`SHIFTOUT_DATA_C0,data,data);
              apb_write(base_c0+`SHIFTOUT_DATA_VALID_C0,32'h0);
              $display("new shiftout data = %h",data);
          end
          else begin
              $display("int number is wrong,shiftout mode");            
          end
      end
    end
    
    //
    // #500_000;
   `endif      
   
    `ifdef TESTCASE_C0_SHIFTOUT_2
    apb_write_read(base_c0+`SOFT_TRIGGER_CTRL_C0,32'b000000000,data);
    apb_write_read(base_c0+`MODE_SEL_C0,32'b011,data);//shift out mode.
    apb_write_read(base_c0+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'd31,data);
      // apb_write_read(base_c0+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'd15,data);
     // apb_write_read(base_c0+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h7,data);
     // apb_write_read(base_c0+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h3,data);
     // apb_write_read(base_c0+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h1,data);
     // apb_write_read(base_c0+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,32'h0,data);
    // apb_write_read(base_c0+`SHIFTMODE_CTRL_C0,32'h1,data);
    
    apb_write_read(base_c0+`SHIFTOUT_DATA_C0,32'h55aa55aa,data);
 	apb_write(base_c0+`SHIFTOUT_DATA_VALID_C0,32'h0);
    //
    //apb_write_read(base_c0+`TARGET_REG_CTRL_C0,32'b110110,data);
    //apb_write_read(base_c0+`SRC_SEL_EDGE_C0,32'h02110000,data);
    apb_write_read(base_c0+`SRC_SEL_EDGE_C0,32'h12210000,data);
    //
    apb_read (base_c0+`ENABLE_C0,data);
    apb_write(base_c0+`ENABLE_C0,data|32'h0001);//c0,enable.
    //
    //CTRL_SNAP_C0
    apb_read(base_c0+`CTRL_SNAP_C0,data);
    apb_write_read(base_c0+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
    apb_read(base_c0+`SNAP_STATUS_C0,data);
    while(!(|data)) apb_read(base_c0+`SNAP_STATUS_C0,data);
    apb_read(base_c0+`CTRL_SNAP_C0,data);
    apb_write_read(base_c0+`CTRL_SNAP_C0,{~data[31:16],data[15:0]},data);//
    apb_read(base_c0+`SNAP_STATUS_C0,data);
    while((|data)) apb_read(base_c0+`SNAP_STATUS_C0,data);
    //$display("capture register status clear");
    //
    apb_read(base_c0+`SINGLE_START_TRIGGER_C0,data);//start;
    apb_write_read(base_c0+`SINGLE_START_TRIGGER_C0,~data,data);//start;
    //
    apb_write_read(base_c0+`SHIFTOUT_DATA_C0,32'h00ff00ff,data);
 	apb_write(base_c0+`SHIFTOUT_DATA_VALID_C0,32'h0);
    tmp_i=32'd31;
    while(1) begin
      wait(i_int);
      apb_read(base_c0+`INTR_STATUS,data_1);
      if(|data_1[7:0]) begin
          data_1 = data_1>>8*0;
          apb_write_read(base_c0+`INTR_CLR,data_1,data);
          // CTRL_SNAP_C0
          // apb_read(base_c0+`CTRL_SNAP_C0,data);
          // apb_write_read(base_c0+`CTRL_SNAP_C0,{data[31:4],~data[3:0]},data);//
          repeat (2) @(posedge i_pclk);
          if(data_1[4]) begin
              data_1=$random;
              apb_write_read(base_c0+`SHIFTOUT_DATA_C0,data_1,data);
              apb_write(base_c0+`SHIFTOUT_DATA_VALID_C0,32'h0);
              apb_write_read(base_c0+`SHIFTOUT_DATA_CTRL_BITCNTS_C0,tmp_i--,data);
              $display("new shiftout data = %h,bits=%d",data_1,tmp_i[4:0]);
          end
          else begin
              $display("int number is wrong,shiftout mode");            
          end
      end
    end
    `endif
   
    //
    #500_000;
    stop_event  <= '1;
    $stop;

end




//`ifdef CAPTURE

initial begin
o_extern_din_a = 1'b0;
o_extern_din_b = 1'b0;
forever begin
#20_000;
// repeat (5) @(posedge i_clk);
repeat (1) @(posedge i_clk);
o_extern_din_a = $random;
o_extern_din_b = $random;
end
end

//`endif


initial begin
#6_000_000;
$stop;
end







endmodule
