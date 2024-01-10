module buf4x4_f(
    input clk,
    input wr_en,
    input [3:0] wr_addr,
    input [3:0] rd_addr,
    input [31:0] wr_data,
    output reg [7:0] rd_data
);
    reg [7:0] mem [15:0];

    always @(posedge clk) begin
        if(wr_en) begin
            mem[wr_addr] <= wr_data[31:24];
            mem[wr_addr + 1] <= wr_data[23:16];
            mem[wr_addr + 2] <= wr_data[15:8];
            mem[wr_addr + 3] <= wr_data[7:0];
        end
    end
    assign rd_data = mem[rd_addr];
endmodule
