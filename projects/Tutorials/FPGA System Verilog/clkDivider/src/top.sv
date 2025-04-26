/*
 * CODER: Luis Fernando Rodriguez Gtz
 * DATE: 26/04/2025
 * PROJECT: clkDivider
 */

module top(
    input  logic rst,
    output logic [7:0] leds
);

wire clk_internal;
logic slow_clk;

GOWIN_OSC 
#(
    .OSC_EN("ENABLE"),  // enable oscillator
    .OSC_FREQ("2.08")   // or "25" for 25 MHz if available
) 
internal_clk_inst 
(
    .osc_clk(clk_internal)
);

clkDivider 
#(
    .DIVISOR(27_000_000) // default to divide 27MHz to ~1Hz
) 
u_clkDivider 
(
    .clk_in(clk_internal),
    .rst(rst),
    .clk_out(slow_clk)
);

ledCounter u_ledCounter 
(
    .clk(slow_clk),
    .rst(rst),
    .leds(leds)
);

endmodule