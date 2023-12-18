`timescale 1ps/1ps

`define IDLE   3'b000
`define INIT   3'b001
`define MULT   3'b010
`define ADD    3'b011
`define WB_ACT 3'b100
`define CHECK  3'b101
`define DONE   3'b110

module controller(start, rst, clk, is_finished, load_a, load_sel, done);
    input start,clk,rst,is_finished;
    output reg load_a, load_sel, done;

    wire Q2, Q1, Q0;
    wire not_Q2, not_Q1, not_Q0, not_start, not_finish;
    NOT nq2(.a(Q2), .out(not_Q2));
    NOT nq1(.a(Q1), .out(not_Q1));
    NOT nq0(.a(Q0), .out(not_Q0));
    NOT nstrt(.a(start), .out(not_start));
    NOT nfnsh(.a(is_finished), .out(not_finish));
    
    wire Q21, Q22, Q23;
    wire Q11, Q12, Q13;
    wire Q01, Q02, Q03, Q04;

    AND4 Q2_1(.a(1'b1), .b(1'b1), .c(Q1), .d(Q0), .out(Q21));
    AND4 Q2_2(.a(Q2), .b(not_Q1), .c(not_Q0), .d(1'b1), .out(Q22));
    AND4 Q2_3(.a(Q2), .b(not_Q1), .c(is_finished), .d(1'b1), .out(Q23));

    AND4 Q1_1(.a(1'b1), .b(1'b1), .c(Q2), .d(Q0), .out(Q11));
    AND4 Q1_2(.a(not_Q1), .b(Q0), .c(not_start), .d(1'b1), .out(Q12));
    AND4 Q1_3(.a(not_Q2), .b(Q1), .c(not_Q0), .d(1'b1), .out(Q13));

    AND4 Q0_1(.a(1'b1), .b(not_Q2), .c(not_Q1), .d(start), .out(Q01));
    AND4 Q0_2(.a(not_Q2), .b(Q1), .c(not_Q0), .d(1'b1), .out(Q02));
    AND4 Q0_3(.a(Q2), .b(not_Q1), .c(not_Q0), .d(1'b1), .out(Q03));
    AND4 Q0_4(.a(Q2), .b(not_Q1), .c(not_finish), .d(1'b1), .out(Q04));

    wire or_Q2, or_Q1, or_Q0;
    OR4 OR_Q2(.a(Q21), .b(Q22), .c(Q23), .d(1'b0), .out(or_Q2));
    OR4 OR_Q1(.a(Q11), .b(Q12), .c(Q13), .d(1'b0), .out(or_Q1));
    OR4 OR_Q0(.a(Q01), .b(Q02), .c(Q03), .d(Q04), .out(or_Q0));

    DFF #(1) dff_Q2(.clk(clk), .rst(rst), .in(or_Q2), .out(Q2));
    DFF #(1) dff_Q1(.clk(clk), .rst(rst), .in(or_Q1), .out(Q1));
    DFF #(1) dff_Q0(.clk(clk), .rst(rst), .in(or_Q0), .out(Q0));
    
    wire or1_loada, or2_loada;
    wire load_aa, load_sell, donee;

    AND4 load_a1(.a(not_Q2), .b(not_Q1), .c(Q0), .d(1'b1), .out(or1_loada));
    AND4 load_a2(.a(Q2), .b(not_Q1), .c(not_Q0), .d(1'b1), .out(or2_loada));
    OR load_ao(.a(or1_loada), .b(or2_loada), .out(load_aa));
    AND4 load_selo(.a(not_Q2), .b(not_Q1), .c(Q0), .d(1'b1), .out(load_sell));
    AND4 done_o(.a(Q2), .b(Q1), .c(not_Q0), .d(1'b1), .out(donee));

    assign done = donee;
    assign load_a = load_aa;
    assign load_sel = load_sell;

endmodule