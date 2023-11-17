//ReLU activation function
module activation (inp, out);
    input [31:0] inp;
    output [31:0] out;
    assign out = (inp[31] == 0) ? inp : 0;
endmodule