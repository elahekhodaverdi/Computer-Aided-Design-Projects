module datapath(clk, rst, x, y, z, rst_acc, rst_res_reg, mem_en,
        filter_wr_en, img_wr_en,  img_slice_en, acc_en, res_buffer_en,
        inc_en, inc_ld, wr_file, adr_sel, mem_offset_sel, countr16_img,
        countr4_filter, countr_filters, countr43, countr16_img,
        row_countr, col_countr, countr16, countr_reg4);

    parameter NUM_FILTERS = 4;
    input clk, rst, mem_en, adr_sel, filter_wr_en, wr_file;
    input img_wr_en, img_slice_en, acc_en, res_buffer_en;
    input inc_en, inc_ld, rst_acc, rst_res_reg;
    input [1:0] mem_offset_sel;
    input [7:0] x,y,z;
    input[7:0] countr16_img, countr4_filter, countr_filters, countr43, row_countr, col_countr, countr16, countr_reg4;

    wire[NUM_FILTERS - 1: 0] filters_wr_en;
    wire [7:0] mem_wr_adr, mem_rd_adr, mem_offset_out, mem_cntr_res;
    wire [7:0] img_rd_adr, img_slice_rd_data;
    wire [7:0] mult_res, x_offset;
    wire [31:0] mem_wr_data, mem_rd_data, img_rd_data;
    wire [7:0] filters_rd_data[0:NUM_FILTERS-1], filter_adr, mem_filter_adr;

    memory mem(clk, mem_rd_adr, mem_rd_data);
    assign mem_offset_out = (mem_offset_sel == 0) ? y :
                            (mem_offset_sel == 1) ? x_offset :
                            (mem_offset_sel == 2) ? z : 0;

    decoder #(NUM_FILTERS) dcdr(countr_filters, filters_wr_en);


    mux2_1 mux(mem_filter_adr, countr16_img, adr_sel, mem_cntr_res);
    adder addr1(mem_offset_out, mem_cntr_res, mem_rd_adr);
    adder addr5(countr4_filter, countr_filters << 2, mem_filter_adr);

    genvar i;
    generate
        for (i = 0; i < NUM_FILTERS; i = i + 1) begin : gen_filters
            buffer_4 filter_buffer(clk, filters_wr_en[i] & filter_wr_en, countr4_filter << 2, mem_rd_data, countr16, filters_rd_data[i]);
            PE pe(clk, rst, rst_acc, rst_res_reg, res_buffer_en, acc_en, mem_en, wr_file,
                  img_slice_rd_data, filters_rd_data[i], countr_reg4, mem_wr_adr, i + 1);
        end
    endgenerate
    buffer_8 img_buffer(clk, img_wr_en, countr16_img << 2, mem_rd_data, img_rd_adr, img_rd_data);
    adder addr2(countr43, mem_offset_out, mem_wr_adr);
    adder addr3(row_countr << 4, col_countr, img_rd_adr);
    buffer_4 img_slice(clk, img_slice_en, row_countr << 2, img_rd_data, countr16, img_slice_rd_data);

    incrementerby4 inc(clk, inc_en, rst, inc_ld, x, x_offset);



endmodule