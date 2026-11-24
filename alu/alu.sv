module alu(
    input  logic [31:0] a,//first input
    input  logic [31:0] b,//second input
    input  logic [3:0]  alu_op,
    output logic [31:0] result,
    output logic        eq,     // a == b
    output logic        lt,     // a <  b, signed
    output logic        ltu     // a <  b, unsigned
);
    //constants for each operation
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

    logic [4:0] shamt;
    assign shamt = b[4:0]; //shift amount

    //comparison flags for branches to reuse logic
    assign eq  = (a == b);
    assign lt  = ($signed(a) < $signed(b));
    assign ltu = (a < b);

    always_comb begin
        case(alu_op)
            ALU_ADD: result = a + b;
            ALU_SUB: result = a - b;
            ALU_SLL: result = a << shamt;
            ALU_SLT: result =  {31'b0, lt};
            ALU_SLTU: result = {31'b0, ltu};
            ALU_XOR: result = a ^ b;
            ALU_SRL: result = a >> shamt;
            ALU_SRA: result = $signed(a) >>> shamt;
            ALU_OR: result = a | b;
            ALU_AND: result = a & b;
            default: result = 32'b0;
        endcase
    end
endmodule
