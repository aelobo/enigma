`default_nettype none

/**
 * ps2.sv
 *
 * Enigma Machine
 *
 * ECE 18-500
 * Carnegie Mellon University
 *
 * This is 
 * 
 **/

/*----------------------------------------------------------------------------*
 *  PS2 protocol                                                              *
 *----------------------------------------------------------------------------*/
module ps2 
    (input  logic           clk, rst_l,
     input  logic           ps2_clk, ps2_data,
     output logic           key_rdy,
     output logic [7:0]     key_out);

    logic [10:0]            shift_reg;
    logic [3:0]             counter;
    // logic                   ps2_clk_sync;
    logic                   ps2_clk_neg_edge;

    enum logic [1:0] {START, DATA, PARITY, STOP} state, nextState;

    // Intermediate signals
    logic peripheral_clk_10khz_d1;
    logic peripheral_clk_10khz_d2;
    logic falling_edge_raw;
    logic falling_edge_sync1;
    logic falling_edge_sync2;

    // Double flop for peripheral clock synchronization
    always_ff @(posedge clk or negedge rst_l) begin
        if (~rst_l) begin
            peripheral_clk_10khz_d1 <= 1'b0;
            peripheral_clk_10khz_d2 <= 1'b0;
        end else begin
            peripheral_clk_10khz_d1 <= ps2_clk;
            peripheral_clk_10khz_d2 <= peripheral_clk_10khz_d1;
        end
    end

    // Detect raw falling edge
    assign falling_edge_raw = peripheral_clk_10khz_d1 & ~peripheral_clk_10khz_d2;

    // Double flop for falling edge synchronization
    always_ff @(posedge clk or negedge rst_l) begin
        if (~rst_l) begin
            falling_edge_sync1 <= 1'b0;
            falling_edge_sync2 <= 1'b0;
        end else begin
            falling_edge_sync1 <= falling_edge_raw;
            falling_edge_sync2 <= falling_edge_sync1;
        end
    end

    // Output synchronized falling edge
    assign ps2_clk_neg_edge = falling_edge_sync2;



    // state transition
    always_ff @(posedge clk, negedge rst_l) begin
        if (~rst_l)
            state <= START;         // start state
        else if (ps2_clk_neg_edge)
            state <= nextState;
    end


    // Next state logic
    always_comb begin
        unique case (state)
            START:   nextState = (~ps2_data) ? DATA : START;                    // data is low --> START bit
            DATA:    nextState = (counter == 4'd8) ? PARITY : DATA;             // 1 byte data sent
            PARITY:  nextState = STOP;
            STOP:    nextState = (ps2_clk_neg_edge && ps2_data) ? START : STOP; // data is high --> STOP bit
            default: nextState = START;
        endcase
    end

    // Output logic
    always_ff @(posedge clk) begin
        // default outputs
        shift_reg <= 11'b0;     // clear shift register
        counter <= 4'b0;        // reset bit counter
        key_rdy <= 1'b0;        // clear key ready flag
        key_out <= 8'b0;        // clear key code

        unique case (state)
            START: begin
                counter <= 1'b0;
                shift_reg <= 11'b0;
            end
            DATA: begin
                if (ps2_clk_neg_edge && (counter < 4'd8)) begin
                    counter <= counter + 1'b1;
                    shift_reg <= {ps2_data, shift_reg[10:1]};    // shift data in
                end
            end
            PARITY: begin
                counter <= 1'b0;
                if (ps2_clk_neg_edge)
                    shift_reg <= {ps2_data, shift_reg[10:1]};   // shift data in
            end
            STOP: begin
                if (ps2_clk_neg_edge) begin
                    shift_reg <= {ps2_data, shift_reg[10:1]};   // shift data in
                    key_rdy <= 1'b1;                            // assert key code is ready
                    key_out <= shift_reg[9:2];                  // final 8 bits
                end
            end
            default: begin
                shift_reg <= shift_reg;
                counter <= counter;
                key_rdy <= key_rdy;
                key_out <= key_out;
            end
        endcase
    end
    
endmodule: ps2