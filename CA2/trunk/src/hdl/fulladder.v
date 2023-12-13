module fa(input a, b, cin, output sum, co);
    wire s;
    XOR x1(.a(a), .b(b), .out(s));
    XOR x1(.a(s), .b(cin), .out(sum));
    carry_out carry (a,b,cin , co);
    carryOut carry(.a(a), .b(b), .c(cin), .cout(co));
endmodule