module u_alu(
    input logic  [31:0] pc,
    input logic  [31:0] instruction,
    output logic [31:0] rd,
    output logic [31:0] link,
    output logic [31:0] rd,
    output logic [31:0] is_u
);
    //opcode
    localparam logic [6:0] AUIPC = 7'b0010111;
    localparam logic [6:0] LUI = 7'b0110111;

    logic [6:0]  opcode;
    logic [31:0] imm_u;
    logic [19:0] upimm;

    assign opcode = instruction[6:0];
    assign rd = instruction[11:7];

    //immediate
    assign imm_u = {{11{instruction[31]}},
                    instruction[31:12],
                    1'b0};
    //upimm
    assign upimm = imm_u[31:12];

    //checking u opcode
    always_comb begin
        case(opcode)
            AUIPC: rd = {upimm, 12'b0} + pc;
            LUI:   rd = {upimm, 12'b0};
        endcase
    end

    assign link = pc + 32'd4;
    assign is_u = ((opcode == AUIPC)|(opcode == LUI));
endmodule
