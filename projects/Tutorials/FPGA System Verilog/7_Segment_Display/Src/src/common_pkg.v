/*
 * CODER: Luis Fernando Rodriguez Gtz
 * DATE: 14/Ago/2023
 * PROJECT: 
 */
 
 `ifndef COMMON_PKG_SV
 	`define COMMON_PKG_SV
 package common_pkg;
    parameter PARAM_DATA_WIDTH  = 4;

    /****************************************
     * Basic Types
     ****************************************/
	/** Parameters*/
    localparam PARAM_U2 = 2;
    localparam PARAM_U3 = 3;
    localparam PARAM_U4 = 4;
    localparam PARAM_U8 = 8;
    localparam PARAM_U16 = 16;
    typedef logic [PARAM_U4 - 1:0] datatype_u4_t;
    typedef logic [PARAM_U8 - 1:0] datatype_u8_t;
    typedef logic [PARAM_U16 - 1:0] datatype_u16_t;
    /****************************************
     * BCD Data Types
     ****************************************/
    typedef logic [PARAM_DATA_WIDTH - 1:0] bcd_data_t;

    /****************************************
     * Digital Tube (7-Segment) Display Types
     ****************************************/
    /* How many segments for the display */
	localparam PARAM_DW_SEGMENT_DISPLAY = 7;
    typedef logic [PARAM_DW_SEGMENT_DISPLAY - 1:0] data2display_t;
    /* How many digits has the display */
    localparam PARAM_DW_DIGITAL_TUBE = 4;
	/** Data Types*/
	typedef logic [PARAM_DATA_WIDTH - 1:0] binary_data_t;
    typedef logic [PARAM_DW_DIGITAL_TUBE - 1:0] digital_tube_t;
    /****************************************
     * Sys Clock
     ****************************************/
    localparam clkFreq_FPGA = 27_000_000;
    localparam clkFreq_TargetHz = 10_000;
    
 
 endpackage: common_pkg
 `endif
