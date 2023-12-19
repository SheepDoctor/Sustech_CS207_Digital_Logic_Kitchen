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

// show feedback signal
module Led2(
input dataIn_ready,
input dataOut_ready,
output [7:0] led2
    );
assign led2[7] = dataIn_ready;
assign led2[6] = dataOut_ready;
    //to be done
endmodule

module Led1(
    input [7:0] dataIn_bits,
    output [7:0] led
    );
    assign led = dataIn_bits;
endmodule