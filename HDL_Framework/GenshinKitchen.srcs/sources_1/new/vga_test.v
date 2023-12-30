module vga_test(
input 					clk,
input 					nrst,

input [10:0]			x,
input [10:0]			y,
input [7:0] 			dataIn_bits
output reg [11:0] 		data
);


parameter white = 12'b1111_1111_1111;
parameter black = 12'd0;


parameter wide = 4'd8;
parameter hight = 5'd16;
parameter line1 = 9'd300;
parameter line2 = 9'd400;
parameter startx = 9'd300;
reg [8]zero[16] = {16'h00f0,16'h0804,16'h0408,16'hf000,16'h0007,16'h0810,16'h1008,16'h0700};
reg [8]one[16] = {16'h0000,16'h0808,16'hfc00,16'h0000,16'h0000,16'h1010,16'h1f10,16'h1000};
always @(posedge clk or negedge nrst) begin
	if(!nrst) begin
		data <= 16'b0;
	end
	else begin
			if(x > startx & x <= startx + wide & y > line1 & y <= line1 + hight) begin
				if(data_in_bits[0]) begin
					if (zero[x-startx][y-line1]) data <= white
					else data <= black;
				end
				else begin
					if (one[x-startx][y-line1]) data <= white
					else data <= black;
				end
			end
			else if(x > startx + wide + space & x <= startx + wide*2 + space & y > line1 + hight & y <= line1 + hight) begin
				if(data_in_bits[1]) begin
					if (zero[x-startx][y-line1]) data <= white
					else data <= black;
				end
				else begin
					if (one[x-startx][y-line1]) data <= white
					else data <= black;
				end
			end
			else if(x > startx + wide*2 + space*2 & x <= startx + wide*3 + space*2 & y > line1 + hight & y <= line1 + hight) begin
				if(data_in_bits[2]) begin
					if (zero[x-startx][y-line1]) data <= white
					else data <= black;
				end
				else begin
					if (one[x-startx][y-line1]) data <= white
					else data <= black;
				end
			end
			else if(x > startx + wide*3 + space*3 & x <= startx + wide*4 + space*3 & y > line1 + hight & y <= line1 + hight) begin
				if(data_in_bits[3]) begin
					if (zero[x-startx][y-line1]) data <= white
					else data <= black;
				end
				else begin
					if (one[x-startx][y-line1]) data <= white
					else data <= black;
				end
			end
			else if(x > startx + wide*4 + space*4 & x <= startx + wide*5 + space*4 & y > line1 + hight & y <= line1 + hight) begin
				if(data_in_bits[4]) begin
					if (zero[x-startx][y-line1]) data <= white
					else data <= black;
				end
				else begin
					if (one[x-startx][y-line1]) data <= white
					else data <= black;
				end
			end
			else if(x > startx + wide*5 + space*5 & x <= startx + wide*6 + space*5 & y > line1 + hight & y <= line1 + hight) begin
				if(data_in_bits[5]) begin
					if (zero[x-startx][y-line1]) data <= white
					else data <= black;
				end
				else begin
					if (one[x-startx][y-line1]) data <= white
					else data <= black;
				end
			end
			else if(x > startx + wide*6 + space*6 & x <= startx + wide*7 + space*6 & y > line1 + hight & y <= line1 + hight) begin
				if(data_in_bits[6]) begin
					if (zero[x-startx][y-line1]) data <= white
					else data <= black;
				end
				else begin
					if (one[x-startx][y-line1]) data <= white
					else data <= black;
				end
			end
			else if(x > startx + wide*7 + space*7 & x <= startx + wide*8 + space*7 & y > line1 + hight & y <= line1 + hight) begin
				if(data_in_bits[7]) begin
					if (zero[x-startx][y-line1]) data <= white
					else data <= black;
				end
				else begin
					if (one[x-startx][y-line1]) data <= white
					else data <= black;
				end
			end
		else
			data <= black;
	end
end
endmodule 
