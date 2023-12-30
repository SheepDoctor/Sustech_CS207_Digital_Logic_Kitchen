//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
//Date        : Sat Dec 30 18:51:49 2023
//Host        : LAPTOP-I606K2C4 running 64-bit major release  (build 9200)
//Command     : generate_target pll108MHz.bd
//Design      : pll108MHz
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "pll108MHz,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=pll108MHz,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "pll108MHz.hwdef" *) 
module pll108MHz
   (clk_in1,
    clk_out1,
    locked,
    reset);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_IN1 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_IN1, CLK_DOMAIN pll108MHz_clk_in1, FREQ_HZ 100000000, PHASE 0.000" *) input clk_in1;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_OUT1 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_OUT1, CLK_DOMAIN /clk_wiz_0_clk_out1, FREQ_HZ 108000000, PHASE 0.0" *) output clk_out1;
  output locked;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET, POLARITY ACTIVE_HIGH" *) input reset;

  wire clk_in1_1;
  wire clk_wiz_0_clk_out1;
  wire clk_wiz_0_locked;
  wire reset_1;

  assign clk_in1_1 = clk_in1;
  assign clk_out1 = clk_wiz_0_clk_out1;
  assign locked = clk_wiz_0_locked;
  assign reset_1 = reset;
  pll108MHz_clk_wiz_0_0 clk_wiz_0
       (.clk_in1(clk_in1_1),
        .clk_out1(clk_wiz_0_clk_out1),
        .locked(clk_wiz_0_locked),
        .reset(reset_1));
endmodule
