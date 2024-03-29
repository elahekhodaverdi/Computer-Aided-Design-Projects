module datapath(clk, rst, x, y, z, rst_acc, rst_res_reg, mem_en, cntr16_img_en, cntr4_filter_en, filter_wr_en, img_wr_en, cntr43_en, row_cntr_en,
          col_cntr_en, cntr16_en, img_slice_en, acc_en, cntr_reg4_en, res_buffer_en, cntr13_en,
          inc_en, inc_ld, wr_file, adr_sel, mem_offset_sel, co_cntr16_img,
          co_cntr4_filter, co_cntr43, co_row_cntr, co_col_cntr, co_cntr16, co_cntr_reg4, co_cntr13, cntr43_res);


    input clk, rst, mem_en, cntr16_img_en, cntr4_filter_en, adr_sel, filter_wr_en, wr_file;
    input img_wr_en, row_cntr_en, col_cntr_en, cntr43_en, cntr16_en, img_slice_en, acc_en, cntr_reg4_en, res_buffer_en;
    input cntr13_en, inc_en, inc_ld, rst_acc, rst_res_reg;
    input [1:0] mem_offset_sel;
    input [7:0] x,y,z;
    output co_cntr16_img, co_cntr4_filter, co_cntr43, co_row_cntr, co_col_cntr, co_cntr16, co_cntr_reg4, co_cntr13;
    output [7:0] cntr43_res;

    wire [7:0] mem_wr_adr, mem_rd_adr, mem_offset_out, cntr4_filter_res, cntr16_img_res, mem_cntr_res;
    wire [7:0] filter_rd_data, img_rd_adr, row_cntr_res, col_cntr_res, cntr16_res, img_slice_rd_data;
    wire [7:0] mult_res, cntr_reg4_res, cntr13_res, x_offset;
    wire [11:0] acc_out, acc_in;
    wire [31:0] mem_wr_data, mem_rd_data, img_rd_data;

    memory mem(clk, mem_en, mem_wr_adr, mem_wr_data, mem_rd_adr, mem_rd_data, wr_file);
    assign mem_offset_out = (mem_offset_sel == 0) ? y :
                            (mem_offset_sel == 1) ? x_offset :
                            (mem_offset_sel == 2) ? z : 0;
    counter #(4) cntr4_filter (clk, rst, cntr4_filter_en, co_cntr4_filter, cntr4_filter_res);
    counter #(16) cntr16_img (clk, rst, cntr16_img_en, co_cntr16_img, cntr16_img_res);

    mux2_1 mux(cntr4_filter_res, cntr16_img_res, adr_sel, mem_cntr_res);
    adder addr1(mem_offset_out, mem_cntr_res, mem_rd_adr);

    buffer_4 filter_buffer(clk, filter_wr_en, cntr4_filter_res << 2, mem_rd_data, cntr16_res, filter_rd_data);
    buffer_8 img_buffer(clk, img_wr_en, cntr16_img_res << 2, mem_rd_data, img_rd_adr, img_rd_data);

    counter #(43) cntr43 (clk, rst, cntr43_en, co_cntr43, cntr43_res);
    adder addr2(cntr43_res, mem_offset_out, mem_wr_adr);

    counter #(4) row_cntr (clk, rst, row_cntr_en, co_row_cntr, row_cntr_res);
    counter #(13) col_cntr (clk, rst, col_cntr_en, co_col_cntr, col_cntr_res);
    adder addr3(row_cntr_res << 4, col_cntr_res, img_rd_adr);
    counter #(16) cntr16 (clk, rst, cntr16_en, co_cntr16, cntr16_res);

    buffer_4 img_slice(clk, img_slice_en, row_cntr_res << 2, img_rd_data, cntr16_res, img_slice_rd_data);

    multiplier mult(img_slice_rd_data, filter_rd_data, mult_res);
    adder12 addr4({4'b0000, mult_res}, acc_out, acc_in);
    register1word acc(clk, acc_en, rst | rst_acc, acc_in, acc_out);

    counter #(4) cntr_reg4 (clk, rst, cntr_reg4_en, co_cntr_reg4, cntr_reg4_res);
    register4word res_buffer(clk, res_buffer_en, rst | rst_res_reg, cntr_reg4_res, acc_out[11:4], mem_wr_data);

    counter #(13) cntr13 (clk, rst, cntr13_en, co_cntr13, cntr13_res);
    incrementerby4 inc(clk, inc_en, rst, inc_ld, x, x_offset);



endmodule