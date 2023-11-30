`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/23 14:17:04
// Design Name: 
// Module Name: Input_Module
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


module Begin_End(
    input [4:0] button,
    input [7:0] switches,
    input clk,
    output reg [7:0] dataIn_bits
    );
    always @(posedge clk) begin
    dataIn_bits = {4'b0000,switches[7:6],2'b01};
    end
endmodule
