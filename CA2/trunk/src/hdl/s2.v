module s2 #(parameter N = 1) (D0, D1, D2, D3, A1, B1, A0, B0 clr, clk, out);
    input [N-1:0] D0, D1, D2, D3, out;
    input A1, B1, A0, B0, clr, clk;
    output reg [N-1:0] out;
    wire S0,S1 ;
    wire [N-1:0] RM;
    assign S1 = A1 || B1;
    assign S2 = A0 && B0;
    mux4to1 #(N) mux(.a(D0), .b(D1), .c(D2), .d(D3), .sel({S1,S0}), .out(RM));
    always @(posedge clk) begin
        if(clr)
            out <= {N{'b0}};
        else
            out <= RM;
    end

endmodule