module S2 #(parameter N = 1) (D0, D1, D2, D3, A1, B1, A0, B0, clr, clk, out);
    input [N-1:0] D0, D1, D2, D3;
    input A1, B1, A0, B0, clr, clk;
    output reg [N-1:0] out;
    wire S0,S1 ;
    wire [N-1:0] RM;
    assign S1 = A1 | B1;
    assign S0 = A0 & B0;
    assign RM = ({S1,S0} == 2'b00) ? D0 :
                ({S1,S0} == 2'b01) ? D1 : 
                ({S1,S0} == 2'b10) ? D2 : D3 ;
    always @(posedge clk) begin
        if(clr)
            out <= 0;
        else
            out <= RM;
    end

endmodule