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

    fp_mul multiplier1(.a(a1), .b(w[0]), .p(reg_mul1_inp));
    fp_mul multiplier2(.a(a2), .b(w[1]), .p(reg_mul2_inp));
    fp_mul multiplier3(.a(a3), .b(w[2]), .p(reg_mul3_inp));
    fp_mul multiplier4(.a(a4), .b(w[3]), .p(reg_mul4_inp));

    register reg_mul1(clk, 1, reg_mul1_inp, reg_mul1_out);
    register reg_mul2(clk, 1, reg_mul2_inp, reg_mul2_out);
    register reg_mul3(clk, 1, reg_mul3_inp, reg_mul3_out);
    register reg_mul4(clk, 1, reg_mul4_inp, reg_mul4_out);

    Addition_Subtraction addr1(.a(reg_mul1_out), .b(reg_mul2_out), .add_sub_signal(1), .res(addr1_res));
    Addition_Subtraction addr2(.a(reg_mul3_out), .b(reg_mul4_out), .add_sub_signal(1), .res(addr2_res));
    Addition_Subtraction addr3(.a(addr1_res), .b(addr2_res), .add_sub_signal(1), .res(addr3_res));

    register reg_addr(clk, 1, addr3_res, reg_addr_out);
    activation act(reg_addr_out, out);

endmodule