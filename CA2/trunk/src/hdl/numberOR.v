module numberOR(in, out);
    parameter N = 5;
    input [N - 1 : 0] in;
    output out;
    wire [N - 1 : 0] result;
    assign out = result [N - 1];
    assign result[0] = in[0];
    genvar i;
    generate
        for (i = 1; i < N; i = i + 1)
        begin: or_ops
            OR orr(
                .a(in[i]),
                .b(result[i - 1]),
                .out(result[i]));
        end
    endgenerate
endmodule