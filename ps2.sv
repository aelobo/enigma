`default_nettype none

/*----------------------------------------------------------------------------*
 *  PS2 protocol                                                              *
 *----------------------------------------------------------------------------*/
module ps2 
    (input  logic           clk,
     input  logic           ps2_clk, ps2_data, rst_l,
     output logic           key_rdy
     output logic [7:0]     key_out);

    logic [10:0]            shift_reg;
    logic [3:0]             counter;
    logic                   ps2_clk_sync, ps2_clk_sync_d;
    logic                   ps2_clk_neg_edge;

    enum logic [1:0] {START, DATA, STOP} state, nextState;

    always_ff @(posedge clk, negedge rst_l) begin
        if (~rst_l) begin
            state <= START;         // start state
            nextState <= START;     // start state

            ps2_clk_sync <= 1'b1;  
            ps2_clk_sync_d <= 1'b1;

            shift_reg <= 11'b0;     // clear shift register
            counter <= 4'b0;        // reset bit counter
            key_rdy <= 1'b0;        // clear key ready flag
            key_out <= 8'b0;        // clear key code
        end else begin
            ps2_clk_sync <= ps2_clk;
            ps2_clk_sync_d <= ps2_clk_sync;
        end
    end

    // detect falling edge of PS2 clock
    ps2_clk_neg_edge = (ps2_clk_sync_d == 1'b1) && (ps2_clk_sync == 1'b0);

    always_ff @(posedge clk, negedge rst_l) begin
        if (~rst_l)
            state <= START;
        else if (ps2_clk_neg_edge) // update next state on PS2 clock falling edge
            state <= nextState;
    end

    // Next state logic
    always_comb begin
        unique case (state)
            START:   nextState = (~ps2_data) ? DATA : START ;
            DATA:    nextState = (counter == 4'd8) ? STOP : DATA;
            STOP:    nextState = (ps2_clk_neg_edge && ps2_data) ? START : STOP;
            default: nextState = START;
        endcase
    end

    // Output logic
    always_ff @(posedge clk) begin
        // default outputs
        key_rdy <= 1'b0;
        key_out <= 8'b0; 
        
        unique case (state)
            START: begin
                counter <= 1'b0;
                shift_reg <= 1'b0;
            end
            DATA: begin
                if (ps2_clk_neg_edge) begin
                    counter <= counter + 1'b0;
                    shift_reg <= {ps2_data, shift_reg[10:1]};
                end
            end
            STOP: begin
                if (ps2_clk_neg_edge && ps2_data) begin
                    key_out <= shift_reg[9:2];
                    key_rdy <= 1'b1;
                end
            end
        endcase
    end
    
endmodule: ps2