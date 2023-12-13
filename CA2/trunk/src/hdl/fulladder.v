module fulladder(a, b, cin, sum, co);
    input a, b, cin;
    output sum, co;
    wire s;
    XOR x1(.a(a), .b(b), .out(s));
    XOR x2(.a(s), .b(cin), .out(sum));
    carryOut carry(.a(a), .b(b), .c(cin), .cout(co));
endmodule