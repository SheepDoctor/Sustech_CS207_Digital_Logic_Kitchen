`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/22/2023 10:37:02 PM
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


`timescale 1ns / 1ps
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


module seven_segment_tube(
input switchMode,
input [15:0] code,
input clk,
output [3:0]tub_sel1,
output [3:0]tub_sel2,
output reg [7:0] tub_control1,
output reg [7:0] tub_control2
    );
reg [3:0]state1;
reg [3:0]state2;
assign tub_sel1 = state1;
assign tub_sel2 = state2;
parameter tub1=4'b0001,tub2=4'b1000,tub3=4'b0100,tub4=4'b0010;
initial begin
{state1,state2} = {tub1,tub1};
end
always@(posedge clk) begin
if(switchMode) begin

case({state1,state2})
{tub1,tub1}:begin
if(code[15:8]>9) tub_control1 = 8'b0110_0000; else tub_control1 = 8'b1111_1100;
if(code[3]) tub_control2 = 8'b0110_0000; else tub_control2 = 8'b1111_1100;
{state1,state2} = {tub2,tub2};
end
{tub2,tub2}:begin
case(code[15:8])
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
if(code[2]) tub_control2 = 8'b0110_0000; else tub_control2 = 8'b1111_1100;
{state1,state2} = {tub3,tub3};
end
{tub3,tub3}:begin
case(code[7:5])
3'b000:tub_control1 = 8'b1111_1100; 
3'b001:tub_control1 = 8'b0110_0000;
3'b010:tub_control1 = 8'b1101_1010; 
3'b011:tub_control1 = 8'b1111_0010;
default:tub_control1 = 8'b1001_1110; 
endcase
if(code[1]) tub_control2 = 8'b0110_0000; else tub_control2 = 8'b1111_1100;
{state1,state2} = {tub4,tub4};
end
{tub4,tub4}:begin
if(code[4]) tub_control1 = 8'b0110_0000; else tub_control1 = 8'b1111_1100;
if(code[0]) tub_control2 = 8'b0110_0000; else tub_control2 = 8'b1111_1100;
{state1,state2} = {tub1,tub1};
end
endcase
end

else
case({state1,state2})
{tub1,tub1}:begin
{tub_control1,tub_control2} = {8'b1001_1100,8'b1110_0000};
{state1,state2} = {tub2,tub2};
end
{tub2,tub2}:begin
{tub_control1,tub_control2} = {8'b1011_0110,8'b1110_1110};
{state1,state2} = {tub3,tub3};
end
{tub3,tub3}:begin
{tub_control1,tub_control2} = {8'b1101_1010,8'b1110_1110};
{state1,state2} = {tub4,tub4};
end
{tub4,tub4}:begin
{tub_control1,tub_control2} = {8'b1111_1100,8'b1110_1110};
{state1,state2} = {tub1,tub1};
end
endcase
end
endmodule


