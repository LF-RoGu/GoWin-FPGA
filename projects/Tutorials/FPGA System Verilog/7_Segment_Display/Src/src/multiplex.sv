/*
 * CODER: Luis Fernando Rodriguez Gtz
 * DATE: 14/Ago/2023
 * PROJECT: 
 */
 
import common_pkg::*;
 
module multiplex
(
    /** INPUT*/
    input digital_tube_t mux_selector,
    input data2display_t mux_data_units,
    input data2display_t mux_data_tens,
    input data2display_t mux_data_hundreds,
    /** OUTPUT*/
    output data2display_t mux_data_output
);

/* Obtain the numbers necesary to ignite each display */ 

always_comb
begin
    case(mux_selector)
        4'b0001: begin
		 	mux_data_output = mux_data_units;
	 	end 
        4'b0010: begin
		 	mux_data_output = mux_data_tens;
	 	end
        4'b0100: begin
		 	mux_data_output = mux_data_hundreds;
	 	end
        4'b1000: begin
            mux_data_output = 7'b1111111;
	 	end
	 	default: begin
		 	mux_data_output = 'b0; /** default*/
	 	end 
    endcase
end 

endmodule
