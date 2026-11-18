module i_alu(
    input logic  [31:0] pc,
    input logic  [31:0] instruction,
    input logic  [31:0] address,
    output logic [31:0] link,
    output logic [31:0] rd,
    output logic [0:0] is_i
);
    //initalizing opcode and immediate variables
    logic [6:0]  opcode;
    logic [31:0] imm_i;
    logic [2:0]  funct3;

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
    localparam logic LBU     = 3'b011; //load byte unsigned
    localparam logic LHU     = 3'b011; //load half-word unsigned
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
    assign opcode =   instruction[6:0];
    assign rd =       instruction[11:7];
    assign rs1 =      instruction[19:15];
    assign rs2 =      instruction[24:20];
    assign funct3 =   instruction[14:12];

    //assigning i imm
    assign imm_i = {{11{instruction[31]}},
                    instruction[31],
                    instruction[19:12],
                    instruction[20],
                    instruction[30:21],
                    1'b0};
    always_comb begin
        //checking first I opcode
        if (opcode == I_3) begin
            case(funct3)
                LB:  rd = ;
                LH:  rd = ;
                LW:  rd = ;
                LBU: rd = ;
                LHU: rd = ;
            endcase
        end
        //checking second I opcode
        if (opcode == I_19) begin
            case(funct3)
                AUIPC: rd = {upimm, 12'b0} + pc;
                LUI:   rd = {upimm, 12'b0};
            endcase
        end
        //checking third I opcode
        if (opcode == I_103) begin
            case(funct3)
                AUIPC: rd = {upimm, 12'b0} + pc;
                LUI:   rd = {upimm, 12'b0};
            endcase
        end
    end

    assign jta = pc + imm_j;
    assign link = pc + 32'd4;
    assign is_i = ((opcode == I_3)|(opcode == I_19)|(opcode == I_103));

endmodule
