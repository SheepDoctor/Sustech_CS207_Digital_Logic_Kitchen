`timescale 1ns / 1ps
/*
solving pc problem: rename pc and assign value to pc in a independent always block
*/
module ScriptMode(
    input reset,
    input clk,
    input slow_clk,
    input dataOut_ready,
    input [7:0] dataOut_bits,
    input dataIn_ready,
    input [7:0] size, // size of the script file
    input script_mode,
    input [15:0] script, // contains instructions
    input uart_clk_16,

    output [7:0] dataIn_bits,
    output reg [7:0] pc
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

    Receiver get(
        .clk(uart_clk_16), 
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
        .rst_n(reset),
        .led(signal),
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
        if(~reset) begin
            pc5 = 0;
            func = 0;
            op_code = 0;
            i_num = 0;
            i_sign = 0;
        end
        else begin
            if(script_mode) begin
                pc5 = 8'b0000_0000;
                func = 2'b0;
                op_code = 3'b0;
                i_num = 8'b0;
                i_sign = 3'b0;     
            end
            else begin
                if(inst != 0) begin
                    func = inst[4:3];
                    op_code = inst[2:0];
                    i_num = inst[15:8];
                    i_sign = inst[7:5];
                end
                else begin
                    //null
                end
            end
        end
    end

    integer clk_counter = 1;
    always @(posedge clk) begin
        if(~reset) begin
            clk_counter <= 1;
        end
        else begin
            if(script_mode) 
                s_clk <= 1'b0;
            else begin
                if(clk_counter == 15000050) begin
                // if(clk_counter == 100000000) begin
                    clk_counter <= 1;
                    s_clk <= ~s_clk;
                end
                else begin
                    clk_counter <= clk_counter + 1;
                end
            end
        end 
    end

    reg [7:0] pc1, pc2, pc3, pc4;
    // jump instruction and game start and end
    always @(*) begin
        if(~reset) begin
            pc1 = 0;
        end
        else begin 
            if(script_mode) begin
                pc1 = 0;
            end
            else if({op_code, func} == 5'b01000) begin
                if(signal[2] == 1) begin
                    pc1 = pc + i_num;
                end
            end
            else if({op_code, func} == 5'b01001) begin
                if(signal[2] == 0) begin
                    pc1 = pc + i_num;
                end
            end
            else begin
                pc1 = 0;
            end
        end
    end

    reg [4:0] movement1;
    reg [7:0] place1;
    // sent moving instructions
    // activate by io changes, when dataIn ready the block is activated
    integer target_prev = 25;
    integer moveCounter = 1;
    always @(posedge s_clk) begin
        if(~reset) begin
            movement1 <= 0; place1 <= 0; pc2 <= 0; target_prev <= 0; moveCounter <= 1;
        end
        else begin
            if(~script_mode) begin // to software ready
                if({op_code, func} == 5'b00100) begin
                    if(target_prev != i_num) begin
                        movement1 <= 5'b00000; place1 <= {2'b00, i_num[5:0]}; pc2 <= pc; //select
                        target_prev <= i_num;
                    end
                    else begin
                        if(signal[0] == 0) begin 
                            movement1 <= 5'b01000; place1 <= {2'b00, i_num[5:0]}; pc2 <= pc; 
                        end// move
                        else begin 
                            movement1 <= 5'b00001; place1 <= {2'b00, i_num[5:0]}; pc2 <= pc + 2; 
                        end// get the item
                    end
                end
                else if({op_code, func} == 5'b00101) begin
                    if(target_prev != i_num) begin
                        movement1 <= 5'b00000; place1 <= {2'b00, i_num[5:0]}; pc2 <= pc;
                        target_prev <= i_num; 
                    end // select
                    else begin
                        if(signal[0] == 0) begin 
                            movement1 <= 5'b01000; place1 <= {2'b00, i_num[5:0]}; pc2 <= pc; 
                        end // move
                        else begin 
                            movement1 <= 5'b00010; place1 <= {2'b00, i_num[5:0]}; pc2 <= pc + 2; 
                        end // put the item
                    end
                end
                else if({op_code, func} == 5'b00110) begin
                    if(target_prev != i_num) begin
                        movement1 <= 5'b00000; place1 <= {2'b00, i_num[5:0]}; pc2 <= pc; 
                        target_prev <= i_num;
                    end // select
                    else begin
                        if(signal[0] == 0) begin 
                            movement1 <= 5'b01000; place1 <= {2'b00, i_num[5:0]}; pc2 <= pc; 
                        end // move
                        else begin 
                            movement1 <= 5'b00100; place1 <= {2'b00, i_num[5:0]}; pc2 <= pc + 2; 
                        end // interact the item
                    end
                end
                else if({op_code, func} == 5'b00111) begin
                    if(target_prev != i_num) begin
                        movement1 <= 5'b00000; place1 <= {2'b00, i_num[5:0]}; moveCounter <= moveCounter + 1; pc2 <= pc; // select of neccessory
                        target_prev <= i_num;
                    end
                    else begin
                        movement1 <= 5'b10000; place1 <= {2'b00, i_num[5:0]}; moveCounter <= 1; pc2 <= pc + 2; // throw
                    end
                end
                else if({op_code, func} == 5'b10001) begin
                    case (moveCounter) 
                        1: begin movement1 <= 5'b00000; start <= 2'b01; place1 <= {start, 6'b000000}; moveCounter <= moveCounter + 1; pc2 <= pc;end
                        2: begin movement1 <= 5'b00000; start <= 2'b01; place1 <= {start, 6'b000000}; moveCounter <= moveCounter + 1; pc2 <= pc;end
                        3: begin movement1 <= 5'b00000; place1 <= 8'b00000000; moveCounter <= 1;pc2 <= pc + 2; end
                    endcase
                end
                else if({{op_code, func} == 5'b10010}) begin
                    case (moveCounter) 
                        1: begin movement1 <= 5'b00000; start <= 2'b10; place1 <= {start, 6'b000000}; moveCounter <= moveCounter + 1; pc2 <= pc; end
                        2: begin movement1 <= 5'b00000; place1 <= 8'b00000000; moveCounter <= 1; pc2 <= pc; end
                    endcase
                end
                else begin
                    movement1 <= movement; place1 <= place; pc2 <= pc; moveCounter <= 1;
                end
            end
            else begin
                movement1 <= 0; place1 <= 0; moveCounter <= 1; pc2 <= 0;
            end
        end
    end

    reg [4:0] movement2;
    reg [7:0] place2;
    // wating mode 1
    integer waitingCounter;
    always @(posedge slow_clk) begin
        if(~reset) begin
            pc3 <= 0;
            waitingCounter <= 0;
            movement2 <= movement;
            place2 <= place;
        end
        else begin
            if(~script_mode && {op_code, func} == 5'b01100 && i_num > 0) begin
                if(waitingCounter == i_num) begin
                    pc3 <= pc + 2;
                    waitingCounter <= 0;
                    movement2 <= movement;
                    place2 <= place;
                end
                else begin
                    pc3 <= pc;
                    waitingCounter <= waitingCounter + 1;
                    movement2 <= movement;
                    place2 <= place;
                end
            end
            else begin
                pc3 <= 0;
                waitingCounter <= 0;
                movement2 <= movement;
                place2 <= place;
            end
        end
    end

    reg [4:0] movement4;
    reg [7:0] place4;
    integer judge;
    // waiting mode 2
    always @(posedge s_clk) begin
        if(~reset) begin
            pc4 <= 0;
            movement4 <= movement;
            place4 <= place;
            judge <= 0;
        end
        else begin
            if(~script_mode) begin
                case ({op_code, func})
                    5'b01101: begin // wait until player has item -- 1
                        if(~judge && signal[i_sign] == 1) begin
                            judge <= 1;
                            pc4 <= pc + 2;
                            movement4 <= movement;
                            place4 <= place;
                        end
                        else begin
                            pc4 <= pc;
                            movement4 <= movement;
                            place4 <= place;
                            judge <= judge;
                        end
                    end
                    default: begin
                        pc4 <= pc;
                        movement4 <= movement;
                        place4 <= place;
                        judge <= 0;
                    end
                endcase
            end
            else begin
                pc4 <= 0;
                movement4 <= movement;
                place4 <= place;
                judge <= 0;
            end
        end
    end

    reg[7:0] pc6;
    reg [4:0] movement3;
    reg [7:0] place3;
    always@(*) begin
        pc6 = pc;
        movement3 = movement;
        place3 = place;
    end

    always @(*) begin
        if(~reset) begin
            pc = 0;
        end
        else begin
            if(script_mode) begin
                pc = 0;
            end
            else begin
                case({op_code, func})
                    5'b01000: begin pc = pc1; movement = movement1; place = place1; end
                    5'b01001: begin pc = pc1; movement = movement1; place = place1; end
                    5'b10001: begin pc = pc2; movement = movement1; place = place1; end
                    5'b10010: begin pc = pc2; movement = movement1; place = place1; end
                    5'b00100: begin pc = pc2; movement = movement1; place = place1; end
                    5'b00101: begin pc = pc2; movement = movement1; place = place1; end
                    5'b00110: begin pc = pc2; movement = movement1; place = place1; end
                    5'b00111: begin pc = pc2; movement = movement1; place = place1; end
                    5'b01100: begin pc = pc3; movement = movement2; place = place2; end
                    5'b01101: begin pc = pc4; movement = movement4; place = place4; end
                    default: begin pc = pc6; movement = movement3; place = place3; end
                endcase
            end
        end
    end
    



    // assign
    // assign led = i_num;
    // assign led = {pc[7:1], script_mode};
    // assign led = place;
    // assign led = moveCounter;
    // assign led = pc;
    // assign led = script[15:8];
    // assign led2 = script[7:0];
    // assign led2 = {signal[2], judge, i_sign, 2'b0, s_clk};
    // assign led2 = waitingCounter;
endmodule
