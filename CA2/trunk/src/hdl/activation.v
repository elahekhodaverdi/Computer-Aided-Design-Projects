module activation(a , out);
    input [31:0] a;
    output [31:0] out;
    mux2to1 activate (.a(a), .b(32'b0), .sel(a[31]), .out());
endmodule