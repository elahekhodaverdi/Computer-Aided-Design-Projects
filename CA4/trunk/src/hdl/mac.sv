module mac (clk, rst, rst_acc, acc_en, img_pixel, filter_value, out);
    input clk, rst, rst_acc, acc_en;
    input [7:0] img_pixel, filter_value;
    output [11:0] out;

    wire [11:0] acc_out, acc_in;
    wire [7:0] mult_res;

    multiplier mult(img_pixel, filter_value, mult_res);
    adder12 addr4({4'b0000, mult_res}, acc_out, acc_in);
    register1word acc(clk, acc_en, rst | rst_acc, acc_in, acc_out);

    assign out = acc_out;//[11:4];
    
endmodule