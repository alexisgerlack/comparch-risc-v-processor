module s_alu(
    input logic clk,
    input logic [31:0]instruction
);
    wire [6:0] opcode = instruction[6:0];
    wire [4:0] imm4 = instruction[11:7];
    wire [4:0] funct3 = instruction[14:12];
    wire [4:0] rs1 = instruction[19:15];
    wire [4:0] rs2 = instruction[24:20];
    wire [4:0] imm11 = instruction[31:25];
endmodule
