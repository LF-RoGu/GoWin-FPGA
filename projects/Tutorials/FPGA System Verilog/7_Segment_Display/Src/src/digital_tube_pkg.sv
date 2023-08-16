/*
 * CODER: Luis Fernando Rodriguez Gtz
 * DATE: 14/Ago/2023
 * PROJECT: 
 */
 
 `ifndef DIGITAL_TUBE_PKG_SV
 	`define DIGITAL_TUBE_PKG_SV
 package digital_tube_pkg;
	/** Parameters*/
	localparam PARAM_DW_DIGITAL_TUBE = 4;

	typedef logic [PARAM_DW_DIGITAL_TUBE - 1:0] digital_tube_t;
 
 endpackage: digital_tube_pkg
 `endif
