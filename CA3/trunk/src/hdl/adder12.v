module adder12 (a, b, out);
    input [11:0] a, b;
    output [11:0] out;
    assign out = a + b;    
endmodule