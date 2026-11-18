module regfile (
    input  logic        clk,
    input  logic [4:0]  rs1,
    input  logic [4:0]  rs2,
    input  logic [4:0]  rd,
    input  logic [31:0] write_data,
    input  logic        write_en,
    output logic [31:0] read_data1,
    output logic [31:0] read_data2
);

    logic [31:0] registers [0:31];

    int i;
    
    // sets every register to 0 when fpga powers up
    initial begin
        for (i = 0; i < 32; i++) begin
            registers[i] = 32'd0;
        end
    end

    // continuously looks up whichever register rs points to and puts it value on read_data
    always_comb begin
        read_data1 = (rs1 == 5'd0) ? 32'd0 : registers[rs1];
        read_data2 = (rs2 == 5'd0) ? 32'd0 : registers[rs2];
    end

    // when clock ticks up if write_en is 1 and the target isn't x0, it overwrites register rd with write_data
    always_ff @(posedge clk) begin
        if (write_en && (rd != 5'd0)) begin
            registers[rd] <= write_data;
        end
    end

endmodule
