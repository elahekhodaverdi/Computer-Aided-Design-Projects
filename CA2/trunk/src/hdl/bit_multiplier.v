module bit_multiplier (xi, yi, pi, ci, xo, yo, po, co);
    input xi, yi, pi, ci;
    output xo, yo, po, co;

    wire xy;
    AND and(xi, yi, xy);
    fulladder fa(pi, xy, ci, po, co);
    assign yo = yi;
    assign xo = xi;

endmodule