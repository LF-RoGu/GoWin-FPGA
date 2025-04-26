/*
 * TESTBENCH: ALU
 */

module tb_alu;

    logic [2:0] opcode;
    logic [7:0] A;
    logic [7:0] B;
    logic [7:0] result;

    // Instantiate ALU
    alu uut (
        .opcode(opcode),
        .A(A),
        .B(B),
        .result(result)
    );

    initial begin
        // Initialize
        A = 8'd15;
        B = 8'd3;
        
        // Test all operations
        opcode = 3'b000; #10; // ADD
        opcode = 3'b001; #10; // SUB
        opcode = 3'b010; #10; // AND
        opcode = 3'b011; #10; // OR
        opcode = 3'b100; #10; // XOR
        opcode = 3'b101; #10; // SHIFT LEFT
        opcode = 3'b110; #10; // SHIFT RIGHT
        opcode = 3'b111; #10; // PASS A

        // Finish
        #10;
        $stop;
    end

endmodule
