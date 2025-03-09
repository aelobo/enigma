`default_nettype none

module scanCodetoSevenSegment
    (input  logic       key_rdy,
     input  logic [7:0] scan_code,  
     output logic [6:0] segment);



    always_comb begin
        unique case (scan_code)
            8'h1C: segment = 7'bxxx_xxxx;       // A
            8'h32: segment = 7'bxxx_xxxx;       // B
            8'h21: segment = 7'bxxx_xxxx;       // C
            8'h23: segment = 7'bxxx_xxxx;       // D
            8'h24: segment = 7'bxxx_xxxx;       // E
            8'h2B: segment = 7'bxxx_xxxx;       // F
            8'h34: segment = 7'bxxx_xxxx;       // G
            8'h33: segment = 7'bxxx_xxxx;       // H
            8'h43: segment = 7'bxxx_xxxx;       // I
            8'h3B: segment = 7'bxxx_xxxx;       // J
            8'h42: segment = 7'bxxx_xxxx;       // K
            8'h4B: segment = 7'bxxx_xxxx;       // L
            8'h3A: segment = 7'bxxx_xxxx;       // M
            8'h31: segment = 7'bxxx_xxxx;       // N
            8'h44: segment = 7'bxxx_xxxx;       // O
            8'h4D: segment = 7'bxxx_xxxx;       // P
            8'h15: segment = 7'bxxx_xxxx;       // Q
            8'h2D: segment = 7'bxxx_xxxx;       // R
            8'h1B: segment = 7'bxxx_xxxx;       // S
            8'h2C: segment = 7'bxxx_xxxx;       // T
            8'h3C: segment = 7'bxxx_xxxx;       // U
            8'h2A: segment = 7'bxxx_xxxx;       // V
            8'h1D: segment = 7'bxxx_xxxx;       // W
            8'h22: segment = 7'bxxx_xxxx;       // X
            8'h35: segment = 7'bxxx_xxxx;       // Y
            8'h1A: segment = 7'bxxx_xxxx;       // Z
        endcase
    end

endmodule: scanCodetoSevenSegment