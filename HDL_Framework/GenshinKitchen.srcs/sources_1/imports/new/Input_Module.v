`timescale 1ns / 1ps
/*
Author: Dong
Description:Input module basically deal with the input siganl(Or output) form the software,
it cantains modules encoding the signal  used for scripts
and modules converting the signal to led signals
*/

module Receiver (
    input clk,
    input dataOut_ready,
    input [7:0] dataOut_bits,
    output [7:0] led,
    output [7:0] size
);
    wire [3:0] signal;
    wire [1:0] verify;
    wire [1:0] channal;
    GetInfo get(
        .clk(clk), 
        .dataOut_ready(dataOut_ready), 
        .dataOut_bits(dataOut_bits), 
        .verify(verify), 
        .channal(channal), 
        .signal(signal));
    // 01 channel: Feedback signal from Client to Board
    FeedbackSignal feedbackSignal(
        .clk(clk), 
        .dataOut_ready(dataOut_ready), 
        .dataOut_bits(dataOut_bits), 
        .led(led),
        .verify(verify),
        .channal(channal),
        .signal(signal));
    // 10 channel: Change into Script loading mode
    ScriptLoadingMode scriptLoadingMode(
        .clk(clk), 
        .dataOut_ready(dataOut_ready), 
        .dataOut_bits(dataOut_bits), 
        .led2(led),
        .size(size),
        .verify(verify),
        .channal(channal),
        .signal(signal));
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
input [1:0] verify,
input [1:0] channal,
input [3:0] signal,
output reg [7:0] led
);

always @(posedge dataOut_ready) begin
    if(dataOut_ready)
        if(verify == 2'b00) begin
            if(channal == 2'b01) begin
                led <= {4'b0000, signal};
            end
        end
    else 
        // fantastic effiects to be added
        led <= 8'b0000_0000;
end

endmodule

module ScriptLoadingMode (
    input clk,
    input dataOut_ready,
    input [7:0] dataOut_bits,
    input [1:0] verify,
    input [1:0] channal,
    input [3:0] signal,
    output reg [7:0] led2,
    output reg [7:0] size
);
always @(posedge dataOut_ready) begin
    if(dataOut_ready)
        if(channal == 2'b10) begin
            led2 <= dataOut_bits;
        end
    else 
        led2 <= 8'b0000_0000;
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
    output [1:0] verify,
    output [1:0] channal,
    output [3:0] signal
);
    assign verify = dataOut_bits[7:6];
    assign signal = dataOut_bits[5:2];
    assign channal = dataOut_bits[1:0];
endmodule