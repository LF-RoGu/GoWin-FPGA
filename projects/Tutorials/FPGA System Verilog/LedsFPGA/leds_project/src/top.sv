/*
 * CODER: Luis Fernando Rodriguez Gtz
 * DATE: 27/Jan/2021
 * PROJECT: bin2leds
 */

import fpga_pkg::*;
 
module bin2leds
(
    /** INPUT*/
    input rst,
    input binary_data_t binary_data,
    /** OUTPUT*/
    output data2display_t data2display_units
);
	 
assign data2display_units[0] = binary_data[0];
assign data2display_units[1] = binary_data[1];
assign data2display_units[2] = binary_data[2];
assign data2display_units[3] = binary_data[3];

 endmodule 
