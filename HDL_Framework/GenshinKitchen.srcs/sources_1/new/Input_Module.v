`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Dong
// 
// Create Date: 2023/11/26 21:14:19
// Design Name: 
// Module Name: Led2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: UNTESTED MODULE
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module UnPackSignal(
input clk,
input dataOut_valid,
input [7:0] dataOut_bits,
output reg [3:0] led
);
reg [1:0] channal;
always @(posedge clk) begin
    if(!dataOut_valid)
        led <= 4'b0000;
    else begin
        led <= dataOut_bits[5:2];
    end
end
endmodule

