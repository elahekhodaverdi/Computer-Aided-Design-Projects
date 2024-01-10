`timescale 1ps/1ps

`define IDLE   4'b0000
`define INIT   4'b0001
`define LD_FILTER   4'b0010
`define NEXT_FILTER 4'b1011
`define LD_SLICE    4'b0011
`define LD_BUFFER 4'b0100
`define MAC  4'b0101
`define LD_RESULT    4'b0110
`define WRITE_MEM 4'b0111
`define INC_OFFSET 4'b1000
`define DONE 4'b1001
`define UPDATE 4'b1010

module controller(clk, start,rst, rst_acc, rst_res_reg, mem_en, wr_file,
            adr_sel, mem_offset_sel, filter_wr_en, img_wr_en, img_slice_en,
            acc_en, res_buffer_en, inc_en, inc_ld, countr16_img, countr_filters,
            countr4_filter, row_countr, col_countr, countr43, countr16, countr_reg4, done);

    input clk, start;
    output reg rst, mem_en, adr_sel, filter_wr_en, wr_file;
    output reg img_wr_en, col_cntr_en, img_slice_en, acc_en, res_buffer_en;
    output reg cntr13_en, inc_en, inc_ld, done, rst_acc, rst_res_reg;
    output reg[1:0] mem_offset_sel;
    output reg [7:0] countr16_img, countr4_filter, countr43, countr_filters, row_countr, col_countr, countr_reg4, countr16;
    
    reg [7:0] cntr16_img = 8'b0;
    reg [7:0] cntr4_filter = 8'b0;
    reg [7:0] cntr43 = 8'b0;
    reg [7:0] cntr_filters = 8'b0;
    reg [7:0] row_cntr = 8'b0;
    reg [7:0] col_cntr = 8'b0;
    reg [7:0] cntr16 = 8'b0;
    reg [7:0] cntr_reg4 = 8'b0;
    reg [7:0] cntr13 = 8'b0;
    reg[3:0] ns =`IDLE;
    reg[3:0] ps =`IDLE;

    always @(start, cntr16_img, cntr4_filter, row_cntr,
             cntr16, cntr43, cntr_reg4, co_cntr13, ps) begin 
        case(ps)
            `IDLE:   ns <= ~start ? `IDLE : `INIT;
            `INIT:   ns <= start ? `INIT : `LD_FILTER;
            `LD_FILTER:   ns <= ~(cntr4_filter == 8'd3) ? `LD_FILTER : `NEXT_FILTER;
            `NEXT_FILTER:   ns <= ~(cntr_filters == 8'd3) ? `LD_FILTER : `LD_SLICE;
            `LD_SLICE:   ns <= ~(cntr16_img == 8'd15) ? `LD_SLICE : `LD_BUFFER;
            `LD_BUFFER:   ns <= ~(row_cntr == 8'd3) ? `LD_BUFFER : `MAC;
            `MAC:   ns <= ~(cntr16 == 8'd15) ? `MAC : `LD_RESULT;
            `LD_RESULT :  ns <= (cntr43 == 8'd42|| cntr_reg4 == 8'd3) ? `WRITE_MEM : `UPDATE;
            `WRITE_MEM : ns <= (cntr43 == 8'd42) ? `DONE : `UPDATE;
            `UPDATE : ns <= ~(cntr13 == 8'd12) ? `LD_BUFFER : `INC_OFFSET;
            `INC_OFFSET : ns <= `LD_SLICE; 
            `DONE: ns <= `IDLE;
        endcase
    end

    always @(ps) begin
        {rst, mem_en, adr_sel, filter_wr_en,
        img_wr_en, img_slice_en, acc_en,
        res_buffer_en, cntr13_en, inc_en, inc_ld, done, mem_offset_sel, wr_file, rst_acc, rst_res_reg} = 0;
        case(ps)
            `INIT:begin  rst = 1; inc_ld = 1;   end
            `LD_FILTER: begin  adr_sel = 1; filter_wr_en = 1; mem_offset_sel = 0; end
            `LD_SLICE : begin   img_wr_en = 1; mem_offset_sel = 1;  end
            `NEXT_FILTER: begin  cntr4_filter = 8'b0; end
            `LD_BUFFER: begin  img_slice_en = 1; end
            `MAC: begin acc_en = 1; end
            `LD_RESULT: begin res_buffer_en = 1; rst_acc = 1;end
            `WRITE_MEM: begin mem_en = 1;  mem_offset_sel = 2; rst_res_reg = 1; end
            `UPDATE: begin end
            `INC_OFFSET: begin inc_en = 1; col_cntr = 8'b0; end
            `DONE: begin done = 1; wr_file = 1; end
        endcase
    end

    always @(posedge clk) begin
        case(ps)
            `INIT:begin end
            `LD_FILTER: begin cntr4_filter = cntr4_filter+ 1; end
            `LD_SLICE : begin  cntr16_img = cntr16_img + 1; cntr_filters = 8'b0; end
            `NEXT_FILTER: begin cntr_filters = cntr_filters + 1; end
            `LD_BUFFER: begin row_cntr = row_cntr + 1; cntr16_img = 8'b0; end
            `MAC: begin cntr16 = cntr16 + 1; row_cntr = 8'b0; end
            `LD_RESULT: begin cntr_reg4 = cntr_reg4 + 1; cntr16 = 8'b0; end
            `WRITE_MEM: begin cntr43 = cntr43 + 1; cntr_reg4 = 8'd0; end
            `UPDATE: begin col_cntr = col_cntr + 1; cntr13 = cntr13 + 1; end
            `INC_OFFSET: begin cntr13 = 8'b0; end
            `DONE: begin cntr43 = 8'd0; end
        endcase
    end

    always @(posedge clk) begin
         ps <= ns;
     end

    assign countr16_img = cntr16_img;
    assign countr_filters = cntr_filters;
    assign countr43 = cntr43;
    assign row_countr = row_cntr;
    assign col_countr = col_cntr;
    assign countr16 = cntr16;
    assign countr_reg4 = cntr_reg4;
endmodule