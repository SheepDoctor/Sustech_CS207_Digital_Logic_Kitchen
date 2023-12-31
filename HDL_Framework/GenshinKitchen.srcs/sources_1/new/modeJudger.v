`include "constants.vh"
/*
this module aims to judge the current mode
*/
module modeJudger(
input [7:0]dataIn_bits,// *data from script module but not dataIn_bits*
input clk,
input rst_n,
output reg switchMode // show current mode
    );
reg state;
reg n_state;
always @(posedge clk, negedge rst_n) begin
        if(~rst_n) begin
        state <= `user; // initially, user mode
        end
        else
        state <= n_state;
end
always@(state,dataIn_bits) begin
case(state)
`user:
casex(dataIn_bits)
8'bxxxx_0101:{n_state,switchMode} = {`script,1'b1}; // if script module sends begin signal, convert to script module
default:{n_state,switchMode} = {`user,1'b0}; // otherwise, still user module
endcase
`script:
casex(dataIn_bits)
8'bxxxx_1001:{n_state,switchMode} = {`user,1'b0}; // if script module sends end signal, convert to script module
default:{n_state,switchMode} = {`script,1'b1}; // otherwise, still script module
endcase
endcase
end
endmodule
