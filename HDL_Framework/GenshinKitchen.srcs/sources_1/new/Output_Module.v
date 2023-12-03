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


module Begin_End(
    input [7:0] switches,
    input clk,
    output reg [7:0] dataIn_bits
    );
    reg [1:0] switch; // A variable to judge if switches[7:6] have been changed.
    always @(posedge clk) begin
    if (switch[1:0] != switches[7:6]) begin
        dataIn_bits <= {4'b0000,switches[7:6],2'b01}; // xxxx_0101 or xxxx_1001 present start or end.
        switch[1:0] <= switches[7:6];
    end
    else
        switch[1:0] <= switches[7:6];
    end
endmodule

module TargetMove(
    input [7:0] switches,
    input clk,
    input dataIn_ready,
    output reg [7:0] dataIn_bits
);
    reg [5:0] switch;
    always @(posedge clk) begin
        if (dataIn_ready) begin
            if (switch[5:0] != switches[5:0]) begin
                dataIn_bits <= {switches[5:0],2'b11}; // xxxx_xx11 present the target machine.
                switch[5:0] <= switches[5:0];
            end
            else
                switch[5:0] <= switches[5:0];
        end
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
    always @(posedge clk , posedge button[0]) begin
        if (dataOut_valid == 1'b1) begin
            if(dataOut_bits[5:2] == 4'b1001 & dataIn_ready)
            dataIn_bits <= 8'b0000_0110;
        end
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
    always @(posedge clk , posedge button[1]) begin
        if (dataOut_valid == 1'b1) begin
            if(dataOut_bits[5:2] == 4'b110x & dataIn_ready)
            dataIn_bits <= 8'b0000_1010;
        end
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
    reg continue = 1'b1;
    always @(posedge clk , posedge button[2]) begin
        if (continue) begin
            if (dataOut_valid == 1'b1) begin
                if(dataOut_bits[5:2] == 4'b1xx1 & dataIn_ready)
                dataIn_bits <= 8'b0001_0010;
            end
            continue <= button[2];
        end
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
    always @(posedge clk , posedge button[3]) begin
        if (dataOut_valid == 1'b1) begin
            if(dataOut_bits[5:2] == 4'b0xxx & dataIn_ready)
            dataIn_bits <= 8'b0010_0010;
        end
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
    always @(posedge clk , posedge button[4]) begin
        if (dataOut_valid == 1'b1) begin
            if(dataOut_bits[5:2] == 4'bx1xx & dataIn_ready)
            dataIn_bits <= 8'b0100_0010;
        end
    end
endmodule