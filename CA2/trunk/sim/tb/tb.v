`timescale 1ps/1ps


module tb();
    reg clk,rst,start;
    wire done;
    wire[31:0] result;

    maxnet max(.clk(clk), .start(start), .rst(rst), .done(done), .result(result));

    always #5 clk = ~clk;
        initial begin
            {start,rst,clk} = 3'b0;
            #30 start = 1'b1;
            #30 start = 1'b0;
            #3000
            #200 rst = 1'b1;
            #200 rst = 1'b0;
            #10 $stop;
        end
endmodule