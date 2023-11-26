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
    output reg [7:0] dataIn_bits = 8'b0000_0001
    );
    always @(posedge clk) begin
        dataIn_bits[3:2] <= switches[7:6]; // switch
    end
endmodule
