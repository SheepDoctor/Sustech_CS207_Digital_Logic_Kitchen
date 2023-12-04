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
output reg uart_clk 
//maybe write other clks here
    );
parameter period = 650;    // 100000000/650 Hz stable
reg [15:0] count; // 16 bits counter for dividing frequency
initial begin
count<=0;
uart_clk<=0;
end
always @ (posedge clk) begin
if(count==(period>>1)-1) begin
uart_clk <= ~uart_clk; // invert clock
count<=0;
end 
else begin
count <= count+1;
end
end
endmodule
