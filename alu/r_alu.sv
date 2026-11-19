module r_alu(
    input logic  [31:0] instruction,
    input logic  [31:0] rs1_data, //register
    input logic  [31:0] rs2_data, //register
    output logic [4:0]  rd_address,
    output logic [31:0] rd_data,
    output logic        is_r
);
    //Declaring Constants
    //opcode
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

    //declaring vars
    logic [6:0]  opcode, funct7;
    logic [2:0]  funct3;
    logic [31:0] sra_result;
    logic [4:0]  shamt;

    //assignments
    assign opcode                  = instruction[6:0];
    assign rd_address              = instruction[11:7];
    assign funct3                  = instruction[14:12];
    assign funct7                  = instruction[31:25];
    assign shamt                   = rs2_data[4:0];
    assign sra_result              = $signed(rs1_data) >>> shamt;
    assign is_r                    = (opcode == R);

    //loop checking funct3
    always_comb begin
        rd_data = 32'b0;
        if (opcode == R) begin
            case(funct3)
                ASX:       rd_data     = funct7[5] ? (rs1_data - rs2_data) : (rs1_data + rs2_data);
                SLL:       rd_data     = rs1_data << shamt;
                SLT:       rd_data     = {31'b0, ($signed(rs1_data) < $signed(rs2_data))};
                SLTU:      rd_data     = {31'b0, (rs1_data < rs2_data)};
                XOR:       rd_data     = rs1_data ^ rs2_data;
                SRX:       rd_data     = funct7[5] ? sra_result : (rs1_data >> shamt);
                OR:        rd_data     = rs1_data | rs2_data;
                AND:       rd_data     = rs1_data & rs2_data;
                default:   rd_data     = 32'b0;
            endcase
        end
    end

endmodule
