module memory (clk, wr_en, wr_adr, wr_data, rd_adr, rd_data, wr_file);
    parameter MAX_MEM_SIZE = 128; 
    // parameter FILE_INPUT = "../sim/file/test.txt";
    // parameter FILE_OUTPUT = "../sim/file/output.dat";
    parameter FILE_INPUT = "file/test.txt";
    parameter FILE_OUTPUT = "file/output.txt";
    input wr_en, clk, wr_file;
    input [7:0] wr_adr, rd_adr;
    input [31:0] wr_data;
   // output reg [7:0] x, y, z;
    output [31:0] rd_data;
    
    reg [31:0] mem [0:MAX_MEM_SIZE-1];

    assign rd_data = mem[rd_adr];

    always @(posedge clk) begin
        if (wr_en) begin
            mem[wr_adr] <= wr_data;
        end
    end
    
    //integer file, i, j;
    //reg [7:0] data;
    //reg [31:0] row;
    initial begin
        $readmemh(FILE_INPUT, mem);
 
    end

    always @(posedge clk) begin
        if (wr_file)begin
            $writememh(FILE_OUTPUT, mem);
        end
    end

endmodule