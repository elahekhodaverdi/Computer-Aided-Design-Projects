module XOR (a, b, out);
    input a, b;
    output out;
    C2 #(1) c2(.D0(1'b0), .D1(1'b1), .D2(1'b1), .D3(1'b0), .A1(a), .B1(b), .A0(a), .B0(b), .F(out));
endmodule