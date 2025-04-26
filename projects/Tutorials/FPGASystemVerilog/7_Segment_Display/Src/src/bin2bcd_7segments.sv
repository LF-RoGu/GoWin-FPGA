/*
 * CODER: Luis Fernando Rodriguez Gtz
 * DATE: 14/Ago/2023
 * PROJECT: 
 */
 
import common_pkg::*;
 
 module bin2bcd_segments
(
    /** INPUT*/
    input binary_data_t bcd_data,
    /** OUTPUT*/
    output data2display_t data2display
);
	
/* Obtain the numbers necesary to ignite each display */ 
 always_comb begin
 
 	case(bcd_data)		 //   gefdcba
	 	4'b0000: begin
		 	data2display = 7'b1000000; /** 0*/
	 	end 
	 	4'b0001: begin
		 	data2display = 7'b1111001; /** 1*/
	 	end 
	 	4'b0010: begin
		 	data2display = 7'b0010100; /** 2*/
	 	end 
	 	4'b0011: begin
		 	data2display = 7'b0110000; /** 3*/
	 	end 
	 	4'b0100: begin
		 	data2display = 7'b0101001; /** 4*/
	 	end 
	 	4'b0101: begin
		 	data2display = 7'b0100010; /** 5*/
	 	end 
	 	4'b0110: begin
		 	data2display = 7'b0000010; /** 6*/
	 	end 
	 	4'b0111: begin
		 	data2display = 7'b1111000; /** 7*/
	 	end 
	 	4'b1000: begin
		 	data2display = 7'b0000000; /** 8*/
	 	end 
	 	4'b1001: begin
		 	data2display = 7'b0101000; /** 9*/
	 	end 
	 	4'b1010: begin
		 	data2display = 7'b0001000; /** A*/
	 	end 
	 	4'b1011: begin
		 	data2display = 7'b0000011; /** B*/
	 	end 
	 	4'b1100: begin
		 	data2display = 7'b1000110; /** C*/
	 	end 
	 	4'b1101: begin
		 	data2display = 7'b0100001; /** D*/
	 	end 
	 	4'b1110: begin
		 	data2display = 7'b0000110; /** E*/
	 	end 
	 	4'b1111: begin
		 	data2display = 7'b0001110; /** F*/
	 	end 
	 	default: begin
		 	data2display = 7'b1000000; /** default*/
	 	end 
 	endcase 
 end 
 endmodule
