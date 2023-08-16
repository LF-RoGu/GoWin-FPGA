/*
 * CODER: Luis Fernando Rodriguez Gtz
 * DATE: 14/Ago/2023
 * PROJECT: 
 */
 
`ifndef DECODER_PKG_SV
    `define DECODER_PKG_SV
package decoder_pkg;
import common_pkg::*;
    /** Parameters*/
    localparam PARAM_BDC_DW = PARAM_DATA_WIDTH;

    /** Data Types*/
    typedef logic[PARAM_BDC_DW - 1:0] bcd_data_t;

endpackage: decoder_pkg
 `endif
