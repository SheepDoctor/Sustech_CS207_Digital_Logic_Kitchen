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
parameter S_start = 3'b000,S_end = 3'b001;
reg [2:0] state;
reg [2:0] n_state;
always @(posedge clk, negedge rst_n) begin
    if(~rst_n) 
    n_state <= S_end;
    else
    state <= n_state;
end

always@(switches,button) begin
case(state)

S_end:
if(~switches[7]&switches[6]) {n_state,dataIn_bits} = {S_start,8'b0000_0101};
else {n_state,dataIn_bits} = {S_end,8'b0000_0000};

S_start:
if(switches[7]&~switches[6]) {n_state,dataIn_bits} = {S_end,8'b0000_1001};
else if(button[0]) {n_state,dataIn_bits} = {S_start,8'b0000_0110};
else if(button[1]) {n_state,dataIn_bits} = {S_start,8'b0000_1010};
else if(button[2]) {n_state,dataIn_bits} = {S_start,8'b0001_0010};
else if(button[3]) {n_state,dataIn_bits} = {S_start,8'b0010_0010};
else if(button[4]) {n_state,dataIn_bits} = {S_start,8'b0100_0010};
else {n_state,dataIn_bits} = {S_switches[5:0],2'b11};

endcase
end
  /*  parameter S0 = 2'b00, S_start = 2'b01,In_Start = 8'b0000_0101,In_End = 8'b0000_1001,In_Get = 5'b00001,
    In_Put = 5'b00010,In_Interact = 5'b00100,In_Move = 5'b01000,In_Throw=5'b10000;

    reg [1:0]state; // state[12:5] is the switches signal; state[4:0] is the button signal.
    reg [1:0]n_state;
    reg [5:0] target;
    always @(posedge clk, negedge rst_n) begin
        if(~rst_n)
        state <= S0;
        else 
        state <= n_state;
    end
    always @(switches[7:6]) begin
        case(state)
        S0: begin 
            if (switches[6]) begin
            n_state = S_start; 
            dataIn_bits = In_Start;
            end
            else n_state = S0;
        end
        S_start: begin 
            if (switches[7]) begin
                n_state = S0;
                dataIn_bits = In_End;
            end
        end
        endcase
    end
    always @(switches[4:0]) begin
        case(state)
        S0: n_state = S0;
        S_start: begin
            if(switches[4:0] < 5'b10101) begin
                target = switches[4:0];
                dataIn_bits = {1'b0,target,2'b11}; //0xxx_xx11 the mid 5 xxxxx is the target's number;
            end
            else target = 5'b00000;
        end
        endcase
    end
    always @(button) begin
        case(state)
        S0: n_state = S0;
        S_start: begin
            case(button)
            In_Get: dataIn_bits = {1'b0,In_Get,2'b10};
            In_Put: dataIn_bits = {1'b0,In_Put,2'b10};
            In_Interact: dataIn_bits = {1'b0,In_Interact,2'b10};
            In_Move: dataIn_bits = {1'b0,In_Move,2'b10};
            In_Throw: dataIn_bits = {1'b0,In_Throw,2'b10};
            endcase
        end
            default: dataIn_bits = 8'b0000_0010;
        endcase
    end
*/
endmodule



module Begin_End(
    input [1:0] switches,
    input dataIn_ready,
    output reg [7:0] dataIn_bits
    );
    always @(switches[1:0]) begin
        case (switches[1:0])
        2'b01: dataIn_bits = 8'b0000_0101;
        2'b10: dataIn_bits = 8'b0000_1001;
        default: dataIn_bits = 8'b0000_0000;
        endcase
    end
endmodule

module TargetMove(
    input [5:0] switches,
    input dataIn_ready,
    output reg [7:0] dataIn_bits
);

    always @(switches[5:0]) begin
    if(dataIn_ready)
         case(switches[5:0])
         6'b000001: dataIn_bits = 8'b0000_0111; // xxxx_xx11 present the target machine.
         6'b000010: dataIn_bits = 8'b0000_1011;
         6'b000011: dataIn_bits = 8'b0000_1111;
         6'b000100: dataIn_bits = 8'b0001_0011;
         6'b000101: dataIn_bits = 8'b0001_0111;
         6'b000110: dataIn_bits = 8'b0001_1011;
         6'b000111: dataIn_bits = 8'b0001_1111;
         6'b001000: dataIn_bits = 8'b0010_0011;
         6'b001001: dataIn_bits = 8'b0010_0111;
         6'b001010: dataIn_bits = 8'b0010_1011;
         6'b001011: dataIn_bits = 8'b0010_1111;
         6'b001100: dataIn_bits = 8'b0011_0011;
         6'b001101: dataIn_bits = 8'b0011_0111;
         6'b001110: dataIn_bits = 8'b0011_1011;
         6'b001111: dataIn_bits = 8'b0011_1111;
         6'b010000: dataIn_bits = 8'b0100_0011;
         6'b010001: dataIn_bits = 8'b0100_0111;
         6'b010010: dataIn_bits = 8'b0100_1011;
         6'b010011: dataIn_bits = 8'b0100_1111;
         6'b010100: dataIn_bits = 8'b0101_0011;
         default: dataIn_bits = 8'b0000_0000;
    endcase
    else dataIn_bits = 8'b0000_0000;
    end
    endmodule

/*module TargetMove(
    input [7:0] switches,
    input clk,
    input dataIn_ready,
    output reg [7:0] dataIn_bits
);
    reg [5:0] switch;
always @(posedge clk)
    switch[5:0] <= switches[5:0];

    always @(switches[5:0]) begin
        if (dataIn_ready)
            dataIn_bits <= {switch,2'b11};  // xxxx_xx11 present the target machine.
        else
            dataIn_bits <= dataIn_bits;
    end
endmodule

module Get(
    input [4:0] button,
    input clk,
    input dataIn_ready,
    input [7:0] dataOut_bits,
    input dataOut_valid,
    output reg [7:0] dataIn_bits
);
    reg n_button;
    always @(posedge clk)
    n_button <= button[0];
    always @(button[0]) begin
        if (button[0]) begin
            if(dataOut_bits[5:2] == 4'b1001 & dataIn_ready)
            dataIn_bits <= 8'b0000_0110;
        end
        else
        dataIn_bits <= 8'b0000_0000;
    end
endmodule

module Put(
    input [4:0] button,
    input clk,
    input dataIn_ready,
    input [7:0] dataOut_bits,
    input dataOut_valid,
    output reg [7:0] dataIn_bits
);
    reg n_button;
    always @(posedge clk)
    n_button <= button[1];
    always @(button[1]) begin
        if (button[1]) begin
            if(dataOut_bits[5:2] == 4'b110x & dataIn_ready)
            dataIn_bits <= 8'b0000_1010;
        end
        else
        dataIn_bits <= 8'b0000_0000;
    end
endmodule

module Interact(
    input [4:0] button,
    input clk,
    input dataIn_ready,
    input [7:0] dataOut_bits,
    input dataOut_valid,
    output reg [7:0] dataIn_bits
);
    reg n_button;
    always @(posedge clk)
    n_button <= button[2];
    always @(button[2]) begin
        if (button[2]) begin
            if(dataOut_bits[5:2] == 4'b1001 & dataIn_ready)
            dataIn_bits <= 8'b0001_0010;
        end
        else
        dataIn_bits <= 8'b0000_0000;
    end
endmodule

module Move(
    input [4:0] button,
    input clk,
    input dataIn_ready,
    input [7:0] dataOut_bits,
    input dataOut_valid,
    output reg [7:0] dataIn_bits
);
    reg n_button;
    always @(posedge clk)
    n_button <= button[3];
    always @(button[3]) begin
        if (button[3]) begin
            if(dataOut_bits[5:2] == 4'b0xxx & dataIn_ready)
            dataIn_bits <= 8'b0010_0010;
        end
        else
        dataIn_bits <= 8'b0000_0000;
    end
endmodule

module Throw(
    input [4:0] button,
    input clk,
    input dataIn_ready,
    input [7:0] dataOut_bits,
    input dataOut_valid,
    output reg [7:0] dataIn_bits
);
    reg n_button;
    always @(posedge clk)
    n_button <= button[4];
    always @(button[4]) begin
        if (button[4]) begin
            if(dataOut_bits[5:2] == 4'bx1xx & dataIn_ready)
            dataIn_bits <= 8'b0100_0010;
        end
        else
        dataIn_bits <= 8'b0000_0000;
    end
endmodule*/
