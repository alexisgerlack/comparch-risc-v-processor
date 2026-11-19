module j_alu(
    input logic  [31:0] pc,
    input logic  [31:0] instruction,
    output logic [31:0] jta,
    output logic [31:0] link,
    output logic [4:0]  rd_address,
    output logic        is_j
);
    //initalizing opcode and immediate variables
    logic [6:0]         opcode;
    logic [31:0]        imm_j;

    //opcode for JAL
    localparam logic [6:0] J = 7'b1101111;

    //instruction formatting
    assign opcode =     instruction[6:0];
    assign rd_address = instruction[11:7];

    //the only j-type instruction is jal so we can assume it is that
    assign imm_j = {{11{instruction[31]}},
                    instruction[31],
                    instruction[19:12],
                    instruction[20],
                    instruction[30:21],
                    1'b0};

    assign jta =  pc + imm_j;
    assign link = pc + 32'd4;
    assign is_j = (opcode == J);

endmodule
