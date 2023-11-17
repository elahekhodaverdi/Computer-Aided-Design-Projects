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

    fp_mult multiplier1(.a(a1), .b(w[0]), .result(reg_mul1_inp));
    fp_mult multiplier1(.a(a2), .b(w[1]), .result(reg_mul2_inp));
    fp_mult multiplier1(.a(a3), .b(w[2]), .result(reg_mul3_inp));
    fp_mult multiplier1(.a(a4), .b(w[3]), .result(reg_mul4_inp));

    
    register reg_mul1(clk, 1, reg_mul1_inp, reg_mul1_out);
    register reg_mul2(clk, 1, reg_mul2_inp, reg_mul2_out);
    register reg_mul3(clk, 1, reg_mul3_inp, reg_mul3_out);
    register reg_mul4(clk, 1, reg_mul4_inp, reg_mul4_out);

    fp_adder addr1(.a(reg_mul1_out), .b(reg_mul2_out), .result(addr1_res));
    fp_adder addr2(.a(reg_mul3_out), .b(reg_mul4_out), .result(addr2_res));
    fp_adder addr1(.a(addr1_res), .b(addr2_res), .result(addr3_res));

    register reg_addr(clk, 1, addr3_res, reg_addr_out);
    activation act(reg_addr_out, out);

endmodule