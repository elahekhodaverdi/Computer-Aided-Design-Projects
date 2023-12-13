module C2 (D0, D1, D2, D3, A1, B1, A0, B0);
    parameter N = 1;
    input [N - 1 : 0] D0, D1, D2, D3;
    input A1, B1, A0, B0;
    output [N - 1 : 0] F;
    wire S0, S1;
    wire [1 : 0] S2;
    assign S0 = A1 | B1;
    assign S1 = A0 & B0;
    assign S2 = {S1, S0};
    assign F = (S2 == 2'b11) ? D3 :
               (S2 == 2'b10) ? D2 :
               (S2 == 2'b01) ? D1 : D0;
endmodule