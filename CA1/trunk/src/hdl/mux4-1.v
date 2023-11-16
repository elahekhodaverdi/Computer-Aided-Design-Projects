`timescale 1ps/1ps

module mux2to1(parameter N = 32)(a, b ,c, d, sel, w);
    input[1:0] sel;
    input[N-1:0] a,b;
    output [N-1:0] w;
    assign w = (sel == 2'b00) ? a : (sel == 2'b01) ? b : (sel == 2'b10) ? c : (sel == 2'b11) ? d : {N}'b0;
endmodule