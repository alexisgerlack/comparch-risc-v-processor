module b_alu(
    input logic [31:0]instruction,
    input logic pc,
    output logic pc,
    output logic is_b
);
    //b opcode
    localparam logic [6:0] B = 7'b1100011;
    //funct3
    localparam logic BEQ    = 3'b000;
    localparam logic BNE    = 3'b001;
    localparam logic BLT    = 3'b100;
    localparam logic BGE    = 3'b101;
    localparam logic BLTU   = 3'b110;
    localparam logic BGEU   = 3'b111;
    //error boolean
    logic error = 1'b0;
    //instruction format
    logic [6:0] opcode;
    logic [4:0] funct3;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [4:0] imm12;

    //assigning instruction format
    assign opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign imm12 = instruction[31:25];
    //there is only one b opcode the sign ext is wrong
    assign bta = pc + SignExt({imm12, 1'b0});
    assign is_b = (opcode == B);

    //checking type of b
    always_comb begin
        case(funct3)
            BEQ: pc = (rs1 == rs2) ? bta : pc;
            BNE: pc = (rs1 != rs2) ? bta : pc;
            BLT: pc = (rs1 < rs2) ? bta : pc;
            BGE: pc = (rs1 >= rs2) ? bta : pc;
            BLTU: pc = (rs1 < rs2) ? bta : pc;
            BGEU: pc = (rs1 >= rs2) ? bta : pc;
            default: error = 1'b1;
        endcase
    end
endmodule
