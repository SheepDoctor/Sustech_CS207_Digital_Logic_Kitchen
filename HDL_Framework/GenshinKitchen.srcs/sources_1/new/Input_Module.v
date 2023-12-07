`timescale 1ns / 1ps
/*
Author: Dong
Module UnPackSignal finction: unpack the signal and output the led signals
rightmost led: traveler is in front of target machine
(rightmost - 1) led: traveler has item in hand
(rightmost - 2) led: target machine is processing
(rightmost - 3) led: target machine has item
*/
module UnPackSignal(
input clk,
input dataOut_ready,
input [7:0] dataOut_bits,
output reg [7:0] led
);
wire [1:0] verify;
wire [1:0] channal;
wire [3:0] signal;

assign verify = dataOut_bits[7:6];
assign channal = dataOut_bits[1:0];
assign signal = dataOut_bits[5:2];
always @(posedge clk) begin
    
    if(dataOut_ready)
        if(verify == 2'b00)
            if(channal == 2'b01) begin
                led <= {4'b0000, signal};
            end
    else 
        // fantastic effiects to be added
        led <= 8'b0000_0000;
end
endmodule

