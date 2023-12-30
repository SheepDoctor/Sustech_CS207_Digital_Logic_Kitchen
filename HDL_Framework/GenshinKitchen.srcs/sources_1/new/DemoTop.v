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
    input           [4:0] button,
    input           [7:0] switches,

    output          [7:0] led,
    output          [7:0] led2,
    
    input           clk,
    input           rst_n,
    input           rx,
    output          tx,
    output          [3:0]tub_sel1,
    output          [3:0]tub_sel2,
    output          [7:0] tub_control1,
    output          [7:0] tub_control2,
    output 					[11:0]vga,
    output 					vga_hs,
    output 					vga_vs
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
wire [3:0] signal;
wire slow_clk;
wire [7:0] size;
wire tube_clk;
wire [7:0]dataIn_user;
wire [7:0]dataIn_script;
wire switchMode;
// Self-Defined wires

// assign led = script[15:8];
// assign led2 = script[7:0];

// assign end

    vga_top vga_inst (
      .clk(clk),
      .nrst(rst_n),
      .dataIn_bits(dataIn_bits),
      .vga(vga),
      .vga_hs(vga_hs),
      .vga_vs(vga_vs)
    )

    clock_frequency_divider clock(
    .clk(clk),
    .uart_clk(uart_clk_16),
    .slow_clk(slow_clk),
    .tube_clk(tube_clk)
    );
    
    modeSwitcher(
    .dataIn_user(dataIn_user),
    .dataIn_script(dataIn_script),
    .switchMode(switchMode),
    .dataIn_bits(dataIn_bits)
    );
    
    modeJudger(
    .dataIn_bits(dataIn_bits),
    .dataOut_bits(dataOut_bits),
    .clk(clk),
    .rst_n(rst_n),
    .switchMode(switchMode)
    );

    seven_segment_tube tube(
    .switchMode(switchMode),
    .code(script),
    .clk(tube_clk),
    .tub_sel1(tub_sel1),
    .tub_sel2(tub_sel2),
    .tub_control1(tub_control1),
    .tub_control2(tub_control2)
    );

    
    Output func(
    .clk(slow_clk),
    .switches(switches), 
    .button(button),
    .rst_n(rst_n),
    .led(signal),
    .dataIn_bits(dataIn_user) // client signal
      );
    
    Receiver receiver(
      .clk(uart_clk_16),
      .dataOut_bits(dataOut_bits),
      .dataOut_ready(dataOut_valid),
      .led(led),
      .size(size)
    );

    ScriptMode scriptMode(
      .reset(rst_n),
      .clk(clk),
      .uart_clk_16(uart_clk_16),
      .slow_clk(slow_clk),
      .dataOut_bits(dataOut_bits),
      .dataOut_ready(dataOut_valid),
      .dataIn_ready(dataIn_ready),
      .dataIn_bits(dataIn_script),
      .size(size),
      .script_mode(script_mode),
      .script(script),
      .pc(pc)
    );
    
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
          .clock(uart_clk_16),     // uart clock. Please use 16 x BultRate. (e.g. 9600 * 16 = 153600Hz  
          .reset(1'b0),               // reset
          
          .io_pair_rx(rx),          // rx, connect to R5 please
          .io_pair_tx(tx),         // tx, connect to T4 please
          
          .io_dataIn_bits(dataIn_bits),     // (a) byte from DevelopmentBoard => GenshinKitchen
          .io_dataIn_ready(dataIn_ready),   // referring (a)  pulse 1 after a byte tramsmit success.
          
          .io_dataOut_bits(dataOut_bits),     // (b) byte from GenshinKitchen => DevelopmentBoard, only available if io_dataOut_valid=1
          .io_dataOut_valid(dataOut_valid)  // referring (b)
        );

endmodule
