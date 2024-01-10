module convolution(clk, start, x, y, z, done);
    parameter NUM_FILTERS = 4;
    input clk, start;
    input [7:0] x, y, z;
    output done;

    wire rst, rst_acc, mem_en, cntr16_img_en, adr_sel, filter_wr_en, rst_res_reg;
    wire img_wr_en, img_slice_en, acc_en, res_buffer_en;
    wire inc_en, inc_ld, wr_file;
    wire [1:0] mem_offset_sel;
    wire [7:0] countr16_img, countr4_filter, countr43, countr_filters, row_countr, col_countr, countr_reg4, countr16;

    datapath #(NUM_FILTERS) dp(clk, rst, x, y, z, rst_acc, rst_res_reg, mem_en,
        filter_wr_en, img_wr_en,  img_slice_en, acc_en, res_buffer_en,
        inc_en, inc_ld, wr_file, adr_sel, mem_offset_sel, countr16_img,
        countr4_filter, countr_filters, countr43, countr16_img,
        row_countr, col_countr, countr16, countr_reg4);

    controller cu(clk, start,rst, rst_acc, rst_res_reg, mem_en, wr_file,
            adr_sel, mem_offset_sel, filter_wr_en, img_wr_en, img_slice_en,
            acc_en, res_buffer_en, inc_en, inc_ld, countr16_img, countr_filters,
            countr4_filter, row_countr, col_countr, countr43, countr16, countr_reg4, done);

endmodule