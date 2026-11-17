`include "memory.sv"

module top (
    input logic clk,
    output logic LED,
    output logic RGB_R,
    output logic RGB_G,
    output logic RGB_B
);
    //cycle cases
    localparam [1:0] FETCH         = 2'b00;
    localparam [1:0] EXECUTE       = 2'b01;
    localparam [1:0] STORE         = 2'b11;

    //initializing clk
    localparam [3:0] CLK_PER_CYCLE = 4'b1111;
    



    always_ff @(posedge clk)begin
        if 
    end


endmodule
