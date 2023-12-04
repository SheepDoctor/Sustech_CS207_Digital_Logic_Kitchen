`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/23 14:52:41
// Design Name: 
// Module Name: Input_sim
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


module Input_sim();
reg [4:0] button;
reg [7:0] switches;
reg clk;
wire [7:0] dataIn_bits;
Input_Module input1(
    .button(button), 
    .switches(switches), 
    .clk(clk), 
    .dataIn_bits(dataIn_bits) // client signal
    );
initial begin
        clk = 1'b0;
    forever begin
        #10 clk = ~clk;
    end
end
initial fork
    #15 switches = 8'b0100_0000;
    #45 switches = 8'b1000_0000;
    #75 switches = 8'b1100_0000;
    #100 $finish;
join
endmodule
