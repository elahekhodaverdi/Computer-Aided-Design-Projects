`timescale 1ps/1ps

module maxnet(clk, start, rst, done, result);
    input clk, rst, start;
    output done;
    output [31:0] result;
    
    wire load_a, load_sel, is_finished;
    controller ctrl(.start(start), .rst(rst), .clk(clk), .is_finished(is_finished), .load_a(load_a), .load_sel(load_sel), .done(done));
    datapath dp(.clk(clk), .load_a(load_a), .load_sel(load_sel), .is_finished(is_finished),.res(result));

endmodule