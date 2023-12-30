//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
//Date        : Sat Dec 30 18:51:49 2023
//Host        : LAPTOP-I606K2C4 running 64-bit major release  (build 9200)
//Command     : generate_target pll108MHz_wrapper.bd
//Design      : pll108MHz_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module pll108MHz_wrapper
   (clk_in1,
    clk_out1,
    locked,
    reset);
  input clk_in1;
  output clk_out1;
  output locked;
  input reset;

  wire clk_in1;
  wire clk_out1;
  wire locked;
  wire reset;

  pll108MHz pll108MHz_i
       (.clk_in1(clk_in1),
        .clk_out1(clk_out1),
        .locked(locked),
        .reset(reset));
endmodule
