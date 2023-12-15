module multiplier (x, y, out);
    parameter N = 5;
    input signed [N - 1 : 0] x, y;
    output signed [2*N - 1 : 0] out;

    wire [2*N - 1 : 0] z;
    // assign out = x * y;
    wire signbit_res;

    wire[N-1:0] abs_x, abs_y;
    abs_to_2scomplement #(N) absx(.a(x), .signbit(x[N-1]), .out(abs_x));
    abs_to_2scomplement #(N) absy(.a(y), .signbit(y[N-1]), .out(abs_y));
    wire xv [N : 0][N : 0];
    wire yv [N : 0][N : 0];
    wire cv [N : 0][N : 0];
    wire pv [N : 0][N : 0];

    genvar i, j;
    generate
        for (i = 0; i < N; i = i + 1)
        begin: gen_rows
            for (j = 0; j < N; j = j + 1)
            begin: gen_cols
                bit_multiplier bm(
                    .xi(xv[i][j]), 
                    .yi(yv[i][j]),
                    .pi(pv[i][j + 1]),
                    .ci(cv[i][j]), 
                    .xo(xv[i][j + 1]),
                    .yo(yv[i + 1][j]),
                    .po(pv[i + 1][j]),
                    .co(cv[i][j + 1])
                );
            end
        end
    endgenerate

    generate
        for (i = 0; i < N; i = i + 1)
        begin: sides
            assign xv[i][0] = abs_x[i];
            assign cv[i][0] = 1'b0;
            assign pv[0][i + 1] = 1'b0;
            assign pv[i + 1][N] = cv[i][N];
            assign yv[0][i] = abs_y[i];
            assign z[i] = pv[i + 1][0];
            assign z[i + N] = pv[N][i + 1];
        end
    endgenerate
    
    XOR res_signbit(.a(x[N-1]), .b(y[N-1]), .out(signbit_res));
    abs_to_2scomplement #(2*N) twoscomplement(.a(z), .signbit(signbit_res), .out(out));

endmodule
