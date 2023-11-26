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
output uart_clk
//maybe write other clks here
    );
    assign uart_clk = clk;//guess
    //to be done
endmodule
