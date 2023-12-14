`timescale 1ps/1ps

module PU (clk, rst, a1, a2, a3, a4, w1, w2, w3, w4, out);
    input clk, rst;
    input [4:0] a1, a2, a3, a4;
    input [4:0] w1, w2, w3, w4;
    output [4:0] out;
    wire [9:0] reg_mul1_inp, reg_mul2_inp, reg_mul3_inp, reg_mul4_inp; 
    wire [9:0] reg_mul1_out, reg_mul2_out, reg_mul3_out, reg_mul4_out; 
    wire [10:0] addr1_res, addr2_res;
    wire [11:0] reg_addr_out, addr3_res;
    wire [11:0] activation_result;

    // first cycle
    multiplier multiplier1(.x(a1), .y(w1), .out(reg_mul1_inp));
    multiplier multiplier2(.x(a2), .y(w2), .out(reg_mul2_inp));
    multiplier multiplier3(.x(a3), .y(w3), .out(reg_mul3_inp));
    multiplier multiplier4(.x(a4), .y(w4), .out(reg_mul4_inp));
    
    register #(10) reg_mul1(clk, rst, 1'b1, reg_mul1_inp, reg_mul1_out);
    register #(10) reg_mul2(clk, rst, 1'b1, reg_mul2_inp, reg_mul2_out);
    register #(10) reg_mul3(clk, rst, 1'b1, reg_mul3_inp, reg_mul3_out);
    register #(10) reg_mul4(clk, rst, 1'b1, reg_mul4_inp, reg_mul4_out);

    // second cycle
    adder #(10) addr1(.a(reg_mul1_out), .b(reg_mul2_out), .sum(addr1_res));
    adder #(10) addr2(.a(reg_mul3_out), .b(reg_mul4_out), .sum(addr2_res));
    adder #(11) addr3(.a(addr1_res), .b(addr2_res), .sum(addr3_res));

    register #(12) reg_addr(clk, rst, 1'b1, addr3_res, reg_addr_out);

    // third cycle
    activation act(reg_addr_out, activation_result);
    assign out = {activation_result[11], activation_result[6], activation_result[5],
                     activation_result[4], activation_result[3]};

endmodule