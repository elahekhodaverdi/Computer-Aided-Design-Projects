`timescale 1ps/1ps

module regTB();
    reg clk, rst, load_a;
    reg [31:0] ai1;
    wire [31:0] a1;
    register #(32) rega1(.clk(clk), .rst(rst), .ld(load_a), .in(ai1) , .out(a1));
    always #5 clk = ~clk;
    initial begin
        clk = 1;
        rst = 0;
        load_a = 0;
        ai1 = 100;
        #10 load_a = 1;
        #10 load_a = 0;
        #10 ai1 = 12;
        #10 load_a = 1;
        #1000 $stop;
    end

endmodule