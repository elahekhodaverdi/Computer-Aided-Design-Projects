module encoder4to2 (in, out);
    input [3 : 0] in;
    output [1 : 0] out;
    OR or1(in[0], in[2], out[0]);
    OR or2(in[0], in[1], out[1]);
endmodule