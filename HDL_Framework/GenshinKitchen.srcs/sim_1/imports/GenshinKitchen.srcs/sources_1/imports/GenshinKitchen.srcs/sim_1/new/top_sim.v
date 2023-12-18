`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/30 17:22:07
// Design Name: 
// Module Name: top_sim
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


module top_sim();
    reg [4:0] button;
    reg [7:0] switches;
    reg clk, rx;
    wire [7:0] led;
    wire [7:0] led2;
    wire tx;
    DemoTop demo(
    .button(button),
    .switches(switches),

    .led(led),
    .led2(led2),
    
    .clk(clk),
    .rx(rx),
    .tx(tx)
    );

    initial begin
        rx = 1'b1;
        clk = 1'b0;
        button = 4'b0000;
        switches = 8'b0000_0000;
        repeat(255) begin
            #10 switches = switches + 8'b0000_0001;
        end
        #10 $finish();
    end
    initial begin
        forever begin
            #10 clk = ~clk;
        end
    end
endmodule
