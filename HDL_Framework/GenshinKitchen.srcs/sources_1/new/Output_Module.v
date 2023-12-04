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
    input [7:0] switches,
    input clk,
    output reg [7:0] dataIn_bits
    );
    reg [1:0] state; // A variable to judge if switches[7:6] have been changed.
    reg [1:0] n_state;
    parameter S0 = 2'b00,S1 = 2'b01,S2 = 2'b10;// * important:need to be put in param.v *
    initial begin
    state = S0;
    end
    
    always @(posedge clk) begin
    state <= n_state;
    end
    
    always @(state,switches[7:6]) begin
    case(state)
    S0: if(switches[6]) n_state = S1; else n_state = S0;
    S1: if(switches[7]) n_state = S2; else n_state = S1;
    S2: if(switches[6]) n_state = S1; else n_state = S2;
    endcase
    if(switches[7]|switches[6]) dataIn_bits = {4'b0000,n_state,2'b01};
    end
    
/*    always @(posedge clk) begin
    if (state[1:0] != switches[7:6]) begin
        dataIn_bits <= {4'b0000,switches[7:6],2'b01}; // xxxx_0101 or xxxx_1001 present start or end.
        state[1:0] <= switches[7:6];
    end
    else
        state[1:0] <= switches[7:6];
    end */
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
