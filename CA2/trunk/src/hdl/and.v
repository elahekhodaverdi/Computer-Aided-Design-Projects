module AND(a, b , out);
    input a, b;
    output out;
    C1 andd(.A0(1'b0), .A1(1'b0), .SA(1'b0), .B0(a), .B1(a), .SB(1'b1), .S0(b), .S1(b), .F(out));

endmodule