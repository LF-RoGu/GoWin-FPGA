/*
 * CODER: Luis Fernando Rodriguez Gtz
 * DATE: 14/Ago/2023
 * PROJECT: 
 */
import bin2bcd_pkg::*;
import decoder_pkg::*;
import common_pkg::*;
 
module bin2bcd
(
    /** INPUT*/
    input clk, //27MHz
    input binary_data_t binary_data,
    /** OUTPUT*/
    output digital_tube_t digital_tube,
    output data2display_t data2display_units
);

digital_tube_t digital_tube_enable_w;
datatype_u8_t digital_tube_counter_w;

bcd_data_t bin2bcd_units_w, bin2bcd_tens_w, bin2bcd_hundreds_w;
data2display_t bin2bcd_units_output_w, bin2bcd_tens_output_w, bin2bcd_hundreds_output_w;

decoder_bin2bcd decoder_bin2bcd_top
(
    /** INPUT*/
    .binary_data(binary_data),
    /** OUTPUT*/
    .binary_data_units(bin2bcd_units_w),
    .binary_data_tens(bin2bcd_tens_w),
    .binary_data_hundreds(bin2bcd_hundreds_w)
);

bin2bcd_segments bin2bcd_segments_units_top
(
    .bcd_data(bin2bcd_units_w),
    .data2display(bin2bcd_units_output_w)
);
bin2bcd_segments bin2bcd_segments_tens_top
(
    .bcd_data(bin2bcd_tens_w),
    .data2display(bin2bcd_tens_output_w)
);
bin2bcd_segments bin2bcd_segments_hundreds_top
(
    .bcd_data(bin2bcd_hundreds_w),
    .data2display(bin2bcd_hundreds_output_w)
);

multiplex multiplex_top
(
    /** INPUT*/
    .mux_selector(digital_tube),
    .mux_data_units(bin2bcd_units_output_w),
    .mux_data_tens(bin2bcd_tens_output_w),
    .mux_data_hundreds(bin2bcd_hundreds_output_w),
    /** OUTPUT*/
    .mux_data_output(data2display_units)
);

digitalTube digitalTube_top
(
    .digital_tube(digital_tube_enable_w),
    .digital_tube_enable(digital_tube)
);

digitalTube_mux digitalTube_mux_top
(
    .clk(clk),
    .digital_tube_mux_enable(digital_tube_enable_w)
);


endmodule 
