/*
* CODER: Luis Fernando Rodriguez Gtz
* DATE: 27/Jan/2021
* PROJECT: bin2leds
*/

`ifndef FPGA_PKKG_SV
    `define FPGA_PKKG_SV
package fpga_pkg;
    /** Parameters*/
    /* How many dip switches */
    localparam SWITCH_PARAM_DW = 4;
    /* How many displays */
    localparam LED_PARAM_DW = 4;
     
    /** Data Types*/
    typedef logic [SWITCH_PARAM_DW - 1:0] binary_data_t;
    typedef logic [LED_PARAM_DW - 1:0] data2display_t;

endpackage
`endif