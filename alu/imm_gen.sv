module imm_u(
    input logic  [31:0] instruction,
    input logic  [2:0]  imm_struct,
    output logic [31:0] imm
);
    //different imm
    localparam logic [2:0] IMM_I = 3'd0;
    localparam logic [2:0] IMM_S = 3'd1;
    localparam logic [2:0] IMM_B = 3'd2;
    localparam logic [2:0] IMM_U = 3'd3;
    localparam logic [2:0] IMM_J = 3'd4;

    always_comb begin
        case(imm_struct)
            IMM_I:imm = {{20{instruction[31]}}, instruction[31:20]};
            IMM_S:imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            IMM_B:imm = {{19{instruction[31]}}, instruction[31], instruction[7],instruction[30:25],
            instruction[11:8], 1'b0};
            IMM_U:imm = {instruction[31:12], 12'b0};
            IMM_J:imm =  {{11{instruction[31]}}, instruction[31], instruction[19:12],
            instruction[20], instruction[30:21], 1'b0};
            default: imm = 32'b0;
        endcase
    end
    endmodule
