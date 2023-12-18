module DFF (clk, rst, in, out);
    parameter N = 5;
    input clk, rst;
    input [N - 1 : 0] in;
    output [N - 1 : 0] out;
    S2 #(N) s2(.D0(out), .D1(in), .D2(0), .D3(0), .A1(1'b0), .B1(1'b0), .A0(1'b1), .B0(1'b1), .clr(rst), .clk(clk), .out(out));
endmodule