// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Fri Dec 29 21:52:05 2023
// Host        : LAPTOP-I606K2C4 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               f:/CS207Lab/VGA/VGA.srcs/sources_1/bd/pll108MHz/ip/pll108MHz_clk_wiz_0_0/pll108MHz_clk_wiz_0_0_stub.v
// Design      : pll108MHz_clk_wiz_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a50tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module pll108MHz_clk_wiz_0_0(clk_out1, reset, locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_out1,reset,locked,clk_in1" */;
  output clk_out1;
  input reset;
  output locked;
  input clk_in1;
endmodule
