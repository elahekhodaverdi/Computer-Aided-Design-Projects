`timescale 1ps/1ps

`define IDLE   4'b0000
`define INIT   4'b0001
`define LD_FILTER   4'b0010
`define LD_SLICE    4'b0011
`define LD_BUFFER 4'b0100
`define MAC  4'b0101
`define LD_RESULT    4'b0110
`define WRITE_MEM 4'b0111
`define INC_OFFSET 4'b1000
`define DONE 4'b1001
`define UPDATE 4'b1010

module controller(clk, start, co_cntr16_img, co_cntr4_filter, co_cntr43, co_row_cntr, co_col_cntr,
                 co_cntr16, co_cntr_reg4, co_cntr13, cntr43_res,
                 rst, rst_acc, rst_res_reg, mem_en, cntr16_img_en, cntr4_filter_en, wr_file, adr_sel, mem_offset_sel, filter_wr_en,
                 img_wr_en, row_cntr_en, col_cntr_en, cntr43_en, cntr16_en, img_slice_en, acc_en, cntr_reg4_en, res_buffer_en,
                 cntr13_en, inc_en, inc_ld, done);

    input clk, start;
    output reg rst, mem_en, cntr16_img_en, cntr4_filter_en, adr_sel, filter_wr_en, wr_file;
    output reg img_wr_en, row_cntr_en, col_cntr_en, cntr43_en, cntr16_en, img_slice_en, acc_en, cntr_reg4_en, res_buffer_en;
    output reg cntr13_en, inc_en, inc_ld, done, rst_acc, rst_res_reg;
    output reg[1:0] mem_offset_sel;
    input co_cntr16_img, co_cntr4_filter, co_cntr43, co_row_cntr, co_col_cntr, co_cntr16, co_cntr_reg4, co_cntr13;
    input [7:0] cntr43_res;

    reg[3:0] ns =`IDLE;
    reg[3:0] ps =`IDLE;

    always @(start, co_cntr16_img, co_cntr4_filter, co_row_cntr,
             co_cntr16, cntr43_res, co_cntr_reg4, co_cntr43, co_cntr13, ps) begin 
        case(ps)
            `IDLE:   ns <= ~start ? `IDLE : `INIT;
            `INIT:   ns <= start ? `INIT : `LD_FILTER;
            `LD_FILTER:   ns <= ~co_cntr4_filter ? `LD_FILTER : `LD_SLICE;
            `LD_SLICE:   ns <= ~co_cntr16_img ? `LD_SLICE : `LD_BUFFER;
            `LD_BUFFER:   ns <= ~co_row_cntr ? `LD_BUFFER : `MAC;
            `MAC:   ns <= ~co_cntr16 ? `MAC : `LD_RESULT;
            `LD_RESULT :  ns <= (cntr43_res == 42 || co_cntr_reg4) ? `WRITE_MEM : `UPDATE;
            `WRITE_MEM : ns <= co_cntr43 ? `DONE : `UPDATE;
            `UPDATE : ns <= ~co_cntr13 ? `LD_BUFFER : `INC_OFFSET;
            `INC_OFFSET : ns <= `LD_SLICE; 
            `DONE: ns <= `IDLE;
        endcase
    end

    always @(ps) begin
        {rst, mem_en, cntr16_img_en, cntr4_filter_en, adr_sel, filter_wr_en,
        img_wr_en, row_cntr_en, col_cntr_en, cntr43_en, cntr16_en, img_slice_en, acc_en,
        cntr_reg4_en, res_buffer_en, cntr13_en, inc_en, inc_ld, done, mem_offset_sel, wr_file, rst_acc, rst_res_reg} = 0;
        case(ps)
            `INIT:begin  rst = 1; inc_ld = 1;   end
            `LD_FILTER: begin cntr4_filter_en = 1; adr_sel = 1; filter_wr_en = 1; mem_offset_sel = 0; end
            `LD_SLICE : begin  cntr16_img_en = 1; img_wr_en = 1; mem_offset_sel = 1;  end
            `LD_BUFFER: begin row_cntr_en = 1; img_slice_en = 1; end
            `MAC: begin acc_en = 1; cntr16_en = 1; end
            `LD_RESULT: begin cntr_reg4_en = 1; res_buffer_en = 1; rst_acc = 1;end
            `WRITE_MEM: begin mem_en = 1; cntr43_en = 1; mem_offset_sel = 2; rst_res_reg = 1; end
            `UPDATE: begin col_cntr_en = 1; cntr13_en = 1; end
            `INC_OFFSET: begin inc_en = 1; end
            `DONE: begin done = 1; wr_file = 1; end
        endcase
    end

    always @(posedge clk) begin
         ps <= ns;
     end



endmodule