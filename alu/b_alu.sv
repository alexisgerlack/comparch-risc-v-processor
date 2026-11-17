module b_alu(
    input logic clk,
    input logic [31:0]instruction,
    input logic pc
);
    wire [6:0] opcode = instruction[6:0];
    wire [4:0] imm4 = instruction[11:7];
    wire [4:0] funct3 = instruction[14:12];
    wire [4:0] rs1 = instruction[19:15];
    wire [4:0] rs2 = instruction[24:20];
    wire [4:0] imm12 = instruction[31:25];

    //there is only one b opcode so no need to check!
    bta = pc + SignExt({imm12, 1'b0});

    logic error = 1'b0;

    localparam logic BEQ    = 3'b000;
    localparam logic BNE    = 3'b001;
    localparam logic BLT    = 3'b100;
    localparam logic BGE    = 3'b101;
    localparam logic BLTU   = 3'b110;
    localparam logic BGEU   = 3'b111;
    
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
endmodule
