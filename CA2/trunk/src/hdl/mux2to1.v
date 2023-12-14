module mux2to1 (a, b, sel, out);
    input sel;
    input [11:0] a, b;
    output [11:0] out;
    C2 #(12) mux2(.D0(a), .D1(b), .D2(12'b0), .D3(12'b0), .A1(1'b0), .B1(1'b0), .A0(sel), .B0(1'b1), .F(out));
endmodule