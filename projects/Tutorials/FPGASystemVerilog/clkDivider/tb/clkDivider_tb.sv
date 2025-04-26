/*
 * CODER: Luis Fernando Rodriguez Gtz
 * DATE: 26/04/2025
 * PROJECT: clkDivider tb
 */


module tb_clkDivider;

    // Parameters
    localparam DIVISOR = 10; // Small divisor for fast simulation

    // Signals
    logic clk;
    logic rst;
    logic clk_out;

    // Instantiate clkDivider
    clkDivider #(
        .DIVISOR(DIVISOR)
    ) uut (
        .clk(clk),
        .rst(rst),
        .clk_out(clk_out)
    );

    // Clock generator (50MHz simulation clock)
    initial clk = 0;
    always #10 clk = ~clk; // 20ns period = 50MHz clock

    // Stimulus
    initial begin
        // Initialize signals
        rst = 1;
        #100;
        rst = 0;

        // Run simulation for enough time
        #2000;
        $stop;
    end

endmodule