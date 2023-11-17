`timescale 1ps/

module maxnet(clk, start, rst, done, result);
    input clk, rst, start;
    output done;
    output [31:0] result;

    wire init_w, init_x, load_a, load_sel, is_finished;
    controller ctrl(.start(start), .rst(rst), .clk(clk), .is_finished(is_finished), .init_w(init_w), .init_x(init_x), .load_a(load_a), .load_sel(load_sel), .done(done));
    datapath dp(.clk(clk),.init_x(init_x),.init_w(init_w),.load_a(load_a), .load_sel(load_sel), .is_finished(is_finished),.result(result));

endmodule