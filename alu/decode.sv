module decode(
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic       funct7,//single bit funct7 flag
    output logic [3:0] alu_op
);
    //constant params structured by the opcode,funct7 and funct3
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
    //funct3
    localparam logic [2:0] ASX     = 3'b000;//look at funct 7 or ADD SUB
    localparam logic [2:0] SLL     = 3'b001;//shift left logical or logical word
    localparam logic [2:0] SLT     = 3'b010;//set less than
    localparam logic [2:0] SLTU    = 3'b011;//set less than unsigned
    localparam logic [2:0] XOR     = 3'b100;//xor
    localparam logic [2:0] SRX     = 3'b101;//look at funct7 for srl or sra or word
    localparam logic [2:0] OR      = 3'b110;//or
    localparam logic [2:0] AND     = 3'b111;//and


    logic is_i;
    logic is_load;
    logic is_lui;
    logic is_auipc;
    logic is_store;
    logic is_jal;
    logic is_jalr;
    logic is_branch;
    logic is_r;

    assign is_i = (opcode == OP_IMM);
    assign is_load = (opcode == LOAD);
    assign is_lui = (opcode == LUI);
    assign is_auipc = (opcode == AUIPC);
    assign is_store = (opcode == STORE);
    assign is_jal = (opcode == JAL);
    assign is_jalr = (opcode == JALR);
    assign is_branch = (opcode == BRACH);
    assign is_r = (opcode == R);

    //formatting
    always_comb begin
        if(is_load)
    end

endmodule
