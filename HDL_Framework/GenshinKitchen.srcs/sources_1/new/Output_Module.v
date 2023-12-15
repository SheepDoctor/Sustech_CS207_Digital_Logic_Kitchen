`timescale 1ns / 1ps
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

// control the beginning and the ending of the game
module Output(
    input clk,
    input [7:0] switches,
    input [4:0] button,
    input rst_n,
    input [3:0] led,
    output reg [7:0]dataIn_bits
);
parameter S_start = 3'b000,S_end = 3'b001,S_action = 3'b010,S_target = 3'b011;
reg [2:0] state;
reg [2:0] n_state;
always @(posedge clk, negedge rst_n) begin
    if(~rst_n)
    state <= S_end; 
    else
    state <= n_state;
end

always@(state,switches,button) begin
case(state)

S_end:
if(~switches[7]&switches[6]) {n_state,dataIn_bits} = {S_start,8'b0000_0101};
else {n_state,dataIn_bits} = {S_end,8'b0000_1001};

S_start:
if(switches[7]&~switches[6]) {n_state,dataIn_bits} = {S_end,8'b0000_1001};
else if((~switches[7]&switches[6])|(switches[7]&switches[6])) {n_state,dataIn_bits} = {S_start,8'b0000_0101};
else n_state = S_action;

S_action:
begin
if(switches[7]&~switches[6]) {n_state,dataIn_bits} = {S_end,8'b0000_1001};
else if(led[0]&led[1]&~led[3]&button[0]) {n_state,dataIn_bits} = {S_action,8'b0000_0110};//get
else if(led[0]&led[1]&button[1]) {n_state,dataIn_bits} = {S_action,8'b0000_1010};//put
else if(button[0]) {n_state,dataIn_bits} = {S_action,8'b0001_0010};//move
else if(led[0]&button[3]) {n_state,dataIn_bits} = {S_action,8'b0010_0010};//interact
else if((button==9|button==11|button==14|button==17|button==19|button==20)&led[1]&button[4]) {n_state,dataIn_bits} = {S_action,8'b0100_0010};//throw
else {n_state,dataIn_bits} = {S_target,8'b0000_0010};
end

S_target:
begin
if(switches[7]&~switches[6]) {n_state,dataIn_bits} = {S_end,8'b0000_1001};
else if(switches[5:0]>20) {n_state,dataIn_bits} = {S_target,8'b0000_0011};
else if(button>0) n_state = S_action;
else {n_state,dataIn_bits} = {S_target,switches[5:0],2'b11};
end

endcase
end
endmodule
