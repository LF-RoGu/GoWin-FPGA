/*
 * CODER: Luis Fernando Rodriguez Gtz
 * DATE: 14/Ago/2023
 * PROJECT: 
 */
 
 `ifndef COMMON_PKG_SV
 	`define COMMON_PKG_SV
 package common_pkg;
    parameter PARAM_DATA_WIDTH  = 4;
	/** Parameters*/
    localparam PARAM_UBYTE = 8;
    localparam PARAM_UWORD = 16;
    /* How many dip switches */
	localparam PARAM_SWITCHES_DW = PARAM_DATA_WIDTH;
    localparam PARAM_DW_DIGITAL_TUBE = 4;
	/** Data Types*/
	typedef logic [PARAM_SWITCHES_DW - 1:0] binary_data_t;
    typedef logic [PARAM_DW_DIGITAL_TUBE - 1:0] digital_tube_t;
    typedef logic [PARAM_UBYTE - 1:0] datatype_u8_t;
    typedef logic [PARAM_UWORD - 1:0] datatype_u16_t;
 
 endpackage: common_pkg
 `endif
