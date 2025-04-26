/*
 * CODER: Luis Fernando Rodriguez Gtz
 * DATE: 14/Ago/2023
 * PROJECT: 
 */

import clkDivider_pkg::*;
import common_pkg::*;

module clkDivider
#(
    parameter counter_objective = clkFreq_FPGA / (2*clkFreq_TargetHz)
)
(
    /** INPUT*/
    input logic clk, //27MHz
    /** OUTPUT*/
    output datatype_u8_t digital_tube_mux_clk
);

datatype_u16_t clk_divider_w, clk_divider_reg_w;
logic internal_clk_w;

always @(posedge clk)
begin
    clk_divider_w = clk_divider_reg_w + 'd1;
    if(clk_divider_reg_w < counter_objective)
        internal_clk_w = 'b1;
    else
        internal_clk_w = 'b0;
end

always_ff @(posedge internal_clk_w)
begin
    if(digital_tube_mux_clk > PARAM_DW_DIGITAL_TUBE)
        digital_tube_mux_clk = 'd0;
    else    
        digital_tube_mux_clk = digital_tube_mux_clk + 'd1;
end


endmodule