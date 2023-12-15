module abs_value #(parameter N = 5) (input [N-1:0] a, output [N-1:0] abs_a);
    wire [N-1:0] inverted_a;
    wire [N-1:0] one = {N{1'b0}};
    one[0] = a[N-1];

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : XOR_LOOP
            XOR xor_i (.a(a[i]), .b(a[N-1]), .out(inverted_a[i]));
        end
    endgenerate

    adder #(N) adder1 (.a(inverted_a), .b(one), .sum(abs_a));
endmodule
