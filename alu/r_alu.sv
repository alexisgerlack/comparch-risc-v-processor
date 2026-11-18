module r_alu(
    input logic clk,
    input logic [31:0]instruction
);
    wire [6:0] opcode = instruction[6:0];
    wire [4:0] rd = instruction[11:7];
    wire [4:0] funct3 = instruction[14:12];
    wire [4:0] rs1 = instruction[19:15];
    wire [4:0] rs2 = instruction[24:20];
    wire [4:0] funct7 = instruction[31:25];

    localparam logic RX    = 7'b0110011;
    localparam logic RY    = 7'b0111011;

    localparam logic ASX     = 3'b000;//look at funct 7 or ADD SUB
    localparam logic SLL     = 3'b001;//shift left logical or logical word
    localparam logic SLT     = 3'b010;//set less than
    localparam logic SLTU    = 3'b011;//set less than unsigned
    localparam logic XOR     = 3'b100;//xor
    localparam logic SRX     = 3'b101;//look at funct7 for srl or sra or word
    localparam logic OR      = 3'b110;//or
    localparam logic AND     = 3'b111;//and

    localparam logic O    = 7'b0100000;
    localparam logic Z    = 7'b0000000;

    logic error = 1'b0;

    always_comb begin
        if (opcode == RX) begin
            case(funct3)
                ASX:  rd = (funct7 == O) ? rs1 + rs2 : rs1 - rs2;
                SLL: rd = rs1 << rs2;
                SLT: rsd = (rs1 < rs2);
                SLTU: rd = (rs1 < rs2);
                XOR:rd = rs1 ^rs2;
                SRX: rd = (funct7 == O) ? rs1 >> rs2[4:0] : rs1 >>> rs2[4:0];
                OR: rd = rs1 | rs2;
                AND: rd = rs1 & rs2;
                default: error = 1'b1;
            endcase
        end
        if (opcode == RY) begin
            case(funct3)
                ASX: rd = (funct7 == O) ? SignExt(rs1+rs2) : SignExt(rs1-rs2); //addw subw
                SLL: rd = SignExt(rs1 << rs2);
                SRX: rd = (funct7 == O) ?  SignExt(rs1 >> rs2) : SignExt(rs1 <<< rs2);
                default: error = 1'b1; //there are some missed in here. I am quite confused about them so ASK
            endcase
        end
    end

endmodule
