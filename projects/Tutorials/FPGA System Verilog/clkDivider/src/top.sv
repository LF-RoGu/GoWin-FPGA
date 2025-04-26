/*
 * CODER: Luis Fernando Rodriguez Gtz
 * DATE: 26/04/2025
 * PROJECT: clkDivider
 */

module top(
    input logic clk,
    input logic rst,
    output logic [7:0] leds
);

wire logic slow_clk;
logic internal_clk;

initial internal_clk = 0;
always #500_000_000  internal_clk = ~internal_clk;  // 20ns period = 50MHz clock

clkDivider 
#(
    .DIVISOR(50)  // Adjust if needed
) 
clkDivider_top (
    .clk(clk),
    .rst(rst),
    .clk_out(slow_clk)
);

ledCounter 
ledCounter_top 
(
    .clk(internal_clk),
    .rst(rst),
    .leds(leds)
);

endmodule