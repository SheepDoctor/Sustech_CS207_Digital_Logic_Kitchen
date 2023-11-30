`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/26 21:14:19
// Design Name: 
// Module Name: Led2
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


module Led2(
input [7:0] dataOut_bits,
output [7:0] led2
    );
    assign led2 = dataOut_bits;
    //to be done
endmodule
