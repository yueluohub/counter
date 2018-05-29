`timescale 1ns / 1ps 

module bfm_ifc_iso7816_3(
    input wire i_vdd,
    input wire i_clk,
    input wire i_rstn,
    inout wire io_data
);

parameter PARA_F=32'd372,
          PARA_D=32'd1;
            
reg r_flag_activation;
//activation
//deactivation
//cold reset
//warm reset
//clock stop
//data receive/send;

reg r_flag_vdd_on ;
reg tx_data;
reg tx_en;

assign rx_in = io_data;
assign io_data = tx_en ? tx_data : 1'bz;

initial begin
r_flag_vdd_on = 1'b0;
@(posedge i_vdd);
r_flag_vdd_on = 1'b1;
end

wire rst_n;
assign rst_n = r_flag_vdd_on;
reg [31:0] r_io_cnts;//ta;
reg [31:0] r_rst_cnts;//tb;
reg [31:0] r_respone_cnts;//tc;
reg r_rst_flag;
reg r_rst_flag_ok;

always @(posedge i_clk or negedge rst_n)
if(!rst_n) begin
    r_rst_cnts <= 32'h0;
    r_rst_flag_ok <= 1'b0;
end    
else if(!i_rstn) begin
    r_rst_cnts <= r_rst_cnts + 1'b1;
    r_rst_flag_ok <= 1'b0;
end
else if(r_rst_flag)begin
    //r_rst_cnts <= 32'h0;
    if(r_rst_cnts>=32'd400)
        r_rst_flag_ok <= 1'b1;
end

always @(posedge i_clk or negedge rst_n)
if(!rst_n) begin
    r_rst_flag <= 1'b0;
end
else if(i_rstn) begin
    r_rst_flag <= 1'b1;
end

reg r_io_flag_ok;
always @(posedge i_clk or negedge rst_n)
if(!rst_n) begin
    r_io_cnts <= 32'h0;
    r_io_flag_ok <= 1'b0;
end    
else if(!i_rstn) begin
    r_io_flag_ok <= 1'b0;
    if(rx_in)
        r_io_cnts <= r_io_cnts + 1'b1;
    else 
        r_io_cnts <= '0;
end
else begin
    if(r_rst_cnts-r_io_cnts <= 32'd200) 
        r_io_flag_ok <= 1'b1;
    
    r_io_cnts <= '0;
     
end

reg r_flag_tc_ok;

always @(posedge i_clk or negedge rst_n)
if(!rst_n) begin
    r_respone_cnts <= 32'h0;
    r_flag_tc_ok <= 1'b0;
end    
else if(i_rstn) begin
    if(rx_in) begin
        r_respone_cnts <= r_respone_cnts + 1'b1;
        if(r_respone_cnts>=32'd400 &&(r_respone_cnts<=32'd40000) )
            r_flag_tc_ok <= 1'b1;
    end
    else 
        r_respone_cnts <= '0;
end
else begin
    r_respone_cnts <= '0;
    r_flag_tc_ok <= 1'b0;
end

reg r1_flag_activation_dly;
always @(posedge i_clk or negedge rst_n)
if(!rst_n) begin
    r_flag_activation <= 1'b0;
end
else if(r_flag_tc_ok && r_io_flag_ok && r_rst_flag_ok) begin
    r_flag_activation <= 1'b1;
end

always @(posedge i_clk)
    r1_flag_activation_dly <= r_flag_activation;


reg [31:0] tx_data_cnts;
reg [4:0] tx_databits_cnts;    
always @(posedge i_clk or negedge rst_n)
if(!rst_n) begin
    tx_en <= 1'b0;
end
else if(!r1_flag_activation_dly && r_flag_activation) begin
    tx_en <= 1'b1;
end 
else if(tx_databits_cnts==5'd10)
    tx_en <= 1'b0;

reg [7:0] send_data;

always @(posedge i_clk or negedge rst_n)
if(!rst_n) begin
    tx_databits_cnts <= '0;
    tx_data_cnts     <= '0;
end
else if((r_flag_activation&&tx_en) || (!r1_flag_activation_dly && r_flag_activation)) begin
    tx_data_cnts <= tx_data_cnts + 1'b1;
    if(tx_data_cnts==PARA_F) begin
        tx_data_cnts <= '0;
        tx_databits_cnts <= tx_databits_cnts + 1'b1;
    end
end
else begin
        tx_data_cnts <= '0;
        tx_databits_cnts <='0;
end
    
always @(posedge i_clk or negedge rst_n)
if(!rst_n) begin
    tx_data <= 1'b1;
    send_data <= 8'b11011100;
end
else begin
    case(tx_databits_cnts)
    5'h0: tx_data <= 1'b0;
    5'h1: tx_data <= send_data[7];
    5'h2: tx_data <= send_data[6];
    5'h3: tx_data <= send_data[5];
    5'h4: tx_data <= send_data[4];
    5'h5: tx_data <= send_data[3];
    5'h6: tx_data <= send_data[2];
    5'h7: tx_data <= send_data[1];
    5'h8: tx_data <= send_data[0];
    5'h9: tx_data <= ^send_data;
    default:tx_data <= 1'b1;
    endcase
end

reg [31:0] rx_data_cnts;
reg [31:0] rx_data_valid1_cnts;
reg [31:0] rx_databits_cnts;
reg rx_data_en;
reg rx_in_dly;
always @(posedge i_clk)
    rx_in_dly <= rx_in;

always @(posedge i_clk or negedge rst_n)
if(!rst_n) begin
    
    rx_data_en <= 1'b0;
end
else if(!tx_en) begin
    if(rx_in_dly&&rx_in) begin
        rx_data_en <= 1'b1;
    end
end

reg [9:0] rx_data;
    
always @(posedge i_clk or negedge rst_n)
if(!rst_n) begin
   rx_data <= 8'b0;
   rx_data_cnts <= '0;
   rx_databits_cnts <= '0;
   rx_data_valid1_cnts <= '0;
end 
else if(rx_data_en) begin
    rx_data_cnts <= rx_data_cnts + 1'b1;
    if(rx_in)
        rx_data_valid1_cnts <= rx_data_valid1_cnts + 1'b1;
    if(rx_data_cnts==PARA_F) begin
        rx_data_valid1_cnts <= '0;
        rx_databits_cnts <= rx_databits_cnts + 1'b1;
        if(rx_data_valid1_cnts>=(PARA_F>>1))
            rx_data <= {rx_data[8:0],1'b1};
        else
            rx_data <= {rx_data[8:0],1'b0};
    end
end 





endmodule
 