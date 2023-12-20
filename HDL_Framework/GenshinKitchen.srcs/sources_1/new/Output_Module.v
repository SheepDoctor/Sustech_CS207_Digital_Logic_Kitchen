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
    input button_get,
    input button_put,
    output reg [1:0]count1,
    output reg [1:0]count2,
    output reg [7:0]dataIn_bits
);
parameter S_start = 3'b000,S_end = 3'b001,S_action = 3'b010,S_target = 3'b011,has = 1'b1, no = 1'b0;
reg [2:0] state;
reg [2:0] n_state;
reg [1:0]count3;
reg [1:0]count4;
reg [1:0]count5;
reg now;
reg next;
reg button1,button2;
reg lEd;

always @(posedge clk, negedge rst_n) begin
    if(~rst_n) begin
    now <= no; 
    lEd <= 1'b0;
    end
    else
    now <= next;
    lEd <= led[1];
end

always@(lEd) begin
case(now)
no:
if(lEd) begin
if(switches==10) {next,count1}={has,count1-1};
else if(switches==12) {next,count2}={has,count2-1};
else if(switches==13) {next,count3}={has,count3-1};
else if(switches==15) {next,count4}={has,count4-1};
else if(switches==16) {next,count5}={has,count5-1};
end
else next = no;
has:
if(~lEd) begin
if(switches==10) {next,count1}={no,count1+1};
else if(switches==12) {next,count2}={no,count2+1};
else if(switches==13) {next,count3}={no,count3+1};
else if(switches==15) {next,count4}={no,count4+1};
else if(switches==16) {next,count5}={no,count5+1};
end
else next = has;
endcase
end

always @(posedge clk, negedge rst_n) begin
    if(~rst_n) begin
    state <= S_end; 
    end
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

else if(led[0]&~led[1]&led[3]&button[0]) {n_state,dataIn_bits} = {S_action,8'b0000_0110};//get

else if(switches[5:0]>6&led[0]&led[1]&button[1]) begin
if(~led[3]|(switches==9|switches==11|switches==14|switches==17|switches==19)) {n_state,dataIn_bits} = {S_action,8'b0000_1010};//put
else begin
if(switches==10&~count1==2'b11) {n_state,dataIn_bits} = {S_action,8'b0000_1010};
else if(switches==12&~count2==2'b11) {n_state,dataIn_bits} = {S_action,8'b0000_1010};
else if(switches==13&~count3==2'b11) {n_state,dataIn_bits} = {S_action,8'b0000_1010};
else if(switches==15&~count4==2'b11) {n_state,dataIn_bits} = {S_action,8'b0000_1010};
else if(switches==16&~count5==2'b11) {n_state,dataIn_bits} = {S_action,8'b0000_1010};
else {n_state,dataIn_bits} = {S_target,8'b0000_0010};
end
end

else if(led[0]&button[2]) {n_state,dataIn_bits} = {S_action,8'b0001_0010};//interact
else if(button[3]) {n_state,dataIn_bits} = {S_action,8'b0010_0010};//move
else if((switches[5:0]==9|switches[5:0]==11|switches[5:0]==14|switches[5:0]==17|switches[5:0]==19|switches[5:0]==20)&led[1]&button[4]) {n_state,dataIn_bits} = {S_action,8'b0100_0010};//throw
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
