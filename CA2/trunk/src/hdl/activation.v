module activation(a , out);
    input [11:0] a;
    output [11:0] out;
    mux2to1 activate (.a(a), .b(12'b0), .sel(a[11]), .out(out));
endmodule