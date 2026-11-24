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
    output logic [4:0] rd_address
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
    localparam logic [6:0] LOAD =   7'b0000011;
    //opcode for immediates
    localparam logic [6:0] OP_IMM =  7'b0010011;
    //opcode for JALR
    localparam logic [6:0] JALR = 7'b1100111;
    //funct3 for load
    localparam logic [2:0] LB      = 3'b000; //load byte
    localparam logic [2:0] LH      = 3'b001; //load half word
    localparam logic [2:0] LW      = 3'b010; //load word
    localparam logic [2:0] LBU     = 3'b100; //load byte unsigned
    localparam logic [2:0] LHU     = 3'b101; //load half-word unsigned
    //funct3 for immediates
    localparam logic [2:0] ADDI    = 3'b000; //add immediate
    localparam logic [2:0] SLLI    = 3'b001; //shift left logical immediate
    localparam logic [2:0] SLTI    = 3'b010; ///shift less than immediate
    localparam logic [2:0] SLTIU   = 3'b011; //shift less than unsigned immediate
    localparam logic [2:0] XORI    = 3'b100; //xor immediate
    localparam logic [2:0] SRXI    = 3'b101; //look at funct 7 to determine SRLI or SRAI
    localparam logic [2:0] ORI     = 3'b110; //or immediate
    localparam logic [2:0] ANDI    = 3'b111; // and immediate

    //u type
    localparam logic [6:0] AUIPC = 7'b0010111;
    localparam logic [6:0] LUI   = 7'b0110111;

    //s-type
    localparam logic [6:0] STORE =     7'b0100011;
    //funct3 options
    localparam logic [2:0] SB =    3'b000;
    localparam logic [2:0] SH =    3'b001;
    localparam logic [2:0] SW =    3'b010;

    //j-type
    localparam logic [6:0] JAL = 7'b1101111;

    //b-type
    localparam logic [6:0] BRANCH      = 7'b1100011;
    //funct3
    localparam logic [2:0] BEQ    = 3'b000;
    localparam logic [2:0] BNE    = 3'b001;
    localparam logic [2:0] BLT    = 3'b100;
    localparam logic [2:0] BGE    = 3'b101;
    localparam logic [2:0] BLTU   = 3'b110;
    localparam logic [2:0] BGEU   = 3'b111;

    //r-type
    localparam logic [6:0] R       = 7'b0110011;

    //booleans for the first and second operand
    localparam logic [1:0] A_RS1  = 2'd0, A_PC   = 2'd1, A_ZERO = 2'd2;
    localparam logic [1:0] B_RS2  = 2'd0, B_IMM  = 2'd1, A_FOUR = 2'd2;
    localparam logic [1:0] WB_ALU = 2'd0, WB_MEM = 2'd1, WB_PC4 = 2'd2;

    logic is_i;
    logic is_load;
    logic is_lui;
    logic is_auipc;
    logic is_store;
    logic is_jal;
    logic is_jalr;
    logic is_branch;
    logic is_r;

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic funct7;
    logic [3:0] r_op, i_op;

    assign is_i = (opcode == OP_IMM);
    assign is_load = (opcode == LOAD);
    assign is_lui = (opcode == LUI);
    assign is_auipc = (opcode == AUIPC);
    assign is_store = (opcode == STORE);
    assign is_jal = (opcode == JAL);
    assign is_jalr = (opcode == JALR);
    assign is_branch = (opcode == BRACH);
    assign is_r = (opcode == R);

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
            3'b110: r_op = ALU_AND;
            default: r_op = ALU_ADD;
        endcase
    end
    //i type
    always_comb begin
        i_op = r_op;
        if (funct3 == 3'b000) i_op = ALU_ADD;   // ADDI
    end

endmodule
