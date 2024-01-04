`timescale 1ps/1ps


module convolutionTB();
    reg clk, start;
    reg [7:0] x, y, z;
    wire done;
    convolution conv(clk, start, x, y, z, done);

    always #5 clk = ~clk;

    initial begin
        {start,clk} = 3'b0;
        x = 4;
        y = 74;
        z = 84;

        #30 start = 1'b1;
        #30 start = 1'b0;

        #50000 $stop;
    end


endmodule