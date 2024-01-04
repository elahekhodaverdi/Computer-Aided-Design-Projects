module counterTB();
    reg clk, rst, en, carry;
    wire [7:0] count;
    counter #(10) cntr(clk, rst, en, carry, count);


endmodule