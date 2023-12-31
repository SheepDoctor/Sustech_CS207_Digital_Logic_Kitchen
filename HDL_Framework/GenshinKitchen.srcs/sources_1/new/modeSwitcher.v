`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/29/2023 10:55:32 PM
// Design Name: 
// Module Name: modeSwitcher
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
this module aims to judge current mode and output dataIn_bits
*/
module modeSwitcher(
input [7:0]dataIn_user,// data from output module
input [7:0]dataIn_script,// data from script module
input switchMode, // 1'b1 for script mode, 1'b0 for user mode
output [7:0]dataIn_bits // dataIn_bits for uart module 
);
assign dataIn_bits = (switchMode)? dataIn_script : dataIn_user; // judge the mode
endmodule


