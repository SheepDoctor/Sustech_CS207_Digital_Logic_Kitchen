`include "constants.vh"
/*
Author: Zhao
Description: The control module of the vga block.
To counting and fresh the vga horizontal and vertical location.
*/
module vga(
input 					clk,
input 					nrst,

input [11:0] 			data,//BGR
output [10:0] 			x,
output [10:0] 			y,

output wire  				vga_hs,
output wire 				vga_vs,
output  				[11:0] vga
);

assign vga_hs = (hcount >= 11'd0 && hcount < `h_sync) ? 1'b0 : 1'b1;
assign vga_vs = (vcount >= 20'd0 && vcount < `v_sync) ? 1'b0 : 1'b1;

assign vga_hen = (hcount >= `h_sync + `h_back && hcount < `h_sync + `h_back + `h_visible) ? 1'b1 : 1'b0; //Horizontal active signal
assign vga_ven = (vcount >= `v_sync + `v_back && vcount < `v_sync + `v_back + `v_visible) ? 1'b1 : 1'b0; //Vertical active signal

assign x = vga_hen ? hcount - `h_sync - `h_back : 11'b0; //Horizental coordinate
assign y = vga_ven ? vcount - `v_sync - `v_back : 11'b0; //Vertical coordinate

assign vga = vga_hen & vga_ven ? data : 12'b0; //Signal source
reg [10:0] hcount;
reg [10:0] vcount;
always @(posedge clk or negedge nrst) begin  //Location counting
	if(!nrst) begin
		hcount <= 11'b0;
		vcount <= 11'b0;
	end
	else begin
		if(hcount < `h_whole)
			hcount <= hcount + 1'b1;
		else begin
			hcount <= 11'b0;
			if(vcount < `v_whole)
				vcount <= vcount + 1'b1;
			else 
				vcount <= 11'b0;
		end
	end
end
endmodule