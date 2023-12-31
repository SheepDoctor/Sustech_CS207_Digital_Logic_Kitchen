`timescale 1ns / 1ps
`include "constants.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/22 21:08:57
// Design Name: 
// Module Name: seven_segment_tube
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
this module aims to show 16 bits machine code when script mode
and "CS207AAA" when user mode
in seven segment tube
notes: 
when script mode
the first two seven segment tube show code[15:8] in decimal(no more than 20) 
the next seven segment tube shows code[7:5] in decimal
last five seven segment tube show code[4:0] respectly
*/
module seven_segment_tube(
input switchMode,
input [15:0] code,
input clk,
output [3:0]tub_sel1,// 4'b1000 or 4'b0100 or 4'b0010 or 4'b0001
output [3:0]tub_sel2,// 4'b1000 or 4'b0100 or 4'b0010 or 4'b0001
output reg [7:0] tub_control1,
output reg [7:0] tub_control2
    );
reg [3:0]state1;
reg [3:0]state2;
assign tub_sel1 = state1;
assign tub_sel2 = state2;
initial begin
{state1,state2} = {`tub1,`tub1};
end
always@(posedge clk) begin
if(switchMode) begin // if script mode, show 16 bits machine code

case({state1,state2})
{`tub1,`tub1}:begin
if(code[15:8]>9) tub_control1 = 8'b0110_0000; else tub_control1 = 8'b1111_1100;// if code[15:8] more than 9, tube[1] = 1 (*the first seven segment tube shows "1"*), otherwise 0
if(code[3]) tub_control2 = 8'b0110_0000; else tub_control2 = 8'b1111_1100; // tube[5] = code[3]
{state1,state2} = {`tub2,`tub2};// 8'b1000_1000
end
{`tub2,`tub2}:begin
case(code[15:8])// tube[2] = the second bit of code[15:8](indecimal)
6'b000001:tub_control1 = 8'b0110_0000;
6'b000010:tub_control1 = 8'b1101_1010;
6'b000011:tub_control1 = 8'b1111_0010;
6'b000100:tub_control1 = 8'b0110_0110;
6'b000101:tub_control1 = 8'b1011_0110; 
6'b000110:tub_control1 = 8'b1011_1110;
6'b000111:tub_control1 = 8'b1110_0000;
6'b001000:tub_control1 = 8'b1111_1110; 
6'b001001:tub_control1 = 8'b1110_0110;
6'b001011:tub_control1 = 8'b0110_0000;
6'b001100:tub_control1 = 8'b1101_1010;
6'b001101:tub_control1 = 8'b1111_0010;
6'b001110:tub_control1 = 8'b0110_0110;
6'b001111:tub_control1 = 8'b1011_0110; 
6'b010000:tub_control1 = 8'b1011_1110;
6'b010001:tub_control1 = 8'b1110_0000;
6'b010010:tub_control1 = 8'b1111_1110; 
6'b010011:tub_control1 = 8'b1110_0110;
default:tub_control1 = 8'b1111_1100;
endcase
if(code[2]) tub_control2 = 8'b0110_0000; else tub_control2 = 8'b1111_1100; // tube[6] = code[2]
{state1,state2} = {`tub3,`tub3};// 8'b0100_0100
end
{`tub3,`tub3}:begin
case(code[7:5]) // tube[3] = code[7:5](in decimal)
3'b000:tub_control1 = 8'b1111_1100; 
3'b001:tub_control1 = 8'b0110_0000;
3'b010:tub_control1 = 8'b1101_1010; 
3'b011:tub_control1 = 8'b1111_0010;
default:tub_control1 = 8'b1001_1110; 
endcase
if(code[1]) tub_control2 = 8'b0110_0000; else tub_control2 = 8'b1111_1100;// tube[7] = code[1]
{state1,state2} = {`tub4,`tub4};// 8'b0010_0010
end
{`tub4,`tub4}:begin
if(code[4]) tub_control1 = 8'b0110_0000; else tub_control1 = 8'b1111_1100;// tube [4] = code[4]
if(code[0]) tub_control2 = 8'b0110_0000; else tub_control2 = 8'b1111_1100;// tube[8] = code[0]
{state1,state2} = {`tub1,`tub1};// 8'b0001_0001
end
endcase
end

else // if user mode, show "CS207AAA"
case({state1,state2})
{`tub1,`tub1}:begin
{tub_control1,tub_control2} = {8'b1001_1100,8'b1110_0000};// tube[1] = C, tube[5] = 7
{state1,state2} = {`tub2,`tub2};
end
{`tub2,`tub2}:begin
{tub_control1,tub_control2} = {8'b1011_0110,8'b1110_1110};// tube[2] = S, tube[6] = A
{state1,state2} = {`tub3,`tub3};
end
{`tub3,`tub3}:begin
{tub_control1,tub_control2} = {8'b1101_1010,8'b1110_1110};// tube[3] = 2, tube[7] = A
{state1,state2} = {`tub4,`tub4};
end
{`tub4,`tub4}:begin
{tub_control1,tub_control2} = {8'b1111_1100,8'b1110_1110};// tube[4] = 0, tube[8] = A
{state1,state2} = {`tub1,`tub1};
end
endcase
end
endmodule

