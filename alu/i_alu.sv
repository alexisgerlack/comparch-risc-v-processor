module i_alu(
    input logic clk,
    input logic [31:0]instruction
);
    wire [6:0] opcode = instruction[6:0];
    wire [4:0] rd = instruction[11:7];
    wire [2:0] funct3 = instruction[14:12];
    wire [4:0] rs1 = instruction[19:15];
    wire [11:0] imm = instruction[31:20];
endmodule
