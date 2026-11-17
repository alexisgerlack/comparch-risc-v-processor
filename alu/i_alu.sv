module i_alu(
    input logic [31:0] pc,
    input logic [31:0] instruction,
    output logic [31:0] jta,
    output logic [31:0] link,
    output logic [31:0] rd,
    output logic [31:0] is_jalr
);
    //initalizing opcode and immediate variables
    logic [6:0]  opcode;
    logic [31:0] imm_i;
    logic [2:0] funct3;

    //opcode for load
    localparam logic [6:0] I_3 =   7'b0000011;
    //opcode for immediates
    localparam logic [6:0] I_19 =  7'b0010011;
    //opcode for JALR
    localparam logic [6:0] I_103 = 7'b1100111;

    //funct3 for load
    localparam logic LB      = 3'b000; //load byte
    localparam logic LH      = 3'b001; //load half word
    localparam logic LW      = 3'b010; //load word
    localparam logic LD      = 3'b011; //load double word
    //funct3 for immediates
    localparam logic ADDI    = 3'b000;//add immediate
    localparam logic SLLI    = 3'b001; //shift left logical immediate
    localparam logic SLTI    = 3'b010; ///shift less than immediate
    localparam logic SLTIU   = 3'b011;//shift less than unsigned immediate
    localparam logic XORI    = 3'b100; //xor immediate
    localparam logic SRXI    = 3'b101; //look at funct 7 to determine SRLI or SRAI
    localparam logic ORI     = 3'b110; //or immediate
    localparam logic ANDI    = 3'b111;// and immediate

    //instruction formatting
    assign opcode = instruction[6:0];
    assign rd = instruction[11:7];
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign funct3 = instruction[14:12];

    //the only j-type instruction is jal so we can assume it is that
    assign imm_i = {{11{instruction[31]}},
                    instruction[31],
                    instruction[19:12],
                    instruction[20],
                    instruction[30:21],
                    1'b0};

    assign jta = pc + imm_j;
    assign link = pc + 32'd4;
    assign is_jal = (opcode == J);

    
endmodule
