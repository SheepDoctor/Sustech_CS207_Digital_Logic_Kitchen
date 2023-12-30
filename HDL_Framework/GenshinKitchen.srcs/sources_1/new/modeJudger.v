module modeJudger(
input [7:0]dataIn_bits,
input clk,
input rst_n,
output reg switchMode
    );
reg state;
reg n_state;
parameter user = 1'b1, script = 1'b0;
always @(posedge clk, negedge rst_n) begin
        if(~rst_n) begin
        state <= user; 
        end
        else
        state <= n_state;
end
always@(state,dataIn_bits) begin
case(state)
user:
casex(dataIn_bits)
8'bxxxx_0101:{n_state,switchMode} = {script,1'b1};
default:{n_state,switchMode} = {user,1'b0};
endcase
script:
casex(dataIn_bits)
8'bxxxx_1001:{n_state,switchMode} = {user,1'b0};
default:{n_state,switchMode} = {script,1'b1};
endcase
endcase
end
endmodule
