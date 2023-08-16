/*
* CODER: Luis Fernando Rodriguez Gtz
* DATE: 27/Jan/2021
* PROJECT: bin2bcd_decoder
*/

import bin2bcd_pkg::*;

module bin2bcd_decoder
(
    /** INPUT*/
    input binary_data_t binary_data,
    /** OUTPUT*/
    output  bcd_data_units
);
 
binary_data_t binary_data_complement2;
 
/** Obtain the information for the units from the switches */
assign bcd_data_units = ( binary_data );

endmodule 
