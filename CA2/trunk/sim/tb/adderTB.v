`timescale 1ps/1ps
module adderTB();
    reg [7:0] a, b;
    reg cin;
    wire [7:0] sum;
    wire co;

    adder #(8) U1 (.a(a), .b(b), .cin(cin), .sum(sum), .co(co));

    initial begin


        a = 8'b10101010;
        b = 8'b01010101;
        cin = 1'b0;

        #10;

        a = 8'b11110000;
        b = 8'b00001111;
        cin = 1'b1;

        #10;

        $finish;
    end
endmodule
