module s_alu(
    input logic  [31:0] rs1_data,
    input logic  [31:0] instruction,
    output logic [31:0] addr,
    output logic [2:0] store_byte,
    output logic is_store
);
    //opcode for s-type
    localparam logic [6:0] S = 7'b0100011;
    //funct3 options
    localparam logic [2:0] SB = 3'b000;
    localparam logic [2:0] SH = 3'b001;
    localparam logic [2:0] SW = 3'b010;

    logic [6:0]  opcode;
    logic [31:0] imm_s;
    logic [2:0]  funct3;
    logic [0:0] error = 1'b0;

    //assigning opcode & funct3 to logic statements
    assign opcode = instruction[6:0];
    assign funct3 = instruction[14:12];

    //assigning the immediate fix this
    assign imm_s = {{20{instruction[31]}},
                    instruction[31:25],
                    instruction[11:7]};

    //assigning adress to have rs2 stored in
    assign addr = rs1_data + imm_s;
    assign is_store = (opcode == S);

    //this helps tell us how many bytes are stored
    always_comb begin
        case(funct3)
            SB: store_byte = 3'b001;
            SH: store_byte = 3'b010;
            SW: store_byte = 3'b100;
            default: error = 1'b1;
        endcase
    end


endmodule
