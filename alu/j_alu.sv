module j_alu(
    input logic [31:0] pc,
    input logic [31:0] instruction,
    output logic [31:0] jta,
    output logic [31:0] link,
    output logic [31:0] rd,
    output logic [31:0] is_jal
);
    //opcode
    localparam logic [6:0] JAL = 7'b1101111;

    logic [6:0]  opcode;
    logic [31:0] imm_j;

    assign opcode = instruction[6:0];
    assign rd = instruction[11:7];

    //the only j-type instruction is jal
    assign imm_j = {{11{instruction[31]}},
                    instruction[31],
                    instruction[19:12],
                    instruction[20],
                    instruction[30:21],
                    1'b0};

    assign jta = pc + imm_j;
    assign link = pc + 32'd4;
    assign is_jal = (opcode == JAL);

endmodule
