module b_alu(
    input logic [31:0] pc,
    input logic [31:0] instruction,
    input logic [31:0] rs1_data, //register
    input logic [31:0] rs2_data, //register
    output logic [31:0] next_pc,
    output logic is_b
);
    //Declaring constants
    //opcode
    localparam logic [6:0] B      = 7'b1100011;
    //funct3
    localparam logic [2:0] BEQ    = 3'b000;
    localparam logic [2:0] BNE    = 3'b001;
    localparam logic [2:0] BLT    = 3'b100;
    localparam logic [2:0] BGE    = 3'b101;
    localparam logic [2:0] BLTU   = 3'b110;
    localparam logic [2:0] BGEU   = 3'b111;

    //Declaring vars
    logic [6:0]  opcode;
    logic [2:0]  funct3;
    logic [31:0] imm12;
    logic [31:0] bta;

    //assigning vars
    assign opcode = instruction[6:0];
    assign funct3 = instruction[14:12];

    //there is only one b opcode
    assign bta =    pc + imm12;
    assign is_b =   (opcode == B);

    //assigning immediate
    assign imm12 = {{19{instruction[31]}}, instruction[31], instruction[7],
        instruction[30:25], instruction[11:8], 1'b0};

    //checking type of b
    always_comb begin
        if(is_b) begin
            case(funct3)
                BEQ:     next_pc = (rs1_data == rs2_data) ? bta : pc + 4;
                BNE:     next_pc = (rs1_data != rs2_data) ? bta : pc + 4;
                BLT:     next_pc = ($signed(rs1_data) < $signed(rs2_data))  ? bta : pc + 4;
                BGE:     next_pc = ($signed(rs1_data) >= $signed(rs2_data)) ? bta : pc + 4;
                BLTU:    next_pc = (rs1_data < rs2_data)  ? bta : pc + 4;
                BGEU:    next_pc = (rs1_data >= rs2_data) ? bta : pc + 4;
                default: next_pc = 32'b0;
            endcase
        end
    end
endmodule
