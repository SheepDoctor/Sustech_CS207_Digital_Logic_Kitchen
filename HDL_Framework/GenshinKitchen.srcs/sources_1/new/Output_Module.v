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
    input dataIn_ready,
    input rst_n,
    input [7:0] dataOut_bits,
    input dataOut_valid,
    output reg [7:0]dataIn_bits
);
parameter S_start = 3'b000,S_end = 3'b001,S_action = 3'b010;
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
else if(button[0]) {n_state,dataIn_bits} = {S_action,8'b0000_0110};
else if(button[1]) {n_state,dataIn_bits} = {S_action,8'b0000_1010};
else if(button[2]) {n_state,dataIn_bits} = {S_action,8'b0001_0010};
else if(button[3]) {n_state,dataIn_bits} = {S_action,8'b0010_0010};
else if(button[4]) {n_state,dataIn_bits} = {S_action,8'b0100_0010};
else {n_state,dataIn_bits} = {S_action,switches[5:0],2'b11};
end

endcase
end
endmodule
