/*
 * CODER: Luis Fernando Rodriguez Gtz
 * DATE: 26/04/2025
 * PROJECT: clkDivider
 */

module top(
    input logic rst,
    output logic [7:0] out_bits
);
wire clk_internal;
wire logic slow_clk;

// Instantiate Gowin Oscillator
Gowin_OSC osc_top (
    .oscout(clk_internal),
    .oscen(1'b1)
);

clkDivider 
#(
    .DIVISOR(1_000)  // Adjust if needed
) 
clkDivider_top (
    .clk(clk_internal),
    .rst(rst),
    .clk_out(slow_clk)
);

bitShifter 
bitShifter_top 
(
    .clk(slow_clk),
    .rst(rst),
    .out_bits(out_bits)
);

endmodule