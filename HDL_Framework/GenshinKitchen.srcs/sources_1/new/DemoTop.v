`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/08 13:04:08
// Design Name: 
// Module Name: ProjTop
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


module DemoTop(
    input [4:0] button,
    input [7:0] switches,

    output [7:0] led,
    output [7:0] led2,
    
    input clk,
    input rst_n,
    input rx,
    output tx
    );

// The wire below is useful!
wire uart_clk_16;

wire [7:0] dataIn_bits;
wire dataIn_ready;
wire [7:0] dataOut_bits;
wire dataOut_valid;
wire script_mode;
wire [7:0] pc;
wire [15:0] script;
// The wire above is useful~
wire [7:0] led1in;
wire [7:0] led2in;
wire slow_clk;
// Self-Defined wires

    clock_frequency_divider clock(
    .clk(clk),
    .uart_clk(uart_clk_16),
    .slow_clk(slow_clk)
    );
/*    
    reset reset(
    .clk(uart_clk_16),
    .dataIn_ready(dataIn_ready),
    .dataIn_bits(dataIn_bits)
    );
    */
    set_ready set (
    .clk(slow_clk),
    .rst_n(rst_n),
    .dataIn_ready(dataIn_ready)
    );
    
    Begin_End input1(
    .clk(slow_clk),
      .switches(switches), 
      .dataIn_ready(dataIn_ready), 
      .dataIn_bits(dataIn_bits) // client signal
      );
  /*    
    UnPackSignal outdata(
      .clk(uart_clk_16),
      .dataOut_bits(dataOut_bits),
      .dataOut_valid(dataOut_valid),
      .led2(led2in)
    );*/

    Led1 output1(
    .dataIn_bits(dataIn_bits),
    .led(led)
    );
    
    Led2 output2(
     .dataIn_ready(dataIn_ready),
     .dataOut_ready(dataOut_valid),//feedback signal
    .led2(led2)
    );
 /*   
    Begin_End input1(
      .switches(switches), 
      .dataIn_ready(dataIn_ready), 
      .dataIn_bits(dataIn_bits) // client signal
      );

    Get input2(
    .button(button),
    .clk(uart_clk_16),
    .dataIn_ready(dataIn_ready),
    .dataOut_bits(dataOut_bits),
    .dataOut_valid(dataOut_valid),
    .dataIn_bits(dataIn_bits)
    );

    TargetMove input3(
    .switches(switches),
    .clk(uart_clk_16),
    .dataIn_ready(dataIn_ready),
    .dataIn_bits(dataIn_bits)
    );

    Put input4(
    .button(button),
    .clk(uart_clk_16),
    .dataIn_ready(dataIn_ready),
    .dataOut_bits(dataOut_bits),
    .dataOut_valid(dataOut_valid),
    .dataIn_bits(dataIn_bits)
    );
    
    Interact input5(
     .button(button),
     .clk(uart_clk_16),
     .dataIn_ready(dataIn_ready),
     .dataOut_bits(dataOut_bits),
     .dataOut_valid(dataOut_valid),
     .dataIn_bits(dataIn_bits)
    );
    
    Move input6(
    .button(button),
    .clk(uart_clk_16),
    .dataIn_ready(dataIn_ready),
    .dataOut_bits(dataOut_bits),
    .dataOut_valid(dataOut_valid),
    .dataIn_bits(dataIn_bits)   
    );
    
    Throw input7(
    .button(button),
    .clk(uart_clk_16),
    .dataIn_ready(dataIn_ready),
    .dataOut_bits(dataOut_bits),
    .dataOut_valid(dataOut_valid),
    .dataIn_bits(dataIn_bits)       
    );*/
    
    ScriptMem script_mem_module(
      .clock(uart_clk_16),   // please use the same clock as UART module
      .reset(1'b0),           // please use the same reset as UART module
      
      .dataOut_bits(dataOut_bits), // please connect to io_dataOut_bits of UART module
      .dataOut_valid(dataOut_valid), // please connect to io_dataOut_valid of UART module
      
      .script_mode(script_mode), // output 1 when loading script from UART.
                                 // at this time, you should not use dataOut_bits or use pc and script.
      
      .pc(pc), // (a) give a program counter (address) to ScriptMem.
      .script(script) // referring (a), returning the corresponding instructions of pc
    );
        
    UART uart_module(
          .clock(uart_clk_16),     // uart clock. Please use 16 x BultRate. (e.g. 9600 * 16 = 153600Hz��
          .reset(1'b0),               // reset
          
          .io_pair_rx(rx),          // rx, connect to R5 please
          .io_pair_tx(tx),         // tx, connect to T4 please
          
          .io_dataIn_bits(dataIn_bits),     // (a) byte from DevelopmentBoard => GenshinKitchen
          .io_dataIn_ready(dataIn_ready),   // referring (a)��pulse 1 after a byte tramsmit success.
          
          .io_dataOut_bits(dataOut_bits),     // (b) byte from GenshinKitchen => DevelopmentBoard, only available if io_dataOut_valid=1
          .io_dataOut_valid(dataOut_valid)  // referring (b)
        );

endmodule
