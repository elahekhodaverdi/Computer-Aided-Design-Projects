module mux4to1 #(parameter N = 1) (a, b, c, d, sel, out);
    input [1:0] sel;
    input [N-1:0] a, b, c, d;
    output [N-1:0] out;
    C2 mux4(.D0(a), .D1(b), .D2(c), .D3(d), .A1(0), .B1(sel[1]), .A0(sel[0]), .B0(1'b1), .F(out));
endmodule