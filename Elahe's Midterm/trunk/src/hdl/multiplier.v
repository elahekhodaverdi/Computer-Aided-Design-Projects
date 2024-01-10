module multiplier #(parameter N = 32) 
(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [2*N-1:0] product
);
    assign product = a * b;
endmodule
