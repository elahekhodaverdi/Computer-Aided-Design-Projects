module memTB ();
    reg clk, wr_en, rd_en;
    reg [7:0] wr_adr, rd_adr;
    reg wr_file;
 //   wire [7:0] x, y, z;
    reg [31:0] wr_data;
    wire [31:0] rd_data;

    memory mem(clk, wr_en, wr_adr, wr_data, rd_adr, rd_data, wr_file);

    always #5 clk = ~clk;

    initial begin
        clk = 1;
        #100 wr_file = 1'b1;
        #20 wr_file = 0;
        #100 $stop;

    end
    
endmodule