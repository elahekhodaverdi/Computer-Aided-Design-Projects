`timescale 1ps/1ps

module PU (clk, a1, a2, a3, a4, w, out);
    input clk;
    input [31:0] a1, a2, a3, a4;
    input [31:0] w [3:0];
    output [31:0] out;
    wire [31:0] reg_mul1_inp, reg_mul2_inp, reg_mul3_inp, reg_mul4_inp; 
    wire [31:0] reg_mul1_out, reg_mul2_out, reg_mul3_out, reg_mul4_out; 
    wire [31:0] addr1_res, addr2_res, addr3_res;
    wire [31:0] reg_addr_out;

    FloatingMultiplication multiplier1(.clk(clk), .A(a1), .B(w[0]), .p(reg_mul1_inp));
    FloatingMultiplication multiplier2(.clk(clk), .A(a2), .B(w[1]), .p(reg_mul2_inp));
    FloatingMultiplication multiplier3(.clk(clk), .A(a3), .B(w[2]), .p(reg_mul3_inp));
    FloatingMultiplication multiplier4(.clk(clk), .A(a4), .B(w[3]), .p(reg_mul4_inp));

    register reg_mul1(clk, 1, reg_mul1_inp, reg_mul1_out);
    register reg_mul2(clk, 1, reg_mul2_inp, reg_mul2_out);
    register reg_mul3(clk, 1, reg_mul3_inp, reg_mul3_out);
    register reg_mul4(clk, 1, reg_mul4_inp, reg_mul4_out);

    FloatingAddition addr1(.clk(clk), .A(reg_mul1_out), .B(reg_mul2_out), .result(addr1_res));
    FloatingAddition addr2(.clk(clk), .A(reg_mul3_out), .B(reg_mul4_out), .result(addr2_res));
    FloatingAddition addr3(.clk(clk), .A(addr1_res), .B(addr2_res), .result(addr3_res));

    register reg_addr(clk, 1, addr3_res, reg_addr_out);
    activation act(reg_addr_out, out);

endmodule