module register (clk, rst, ld, in, out);
    parameter N = 32;
    input clk, rst, ld;
    input [31 : 0] in;
    output [31 : 0] out;
    S2 #(32) s2(.D0(out), .D1(in), .D2(0), .D3(0), .A1(1'b0), .B1(1'b0), .A0(ld), .B0(1'b1), .clr(rst), .clk(clk), .out(out));
endmodule