/*
 * CODER: Luis Fernando Rodriguez Gtz
 * DATE: 14/Ago/2023
 * PROJECT: 
 */
 
 import common_pkg::*;
 
 module digitalTube
(
    /** INPUT*/
    input digital_tube_t digital_tube,
    /** OUTPUT*/
    output digital_tube_t digital_tube_enable
);
	
/* Obtain the numbers necesary to ignite each display */ 
always_comb 
begin
    case(digital_tube)
        4'b0000: begin
            digital_tube_enable = digital_tube;
        end 
        4'b0001: begin
            digital_tube_enable = digital_tube;
        end 
        4'b0010: begin
            digital_tube_enable = digital_tube;
        end 
        4'b0011: begin
            digital_tube_enable = digital_tube;
        end 
        4'b0100: begin
            digital_tube_enable = digital_tube;
        end 
        4'b0101: begin
            digital_tube_enable = digital_tube;
        end 
        4'b0110: begin
            digital_tube_enable = digital_tube;
        end 
        4'b0111: begin
            digital_tube_enable = digital_tube;
        end 
        4'b1000: begin
            digital_tube_enable = digital_tube;
        end 
        4'b1001: begin
            digital_tube_enable = digital_tube;
        end 
        4'b1010: begin
            digital_tube_enable = digital_tube;
        end 
        4'b1011: begin
            digital_tube_enable = digital_tube;
        end 
        4'b1100: begin
            digital_tube_enable = digital_tube;
        end 
        4'b1101: begin
            digital_tube_enable = digital_tube;
        end 
        4'b1110: begin
            digital_tube_enable = digital_tube;
        end 
        4'b1111: begin
            digital_tube_enable = digital_tube;
        end 
        default: begin
            digital_tube_enable = 'b0; /** default*/
        end 
    endcase 
end 
endmodule
