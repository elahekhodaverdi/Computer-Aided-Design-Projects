module dp (clk,init_x,init_x,load_a, load_sel, is_finished,res );
    input clk, init_x, init_w, load_a, load_sel;
    output is_finished;
    output [31:0] res;
    wire[31:0] PU1, PU2, PU3, PU4;
    wire[31:0] ai1, ai2, ai3, ai4;
    wire [31:0] a1, a2, a3, a4;
    wire [31:0] x1, x2, x3, x4;
    wire[1:0] sel_res;
    encoder_4to2 encoder(.in({{|a1},{|a2},{|a3},{|a4}}), .out(sel_res));
    check  chck(.zero0({|a1}), .zero1({|a2}), .zero2({|a3}), .zero3({|a4}), .is_finished(is_finished));
    
    mux2to1 mxa1(.a(PU1), .b() , .sel(load_sel), .w(ai1));
    mux2to1 mxa2(.a(PU2), .b() , .sel(load_sel), .w(ai2));
    mux2to1 mxa3(.a(PU3), .b() , .sel(load_sel), .w(ai3));
    mux2to1 mxa4(.a(PU4), .b() , .sel(load_sel), .w(ai4));

    PU PU_1(.clk(clk), .a1(a1), .a2(a2), .a3(a3), .a4(a4), .w(), .out(PU1));
    PU PU_2(.clk(clk), .a1(a1), .a2(a2), .a3(a3), .a4(a4), .w(), .out(PU2));
    PU PU_3(.clk(clk), .a1(a1), .a2(a2), .a3(a3), .a4(a4), .w(), .out(PU3));
    PU PU_4(.clk(clk), .a1(a1), .a2(a2), .a3(a3), .a4(a4), .w(), .out(PU4));

    mux2to1 mux_res(.a(), .b() ,.c(), .d(), .sel(sel_res), .w(res));
    
    
endmodule