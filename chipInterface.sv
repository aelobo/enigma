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
     
     input  logic   PS2_CLK,    // ps2_clk  signal inout??
     input  logic   PS2_DAT,    // ps2_data signal inout??

     input  logic [3:0] KEY,
	 input  logic [9:0] LEDR,
     output logic [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);

    
    logic RST_L = ~KEY[0];
    
    // ps2 keyboard
    ps2 ps2_keyboard(
                .clk(CLOCK_50),     // source clock
                .rst_l(RST_L),      // active low reset KEY0
                .ps2_clk(PS2_CLK),  // ps2 clock
                .ps2_data(PS2_DAT), // ps2 data
                .key_rdy(LEDR[0]),  // keyboard ready signal LED0
                .key_out(HEX0)      // keyboard output displayed on HEX0
    );

    assign HEX5 = 7'h7F;


endmodule: chipInterface