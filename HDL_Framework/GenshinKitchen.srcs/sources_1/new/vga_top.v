module vga_top(
input 					clk,
input 					nrst,
output 					[15:0]vga,
output 					vga_hs,
output 					vga_vs
);

wire [15:0] data;
wire [10:0] x;
wire [10:0] y;
wire clk_108M;
wire locked;
vga vga_inst(
	.clk(clk_108M),
	.nrst(locked&nrst),
	.data(data),//RGB565
	.x(x),
	.y(y),
	.vga_hs(vga_hs),
	.vga_vs(vga_vs),
	.vga(vga)
);

vga_test vga_test_inst(
	.clk(clk_108M),
	.nrst(locked&nrst),
	.x(x),
	.y(y),
	.data(data)
);

pll108MHz	pll_108M_inst (
	.reset (!nrst),
	.clk_in1 (clk),
	.clk_out1 (clk_108M),
	.locked (locked)
	);
endmodule 
