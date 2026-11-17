module u_alu(
    input logic  [31:0] pc,
    input logic  [31:0] instruction,
    output logic [31:0] rd,
    output logic [31:0] link,
    output logic [31:0] rd,
    output logic [31:0] is_auipc
);
    //opcode
    localparam logic [6:0] AUIPC = 7'b0010111;

    logic [6:0]  opcode;
    logic [31:0] imm_u;

    assign opcode = instruction[6:0];
    assign rd = instruction[11:7];

    //
    assign imm_u = {{11{instruction[31]}},
                    instruction[31:12],
                    1'b0};
    assign rd = {upimm, 12'b0} + pc;

    assign link = pc + 32'd4;
    assign is_auipc = (opcode == AUIPC);
endmodule
