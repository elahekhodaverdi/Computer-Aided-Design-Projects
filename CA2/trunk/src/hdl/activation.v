module activation(a , out);
    input [11:0] a;
    output [4:0] out;
    mux2to1 activate (.a({a[11],a[6],a[5],a[4],a[3]}), .b(5'b0), .sel(a[11]), .out(out));
endmodule