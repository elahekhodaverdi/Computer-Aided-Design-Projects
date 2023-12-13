module mux2to1 #(parameter N = 32) (a, b, sel, out);
    input sel;
    input [N-1:0] a, b;
    output [N-1:0] out;
    C2 #(N) mux2(.D0(a), .D1(b), .D2({N{'b0}}), .D3({N{'b0}}), .A1(1'b0), .B1(1'b0), .A0(sel), .B0(1'b1), .F(out));
endmodule