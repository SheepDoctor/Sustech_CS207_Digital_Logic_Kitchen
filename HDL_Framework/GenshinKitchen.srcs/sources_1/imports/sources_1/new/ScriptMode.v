`timescale 1ns / 1ps

module ScriptMode(
    input rst_n,
    input clk,
    input slow_clk,
    input dataOut_ready,
    input [7:0] dataOut_bits,
    input dataIn_ready,
    input [7:0] size, // size of the script file
    input script_mode,
    input [15:0] script, // contains instructions
    output dataIn_bits ,
    output reg [7:0] pc
    );
    reg [15:0] inst; // the ready-to-decode signal
    always @(negedge script_mode) begin
        if(~script_mode)
            inst <= script;
    end

    wire [3:0] signal; //meaningless
    wire [1:0] verify; // meaningless
    wire [1:0] channal; // if channal == 10 then it's the script mode
    reg [4:0] movement;
    reg [7:0] place;

    GetInfo get(
        .clk(clk), 
        .dataOut_ready(dataOut_ready), 
        .dataOut_bits(dataOut_bits), 
        .verify(verify), 
        .channal(channal), 
        .signal(signal));

    // send data to the software
    /*
    movement:
        get 00001
        put 00010
        interact 00100
        move 01000
        throw 10000
    place:
        [5:0] is the location
        7 start
        6 end
    */
    Output out(
        .clk(slow_clk),
        .button(movement),
        .switches(place),
        .dataIn_ready(dataIn_ready),
        .rst_n(rst_n),
        .dataOut_bits(dataOut_bits),
        .dataOut_valid(dataOut_ready),
        .dataIn_bits(dataIn_bits)
    );

    reg [7:0] i_num;
    reg [2:0] i_sign, op_code;
    reg [1:0] func;
    reg [1:0] start;
    reg io; // io == 0, from software; io == 1, to software

    // setting status
    // data changes when the dataflow mode change
    always @(posedge dataIn_ready) begin
        io <= 1;
    end
    always @(posedge dataOut_ready) begin
        io <= 0;
    end

    // dealing with inst, encode
    // data only chage when pc changes
    always @(*) begin
        if(~script_mode) begin
            func = inst[4:3];
            op_code = inst[2:0];
            i_num = inst[15:8];
            i_sign = inst[7:5];
        end
    end

    // jump instruction and game start and end
    always @(inst) begin
        if({op_code, func} == 5'b01000) begin
            if(i_sign == 3'b001) begin
                pc = pc + i_num;
            end
        end
        else if({op_code, func} == 5'b01001) begin
            if(i_sign == 3'b000) begin
                pc = pc + i_num;
            end
        end
        else if({op_code, func} == 5'b10001) begin
            start = 2'b10;
            pc = pc + 2;
        end
        else if({op_code, func} == 5'b10010) begin
            start = 2'b01;
            pc = pc + 2;
        end
    end

    // sent moving instructions
    // activate by io changes, when dataIn ready the block is activated
    integer moveCounter = 1;
    always @(io) begin
        if(io) begin // to software ready
            if({op_code, func} == 5'b00100) begin
                case (moveCounter)
                    1: begin movement = 5'b00000; place = {start, i_num[5:0]}; moveCounter = moveCounter + 1; end // select a place
                    2: begin movement = 5'b01000; place = {start, i_num[5:0]}; moveCounter = moveCounter + 1; end// move
                    3: begin movement = 5'b00001; place = {start, i_num[5:0]}; moveCounter = 1; pc = pc + 2; end// get the item
                endcase
            end
            else if({op_code, func} == 5'b00101) begin
                case (moveCounter)
                    1: begin movement = 5'b00000; place = {start, i_num[5:0]}; moveCounter = moveCounter + 1; end// select a place
                    2: begin movement = 5'b01000; place = {start, i_num[5:0]}; moveCounter = moveCounter + 1; end// move
                    3: begin movement = 5'b00010; place = {start, i_num[5:0]}; moveCounter = 1; pc = pc + 2; end // put the item
                endcase
            end
            else if({op_code, func} == 5'b00110) begin
                case (moveCounter)
                    1: begin movement = 5'b00000; place = {start, i_num[5:0]}; moveCounter = moveCounter + 1; end // select a place
                    2: begin movement = 5'b01000; place = {start, i_num[5:0]}; moveCounter = moveCounter + 1; end // move
                    3: begin movement = 5'b00100; place = {start, i_num[5:0]}; moveCounter = 1; pc = pc + 2; end // interact the item
                endcase
            end
            else if({op_code, func} == 5'b00111) begin
                case (moveCounter)
                    1: begin movement = 5'b00000; place = {start, i_num[5:0]}; moveCounter = moveCounter + 1; end // select a place
                    2: begin movement = 5'b01000; place = {start, i_num[5:0]}; moveCounter = moveCounter + 1; end// move
                    3: begin movement = 5'b10000; place = {start, i_num[5:0]}; moveCounter = 1; pc = pc + 2; end // throw the item
                endcase
            end
        end
    end

    // wating mode 1
    integer watingCounter = 0;
    always @(posedge slow_clk) begin
        if({op_code, func} == 5'b01100 && i_num > 0) begin
            if(watingCounter == i_num) begin
                pc = pc + 2;
                watingCounter = 0;
            end
            watingCounter = watingCounter + 1;
        end
    end

    // waiting mode 2
    always @(posedge clk) begin
        if({op_code, func} == 5'b01101) begin
            if(i_sign) begin
                pc = pc + 2;
            end
        end
    end
endmodule
