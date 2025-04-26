/*
 * CODER: Luis Fernando Rodriguez Gtz
 * DATE: 14/Ago/2023
 * PROJECT: BCD Decoder using Shift-and-Add-3 (Double Dabble)
 */
 
import common_pkg::*;

module decoder_bin2bcd
(
    /** INPUT */
    input  binary_data_t binary_data,  // Assume 8-bit input for 0-255 range

    /** OUTPUT */
    output bcd_data_t binary_data_units,
    output bcd_data_t binary_data_tens,
    output bcd_data_t binary_data_hundreds
);

    logic [19:0] shift_reg;
    integer i;

    always_comb begin
        // Initialize the shift register
        shift_reg = 20'd0;
        shift_reg[7:0] = binary_data; // Place binary input in lowest 8 bits

        // Perform Double Dabble algorithm for 8 bits
        for (i = 0; i < 8; i = i + 1) begin
            // Add 3 to BCD digits if >= 5
            if (shift_reg[11:8] >= 5)
                shift_reg[11:8] = shift_reg[11:8] + 3;
            if (shift_reg[15:12] >= 5)
                shift_reg[15:12] = shift_reg[15:12] + 3;
            if (shift_reg[19:16] >= 5)
                shift_reg[19:16] = shift_reg[19:16] + 3;

            // Left shift the entire register
            shift_reg = shift_reg << 1;
        end

        // Extract BCD digits
        binary_data_units    = shift_reg[11:8];
        binary_data_tens     = shift_reg[15:12];
        binary_data_hundreds = shift_reg[19:16];
    end

endmodule
