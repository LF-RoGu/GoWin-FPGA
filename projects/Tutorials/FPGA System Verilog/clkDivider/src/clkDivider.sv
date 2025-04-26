/*
 * CODER: Luis Fernando Rodriguez Gtz
 * DATE: 26/04/2025
 * PROJECT: clkDivider
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
        if (counter == DIVISOR-1) begin
            counter <= 0;
            clk_out <= ~clk_out;  // Toggle output clock
        end else begin
            counter <= counter + 1;
        end
    end
end

endmodule