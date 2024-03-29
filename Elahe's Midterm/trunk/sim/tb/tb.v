`timescale 1ps/1ps


module tb();
    reg clk,rst,start;
    wire done;
    convolution conv(
    .clk(clk),
    .rst(rst),
    .start(start),
    .X(7'd5),
    .Y(7'd71),
    .Z(7'd83),
    .done(done));

    always #5 clk = ~clk;
        initial begin
            {start,rst,clk} = 3'b0;
            #30 start = 1'b1;
            #30 start = 1'b0;
            #66000
            #200 rst = 1'b1;
            #200 rst = 1'b0;
            #10 $stop;
        end
endmodule