`timescale 1ns / 1ps
/*
solving pc problem: rename pc and assign value to pc in a independent always block
*/
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

    output [7:0] dataIn_bits,
    output reg [7:0] pc,
    output [7:0] led,
    output [7:0] led2
    );
    reg [15:0] inst; // the ready-to-decode signal
    always @(*) begin
        if(~script_mode)
            inst = script;
        else
            inst = 16'b0;
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
    reg s_clk;

    // setting status
    // data changes when the dataflow mode change
    // always @(*) begin
    //     if(dataIn_ready)
    //         io = 1;
    //     else if(dataOut_ready)
    //         io = 0;
    // end

    // dealing with inst, encode
    // data only chage when pc changes
    reg [7:0] pc5;
    always @(*) begin
        if(script_mode) begin
            pc5 = 8'b0000_0000;
            func = 2'b0;
            op_code = 3'b0;
            i_num = 8'b0;
            i_sign = 3'b0;     
        end
        else if(~script_mode) begin
            func = inst[4:3];
            op_code = inst[2:0];
            i_num = inst[15:8];
            i_sign = inst[7:5];
        end
    end

    integer clk_counter = 1;
    always @(posedge slow_clk) begin
        if(script_mode) 
            s_clk <= 1'b0;
        clk_counter <= clk_counter + 1;
        if(clk_counter == 10) begin
            clk_counter <= 1;
            s_clk <= ~s_clk;
        end
    end

    reg [7:0] pc1, pc2, pc3, pc4;
    // jump instruction and game start and end
    always @(*) begin
        if(~script_mode && {op_code, func} == 5'b01000) begin
            if(i_sign == 3'b001) begin
                pc1 = pc + i_num;
            end
        end
        else if(~script_mode && {op_code, func} == 5'b01001) begin
            if(i_sign == 3'b000) begin
                pc1 = pc + i_num;
            end
        end
        else begin
            pc1 = pc;
        end
    end

    // sent moving instructions
    // activate by io changes, when dataIn ready the block is activated
    integer moveCounter = 1;
    always @(posedge s_clk) begin
        if(~script_mode) begin // to software ready
            if({op_code, func} == 5'b00100) begin
                case (moveCounter)
                    1: begin movement <= 5'b00000; place <= {2'b00, i_num[5:0]}; moveCounter <= moveCounter + 1; pc2 <= pc; end // select a place
                    2: begin movement <= 5'b01000; place <= {2'b00, i_num[5:0]}; moveCounter <= moveCounter + 1; pc2 <= pc; end// move
                    3: begin movement <= 5'b00001; place <= {2'b00, i_num[5:0]}; moveCounter <= 1; pc2 <= pc + 2; end// get the item
                endcase
            end
            else if({op_code, func} == 5'b00101) begin
                case (moveCounter)
                    1: begin movement <= 5'b00000; place <= {2'b00, i_num[5:0]}; moveCounter <= moveCounter + 1; pc2 <= pc; end// select a place
                    2: begin movement <= 5'b01000; place <= {2'b00, i_num[5:0]}; moveCounter <= moveCounter + 1; pc2 <= pc; end// move
                    3: begin movement <= 5'b00010; place <= {2'b00, i_num[5:0]}; moveCounter <= 1; pc2 <= pc + 2; end // put the item
                endcase
            end
            else if({op_code, func} == 5'b00110) begin
                case (moveCounter)
                    1: begin movement <= 5'b00000; place <= {2'b00, i_num[5:0]}; moveCounter <= moveCounter + 1; pc2 <= pc; end // select a place
                    2: begin movement <= 5'b01000; place <= {2'b00, i_num[5:0]}; moveCounter <= moveCounter + 1; pc2 <= pc; end // move
                    3: begin movement <= 5'b00100; place <= {2'b00, i_num[5:0]}; moveCounter <= 1; pc2 <= pc + 2; end // interact the item
                endcase
            end
            else if({op_code, func} == 5'b00111) begin
                case (moveCounter)
                    1: begin movement <= 5'b00000; place <= {2'b00, i_num[5:0]}; moveCounter <= moveCounter + 1; pc2 <= pc; end // select a place
                    2: begin movement <= 5'b01000; place <= {2'b00, i_num[5:0]}; moveCounter <= moveCounter + 1; pc2 <= pc; end// move
                    3: begin movement <= 5'b10000; place <= {2'b00, i_num[5:0]}; moveCounter <= 1; pc2 <= pc + 2; end // throw the item
                endcase
            end
            else if({op_code, func} == 5'b10001) begin
                case (moveCounter) 
                    1: begin movement <= 5'b00000; start <= 2'b01; place <= {start, 6'b000000}; moveCounter <= moveCounter + 1; pc2 <= pc;end
                    2: begin movement <= 5'b00000; start <= 2'b01; place <= {start, 6'b000000}; moveCounter <= moveCounter + 1; pc2 <= pc;end
                    3: begin movement <= 5'b00000; place <= 8'b00000000; moveCounter <= 1;pc2 <= pc + 2; end
                endcase
            end
            else if({{op_code, func} == 5'b10010}) begin
                case (moveCounter) 
                    1: begin movement <= 5'b00000; start <= 2'b10; place <= {start, 6'b000000}; moveCounter <= moveCounter + 1; pc2 <= pc; end
                    2: begin movement <= 5'b00000; place <= 8'b00000000; moveCounter <= 1; pc2 <= 8'b0; end
                endcase
            end
            else begin
                movement <= movement; place <= place; pc2 <= pc;
            end
        end
    end

    // wating mode 1
    integer watingCounter = 0;
    always @(posedge s_clk) begin
        if(~script_mode && {op_code, func} == 5'b01100 && i_num > 0) begin
            if(watingCounter == i_num) begin
                pc3 <= pc + 2;
                watingCounter = 0;
            end
            watingCounter = watingCounter + 1;
        end
    end

    // waiting mode 2
    always @(posedge s_clk) begin
        if(~script_mode && {op_code, func} == 5'b01101) begin
            if(i_sign) begin
                pc4 <= pc + 2;
            end
        end
    end

    always @(*) begin
        if(script_mode) begin
            pc = pc5;
        end
        else
            case({op_code, func})
                5'b01000: pc = pc1;
                5'b01001: pc = pc1;
                5'b10001: pc = pc2;
                5'b10010: pc = pc2;
                5'b00100: pc = pc2;
                5'b00101: pc = pc2;
                5'b00110: pc = pc2;
                5'b00111: pc = pc2;
                5'b01100: pc = pc3;
                5'b01101: pc = pc4;
                default: pc = pc5;
            endcase
    end
    


    // assign
    // assign led = i_num;
    assign led2[7:1] = {op_code, func, slow_clk, s_clk};
    // assign led = {pc[7:1], script_mode};
    // assign led = place;
    assign led = moveCounter;
    // assign led = pc;
    // assign led = script[15:8];
    // assign led2 = script[7:0];
    // assign led2 = {movement, 3'b000};
endmodule
