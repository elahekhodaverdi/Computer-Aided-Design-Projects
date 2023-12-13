module fulladderTB();
    reg a, b, cin;
    wire sum, co;

    fulladder U1 (.a(a), .b(b), .cin(cin), .sum(sum), .co(co));

    initial begin
        a = 1'b0; b = 1'b0; cin = 1'b0;
        #10;

        a = 1'b0; b = 1'b0; cin = 1'b1;
        #10;

        a = 1'b0; b = 1'b1; cin = 1'b0;
        #10;

        a = 1'b0; b = 1'b1; cin = 1'b1;
        #10;

        a = 1'b1; b = 1'b0; cin = 1'b0;
        #10;

        a = 1'b1; b = 1'b0; cin = 1'b1;
        #10;

        a = 1'b1; b = 1'b1; cin = 1'b0;
        #10;

        a = 1'b1; b = 1'b1; cin = 1'b1;
        #10;

        $finish;
    end
endmodule
