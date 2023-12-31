`define period1  650
`define period2  10000000
`define period3  500000
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