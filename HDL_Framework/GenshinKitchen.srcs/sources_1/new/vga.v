module vga(
input 					clk,
input 					nrst,

input [11:0] 			data,
output [10:0] 			x,
output [10:0] 			y,

output wire  				vga_hs,
output wire 				vga_vs,
output  				[11:0] vga
);
parameter h_visible = 1280;
parameter h_front = 48;
parameter h_sync = 112;
parameter h_back = 248;
parameter h_whole = 1688;

parameter v_visible = 1024;
parameter v_front = 1;
parameter v_sync = 3;
parameter v_back = 38;
parameter v_whole = 1066;
assign vga_hs = (hcount >= 11'd0 && hcount < h_sync) ? 1'b0 : 1'b1;
assign vga_vs = (vcount >= 20'd0 && vcount < v_sync) ? 1'b0 : 1'b1;

assign vga_hen = (hcount >= h_sync + h_back && hcount < h_sync + h_back + h_visible) ? 1'b1 : 1'b0; //
assign vga_ven = (vcount >= v_sync + v_back && vcount < v_sync + v_back + v_visible) ? 1'b1 : 1'b0; //

assign x = vga_hen ? hcount - h_sync - h_back : 11'b0; //
assign y = vga_ven ? vcount - v_sync - v_back : 11'b0; //

assign vga = vga_hen & vga_ven ? data : 16'b0;
reg [10:0] hcount;
reg [10:0] vcount;
always @(posedge clk or negedge nrst) begin
	if(!nrst) begin
		hcount <= 11'b0;
		vcount <= 11'b0;
	end
	else begin
		if(hcount < h_whole)
			hcount <= hcount + 1'b1;
		else begin
			hcount <= 11'b0;
			if(vcount < v_whole)
				vcount <= vcount + 1'b1;
			else 
				vcount <= 11'b0;
		end
	end
end
endmodule