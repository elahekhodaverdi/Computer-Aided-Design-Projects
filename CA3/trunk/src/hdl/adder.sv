module adder (a, b, out);
    input [7:0] a, b;
    output [7:0] out;
    assign out = a + b;    
endmodule