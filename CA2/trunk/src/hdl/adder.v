module adder #(parameter N = 8) (input [N-1:0] a, b, input cin, output [N-1:0] sum, output co);
    wire [N:0] c;
    genvar i;
    fulladder f0 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .co(c[1]));
    generate
        for (i = 1; i < N; i = i + 1) begin : FA_LOOP
            fulladder fi (.a(a[i]), .b(b[i]), .cin(c[i]), .sum(sum[i]), .co(c[i+1]));
        end
    endgenerate
    assign co = c[N];
endmodule
