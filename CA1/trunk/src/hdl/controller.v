`timescale 1ps/1ps

`define IDLE   3'b000
`define INIT   3'b001
`define MULT   3'b010
`define ADD    3'b011
`define WB_ACT 3'b100
`define CHECK  3'b101
`define DONE   3'b110

module controller(start, rst, clk, is_finished, init_w, init_x, load_a, load_sel, done);
    input start,clk,rst,is_finished;
    output reg init_w, init_x, load_a, load_sel, done;
    reg[2:0] ns =`IDLE;
    reg[2:0] ps =`IDLE;

    always @(start, is_finished, ps) begin 
        case(ps)
            `IDLE:   ns <= ~start ? `IDLE : `INIT;
            `INIT:   ns <= start ? `INIT : `MULT;
            `MULT:   ns <= `ADD;
            `ADD:    ns <= `WB_ACT;
            `WB_ACT: ns <= `CHECK;
            `CHECK:  ns <= is_finished ? `DONE : `MULT;
            `DONE :  ns <= `IDLE; 
        endcase
    end

    always @(ps) begin
        {init_w, init_x, load_a, load_sel, done} = 5'b0;
        case(ps)
            `INIT:begin init_w =1'b1; init_x= 1'b1; load_a=1'b1; load_sel = 4'b1; end
            `WB_ACT: begin load_a = 1'b1; end
            `DONE : begin  done = 1'b1; end
        endcase
    end

    always @(posedge clk, posedge rst) begin
        if (rst)
            ps <= `IDLE;
        else
         ps <= ns;
     end



endmodule