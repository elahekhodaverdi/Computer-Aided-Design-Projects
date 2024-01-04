module buffer_4 (clk, wr_en, wr_adr, wr_data, rd_adr, rd_data);
    parameter SIZE = 16;
    input clk, wr_en;
    input [7:0] wr_adr, rd_adr;
    input [31:0] wr_data;
    output [7:0] rd_data;

    reg [7:0] mem [0:SIZE-1];

    assign rd_data = mem[rd_adr];

    always @(posedge clk) begin
        if (wr_en) begin
            mem[wr_adr] <= wr_data[31 : 24];
            mem[wr_adr + 1] <= wr_data[23 : 16];
            mem[wr_adr + 2] <= wr_data[15 : 8];
            mem[wr_adr + 3] <= wr_data[7 : 0];
        end
    end
    
endmodule