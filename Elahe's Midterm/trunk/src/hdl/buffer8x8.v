module buffer8x8(
    input clk,
    input wr_en,
    input shift_en,
    input [5:0] wr_addr,
    input [5:0] rd_addr,
    input [31:0] wr_data,
    output reg [7:0] rd_data
);
    reg [7:0] mem [63:0];

    integer i;
    integer j;
    always @(posedge clk) begin
        if(wr_en) begin
            mem[wr_addr] <= wr_data[31:24];
            mem[wr_addr + 1] <= wr_data[23:16];
            mem[wr_addr + 2] <= wr_data[15:8];
            mem[wr_addr + 3] <= wr_data[7:0];
        end
        if(shift_en) begin
            for(i = 0; i < 8;i = i+1)
                for(j = 0; j < 7; j = j+1)
                begin
                    if((i > 3) && j == 0)
                        mem[8*(i -4) + 7] = mem[8*i];
                    mem[8*i + j] = mem[8*i + j + 1];
                end
        end
    end
    assign rd_data = mem[rd_addr];
endmodule
