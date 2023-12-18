`timescale 1ns / 1ps
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

//transfer clk into uart_clk
module clock_frequency_divider(
input clk,
output reg uart_clk, 
output reg slow_clk
//maybe write other clks here
    );
parameter period1 = 650, period2 = 10000000;    // 100000000/650 Hz stable and 10Hz stable
reg [15:0] count1;// 16 bits counter for dividing frequency
reg [31:0] count2; 
initial begin
count1<=0;
uart_clk<=0;
end
always @ (posedge clk) begin
if(count1==(period1>>1)-1) begin
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
if(count2==(period2>>1)-1) begin
slow_clk <= ~slow_clk; // invert clock
count2<=0;
end 
else begin
count2 <= count2+1;
end
end
endmodule
