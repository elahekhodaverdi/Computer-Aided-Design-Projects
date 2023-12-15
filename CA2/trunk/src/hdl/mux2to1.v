module mux2to1 (a, b, sel, out);
    input sel;
    input [4:0] a, b;
    output [4:0] out;
    C2 #(5) mux2(.D0(a), .D1(b), .D2(5'b0), .D3(5'b0), .A1(1'b0), .B1(1'b0), .A0(sel), .B0(1'b1), .F(out));
endmodule