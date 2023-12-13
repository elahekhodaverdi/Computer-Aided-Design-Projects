module NOT (a, out);
    input a;
    output out;
    C1 c1(.A0(1'b1), .A1(1'b1), .SA(1'b0), .B0(1'b0), .B1(1'b0), .SB(1'b1), .S0(a), .S1(a), .F(out));
        
endmodule