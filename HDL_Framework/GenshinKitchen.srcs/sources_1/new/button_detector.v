`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/18 17:21:14
// Design Name: 
// Module Name: button_detector
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


module button_shifter(
input clk,
input button,
output detect
    );
wire Q1;
wire Q2;
D_ff d1(clk,button,Q1);
D_ff d2(clk,Q1,Q2);
assign detect = Q1&~Q2;
endmodule

module D_ff(
input clk,
input D,
output reg Q
);
always @(posedge clk) Q <= D;
endmodule
