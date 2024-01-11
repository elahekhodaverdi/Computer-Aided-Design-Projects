`define IDLE   4'b0000
`define INIT   4'b0001
`define MAC  4'b0101
`define LD_RESULT    4'b0110
`define WRITE_MEM 4'b0111
`define INC_OFFSET 4'b1000
`define DONE 4'b1001
`define UPDATE 4'b1010

module pe_cu(clk, start, rst, rst_acc, acc_en,
             res_buffer_en, rst_res_reg, wr_en, wr_file, done,
             img_buffer_index, buffer_cntr, res_index, wr_adr);
    parameter NUM_IMAGES = 1;
    parameter IMG_SIZE = 16;
    input clk, start;
    output reg rst, rst_acc, acc_en, res_buffer_en, rst_res_reg, wr_en, wr_file;
    output reg [7:0] img_buffer_index, buffer_cntr, res_index, wr_adr;
    output reg done = 0;


    reg [7:0] cntr_lines = 8'b0;
    reg [7:0] cntr16 = 8'b0;
    reg [7:0] cntr_reg4 = 8'b0;
    reg [7:0] cntr_img_index = 8'b0;
    reg[3:0] ns =`IDLE;
    reg[3:0] ps =`IDLE;

    always @(start, cntr16, cntr_lines, cntr_reg4, ps) begin 
        case(ps)
            `IDLE:   ns <= ~start ? `IDLE : `INIT;
            `INIT:   ns <= `MAC;
            `MAC:   ns <= ~(cntr16 == 8'd15) ? `MAC : `LD_RESULT;
            `LD_RESULT :  ns <= (cntr_lines == 8'd42 || cntr_reg4 == 8'd3) ? `WRITE_MEM : `MAC;
            `WRITE_MEM : ns <= ((cntr_lines == 8'd42 && IMG_SIZE == 16) ||
                                (cntr_lines == 8'd24 && IMG_SIZE == 13)) ? `DONE : `MAC;
            `DONE: ns <= `IDLE;
        endcase
    end

    always @(posedge clk) begin
        case(ps)
            `INIT:begin end
            `MAC: begin cntr16 = cntr16 + 1; end
            `LD_RESULT: begin
                     cntr_reg4 = cntr_reg4 + 1;
                     cntr_img_index = cntr_img_index + 1;
                     if (IMG_SIZE - cntr_img_index == 4'd3) begin
                         cntr_img_index = cntr_img_index + 3;
                     end
            end
            `WRITE_MEM: begin cntr_lines = cntr_lines + 1; cntr_reg4 = 8'd0; end
            `DONE: begin done = 1; end
        endcase
    end

    always @(ps) begin
        {rst, acc_en, res_buffer_en, done, wr_file, rst_acc, rst_res_reg, wr_en} = 0;
        case(ps)
            `INIT:begin  rst = 1; end
            `MAC: begin acc_en = 1; end
            `LD_RESULT: begin res_buffer_en = 1; rst_acc = 1; cntr16 = 0; end
            `WRITE_MEM: begin wr_en = 1; rst_res_reg = 1; cntr_reg4 = 0; end
            `DONE: begin done = 1; wr_file = 1; end
        endcase
    end

    always @(posedge clk) begin
         ps <= ns;
     end

    assign img_buffer_index = cntr_img_index;
    assign buffer_cntr = cntr16;
    assign res_index = cntr_reg4;
    assign wr_adr = cntr_lines;

endmodule