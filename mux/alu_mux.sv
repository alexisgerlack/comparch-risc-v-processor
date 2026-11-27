module alu_mux(
    input  logic [1:0] a_sel,
    input  logic [1:0] b_sel,
    input  logic [31:0] pc,
    input  logic [31:0] rs1_data,
    input  logic [31:0] rs2_data,
    input  logic [31:0] imm,
    output logic [31:0] a,
    output logic [31:0] b,
    output logic illegal
);
    /*
    alu_mux uses the inputs to determine the a and b that will go into the alu
    Inputs:
        a_sel - a two bit wide number determined by decode representing what a will be
        b_sel - a two bit wide number determined by decode representing what b will be
        pc - 32-bit wide program counter
        rs1_data - 32-bit wide data retrieved from register - possible a value
        rs2_data - 32-bit wide data retrieved from register - possible b value
        imm - 32-bit immediate determined by imm_gen
    Outputs:
        a - 32-bit operand. this is the first operand the alu will take in
        b - 32-bit operand. this is the second operand the alu will take in
        illegal - boolean value determining whether a valid a_sel or b_sel was used
    */
    //states of a and b
    localparam logic [1:0] A_RS1  = 2'd0, A_PC   = 2'd1, A_ZERO = 2'd2;
    localparam logic [1:0] B_RS2  = 2'd0, B_IMM  = 2'd1, B_FOUR = 2'd2;

    always_comb begin
        illegal = 0;
        case(a_sel)
            A_RS1: a = rs1_data;
            A_PC: a = pc;
            A_ZERO: a = 0;
            default: illegal = 1;
        endcase
        case(b_sel)
            B_RS2: b = rs2_data;
            B_IMM: b = imm;
            B_FOUR: b = 32'd4;
            default: illegal = 1;
        endcase
    end

endmodule
