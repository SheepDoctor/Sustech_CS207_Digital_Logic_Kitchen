`timescale 1ns / 1ps


module scriptMode_sim();

    reg rst_n;
    reg clk;
    reg slow_clk;
    reg dataOut_ready;
    reg [7:0] dataOut_bits;
    reg dataIn_ready;
    reg [7:0] size;
    reg script_mode;
    reg [15:0] script;
    wire dataIn_bits;
    wire [7:0] pc;
    ScriptMode s(
        .rst_n(rst_n),
        .clk(clk),
        .slow_clk(slow_clk),
        .dataOut_ready(dataOut_ready),
        .dataOut_bits(dataOut_bits),
        .dataIn_ready(dataIn_ready),
        .size(size), // size of the script file
        .script_mode(script_mode),
        .script(script), // contains instructions
        .dataIn_bits(dataIn_bits),
        .pc(pc)
    );
    
    initial fork
        rst_n = 1'b0;
        clk = 1'b0;
        forever begin
            #10 clk = ~clk;
        end
        slow_clk = 1'b0;
        forever begin
            #100000000 slow_clk = ~slow_clk; 
        end
    join
endmodule
