`timescale 1ns / 1ps
/*
Author: Dong
Description:Input module basically deal with the input siganl(Or output) form the software,
it cantains modules encoding the signal  used for scripts
and modules converting the signal to led signals
*/
parameter ignore = 2'b00;
parameter feedback = 2'b00;
parameter script_loading = 2'b00;
parameter unused = 2'b00;
module Receiver (
    input clk,
    input script_mode,
    input dataOut_ready,
    input [7:0] dataOut_bits,
    output [7:0] led
);
    wire [1:0] verify;
    wire [1:0] channal;
    wire [3:0] signal;
    GetInfo getInfo(clk, dataOut_ready, dataOut_bits, verify, channal, signal);
    FeedbackSignal feedbackSignal(clk, script_mode, dataOut_ready, dataOut_bits, led);
    
endmodule

/*
Author: Dong
Module FeedbackSignal function: unpack the signal and output the led signals
rightmost led: traveler is in front of target machine
(rightmost - 1) led: traveler has item in hand
(rightmost - 2) led: target machine is processing
(rightmost - 3) led: target machine has item
*/
module FeedbackSignal(
input clk,
input script_mode,
input dataOut_ready,
input [7:0] dataOut_bits,
output reg [7:0] led
);
wire [1:0] verify;
wire [1:0] channal;
wire [3:0] signal;

GetInfo get(clk, dataOut_ready, dataOut_bits, verify, channal, signal);

always @(posedge clk) begin
    
    if(dataOut_ready)
        if(script_mode != 1'b1)
            if(verify == 2'b00)
                if(channal == 2'b01) begin
                    led <= {4'b0000, signal};
                end
    else 
        // fantastic effiects to be added
        led <= 8'b0000_0000;
end
endmodule


/*
Author: Dong
Module GetInfo returns few states that can be edcoded from signals from software
*/
module GetInfo (
    input clk,
    input dataOut_ready,
    input [7:0] dataOut_bits,
    output reg [1:0] verify,
    output reg [1:0] channal,
    output reg [3:0] signal
);
always @(posedge clk) begin
    verify <= dataOut_bits[7:6];
    channal <= dataOut_bits[1:0];
    signal <= dataOut_bits[5:2];
end
endmodule