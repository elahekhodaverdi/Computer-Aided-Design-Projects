module abs_to_2scomplement #(parameter N = 5) (a, signbit, out);
    input [N-1:0] a;
    input signbit;
    output [N-1:0] out;

    wire [N-1:0] inverted_a;
    wire [N-1:0] one;

    assign one = {{(N-1){1'b0}}, signbit };

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : XOR_LOOP
            XOR xor_i (.a(a[i]), .b(signbit), .out(inverted_a[i]));
        end
    endgenerate

    adder #(N) adder1 (.a(inverted_a), .b(one), .sum(out));
endmodule
