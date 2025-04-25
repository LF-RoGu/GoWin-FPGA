/*
 * CODER: Luis Fernando Rodriguez Gtz
 * DATE: 14/Ago/2023
 * PROJECT: 
 */

import digitalTube_mux_pkg::*;
import common_pkg::*;

module digitalTube_mux
#(
    parameter counter_objective = clkFreq_FPGA / (2*clkFreq_TargetHz)
)
(
    /** INPUT*/
    input logic clk, //27MHz
    /** OUTPUT*/
    output digital_tube_t digital_tube_mux_enable
);

datatype_u8_t digital_tube_mux_counter;
datatype_u16_t clk_divider_w, clk_divider_reg_w;
logic internal_clk_w;

always @(posedge clk)
begin
    clk_divider_reg_w = clk_divider_w + 'd1;
    if(clk_divider_reg_w >= counter_objective)
        internal_clk_w = 'b1;     
    else if (clk_divider_reg_w > (2*counter_objective))
        clk_divider_reg_w = 'd0;
    else
        internal_clk_w = 'b0;
end

always_ff @(negedge internal_clk_w)
begin
    if(digital_tube_mux_counter > PARAM_DW_DIGITAL_TUBE)
        digital_tube_mux_counter = 'd0;
    else    
        digital_tube_mux_counter = digital_tube_mux_counter + 'd1;
end

assign digital_tube_mux_enable = 4'b0001 << digital_tube_mux_counter;
assign clk_divider_w = clk_divider_reg_w;

endmodule