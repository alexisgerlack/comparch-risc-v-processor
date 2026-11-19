module u_alu(
    input logic  [31:0] pc,
    input logic  [31:0] instruction,
    output logic [4:0]  rd_address,
    output logic [31:0] link,
    output logic [31:0] rd_data,
    output logic        is_u
);
    //constant opcodes for case statement
    localparam logic [6:0] AUIPC = 7'b0010111;
    localparam logic [6:0] LUI   = 7'b0110111;

    //initializing variables
    logic [6:0]            opcode;
    logic [31:0]           imm_u;

    //assigning vars
    assign opcode =        instruction[6:0];
    assign rd_address =    instruction[11:7];
    assign is_u =          ((opcode == AUIPC)|(opcode == LUI));
    assign link =          pc + 32'd4;

    //immediate
    assign imm_u =         {instruction[31:12], 12'b0};

    //checking u opcode
    always_comb begin
        if (is_u) begin
            case(opcode)
                AUIPC:     rd_data = pc + imm_u;
                LUI:       rd_data = imm_u;
                default:   rd_data = 32'b0;
            endcase
        end
    end
endmodule
