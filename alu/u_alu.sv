module u_alu(
    input logic clk,
    input logic [31:0]instruction
);
    wire [6:0] opcode = instruction[6:0];
    wire [4:0] rd = instruction[11:7];
    wire [4:0] imm = instruction[31:12];

endmodule
