`timescale 1ps/1ps


module convolutionTB();
    reg clk, start;
    reg [7:0] x, y, z;
    wire done;
    convolution #(4) conv(clk, start, x, y, z, done);

    always #5 clk = ~clk;

    initial begin
        {start,clk} = 3'b0;
        x = 16;
        y = 0;
        z = 0;

        #30 start = 1'b1;
        #30 start = 1'b0;

        #50000 $stop;
    end


endmodule