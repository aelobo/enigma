`default_nettype none

/**
 * library.sv
 *
 * Enigma Machine
 *
 * ECE 18-500
 * Carnegie Mellon University
 *
 * This is the library of standard components used by the enigma machine,
 * which includes both synchronous and combinational components.
 **/

/*----------------------------------------------------------------------------*
 *  Combinational Components                                                  *
 *----------------------------------------------------------------------------*/

// Mux2to1
module Mux2to1
  #(parameter WIDTH = 8)
  (input  logic [WIDTH-1:0] I0, I1,
   input  logic S,
   output logic [WIDTH-1:0] Y);

  assign Y = (S) ? I1 : I0;

endmodule: Mux2to1

/*----------------------------------------------------------------------------*
 *  Synchronous Components                                                    *
 *----------------------------------------------------------------------------*/