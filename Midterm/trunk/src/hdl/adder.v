module adder #(parameter N = 32) (a, b, sum);
    input [N-1:0] a,b;
    output [N-1:0] sum;
    assign sum = a + b;
endmodule