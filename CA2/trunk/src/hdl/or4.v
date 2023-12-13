module OR4(a, b, c, d, out);
    input a, b, c, d;
    output out;
    C2 #(1) or4(.D0(a), .D1(1'b1), .D2(1'b1), .D3(1'b1), .A1(b), .B1(c), .A0(d), .B0(1'b1), .F(out));
endmodule