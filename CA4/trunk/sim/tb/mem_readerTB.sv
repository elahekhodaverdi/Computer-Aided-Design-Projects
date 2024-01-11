module mem_readerTB();
    reg clk, start;
    reg [7:0] x, y, z;

    wire [7:0] img_data [0:255];
    wire [7:0] filters [0:3][0:15];
    wire done;

    mem_reader mr(clk, start, x, y, z, done, img_data, filters);

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        start = 0;
        x = 16;
        y = 0;
        z = 0;
        #10 start = 1;
        #10 start = 0;
        #10000 $stop;
    end

    


endmodule