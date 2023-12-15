`timescale 1ps/1ps
module multiplierTB();
    reg [4:0] a, b;
    wire [9:0] product;

    multiplier #(5) U1 (.x(a), .y(b), .out(product));

    initial begin

        a = 5'd2; // 2
        b = 5'd4; // 4

        #10;

        a = 5'd27; // -5 (2's complement)
        b = 5'd29; // -3 (2's complement)

        #10;

        a = 5'd11; // 11
        b = 5'd1; // 1

        #10;

        $finish;
    end
endmodule
