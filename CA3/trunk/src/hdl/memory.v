module memory (clk, rd_adr, rd_data);
    parameter MAX_MEM_SIZE = 128; 
    parameter FILE_INPUT = "./sim/file/test.txt";
    parameter FILE_OUTPUT = "./sim/file/output.dat";
    // parameter FILE_INPUT = "file/test.txt";
    // parameter FILE_OUTPUT = "file/output.txt";
    input clk;
    input [7:0] rd_adr;
   // output reg [7:0] x, y, z;
    output [31:0] rd_data;
    
    reg [31:0] mem [0:MAX_MEM_SIZE-1];

    assign rd_data = mem[rd_adr];

    always @(posedge clk) begin
        if (wr_en) begin
            mem[wr_adr] <= wr_data;
        end
    end

endmodule