module vga_test(
input 					clk,
input 					nrst,
input [10:0]			x,
input [10:0]			y,
input [3:0]             signal,
input [7:0]             pc,
input [15:0]            script,
input [7:0] 			dataIn_bits,
output reg [11:0] 		data
);


parameter white = 12'b1111_1111_1111;
parameter black = 12'd0;


parameter wide = 9'd64;
parameter swide = 9'd32;
parameter hight = 9'd64;
parameter line1 = 9'd200;
parameter line2 = 9'd300;
parameter line3 = 9'd400;
parameter line4 = 10'd500;
parameter startx = 9'd300;
parameter space = 6'd20;
parameter sspace = 6'd10;

always @(posedge clk or negedge nrst) begin
	if(!nrst) begin
		data <= 16'b0;
	end
	else begin
			if(x > startx & x <= startx + wide & y > line1 & y <= line1 + hight) begin
				if(dataIn_bits[7]) data <= white;
				else data <= black;
			end
			else if(x > startx + wide + space & x <= startx + wide*2 + space & y > line1 & y <= line1 + hight) begin
				if(dataIn_bits[6]) data <= white;
                else data <= black;
            end
			else if(x > startx + wide*2 + space*2 & x <= startx + wide*3 + space*2 & y > line1 & y <= line1 + hight) begin
				if(dataIn_bits[5]) begin
					data <= white;
            end
            else begin
                data <= black;
            end
        end
			else if(x > startx + wide*3 + space*3 & x <= startx + wide*4 + space*3 & y > line1 & y <= line1 + hight) begin
				if(dataIn_bits[4]) begin
					data <= white;
            end
            else begin
                data <= black;
            end
        end
			else if(x > startx + wide*4 + space*4 & x <= startx + wide*5 + space*4 & y > line1 & y <= line1 + hight) begin
				if(dataIn_bits[3]) begin
					data <= white;
            end
            else begin
                data <= black;
            end
        end
			else if(x > startx + wide*5 + space*5 & x <= startx + wide*6 + space*5 & y > line1 & y <= line1 + hight) begin
				if(dataIn_bits[2]) begin
					data <= white;
            end
            else begin
                data <= black;
            end
        end
			else if(x > startx + wide*6 + space*6 & x <= startx + wide*7 + space*6 & y > line1 & y <= line1 + hight) begin
				if(dataIn_bits[1]) begin
					data <= white;
            end
            else begin
                data <= black;
            end
        end
			else if(x > startx + wide*7 + space*7 & x <= startx + wide*8 + space*7 & y > line1 & y <= line1 + hight) begin
				if(dataIn_bits[0]) begin
					data <= white;
            end
            else begin
                data <= black;
            end
        end
        else if(x > startx & x <= startx + wide & y > line2 & y <= line2 + hight) begin
                    if(signal[3]) data <= white;
                    else data <= black;
                end
        else if(x > startx + wide + space & x <= startx + wide*2 + space & y > line2 & y <= line2 + hight) begin
                    if(signal[2]) data <= white;
                    else data <= black;
                end
                
        else if(x > startx + wide*2 + space*2 & x <= startx + wide*3 + space*2 & y > line2 & y <= line2 + hight) begin
                    if(signal[1]) data <= white;
                    else data <= black;
                end
        else if(x > startx + wide*3 + space*3 & x <= startx + wide*4 + space*3 & y > line2 & y <= line2 + hight) begin
                    if(signal[0]) data <= white;
                    else data <= black;
                end
        else if(x > startx & x <= startx + wide & y > line3 & y <= line3 + hight) begin
                    if(pc[7]) data <= white;
                    else data <= black;
               end
        else if(x > startx + wide + space & x <= startx + wide*2 + space & y > line3 & y <= line3 + hight) begin
                    if(pc[6]) data <= white;
                    else data <= black;
                end
        else if(x > startx + wide*2 + space*2 & x <= startx + wide*3 + space*2 & y > line3 & y <= line3 + hight) begin
                    if(pc[5]) data <= white;
                    else data <= black;
                end
        else if(x > startx + wide*3 + space*3 & x <= startx + wide*4 + space*3 & y > line3 & y <= line3 + hight) begin
                    if(pc[4]) data <= white;
                    else data <= black;
                end
        else if(x > startx + wide*4 + space*4 & x <= startx + wide*5 + space*4 & y > line3 & y <= line3 + hight) begin
                    if(pc[3]) data <= white;
                    else data <= black;
                end
        else if(x > startx + wide*5 + space*5 & x <= startx + wide*6 + space*5 & y > line3 & y <= line3 + hight) begin
                    if(pc[2]) data <= white;
                    else data <= black;
                 end
        else if(x > startx + wide*6 + space*6 & x <= startx + wide*7 + space*6 & y > line3 & y <= line3 + hight) begin
                    if(pc[1]) data <= white;
                    else data <= black;
                end
        else if(x > startx + wide*7 + space*7 & x <= startx + wide*8 + space*7 & y > line3 & y <= line3 + hight) begin
                    if(pc[0]) data <= white;
                    else data <= black;
                end
        else if(x > startx & x <= startx + swide & y > line4 & y <= line4 + hight) begin
                    if(script[15]) data <= white;
                    else data <= black;
               end
        else if(x > startx + swide + sspace & x <= startx + swide*2 + sspace & y > line4 & y <= line4 + hight) begin
                    if(script[14]) data <= white;
                    else data <= black;
                end
        else if(x > startx + swide*2 + sspace*2 & x <= startx + swide*3 + sspace*2 & y > line4 & y <= line4 + hight) begin
                    if(script[13]) data <= white;
                    else data <= black;
                end
        else if(x > startx + swide*3 + sspace*3 & x <= startx + swide*4 + sspace*3 & y > line4 & y <= line4 + hight) begin
                    if(script[12]) data <= white;
                    else data <= black;
                end
        else if(x > startx + swide*4 + sspace*4 & x <= startx + swide*5 + sspace*4 & y > line4 & y <= line4 + hight) begin
                    if(script[11]) data <= white;
                    else data <= black;
                end
        else if(x > startx + swide*5 + sspace*5 & x <= startx + swide*6 + sspace*5 & y > line4 & y <= line4 + hight) begin
                    if(script[10]) data <= white;
                    else data <= black;
                 end
        else if(x > startx + swide*6 + sspace*6 & x <= startx + swide*7 + sspace*6 & y > line4 & y <= line4 + hight) begin
                    if(script[9]) data <= white;
                    else data <= black;
                end
        else if(x > startx + swide*7 + sspace*7 & x <= startx + swide*8 + sspace*7 & y > line4 & y <= line4 + hight) begin
                    if(script[8]) data <= white;
                    else data <= black;
                end
        else if(x > startx + swide*8 + sspace*8 & x <= startx + swide*9 + sspace*8 & y > line4 & y <= line4 + hight) begin
                    if(script[7]) data <= white;
                    else data <= black;
                end
        else if(x > startx + swide*9 + sspace*9 & x <= startx + swide*10 + sspace*9 & y > line4 & y <= line4 + hight) begin
                    if(script[6]) data <= white;
                    else data <= black;
                end
        else if(x > startx + swide*10 + sspace*10 & x <= startx + swide*11 + sspace*10 & y > line4 & y <= line4 + hight) begin
                    if(script[5]) data <= white;
                    else data <= black;
                end
        else if(x > startx + swide*11 + sspace*11 & x <= startx + swide*12 + sspace*11 & y > line4 & y <= line4 + hight) begin
                    if(script[4]) data <= white;
                    else data <= black;
                end
        else if(x > startx + swide*12 + sspace*12 & x <= startx + swide*13 + sspace*12 & y > line4 & y <= line4 + hight) begin
                    if(script[3]) data <= white;
                    else data <= black;
                end
        else if(x > startx + swide*13 + sspace*13 & x <= startx + swide*14 + sspace*13 & y > line4 & y <= line4 + hight) begin
                    if(script[2]) data <= white;
                    else data <= black;
                 end
        else if(x > startx + swide*14 + sspace*14 & x <= startx + swide*15 + sspace*14 & y > line4 & y <= line4 + hight) begin
                    if(script[1]) data <= white;
                    else data <= black;
                end
        else if(x > startx + swide*15 + sspace*15 & x <= startx + swide*16 + sspace*15 & y > line4 & y <= line4 + hight) begin
                    if(script[0]) data <= white;
                    else data <= black;
                end
		else
			data <= 12'b1111_0000_0000;
	end
end
endmodule 
