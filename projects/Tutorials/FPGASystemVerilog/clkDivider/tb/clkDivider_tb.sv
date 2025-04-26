/*
 * CODER: Luis Fernando Rodriguez Gtz
 * DATE: 26/04/2025
 * PROJECT: clkDivider tb
 */


module tb_top;

    logic clk;
    logic rst;
    logic [7:0] leds;
    logic slow_clk;

    // DUTs (Design Under Test)
    clkDivider
    #(
        .DIVISOR(10)  // Adjust if needed
    )  
    clkDivider_top (
        .clk(clk),
        .rst(rst),
        .clk_out(slow_clk)
    );

    ledCounter ledCounter_top (
        .clk(slow_clk),
        .rst(rst),
        .leds(leds)
    );

    // Clock generation (50MHz simulation clock)
    initial clk = 0;
    always #10 clk = ~clk;

    // Stimulus
    initial begin
        rst = 1;
        #100;
        rst = 0;

        #10_000_000;
        $stop;
    end

endmodule
