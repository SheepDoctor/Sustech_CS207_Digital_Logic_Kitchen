`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/07 13:02:04
// Design Name: 
// Module Name: reset
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


module reset(
input clk,
input dataIn_ready,
output reg [7:0] dataIn_bits
    );
always @(posedge clk, negedge dataIn_ready) begin
if(~dataIn_ready) dataIn_bits <= 8'b0000_0000;
end
endmodule

module set_ready(
input clk,
input rst_n,
output reg dataIn_ready
);
always @(posedge clk,negedge rst_n) begin
if(~rst_n) dataIn_ready <= 1'b1;
end
endmodule
