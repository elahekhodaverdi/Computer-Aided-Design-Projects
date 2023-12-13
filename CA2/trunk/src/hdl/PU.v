`timescale 1ps/1ps

module PU (clk, rst, a1, a2, a3, a4, w1, w2, w3, w4, out);
    input clk, rst;
    input [31:0] a1, a2, a3, a4;
    input [31:0] w1, w2, w3, w4;
    output [31:0] out;
    wire [31:0] reg_mul1_inp, reg_mul2_inp, reg_mul3_inp, reg_mul4_inp; 
    wire [31:0] reg_mul1_out, reg_mul2_out, reg_mul3_out, reg_mul4_out; 
    wire [31:0] addr1_res, addr2_res, addr3_res;
    wire [31:0] reg_addr_out;

    // first cycle
    multiplier multiplier1(.x(a1), .y(w1), .z(reg_mul1_inp));
    multiplier multiplier2(.x(a2), .y(w2), .z(reg_mul2_inp));
    multiplier multiplier3(.x(a3), .y(w3), .z(reg_mul3_inp));
    multiplier multiplier4(.x(a4), .y(w4), .z(reg_mul4_inp));
    
    register reg_mul1(clk, rst, 1'b0, reg_mul1_inp, reg_mul1_out);
    register reg_mul2(clk, rst, 1'b0, reg_mul2_inp, reg_mul2_out);
    register reg_mul3(clk, rst, 1'b0, reg_mul3_inp, reg_mul3_out);
    register reg_mul4(clk, rst, 1'b0, reg_mul4_inp, reg_mul4_out);

    // second cycle
    adder #(32) addr1(.a(reg_mul1_out), .b(reg_mul2_out), .sum(addr1_res));
    adder #(32) addr2(.a(reg_mul3_out), .b(reg_mul4_out), .sum(addr2_res));
    adder #(32) addr3(.a(addr1_res), .b(addr2_res), .sum(addr3_res));

    register reg_addr(clk, 1'b0, addr3_res, reg_addr_out);

    // third cycle
    activation act(reg_addr_out, out);

endmodule