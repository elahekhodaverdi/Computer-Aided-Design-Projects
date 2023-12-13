module carryOut(a, b, c, cout);
    input a, b, c;
    output cout;
    C2 co(.D0(1'b0), .D1(1'b1), .D2(c), .D3(1'b1), .A1(a), .B1(b), .A0(a), .B0(b), .F(cout));
endmodule