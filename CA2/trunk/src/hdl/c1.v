module C1 (A0, A1, SA, B0, B1, SB, S0, S1, F);
    parameter N = 1;
    input [N - 1 : 0] A0, A1, B0, B1;
    input S0, S1, SB, SA;
    wire S2;
    output [N - 1 : 0] F;
    wire [N - 1 : 0] F1, F2;
    assign F1 = (SA) ? A1 : A0;
    assign F2 = (SB) ? B1 : B0;
    assign S2 = S0 | S1;
    assign F = (S2) ? F2 : F1;
endmodule