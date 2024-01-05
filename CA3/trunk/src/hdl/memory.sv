module memory (clk, rd_adr, rd_data);
    parameter MAX_MEM_SIZE = 128; 
    //parameter FILE_INPUT = "./sim/file/input.txt";
    parameter FILE_INPUT = "file/input.txt";
    
    input clk;
    input [7:0] rd_adr;
    output [31:0] rd_data;
    
    reg [31:0] mem [0:MAX_MEM_SIZE-1];

    initial begin
        $readmemh(FILE_INPUT, mem);
    end

    assign rd_data = mem[rd_adr];

endmodule