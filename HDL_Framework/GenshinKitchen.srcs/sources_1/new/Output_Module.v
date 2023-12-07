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
