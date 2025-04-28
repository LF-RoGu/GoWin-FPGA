/*
 * CODER: Luis Fernando Rodriguez Gtz
 * DATE: 26/04/2025
 * PROJECT: clkDivider
 */

module top(
    input logic rst_n,
    output logic [7:0] out_bits
);
logic clk_internal;
logic slow_clk;

logic rst;
assign rst = ~rst_n;         // Invert reset input

Gowin_OSC u_osc (
        .oscout(clk_internal),     // Connect oscillator output
        .oscen(1'b1)               // Always enable oscillator
);

clkDivider 
#(
    .DIVISOR(97_500)  // Adjust if needed
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