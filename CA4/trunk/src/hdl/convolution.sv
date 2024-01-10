module convolution(clk, start, x, y, z, done);
    parameter NUM_FILTERS = 4;
    input clk, start;
    input [7:0] x, y, z;
    output done;

    wire rst, rst_acc, mem_en, cntr16_img_en, cntr_filters_en, cntr4_filter_en, adr_sel, filter_wr_en, rst_res_reg;
    wire img_wr_en, row_cntr_en, col_cntr_en, cntr43_en, cntr16_en, img_slice_en, acc_en, cntr_reg4_en, res_buffer_en;
    wire cntr13_en, inc_en, inc_ld, wr_file;
    wire [1:0] mem_offset_sel;
    wire co_cntr16_img, co_cntr4_filter, co_cntr_filters, co_cntr43, co_row_cntr, co_col_cntr, co_cntr16, co_cntr_reg4, co_cntr13;
    wire [7:0] cntr43_res;

    datapath #(NUM_FILTERS) dp(clk, rst, x, y, z, rst_acc, rst_res_reg, mem_en, cntr16_img_en, cntr_filters_en, cntr4_filter_en, filter_wr_en, img_wr_en, cntr43_en, row_cntr_en,
          col_cntr_en, cntr16_en, img_slice_en, acc_en, cntr_reg4_en, res_buffer_en, cntr13_en,
          inc_en, inc_ld, wr_file, adr_sel, mem_offset_sel, co_cntr16_img,
          co_cntr4_filter, co_cntr_filters, co_cntr43, co_row_cntr, co_col_cntr, co_cntr16, co_cntr_reg4, co_cntr13, cntr43_res);

    controller cu(clk, start, co_cntr16_img, co_cntr4_filter, co_cntr_filters, co_cntr43, co_row_cntr, co_col_cntr,
                 co_cntr16, co_cntr_reg4, co_cntr13, cntr43_res,
                 rst, rst_acc, rst_res_reg, mem_en, cntr16_img_en, cntr_filters_en, cntr4_filter_en, wr_file, adr_sel, mem_offset_sel, filter_wr_en,
                 img_wr_en, row_cntr_en, col_cntr_en, cntr43_en, cntr16_en, img_slice_en, acc_en, cntr_reg4_en, res_buffer_en,
                 cntr13_en, inc_en, inc_ld, done);

endmodule