`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/09 13:51:42
// Design Name: 
// Module Name: sim_output
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

module sim_output(

    );
    reg clk,rst_n,dataIn_ready,dataOut_ready,dataOut_valid;
    reg [7:0] switches;
    reg [4:0] button;
    reg [7:0] dataOut_bits;
    wire [7:0]dataIn_bits;
    Output tb(clk,switches,button,dataIn_ready, rst_n,dataOut_bits,dataOut_valid,dataIn_bits);
    initial #70 $finish;
    initial begin
    clk = 1'b0;
    rst_n = 1'b0;
    dataIn_ready = 1'b1;
    dataOut_ready = 1'b1;
    dataOut_valid = 1'b1;
    button = 5'b00000;
    forever #1 clk = ~clk;
    end
    initial fork
    switches = 8'b0000_0000;
    #1 rst_n = 1'b1;
    #3 switches = 8'b0100_0000;
    #35 switches = 8'b1011_0000;
    #40 switches = 8'b0100_0000;
    #47 switches = 8'b0100_0011;
    join
endmodule
