module buf4x4_w(
    input clk,
    input wr_en,
    input [3:0] wr_addr,
    input [3:0] rd_addr,
    input [7:0] wr_data,
    output reg [7:0] rd_data
);
    reg [7:0] mem [15:0];

    always @(posedge clk) begin
        if(wr_en)
            mem[wr_addr] <= wr_data;
    end
    assign rd_data = mem[rd_addr];
endmodule
