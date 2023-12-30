module vga_test(
input 					clk,
input 					nrst,

input [10:0]			x,
input [10:0]			y,
output reg [15:0] 		data
);

parameter red = 16'b11111_000000_00000;
parameter green = 16'b00000_111111_00000;
parameter blue = 16'b00000_000000_11111;
parameter purple = 16'hf81f;
parameter yellow = 16'hffe0;
parameter cyan = 16'h07ff;
parameter orange  = 16'hfc00;
parameter white = 16'hffff;

parameter bar_wide = 11'd1280 / 11'd8;
always @(posedge clk or negedge nrst) begin
	if(!nrst) begin
		data <= 16'b0;
	end
	else begin
		if(x < bar_wide * 11'd1)
			data <= red;
		else if(x < bar_wide * 11'd2)
			data <= green;
		else if(x < bar_wide * 11'd3)
			data <= blue;
		else if(x < bar_wide * 11'd4)
			data <= purple;
		else if(x < bar_wide * 11'd5)
			data <= yellow;
		else if(x < bar_wide * 11'd6)
			data <= cyan;
		else if(x < bar_wide * 11'd7)
			data <= orange;
		else
			data <= white;
	end
end
endmodule 
