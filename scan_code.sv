`default_nettype none

/**
 * scan_code.sv
 *
 * Enigma Machine
 *
 * ECE 18-500
 * Carnegie Mellon University
 *
 * This is the ps2 scan code to seven segment display mapping
 **/

/*----------------------------------------------------------------------------*
 *  Scan code to seven-segment display                                        *
 *----------------------------------------------------------------------------*/

module scanCodetoSevenSegment
    (input  logic       key_rdy,
     input  logic [7:0] scan_code,  
     output logic [6:0] segment);

    always_comb begin
        unique case (scan_code)
            8'h1C: segment = 7'b111_0111;       // A
            8'h32: segment = 7'b001_1111;       // B
            8'h21: segment = 7'b100_1110;       // C
            8'h23: segment = 7'b011_1101;       // d
            8'h24: segment = 7'b100_1111;       // E
            8'h2B: segment = 7'b100_0111;       // F
            8'h34: segment = 7'b111_1011;       // g
            8'h33: segment = 7'b011_0111;       // H
            8'h43: segment = 7'b011_0000;       // I
            8'h3B: segment = 7'b011_1000;       // J
            8'h42: segment = 7'b000_0111;       // K
            8'h4B: segment = 7'b000_1110;       // L
            8'h3A: segment = 7'b101_0100;       // M
            8'h31: segment = 7'b111_0110;       // n
            8'h44: segment = 7'b111_1110;       // O
            8'h4D: segment = 7'b110_0111;       // p
            8'h15: segment = 7'b111_0011;       // q
            8'h2D: segment = 7'b100_0110;       // r
            8'h1B: segment = 7'b101_1011;       // S
            8'h2C: segment = 7'b000_1111;       // t
            8'h3C: segment = 7'b011_1110;       // U
            8'h2A: segment = 7'b001_1100;       // v
            8'h1D: segment = 7'b010_1010;       // W
            8'h22: segment = 7'b011_0001;       // X
            8'h35: segment = 7'b011_1011;       // y
            8'h1A: segment = 7'b110_1101;       // Z
        endcase
    end

endmodule: scanCodetoSevenSegment