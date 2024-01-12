module mem_reader(clk, start, write_inp_en, img_inp, x, y, z, done, img_data, filters);

    parameter IMG_SIZE = 16;
    parameter IMG_LINE_SIZE = 64;
    parameter FILE_INPUT = "input.txt";
    input clk, start, write_inp_en;
    input [7:0] x, y, z;
    input [31:0] img_inp [0:127];
    output [7:0] img_data [0:IMG_SIZE * IMG_SIZE - 1];
    output [7:0] filters [0:3][0:15];
    output done;

    wire rst, adr_sel, filter_wr_en, img_wr_en, write_mem_en;
    wire [7:0] countr_filters, countr4_filter, countr_img;
    wire [1:0] mem_offset_sel;


    memory_reader_dp #(IMG_SIZE, IMG_LINE_SIZE, FILE_INPUT) dp(clk, rst, adr_sel, filter_wr_en, img_wr_en, mem_offset_sel, img_inp, write_mem_en,
                x, y, z, countr_filters, countr4_filter, countr_img, img_data, filters);

    memory_reader_cu #(IMG_SIZE) cu(clk, start, write_inp_en, rst, adr_sel, filter_wr_en, img_wr_en,
                         countr_filters, countr4_filter, countr_img, mem_offset_sel, write_mem_en, done);


endmodule