module vga_top(
input 					clk,
input 					nrst,
input                   [7:0]dataIn_bits,
input [3:0]             signal,
input [7:0]             pc,
input [15:0]            script,
output 					[11:0]vga,
output 					vga_hs,
output 					vga_vs
);

wire [11:0] data;
wire [10:0] x;
wire [10:0] y;
wire clk_108M;
wire locked;
vga vga_inst(
	.clk(clk),
	.nrst(nrst),
	.data(data),//RGB565
	.x(x),
	.y(y),
	.vga_hs(vga_hs),
	.vga_vs(vga_vs),
	.vga(vga)
);

vga_test vga_test_inst(
	.clk(clk),
	.nrst(nrst),
	.signal(signal),
	.pc(pc),
	.script(script),
	.dataIn_bits(dataIn_bits),
	.x(x),
	.y(y),
	.data(data)
);

endmodule 
