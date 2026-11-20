`include "register_en.sv"

module fetch (
    input  logic         clk
    input  logic [31:0]  next_pc,
    input  logic         pc_en,

    input  logic [31:0]  imem_data_out,
    input  logic         ir_en,

    output logic [31:0]  pc,
    output logic [31:0]  imem_address,
    output logic [31:0]  instruction
);

    register_en #(.WIDTH(32), .INIT(32'h00001000)) pc_reg (
        .clk (clk),
        .en  (pc_en),
        .d   (next_pc),
        .q   (pc)
    );

    assign imem_address = pc;

    register_en #(.WIDTH(32), .INIT(32'd0)) ir_reg (
        .clk (clk),
        .en  (ir_en),
        .d   (imem_data_out),
        .q   (instruction)
    );

endmodule