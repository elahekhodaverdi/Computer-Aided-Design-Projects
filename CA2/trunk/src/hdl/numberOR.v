module numberOR(in, out);
    parameter N = 32;
    input [N - 1 : 0] in;
    output [N - 1 : 0] out;
    wire [N - 1 : 0] result;
    assign out = result [N - 1];
    assign result[0] = in[0];
    genvar i;
    generate
        for (i = 1; i < N; i = i + 1)
        begin: or_ops
            OR orr(
                .in1(in[i]),
                .in2(result[i - 1]),
                .out(result[i]));
        end
    endgenerate
endmodule