module OR (a, b, out);
    input a, b;
    output out;
    C1 c1(.A0(1'b0), .A1(1'b0), .B0(1'b1), .B1(1'b1), .SA(1'b0), .SB(1'b0), .S0(a), .S1(b), .F(out));

endmodule