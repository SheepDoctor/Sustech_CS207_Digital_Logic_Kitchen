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
    input script_mode,
    input [15:0] script, // contains instructions
    input uart_clk_16,
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

    // get data from software
    Receiver get(
        .clk(uart_clk_16), 
        .dataOut_ready(dataOut_ready), 
        .dataOut_bits(dataOut_bits), 
        .verify(verify),
        .channal(channal),
        .signal(signal)
        );
    // send data to software
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
    

    // dealing with inst, encode
    // data only changes when pc changes
    reg [1:0] func;      // Assuming 2 bits for func
    reg [2:0] op_code;   // Assuming 3 bits for op_code
    reg [7:0] i_num;
    reg [2:0] i_sign; 
    reg [1:0] state;
    reg wait_1, wait_2;

    always @(posedge uart_clk_16, negedge reset) begin
        if (~reset || script_mode) begin
            state <= 2'b00;
            func <= 2'b0;
            op_code <= 3'b0;
            i_num <= 8'b0;
            i_sign <= 3'b0;
        end
        else begin
            case (state)
                2'b00: begin  // Idle state
                    if (inst) begin
                        func <= func;
                        op_code <= op_code;
                        i_num <= i_num;
                        i_sign <= i_sign;
                        state <= 2'b01;  // Transition to the next state
                    end
                    else begin
                        func <= func;
                        op_code <= op_code;
                        i_num <= i_num;
                        i_sign <= i_sign;
                        state <= 2'b00;
                    end
                    // Additional logic for handling when inst is 0 if needed
                end
                2'b01: begin  // Update state
                    func <= inst[4:3];
                    op_code <= inst[2:0];
                    i_num <= inst[15:8];
                    i_sign <= inst[7:5];
                    state <= 2'b00;  // Transition back to idle state
                end
                default: begin
                    func <= func;
                    op_code <= op_code;
                    i_num <= i_num;
                    i_sign <= i_sign;
                    state <= 00;
                end
            endcase
        end
    end



    reg [1:0] start;
    reg s_clk;
    integer clk_counter = 1;
    always @(posedge clk) begin
        if(~reset || script_mode) begin
            clk_counter <= 1;
        end
        else begin
            if(clk_counter == 15000050) begin
                // if(clk_counter == 75000050) begin
                clk_counter <= 1;
                s_clk <= ~s_clk;
            end
            else begin
                clk_counter <= clk_counter + 1;
            end
        end 
    end

    reg [7:0] pc1, pc2, pc3, pc4;
    // jump instruction
    reg [1:0] jump;
    always @(posedge clk) begin
        if(~reset || script_mode) begin
            pc1 = 0;
            jump <= 2'b00;
        end
        else begin 
            if({op_code, func, wait_2} == 6'b010000) begin
                case(jump)
                    2'b00: begin // where the jump is not yet triggered and now it is triggered
                        if(signal[i_sign] == 1) begin
                            jump <= 2'b01;
                            pc1 <= pc;
                        end
                        else begin
                            jump <= 2'b10;
                            pc1 <= pc;
                        end
                    end
                    2'b01: begin // where jump is triggered and excution needed
                        jump <= 2'b11;
                        pc1 <= pc + i_num * 2;
                    end
                    2'b10: begin
                        jump <= 2'b11;
                        pc1 <= pc + 2;
                    end
                    2'b11: begin // maintain the state til the next inst coming
                        jump <= 2'b11;
                        pc1 <= pc;
                    end
                    default: begin
                        jump <= 2'b10;
                        pc1 <= pc;
                    end
                endcase
            end
            else if({op_code, func, wait_2} == 6'b010010) begin
                case(jump)
                    2'b00: begin // where the jump is not yet triggered and now it is triggered
                        if(signal[i_sign] == 0) begin
                            jump <= 2'b01;
                            pc1 <= pc;
                        end
                        else begin
                            jump <= 2'b10;
                            pc1 <= pc;
                        end
                    end
                    2'b01: begin // where jump is triggered and excution needed
                        jump <= 2'b11;
                        pc1 <= pc + i_num * 2;
                    end
                    2'b10: begin
                        jump <= 2'b11;
                        pc1 <= pc + 2;
                    end
                    2'b11: begin // maintain the state til the next inst coming
                        jump <= 2'b11;
                        pc1 <= pc;
                    end
                    default: begin
                        jump <= 2'b10;
                        pc1 <= pc;
                    end
                endcase
            end
            else begin
                pc1 <= pc;
                jump <= 2'b00;
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
        if(~reset || script_mode) begin
            movement1 <= 0; place1 <= 0; pc2 <= 0; target_prev <= 0; moveCounter <= 1;
        end
        else begin
            case({op_code, func, wait_2})
                6'b001000 : begin
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
                6'b001010 : begin
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
                6'b001100 : begin
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
                6'b001110 : begin
                    if(target_prev != i_num) begin
                        movement1 <= 5'b00000; place1 <= {2'b00, i_num[5:0]}; moveCounter <= moveCounter + 1; pc2 <= pc; // select of neccessory
                        target_prev <= i_num;
                    end
                    else begin
                        movement1 <= 5'b10000; place1 <= {2'b00, i_num[5:0]}; moveCounter <= 1; pc2 <= pc + 2; // throw
                    end
                end
                6'b100010 : begin
                    case (moveCounter) 
                        1: begin movement1 <= 5'b00000; start <= 2'b01; place1 <= {start, 6'b000000}; moveCounter <= moveCounter + 1; pc2 <= pc;end
                        2: begin movement1 <= 5'b00000; start <= 2'b01; place1 <= {start, 6'b000000}; moveCounter <= moveCounter + 1; pc2 <= pc;end
                        3: begin movement1 <= 5'b00000; place1 <= 8'b00000000; moveCounter <= 1;pc2 <= pc + 2; end
                        default: begin movement1 <= 5'b00000; place1 <= 8'b00000000; moveCounter <= 1; pc2 <= pc; end
                    endcase
                end
                6'b100100 : begin
                    case (moveCounter) 
                        1: begin movement1 <= 5'b00000; start <= 2'b10; place1 <= {start, 6'b000000}; moveCounter <= moveCounter + 1; pc2 <= pc; end
                        2: begin movement1 <= 5'b00000; place1 <= 8'b00000000; moveCounter <= 1; pc2 <= pc; end
                        default: begin movement1 <= 5'b00000; place1 <= 8'b00000000; moveCounter <= 1; pc2 <= pc; end
                    endcase
                end
                default : begin
                    movement1 <= movement; place1 <= place; pc2 <= pc; moveCounter <= 1;
                end
            endcase
        end
    end


    reg wait_1_f;
    integer waitingCounter;
    // waiting mode 1
    always @(posedge slow_clk) begin
        if(~reset || script_mode) begin
            pc3 <= 0;
            wait_1 <= 0;
            wait_1_f <= 0;
        end
        else begin
            if({op_code, func} == 5'b01100) begin
                casex({wait_1_f, wait_1}) 
                    3'b00: begin // state 00 means it was not triggered at first, here it triggered
                        {wait_1_f, wait_1} <= 2'b01;
                        pc3 <= pc;
                        waitingCounter <= 1; // reset the waitingCounter
                    end
                    3'b01: begin // the state is an idle state, when time is up, it moves to next state
                        if(waitingCounter == i_num) begin // if time is up
                            pc3 <= pc + 2;
                            waitingCounter <= 1; // reset the waitingCounter
                        end
                        else begin // still counting
                            waitingCounter <= waitingCounter + 1;
                        end
                    end
                    3'b11: begin // waitutil is done, waiting the next inst coming and the case would break
                        {wait_1_f, wait_1} <= 2'b11;
                        pc3 <= pc;
                    end
                    default: begin // defalut state when waitutil is triggered
                        {wait_1_f, wait_1} <= 2'b00;
                        pc3 <= pc;
                    end
                endcase
            end
            else begin
                {wait_1_f, wait_1} <= 2'b00;
                pc3 <= pc;
            end
        end
    end


    reg wait_2_f;
    // waiting mode 2
    always @(posedge clk) begin
        if(~reset || script_mode) begin
            pc4 <= 0;
            wait_2 <= 0;
            wait_2_f <= 0;
        end
        else begin
            if({op_code, func} == 5'b01101) begin
                casex({wait_2_f, wait_2, signal[i_sign]}) 
                    3'b00x: begin // state 00 means it was not triggered at first
                        {wait_2_f, wait_2} <= 2'b01;
                        pc4 <= pc;
                    end
                    3'b010: begin // state 01 means waitutil is triggered but the mission is still processing
                        {wait_2_f, wait_2} <= 2'b01;
                        pc4 <= pc;
                    end
                    3'b011: begin // the signal gets ready and ready to add pc
                        {wait_2_f, wait_2} <= 2'b11;
                        pc4 <= pc + 2;
                    end
                    3'b11x: begin // waitutil is done, waiting the next inst coming and the case would break
                        {wait_2_f, wait_2} <= 2'b11;
                        pc4 <= pc;
                    end
                    default: begin // defalut state when waitutil is triggered
                        {wait_2_f, wait_2} <= 2'b00;
                        pc4 <= pc;
                    end
                endcase
            end
            else begin
                {wait_2_f, wait_2} <= 2'b00;
                pc4 <= pc;
            end
        end
    end

    wire [7:0] pc5, movement2;
    wire [4:0] place2;
    assign pc5 = pc;
    assign movement2 = movement;
    assign place2 = place;

    always @(*) begin
        if(~reset) begin
            pc = 0;
            movement = 0; 
            place = 0;
        end
        else begin
            if(script_mode) begin
                pc = 0;
            end
            else begin
                casex({op_code, func, wait_2})
                    6'b010000: begin pc = pc1; movement = movement2; place = place2; end // jumpif
                    6'b010010: begin pc = pc1; movement = movement2; place = place2; end // jumpifnot
                    6'b100010: begin pc = pc2; movement = movement1; place = place1; end // game start
                    6'b100100: begin pc = pc2; movement = movement1; place = place1; end // game end
                    6'b001000: begin pc = pc2; movement = movement1; place = place1; end // get
                    6'b001010: begin pc = pc2; movement = movement1; place = place1; end // put
                    6'b001100: begin pc = pc2; movement = movement1; place = place1; end // interact
                    6'b001110: begin pc = pc2; movement = movement1; place = place1; end // throw
                    6'b01100x: begin pc = pc3; movement = movement2; place = place2;end // wait signal
                    6'b01101x: begin pc = pc4; movement = movement2; place = place2;end // waitutil signal
                    default: begin pc = pc5; movement = movement2; place = place2;end // other inst
                endcase
            end
        end
    end

assign led = i_num;
assign led2 = pc;
endmodule
