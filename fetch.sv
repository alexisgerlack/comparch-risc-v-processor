`include "register_en.sv"

module fetch (
    input logic clk,

    input logic [31:0]  next_pc,
    input logic pc_en, //when to load pc

    input logic [31:0]  imem_data_out, //instruction from memory.sv
    input logic ir_en, //when to latch imem_data_out into the instruction register

    output logic [31:0]  pc,
    output logic [31:0]  imem_address, //drives memory.sv's imem_address input which equals pc
    output logic [31:0]  instruction 
);

    //holds the current address, loads next_pc only when pc_en is asserted
    //inits to 0x1000 which is  memory.sv base address
    register_en #(.WIDTH(32), .INIT(32'h00001000)) pc_reg (
        .clk (clk),
        .en (pc_en),
        .d (next_pc),
        .q (pc)
    );


    assign imem_address = pc;

    //captures whatever memory.sv returns only on ir_en's edge since the memory read takes 1 cycle longer than driving the address does
    register_en #(.WIDTH(32), .INIT(32'd0)) ir_reg (
        .clk (clk),
        .en (ir_en),
        .d (imem_data_out),
        .q (instruction)
    );

endmodule