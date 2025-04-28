/*
 * CODER: Luis Fernando Rodriguez Gtz
 * DATE: 28/04/2025
 * PROJECT: Bit Shifter with auto restart
 */
module bitShifter(
    input  logic clk,
    input  logic rst,
    output logic [7:0] out_bits
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        out_bits <= 8'b1000_0000; // Start with MSB = 1
    end else begin
        if (out_bits == 8'b0000_0001) begin
            out_bits <= 8'b1000_0000; // Restart when reach LSB
        end else begin
            out_bits <= out_bits >> 1; // Otherwise shift right
        end
    end
end

endmodule
