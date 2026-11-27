module next_pc_mux(
    input  logic [31:0] current_pc,
    input  logic [31:0] pc_four,
    input  logic [31:0] pc_j,
    input  logic [2:0] funct3,
    input  logic eq, lt, ltu,
    output logic [31:0] next_pc,
    output logic illegal
);
    /*
    alu_mux uses the inputs to determine the a and b that will go into the alu
    Inputs:
        current_pc - 32-bit wide program counter from register. This is the current program counter
        pc_four - this is the current pc plus four. determined by the alu in a previous cycle
        pc_j - this is the pc if a jump or branch was made.
        pc_sel - this determines the current pc
    Outputs:
        next_pc - 32-bit program counter for next cycle
        illegal - boolean value determining whether a valid a_sel or b_sel was used
    */
    //pc_sel states
    localparam logic [31:0] PC_FOUR = 1'b00;
    localparam logic [31:0] PC_JUMP = 1'b01;
    localparam logic [31:0] PC_JALR = 2'b10;

    logic [1:0] pc_sel;

    //determining pc_sel


here use a block to determine if the branch is taken using case statement of funct3
then use another block to determine pc_sel
do this with a case statement defaulting to pc_four

dw later lex this is easier than u think i just cant do it rn


    //assigning the pc_sel value
    always_comb begin
        illegal = 0;
        case(pc_sel)
            PC_FOUR: next_pc = pc_four;
            PC_JUMP: next_pc = pc_jump;
            default: illegal = 1;
        endcase
    end

endmodule
