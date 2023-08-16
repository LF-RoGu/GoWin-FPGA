/*
 * CODER: Luis Fernando Rodriguez Gtz
 * DATE: 14/Ago/2023
 * PROJECT: 
 */
 
import common_pkg::*;
import decoder_pkg::*;
 
module decoder_bin2bcd
(
    /** INPUT*/
    input binary_data_t binary_data,
    /** OUTPUT*/
    output bcd_data_t binary_data_units,
    output bcd_data_t binary_data_tens,
    output bcd_data_t binary_data_hundreds
);


/*
    Obtain the sign, if the bit is: 
    1 -> negative 
    0 -> positive
*/
assign binary_data_sign = (binary_data[PARAM_DATA_WIDTH - 'b1] == 1'b1) ? (1'b0) : (1'b1);

/* Obtain the numbers necesary to ignite each display */ 
assign binary_data_hundreds = ( (binary_data * 'd10) >> 'd10 ); 
assign binary_data_tens = ( ( binary_data - (binary_data_hundreds * 'd100) ) * 'd100 ) >> 'd10;
assign binary_data_units = ( binary_data - ( binary_data_hundreds * 'd100 ) - ( binary_data_tens * 'd10 ) );

endmodule
