`timescale 1ns / 1ps
`include "constants.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/23 14:17:04
// Design Name: 
// Module Name: Input_Module
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

/*
this module aims to output dataIn_bits(dataIn_user)
notes:
for led[3:0]
led[0]: in front of the target machine
led[1]:
led[2]:
led[3]: there is item in target machine
*/
module Output(
    input clk,
    input [7:0] switches,
    input [4:0] button,
    input rst_n,
    input [3:0] led,// signal for judging legality 
    output reg [7:0]dataIn_bits // dataIn_user
);
reg [2:0] state;
reg [2:0] n_state;

always @(posedge clk, negedge rst_n) begin
    if(~rst_n) begin
    state <= `S_end; 
    end
    else
    state <= n_state;
end

always@(state,switches,button) begin
case(state)

`S_end:// game not start (initial state)
if(~switches[7]&switches[6]) {n_state,dataIn_bits} = {`S_start,8'b0000_0101};// game start
else {n_state,dataIn_bits} = {`S_end,8'b0000_1001};

`S_start:// enter this state after outputing the game start signal, in this state, there will be no reaction when changing switches or buttons
if(switches[7]&~switches[6]) {n_state,dataIn_bits} = {`S_end,8'b0000_1001};// game end
else if((~switches[7]&switches[6])|(switches[7]&switches[6])) {n_state,dataIn_bits} = {`S_start,8'b0000_0101};
else n_state = `S_action; // when switches[7:6] = 2'b00, change state

`S_action:// state for get/put/interact/move/throw
begin
if(switches[7]&~switches[6]) {n_state,dataIn_bits} = {`S_end,8'b0000_1001};// game end

else if(led[0]&~led[1]&led[3]&button[0]) {n_state,dataIn_bits} = {`S_action,8'b0000_0110};//judge: if in front of the machine and no item in hand and machine has item, get

else if(switches[5:0]>6&led[0]&led[1]&button[1]) begin // judge: legal target machine and in front of the machine and has item in hand
if(~led[3]) {n_state,dataIn_bits} = {`S_action,8'b0000_1010};// if there is no item in target machine, put
else if(switches==9|switches==10|switches==11|switches==12|switches==13|switches==14|switches==15|switches==16|switches==17|switches==19) {n_state,dataIn_bits} = {`S_action,8'b0000_1010};// if target machine is among these machines, put
end

else if(led[0]&button[2]) {n_state,dataIn_bits} = {`S_action,8'b0001_0010};//judge: if in front of the machine interact
else if(button[3]) {n_state,dataIn_bits} = {`S_action,8'b0010_0010};// move(no need for judge)
else if((switches[5:0]==9|switches[5:0]==11|switches[5:0]==14|switches[5:0]==17|switches[5:0]==19|switches[5:0]==20)&led[1]&button[4]) {n_state,dataIn_bits} = {`S_action,8'b0100_0010};// judge: if target machine is among these machines and has item in hand, throw
else {n_state,dataIn_bits} = {`S_target,8'b0000_0010};// reset signal in 10 channel, otherwise, you can't double move/put/get/interact/throw
end

`S_target:// state for choosing target machine
begin
if(switches[7]&~switches[6]) {n_state,dataIn_bits} = {`S_end,8'b0000_1001};// game end 
else if(switches[5:0]>20) {n_state,dataIn_bits} = {`S_target,8'b0000_0011};// judge legality(the number of target machine can't be more than 20)
else if(button>0) n_state = `S_action;
else {n_state,dataIn_bits} = {`S_target,switches[5:0],2'b11};// choose target machine
end

endcase
end
endmodule
