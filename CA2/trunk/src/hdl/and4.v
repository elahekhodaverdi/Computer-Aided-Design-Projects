module AND4 (a, b, c, d, out);
    input a, b, c, d;
    output out;
    C2 #(1) c2(.D0(1'b0), .D1(1'b0), .D2(1'b0), .D3(d), .A1(a), .B1(1'b0), .A0(b), .B0(c), .F(out));
endmodule