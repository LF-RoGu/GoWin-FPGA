/*
 * CODER: Luis Fernando Rodriguez Gtz
 * DATE: 26/04/2025
 * PROJECT: clkDivider
 */
module ledCounter(
    input  logic clk,
    input  logic rst,
    output logic [7:0] leds
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        leds <= 8'd0;
    end else if (leds == 8'd255) begin
        leds <= 8'd0; // Reset on overflow
    end else begin
        leds <= leds + 8'd1;
    end
end

endmodule