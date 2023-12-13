`timescale 1ps/1ps
module xorTB();
    reg a, b;
    wire out;

    XOR U1 (.a(a), .b(b), .out(out));

    initial begin
        a = 1'b0;
        b = 1'b0;

        #10;

        a = 1'b0;
        b = 1'b1;

        #10;

        a = 1'b1;
        b = 1'b0;

        #10;

        a = 1'b1;
        b = 1'b1;

        #10;
        $finish;
    end
endmodule
