/*
this is the file which contains all parameters
*/
// clock divide
`define period1  650
`define period2  10000000
`define period3  500000

// mode judge
`define user 1'b1
`define script 1'b0

// control seven segment tube
`define tub1 4'b0001
`define tub2 4'b1000
`define tub3 4'b0100
`define tub4 4'b0010

// operation states
`define S_start 3'b000
`define S_end 3'b001
`define S_action 3'b010
`define S_target 3'b011

`define white  12'b1111_1111_1111 //RGB white
`define black  12'd0              //RGB black
`define blue  12'b1111_0000_0000   //RGB blue
`define wide  9'd64               //Vga squire wide
`define swide  9'd32              //Vga small squire wide
`define hight  9'd64              //Vga squire hight
`define line1  9'd200             //Vga 1st line y location (dataIn_bits)
`define line2  9'd300             //Vga 2ed line y location (signal)
`define line3  9'd400             //Vga 3rd line y location (pc)
`define line4  10'd500            //Vga 4th line y location (script)
`define startx  9'd300            //Vga start x location
`define space  6'd20              //Vga space wide
`define sspace  6'd10             //Vga small space wide
`define h_visible  1280           // Resolution: 1280*1024
`define h_front  48               //Vga parametric
`define h_sync  112               //Vga parametric
`define h_back  248               //Vga parametric
`define h_whole  1688             //Vga parametric
`define v_visible  1024           //Vga parametric
`define v_front  1                //Vga parametric
`define v_sync  3                 //Vga parametric
`define v_back  38                //Vga parametric
`define v_whole  1066             //Vga parametric
