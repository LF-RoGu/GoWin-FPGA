/*
 * CODER: Luis Fernando Rodriguez Gtz
 * DATE: 26/04/2025
 * PROJECT: clkDivider
 */

module clkDivider
#(
    parameter integer DIVISOR = 27_000_000   // default divide for 1 Hz from 27MHz
)
(
    /** INPUT*/
    input logic clk_in, //27MHz
    input logic rst,
    /** OUTPUT*/
    output logic clk_out
);

    logic [$clog2(DIVISOR)-1:0] counter;

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter == DIVISOR-'d1) begin
                counter <= 'd0;
                clk_out <= ~clk_out; // toggle
            end else begin
                counter <= counter + 8'd1;
            end
        end
    end

endmodule