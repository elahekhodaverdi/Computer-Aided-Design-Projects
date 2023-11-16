`timescale 1ps/1ps


module mux2to1(parameter N = 32)(a, b , sel, w);
    input sel;
    input[N-1:0] a,b;
    output [N-1:0] w;
    assign w = (sel == 1'b0) ? a : (sel == 1'b1) ? b : {N}'b0;
endmodule