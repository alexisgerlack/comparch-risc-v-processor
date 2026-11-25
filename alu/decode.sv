module decode(
    input  logic [31:0] instruction,
    //operation boolean
    output  logic is_r, is_i, is_load, is_store, is_branch, is_jal, is_jalr, is_lui, is_auipc,
    //controls
    output logic [3:0] alu_op,
    output logic [2:0] imm_sel,
    output logic [1:0] a_sel, b_sel, wb_sel,
    output logic reg_write, mem_read, mem_write,
    //passthrough
    output logic [2:0] funct3,
    output logic [4:0] rd_address,
    //illegal boolean
    output logic illegal
);
    //case constants for alu operations
    localparam logic [3:0] ALU_ADD  = 4'd0;
    localparam logic [3:0] ALU_SUB  = 4'd1;
    localparam logic [3:0] ALU_SLL  = 4'd2;
    localparam logic [3:0] ALU_SLT  = 4'd3;
    localparam logic [3:0] ALU_SLTU = 4'd4;
    localparam logic [3:0] ALU_XOR  = 4'd5;
    localparam logic [3:0] ALU_SRL  = 4'd6;
    localparam logic [3:0] ALU_SRA  = 4'd7;
    localparam logic [3:0] ALU_OR   = 4'd8;
    localparam logic [3:0] ALU_AND  = 4'd9;

    //case constants for immediate
    localparam logic [2:0] IMM_I = 3'd0;
    localparam logic [2:0] IMM_S = 3'd1;
    localparam logic [2:0] IMM_B = 3'd2;
    localparam logic [2:0] IMM_U = 3'd3;
    localparam logic [2:0] IMM_J = 3'd4;

    //i type
    //opcode for load
    localparam logic [6:0] LOAD   = 7'b0000011;
    //opcode for immediates
    localparam logic [6:0] OP_IMM = 7'b0010011;
    //opcode for JALR
    localparam logic [6:0] JALR   = 7'b1100111;
    //u type
    localparam logic [6:0] AUIPC  = 7'b0010111;
    localparam logic [6:0] LUI    = 7'b0110111;
    //s-type
    localparam logic [6:0] STORE  = 7'b0100011;
    //j-type
    localparam logic [6:0] JAL    = 7'b1101111;
    //b-type
    localparam logic [6:0] BRANCH = 7'b1100011;
    //r-type
    localparam logic [6:0] R      = 7'b0110011;

    //booleans for the first and second operand
    localparam logic [1:0] A_RS1  = 2'd0, A_PC   = 2'd1, A_ZERO = 2'd2;
    localparam logic [1:0] B_RS2  = 2'd0, B_IMM  = 2'd1, B_FOUR = 2'd2;
    localparam logic [1:0] WB_ALU = 2'd0, WB_MEM = 2'd1, WB_PC4 = 2'd2;

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic funct7;
    logic [3:0] r_op, i_op;

    assign opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[30];
    assign rd_address = instruction[11:7];

    //r type op gen
    always_comb begin
        case (funct3)
            3'b000: r_op = funct7 ? ALU_SUB : ALU_ADD;
            3'b001: r_op = ALU_SLL;
            3'b010: r_op = ALU_SLT;
            3'b011: r_op = ALU_SLTU;
            3'b100: r_op = ALU_XOR;
            3'b101: r_op = funct7 ? ALU_SRA : ALU_SRL;
            3'b110: r_op = ALU_OR;
            3'b111: r_op = ALU_AND;
            default: r_op = ALU_ADD;
        endcase
    end
    //i type
    always_comb begin
        i_op = r_op;
        if (funct3 == 3'b000) i_op = ALU_ADD;   // ADDI
    end

    always_comb begin
        //setting defaults
        is_i = 0; is_load = 0; is_lui = 0; is_auipc = 0; is_store = 0;
        is_jal = 0; is_jalr = 0; is_branch = 0; is_r = 0;
        imm_sel = IMM_I; alu_op = ALU_ADD; a_sel = A_RS1; b_sel = B_IMM; wb_sel = WB_ALU;
        reg_write = 0; mem_read = 0; mem_write = 0;

        case(opcode)
            OP_IMM: begin
                is_i = 1; alu_op = i_op; reg_write = 1; //the default a and b are correct for this one
            end
            LOAD: begin
                is_load = 1; mem_read = 1; reg_write = 1; wb_sel = WB_MEM; //default a+b
            end
            LUI: begin
                is_lui = 1; a_sel = A_ZERO; imm_sel = IMM_U; reg_write = 1;
            end
            AUIPC: begin
                is_auipc = 1; reg_write = 1; a_sel = A_PC; imm_sel = IMM_U;
            end
            STORE: begin
                is_store = 1; mem_write = 1; a_sel = A_RS1; imm_sel = IMM_S;
            end
            JAL: begin
                is_jal = 1; reg_write = 1; wb_sel = WB_PC4; a_sel = A_PC; imm_sel = IMM_J;
            end
            JALR: begin
                is_jalr = 1; reg_write = 1; wb_sel = WB_PC4;// default a + b
            end
            BRANCH: begin
                is_branch = 1; imm_sel = IMM_B; b_sel = B_RS2; //default a
            end
            R: begin
                is_r = 1; alu_op = r_op; reg_write = 1; b_sel = B_RS2; //default a
            end
            default: illegal = 1;
        endcase
    end
endmodule
