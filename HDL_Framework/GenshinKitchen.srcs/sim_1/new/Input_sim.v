`timescale 1ns / 1ps
/*
Author: Dong 
Sim for UnPackSignal module
*/
module Input_sim();
    reg clk;
    reg dataOut_ready;
    reg [7:0] dataOut_bits;
    wire [7:0] led;
    UnPackSignal us(clk, dataOut_ready, dataOut_bits, led);

    initial fork
        clk <= 1'b0;
        dataOut_ready <= 1'b0;
        dataOut_bits <= 8'b0000_0001;
        #5 dataOut_ready <= 1'b1;
        forever begin
            #5 clk = ~clk;
        end
        #15 dataOut_bits <= 8'b0000_0101;
        #30 dataOut_bits <= 8'b0000_1001;
        #45 dataOut_bits <= 8'b0001_0001;
        #60 dataOut_bits <= 8'b0010_0001;
        #100 $finish;
    join
endmodule
