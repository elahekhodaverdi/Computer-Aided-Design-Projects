`define IDLE   4'b0000
`define INIT   4'b0001
`define LD_FILTER   4'b0010
`define NEXT_FILTER 4'b1011
`define LD_IMG    4'b0011
`define DONE    4'b0111

module memory_reader_cu(clk, start, rst, adr_sel, filter_wr_en, img_wr_en,
                         countr_filters, countr4_filter, countr_img, mem_offset_sel, done);

    parameter IMG_SIZE = 16;
    input clk, start;

    output reg rst, adr_sel, filter_wr_en, img_wr_en;
    output reg [7:0] countr_filters, countr4_filter, countr_img;
    output reg [1:0] mem_offset_sel;
    output reg done = 0;

    reg [7:0] cntr_img = 8'b0;
    reg [7:0] cntr4_filter = 8'b0;
    reg [7:0] cntr_filters = 8'b0;

    reg[3:0] ns =`IDLE;
    reg[3:0] ps =`IDLE;

    always @(start, cntr_img, cntr4_filter, ps, cntr_filters) begin 
        case(ps)
            `IDLE:   ns <= ~start ? `IDLE : `INIT;
            `INIT:   ns <= `LD_FILTER;
            `LD_FILTER:   ns <= ~(cntr4_filter == 8'd3) ? `LD_FILTER : `NEXT_FILTER;
            `NEXT_FILTER:   ns <= ~(cntr_filters == 8'd3) ? `LD_FILTER : `LD_IMG;
            `LD_IMG:   ns <= ~(cntr_img * 4 >= IMG_SIZE * IMG_SIZE) ? `LD_IMG : `DONE;
            `DONE: ns <= `IDLE;
        endcase
    end

    always @(*) begin
        {rst, adr_sel, filter_wr_en, mem_offset_sel, img_wr_en, done} = 0;
        case(ps)
            `INIT:begin  rst = 1; end
            `LD_FILTER: begin  adr_sel = 1; filter_wr_en = 1; mem_offset_sel = 0; end
            `NEXT_FILTER: begin  cntr4_filter = 8'b0; end
            `LD_IMG : begin   img_wr_en = 1; mem_offset_sel = 1;  end
            `DONE: begin done = 1; end
        endcase
    end

    always @(posedge clk) begin
        case(ps)
            `INIT:begin end
            `LD_FILTER: begin cntr4_filter = cntr4_filter+ 1; end
            `NEXT_FILTER: begin cntr_filters = cntr_filters + 1; end
            `LD_IMG : begin  cntr_img = cntr_img + 1; cntr_filters = 8'b0; end
            
        endcase
    end

    always @(posedge clk) begin
         ps <= ns;
     end

    assign countr_img = cntr_img;
    assign countr_filters = cntr_filters;
    assign countr4_filter = cntr4_filter;

endmodule