/*
 * CODER: Luis Fernando Rodriguez Gtz
 * DATE: 27/04/2025
 * PROJECT: ALU
 */

module alu (
    input  logic [2:0] opcode,  // Operation selector
    input  logic [7:0] A,       // Operand A
    input  logic [7:0] B,       // Operand B
    output logic [7:0] result   // Result
);

    always_comb begin
        case (opcode)
            3'b000: result = A + B;          // ADD
            3'b001: result = A - B;          // SUB
            3'b010: result = A & B;          // AND
            3'b011: result = A | B;          // OR
            3'b100: result = A ^ B;          // XOR
            3'b101: result = A << 1;         // Shift Left A
            3'b110: result = A >> 1;         // Shift Right A
            3'b111: result = A;              // Pass A
            default: result = 8'd0;
        endcase
    end

endmodule
