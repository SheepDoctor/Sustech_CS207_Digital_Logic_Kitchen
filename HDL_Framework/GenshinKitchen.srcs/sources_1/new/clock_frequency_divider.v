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


module clock_frequency_divider(
input clk,
output reg uart_clk 
//maybe write other clks here
    );
    
reg [15:0] count; // 16 bits counter for dividing frequency
always @ (posedge clk) begin
if(count==325)begin
uart_clk <= ~uart_clk; // 切换时钟边沿以生成50%占空比
count<=0;
end else begin
count <= count+1;
end
end
endmodule
