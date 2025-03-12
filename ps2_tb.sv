`default_nettype none

module ps2_tb;

    // Parameters
    localparam SYSTEM_CLK_PERIOD = 5; // 50MHz clock period (5ns)
    localparam PS2_CLK_PERIOD = 100000; // 10kHz clock period (100us)

    // Inputs
    logic clk, rst_l;
    logic ps2_clk, ps2_data;

    // Outputs
    logic key_rdy;
    logic [7:0] key_out;

    // Instantiate the module
    ps2 uut (
        .clk(clk),
        .rst_l(rst_l),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .key_rdy(key_rdy),
        .key_out(key_out)
    );

    // Clock generation
    initial begin
        clk = 1'b0;
        forever #(SYSTEM_CLK_PERIOD / 2) clk = ~clk;
    end

    // PS/2 clock generation
    initial begin
        ps2_clk = 1'b1;
        forever #(PS2_CLK_PERIOD / 2) ps2_clk = ~ps2_clk;
    end

    // Reset generation
    // initial begin
    //     rst_l = 1'b0;
    //     #1000000;
    //     rst_l = 1'b1;
    // end

    // PS/2 Data Simulation (Example: sending 'A' - scan code 0x1C)
    initial begin
        rst_l = 1'b0;
        #200000;
        rst_l = 1'b1;
        
        // #200000; // Wait for clocks to stabilize

        // Example: 'A' (scan code 0x1C = 00011100)
        // PS/2 data: start bit (0), data bits (00111000), parity (1), stop bit (1)
        // PS/2 data (reversed): 0 00011100 1 1

        // Idle state
        ps2_data = 1'b1; #(PS2_CLK_PERIOD);
        ps2_data = 1'b1; #(PS2_CLK_PERIOD);
        ps2_data = 1'b1; #(PS2_CLK_PERIOD);


        // Start bit
        ps2_data = 1'b0;
        #(PS2_CLK_PERIOD); // Wait for falling edge

        // Data bits (LSB first)
        ps2_data = 1'b0; #(PS2_CLK_PERIOD);
        ps2_data = 1'b0; #(PS2_CLK_PERIOD);      
        ps2_data = 1'b1; #(PS2_CLK_PERIOD);
        ps2_data = 1'b1; #(PS2_CLK_PERIOD);
        ps2_data = 1'b1; #(PS2_CLK_PERIOD);
        ps2_data = 1'b0; #(PS2_CLK_PERIOD);
        ps2_data = 1'b0; #(PS2_CLK_PERIOD);
        ps2_data = 1'b0; #(PS2_CLK_PERIOD);

        // Parity bit (odd parity)
        ps2_data = 1'b1; #(PS2_CLK_PERIOD);

        // Stop bit
        ps2_data = 1'b1; #(PS2_CLK_PERIOD);

        // Idle state
        ps2_data = 1'b1; #(PS2_CLK_PERIOD);
        ps2_data = 1'b1; #(PS2_CLK_PERIOD);
        ps2_data = 1'b1; #(PS2_CLK_PERIOD);

        // Start bit
        ps2_data = 1'b0;
        #(PS2_CLK_PERIOD); // Wait for falling edge

        // Data bits (LSB first)
        ps2_data = 1'b0; #(PS2_CLK_PERIOD);
        ps2_data = 1'b0; #(PS2_CLK_PERIOD);      
        ps2_data = 1'b1; #(PS2_CLK_PERIOD);
        ps2_data = 1'b1; #(PS2_CLK_PERIOD);
        ps2_data = 1'b1; #(PS2_CLK_PERIOD);
        ps2_data = 1'b0; #(PS2_CLK_PERIOD);
        ps2_data = 1'b0; #(PS2_CLK_PERIOD);
        ps2_data = 1'b0; #(PS2_CLK_PERIOD);

        // Parity bit (odd parity)
        ps2_data = 1'b1; #(PS2_CLK_PERIOD);

        // Stop bit
        ps2_data = 1'b1; #(PS2_CLK_PERIOD);

        #1000000; // Wait a bit
        $finish;
    end

    // Monitor key_rdy and key_out
    always @(posedge key_rdy) begin
        $display("Key ready: key_out = %h at time %t", key_out, $time);
    end

    // Monitor the ps2 clk neg edge.
    always @(posedge clk) begin
      if(uut.ps2_clk_neg_edge) $display("ps2 neg edge at time %t", $time);
    end

endmodule