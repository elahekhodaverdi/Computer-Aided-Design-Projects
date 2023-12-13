module datapath(clk, rst, load_a, load_sel, is_finished, res);
    input clk, load_a, load_sel, rst;
    output is_finished;
    output [31:0] res;
    wire[31:0] PU1, PU2, PU3, PU4;
    wire[31:0] ai1, ai2, ai3, ai4;
    wire [31:0] a1, a2, a3, a4;
    wire or_a1, or_a2, or_a3, or_a4;
    wire[1:0] sel_res;



    wire [31:0] W_out [15:0];
    wire [31:0] X_out [3:0];

    // read Weights and inputs from memory
    Memory memory(X_out,W_out);
    // encoder for maximum selector
    numberOR #(32) ora1(.in(a1), .out(or_a1));
    numberOR #(32) ora2(.in(a2), .out(or_a2));
    numberOR #(32) ora3(.in(a3), .out(or_a3));
    numberOR #(32) ora4(.in(a4), .out(or_a4));

    encoder4to2 encoder(.in({or_a1, or_a2, or_a3, or_a4}), .out(sel_res));
    // check if procedure is finished
    check  chck(.a({or_a1, or_a2, or_a3, or_a4}), .is_finished(is_finished));
    
    // neuron registers
    register #(32) rega1(.clk(clk), .rst(rst), .ld(load_a), .in(ai1) , .out(a1));
    register #(32) rega2(.clk(clk), .rst(rst), .ld(load_a), .in(ai2) , .out(a2));
    register #(32) rega3(.clk(clk), .rst(rst), .ld(load_a), .in(ai3) , .out(a3));
    register #(32) rega4(.clk(clk), .rst(rst), .ld(load_a), .in(ai4) , .out(a4));

    // select registers load values(between activation output and memory output)
    mux2to1 #(32) mxa1(.a(PU1), .b(X_out[0]) , .sel(load_sel), .w(ai1));
    mux2to1 #(32) mxa2(.a(PU2), .b(X_out[1]) , .sel(load_sel), .w(ai2));
    mux2to1 #(32) mxa3(.a(PU3), .b(X_out[2]) , .sel(load_sel), .w(ai3));
    mux2to1 #(32) mxa4(.a(PU4), .b(X_out[3]) , .sel(load_sel), .w(ai4));

    PU PU_1(.clk(clk), .a1(a1), .a2(a2), .a3(a3), .a4(a4), .w1(W_out[0]), .w2(W_out[1]), .w3(W_out[2]), .w4(W_out[3]), .out(PU1));
    PU PU_2(.clk(clk), .a1(a1), .a2(a2), .a3(a3), .a4(a4), .w1(W_out[4]), .w2(W_out[5]), .w3(W_out[6]), .w4(W_out[7]), .out(PU2));
    PU PU_3(.clk(clk), .a1(a1), .a2(a2), .a3(a3), .a4(a4), .w1(W_out[8]), .w2(W_out[9]), .w3(W_out[10]), .w4(W_out[11]), .out(PU3));
    PU PU_4(.clk(clk), .a1(a1), .a2(a2), .a3(a3), .a4(a4), .w1(W_out[12]), .w2(W_out[13]), .w3(W_out[14]), .w4(W_out[15]), .out(PU4));

    // select maximum value
    mux4to1 #(32) mux_res(.a(X_out[0]), .b(X_out[1]) ,.c(X_out[2]), .d(X_out[3]), .sel(sel_res), .w(res));

endmodule