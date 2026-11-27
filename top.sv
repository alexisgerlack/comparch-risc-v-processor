logic [4:0]  rs1_addr, rs2_addr;
logic [31:0] read_data1, read_data2;
logic [31:0] write_data;
logic reg_write_en;

assign rs1_addr = instruction[19:15];
assign rs2_addr = instruction[24:20];
assign reg_write_en = 1'b0;

regfile regfile_inst (
    .clk (clk),
    .rs1 (rs1_addr),
    .rs2 (rs2_addr),
    .rd (rd_address),
    .write_data (write_data),
    .write_en (reg_write_en),
    .read_data1 (read_data1),
    .read_data2 (read_data2)
);