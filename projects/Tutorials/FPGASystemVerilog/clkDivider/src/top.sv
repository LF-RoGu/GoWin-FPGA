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

clkDivider 
#(
    .DIVISOR(10)  // Adjust if needed
) 
clkDivider_top (
    .clk(clk),
    .rst(rst),
    .clk_out(slow_clk)
);

ledCounter 
ledCounter_top 
(
    .clk(slow_clk),
    .rst(rst),
    .leds(leds)
);

endmodule