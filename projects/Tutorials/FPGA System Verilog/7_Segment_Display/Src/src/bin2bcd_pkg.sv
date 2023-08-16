/*
 * CODER: Luis Fernando Rodriguez Gtz
 * DATE: 14/Ago/2023
 * PROJECT: 
 */
 
 `ifndef BIN2BCD_PKG_SV
 	`define BIN2BCD_PKG_SV
 package bin2bcd_pkg;
	/** Parameters*/
    /* How many segments for the display */
	localparam PARAM_DW_SEGMENT_DISPLAY = 7;
	 
	/** Data Types*/
	typedef logic [PARAM_DW_SEGMENT_DISPLAY - 1:0] data2display_t;
 
 endpackage: bin2bcd_pkg
 `endif
