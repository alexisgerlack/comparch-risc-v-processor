module i_alu(
    input logic  [31:0] pc,
    input logic  [31:0] instruction,
    input logic  [31:0] rs1_data,
    input logic  [31:0] mem_rdata,
    output logic [31:0] address,
    output logic [31:0] jta,
    output logic [31:0] link, //pc+4
    output logic [4:0] rd_address,
    output logic [31:0] rd_data,
    output logic is_i,
    output logic is_jalr
);
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
    localparam logic [2:0] ADDI    = 3'b000;//add immediate
    localparam logic [2:0] SLLI    = 3'b001; //shift left logical immediate
    localparam logic [2:0] SLTI    = 3'b010; ///shift less than immediate
    localparam logic [2:0] SLTIU   = 3'b011;//shift less than unsigned immediate
    localparam logic [2:0] XORI    = 3'b100; //xor immediate
    localparam logic [2:0] SRXI    = 3'b101; //look at funct 7 to determine SRLI or SRAI
    localparam logic [2:0] ORI     = 3'b110; //or immediate
    localparam logic [2:0] ANDI    = 3'b111;// and immediate

    //initalizing opcode and immediate variables
    logic [6:0]  opcode;
    logic [31:0] imm_i;
    logic [2:0]  funct3;
    logic [4:0]  shamt;
    logic signed [31:0]  rs1_signed, imm_signed, sra_result;
    logic [7:0]  load_byte;
    logic [15:0]  load_half;


    //instruction formatting
    assign opcode =           instruction[6:0];
    assign rd_address =       instruction[11:7];
    assign shamt =            instruction[24:20];
    assign funct3 =           instruction[14:12];
    //assigning i imm
    assign imm_i =            {{20{instruction[31]}},
                              instruction[31:20]};

    assign rs1_signed =       rs1_data;
    assign imm_signed =       imm_i;
    assign sra_result =       rs1_signed >>> shamt;

    //computing outputs and adress
    assign address =          rs1_data + imm_i;
    assign jta =              (rs1_data + imm_i) & ~32'd1;
    assign link =             pc + 32'd4;

    //computing loads
    assign load_byte  =       mem_rdata[8 * address[1:0] +: 8];
    assign load_half =        mem_rdata[16 * address[1]  +: 16];

    //computing boolean outputs
    assign is_jalr =          (opcode == JALR);
    assign is_i =             (opcode == LOAD) | (opcode == OP_IMM) | (opcode == JALR);

    always_comb begin
        rd_data = 32'b0;
        //checking first I opcode
        case(opcode)
            LOAD: begin
                case(funct3)
                    LB:      rd_data =     {{24{load_byte[7]}},  load_byte};
                    LH:      rd_data =     {{16{load_half[15]}}, load_half};
                    LW:      rd_data =     mem_rdata;
                    LBU:     rd_data =     {24'b0, load_byte};
                    LHU:     rd_data =     {16'b0, load_half};
                    default: rd_data =     32'b0;
                endcase
            end
            //checking second I opcode
            OP_IMM: begin
                case(funct3)
                    ADDI:    rd_data =     rs1_data + imm_i;
                    SLLI:    rd_data =     rs1_data << shamt;
                    SLTI:    rd_data =     {31'b0, rs1_signed < imm_signed};
                    SLTIU:   rd_data =     {31'b0, rs1_data < imm_i};
                    XORI:    rd_data =     rs1_data ^ imm_i;
                    SRXI:    rd_data =     instruction[30] ? sra_result : (rs1_data >> shamt);
                    ORI:     rd_data =     rs1_data | imm_i;
                    ANDI:    rd_data =     rs1_data & imm_i;
                    default: rd_data =     32'b0;
                endcase
            end
            //checking third I opcode
            JALR: rd_data =                link;
            default: rd_data =             32'b0;
        endcase
    end
endmodule
