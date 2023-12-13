`timescale 1ps/1ps
module multiplierTB();
    reg [3:0] a, b;
    wire [7:0] product;

    multiplier #(4) U1 (.A(a), .B(b), .P(product));

    initial begin

        a = 4'b0011; // 3
        b = 4'b0101; // 5

        #10;

        a = 4'b1111; // 15
        b = 4'b1010; // 10

        #10;

        $finish;
    end
endmodule
