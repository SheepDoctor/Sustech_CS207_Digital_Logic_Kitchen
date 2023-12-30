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


module modeSwitcher(
input [7:0]dataIn_user,
input [7:0]dataIn_script,
input switchMode,
output [7:0]dataIn_bits
);
assign dataIn_bits = (switchMode)? dataIn_script : dataIn_user;
endmodule

