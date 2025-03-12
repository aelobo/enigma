`default_nettype none

/**
 * chipInterface.sv
 *
 * Enigma Machine
 *
 * ECE 18-500
 * Carnegie Mellon University
 *
 * This is the chip interface!
 * 
 **/

/*----------------------------------------------------------------------------*
 *  Chip interface                                                            *
 *----------------------------------------------------------------------------*/
module chipInterface
    (input  logic   CLOCK_50,   // clock source
     
     inout  logic   PS2_CLK,    // ps2_clk  signal inout??
     inout  logic   PS2_DAT,    // ps2_data signal inout??

     input  logic [3:0] KEY,
	 input  logic [9:0] LEDR,
     output logic [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);

    logic       key_rdy;
    logic [6:0] key_out, segment;

    logic       RST_L;


    assign RST_L    = ~KEY[0];
    assign HEX0     = (key_rdy) ? key_out : 7'b0;
    assign HEX5     = 7'h7F;
    
    // ps2 keyboard
    ps2 ps2_keyboard(
                .clk(CLOCK_50),     // source clock
                .rst_l(RST_L),      // active low reset KEY0
                .ps2_clk(PS2_CLK),  // ps2 clock
                .ps2_data(PS2_DAT), // ps2 data
                .key_rdy(key_rdy),  // keyboard ready signal LED0
                .key_out(key_out)   // keyboard scan code output
    );

    scanCodetoSevenSegment sevenSeg(
                            .scan_code(key_out),    // input keyboard scan code
                            .segment(HEX0)          // output on HEX0
    );
    


endmodule: chipInterface