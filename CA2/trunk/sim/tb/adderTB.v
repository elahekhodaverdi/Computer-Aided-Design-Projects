`timescale 1ps/1ps
module adderTB();
    reg signed [9:0] a, b;
    reg cin;
    wire [10:0] sum;

    adder #(11) U1 (.a({a[9], a}), .b({b[9], b}), .sum(sum));

    initial begin


        a = -32;
        b = 24;
        cin = 1'b0;

        #10;


        $finish;
    end
endmodule
