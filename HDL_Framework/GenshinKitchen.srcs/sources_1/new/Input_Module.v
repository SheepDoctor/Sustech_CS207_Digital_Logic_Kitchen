// show dataIn_bits
module Led1(
input [7:0] dataIn_bits,
output [7:0] led
);
assign led = dataIn_bits;
endmodule