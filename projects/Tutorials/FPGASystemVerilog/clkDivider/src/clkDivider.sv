/*
 * CODER: Luis Fernando Rodriguez Gtz
 * DATE: 26/04/2025
 * PROJECT: clkDivider
 */

/*
 * Clock Divider Module
 * 
 * DIVISOR Formula:
 * 
 *    DIVISOR = F_in / (2 * F_out)
 * 
 * Where:
 *    - F_in  = Input clock frequency (in Hz)
 *    - F_out = Desired output clock frequency (in Hz)
 *
 * Behavior:
 *    - clk_out toggles every DIVISOR input clock cycles.
 *    - Full period of clk_out = 2 * DIVISOR cycles.
 *
 * Example:
 *    Input clock (F_in) = 195,000 Hz
 *    Desired output (F_out) = 1 Hz
 *    
 *    DIVISOR = 195,000 / (2 * 1) = 97,500
 */


module clkDivider 
#(
    parameter integer DIVISOR = 25_000_000  // Default to ~1Hz from 25MHz clock
)
(
    input clk,    // Input clock (internal 25-27 MHz)
    input rst,    // Reset input
    output reg clk_out  // Divided clock output
);

reg [$clog2(DIVISOR)-1:0] counter;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        clk_out <= 0;
    end else begin
        if (counter > DIVISOR-1) begin
            counter <= 0;
            clk_out <= ~clk_out;  // Toggle output clock
        end else begin
            counter <= counter + 'd1;
        end
    end
end

endmodule