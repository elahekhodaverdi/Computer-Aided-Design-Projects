module create_index #(parameter N1 = 8, parameter N2= 4)(
    input [N2-1:0] x,
    input [N2-1:0] y,
    output [N1-1:0] index
);
    assign index = y*N2 + x;

endmodule