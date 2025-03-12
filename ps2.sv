`default_nettype none

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
    logic                   ps2_clk_neg_edge;

    // FSM states
    enum logic [2:0] {IDLE, START, DATA, PARITY, STOP} state, nextState;

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


    // State transition
    always_ff @(posedge clk, negedge rst_l) begin
        if (~rst_l)
            state <= IDLE;
        else if (ps2_clk_neg_edge)
            state <= nextState;
    end


    // Next state logic
    always_comb begin
        unique case (state)
            IDLE:    nextState = (ps2_data) ? IDLE : START;
            START:   nextState = DATA;                                  // Data is low --> START bit
            DATA:    nextState = (counter == 4'd7) ? PARITY : DATA;     // 1 byte data sent
            PARITY:  nextState = STOP;      
            STOP:    nextState = (ps2_data) ? STOP : START;             // Data is high --> STOP bit
            default: nextState = IDLE;
        endcase
    end


    // Output logic
    always_ff @(posedge clk) begin
        unique case (state)
            IDLE: begin
                counter <= 4'b0;                        // Reset bit counter
                shift_reg <= 11'b0;                     // Clear shift register
                key_rdy <= 1'b0;                        // Clear key ready flag
                key_out <= 8'b0;                        // Clear key code
            end
            START: begin
                counter <= 4'b0;                        // Reset bit counter
                shift_reg <= 11'b0;                     // Clear shift register
                key_rdy <= 1'b0;                        // Clear key ready flag
                key_out <= 8'b0;                        // Clear key code
            end
            DATA: begin
                if (ps2_clk_neg_edge && (counter < 4'd7)) begin
                    counter <= counter + 1'b1;
                    shift_reg <= {ps2_data, shift_reg[10:1]};           // Shift data in
                end
                else if (ps2_clk_neg_edge && (counter == 4'd7)) begin
                    counter <= counter;
                    shift_reg <= {ps2_data, shift_reg[10:1]};           // Shift data in
                end
                else begin
                    counter <= counter;
                    shift_reg <= shift_reg;
                end
                key_rdy <= 1'b0;
                key_out <= 8'b0;
            end
            PARITY: begin
                counter <= 4'b0;
                if (ps2_clk_neg_edge) begin
                    shift_reg <= {ps2_data, shift_reg[10:1]};           // Shift data in
                    key_out <= shift_reg[9:2];                          // Final 8 bits
                    key_rdy <= 1'b1;                                    // Assert key code is ready
                end 
                else begin
                    shift_reg <= shift_reg;
                    key_rdy <= key_rdy;
                    key_out <= key_out;
                end
            end
            STOP: begin
                counter <= 4'b0;
                shift_reg <= shift_reg;
                key_rdy <= key_rdy;
                key_out <= key_out;
            end
            default: begin
                counter <= counter;
                shift_reg <= shift_reg;
                key_rdy <= key_rdy;
                key_out <= key_out;
            end
        endcase
    end
    
endmodule: ps2