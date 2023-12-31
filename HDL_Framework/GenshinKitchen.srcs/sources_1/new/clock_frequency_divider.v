`timescale 1ns / 1ps
`include "constants.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/24 10:59:11
// Design Name: 
// Module Name: clock_frequency_divider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
/*
this module aims to transfer (100MHz)clk into uart_clk and other clks
*/
module clock_frequency_divider(
input clk,
output reg uart_clk,// clk for uart and script module(about 153800Hz)
output reg slow_clk,// clk for output module(10Hz)
output reg tube_clk // clk for seven segment tube(200Hz)
    );
// 16 or 32 bits counter for dividing frequency    
reg [15:0] count1;
reg [31:0] count2; 
reg [31:0] count3; 
initial begin
count1<=0;
uart_clk<=0;
end
always @ (posedge clk) begin
if(count1==(`period1>>1)-1) begin
uart_clk <= ~uart_clk; // invert clock
count1<=0;
end 
else begin
count1 <= count1+1;
end
end

initial begin
count2<=0;
slow_clk<=0;
end
always @ (posedge clk) begin
if(count2==(`period2>>1)-1) begin
slow_clk <= ~slow_clk; // invert clock
count2<=0;
end 
else begin
count2 <= count2+1;
end
end

initial begin
count3<=0;
tube_clk<=0;
end
always @ (posedge clk) begin
if(count3==(`period3>>1)-1) begin
tube_clk <= ~tube_clk; // invert clock
count3<=0;
end 
else begin
count3 <= count3+1;
end
end
endmodule
