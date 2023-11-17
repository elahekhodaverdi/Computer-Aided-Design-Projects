`timescale 1ps/1ps


module tb();
    reg clk,rst,start;
    wire init_w,init_x,load_a,load_sel, isfinished;
    controller cntrlr(start, rst, clk, isfinished, init_w, init_x, load_a, load_sel, done);
    dp datapath(clk,init_x,init_w,load_a, load_sel, is_finished,res );

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