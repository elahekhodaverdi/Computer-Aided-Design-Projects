module multiplier #(parameter N = 4) (
    input [N-1:0] A,
    input [N-1:0] B,
    output [2*N-1:0] P
);
    genvar i, j;
    wire [N-1:0] partial_products [N-1:0];
    wire [N-1:0] sum, carry;

    // Generate partial products
    generate
        for (i = 0; i < N; i = i + 1) begin : gen_partial_products
            for (j = 0; j < N; j = j + 1) begin : gen_and
                assign partial_products[i][j] = A[i] & B[j];
            end
        end
    endgenerate

    // Sum partial products using the provided full adder
    generate
        for (i = 0; i < N; i = i + 1) begin : gen_sum
            fulladder fa (.a(partial_products[0][i]), .b(partial_products[1][i-1]), .cin(0), .sum(sum[i]), .co(carry[i]));
        end
    endgenerate

    // Generate product
    generate
        for (i = 0; i < 2*N; i = i + 1) begin : gen_product
            if (i < N) begin
                assign P[i] = sum[i];
            end else begin
                assign P[i] = carry[i-N];
            end
        end
    endgenerate
endmodule
