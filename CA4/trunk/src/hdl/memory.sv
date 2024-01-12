module memory (clk, write_en, rd_adr, img_inp, rd_data);
    parameter MAX_MEM_SIZE = 128;
    parameter IMG_LINE_SIZE = 64; 
    parameter FILE_INPUT = "input.txt";
    parameter START_WR_IMG = 16;
    //parameter FILE_INPUT = "file/input.txt";
    
    input clk, write_en;
    input [7:0] rd_adr;
    input [31:0] img_inp [0:127];
    output [31:0] rd_data;
    
    reg [31:0] mem [0:MAX_MEM_SIZE-1];

    initial begin
        string file_name;
        file_name = $sformatf("file/%s", FILE_INPUT);
        $readmemh(file_name, mem);
    end

    assign rd_data = mem[rd_adr];
    int i;
    always @(clk) begin
        if(write_en) begin
            for (i = 0 ; i < IMG_LINE_SIZE; i = i + 1) begin
                mem[i+ START_WR_IMG] = img_inp[i];
            end
        end
    end
endmodule