module memory_reader_dp (clk, rst, adr_sel, filter_wr_en, img_wr_en, mem_offset_sel,
                x, y, z, countr_filters, countr4_filter, countr_img, img_data, filters);
    
    parameter IMG_SIZE = 16;
    parameter FILE_INPUT = "input.txt";
    input clk, rst, adr_sel, filter_wr_en, img_wr_en;
    input [7:0] x, y, z, countr_filters, countr4_filter, countr_img;
    input [1:0] mem_offset_sel;

    output [7:0] img_data [0:IMG_SIZE * IMG_SIZE - 1];
    output [7:0] filters [0:3][0:15];


    wire [7 : 0] mem_offset_out, mem_filter_adr, mem_rd_adr, mem_cntr_res;
    wire [3 : 0] filters_wr_en;
    wire [31 : 0] mem_rd_data;

    memory #(128, FILE_INPUT) mem(clk, mem_rd_adr, mem_rd_data);
    assign mem_offset_out = (mem_offset_sel == 0) ? y :
                            (mem_offset_sel == 1) ? x :
                            (mem_offset_sel == 2) ? z : 0;

    decoder #(4) dcdr(countr_filters, filters_wr_en);

    assign mem_filter_adr = (countr_filters << 2) + countr4_filter;
    mux2_1 mux(mem_filter_adr, countr_img, adr_sel, mem_cntr_res);
    assign mem_rd_adr = mem_offset_out + mem_cntr_res;

    buffer #(IMG_SIZE * IMG_SIZE) img(clk, img_wr_en, countr_img << 2, mem_rd_data, img_data);
    
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_filters
            buffer #(16) filter_buffer(clk, filters_wr_en[i] & filter_wr_en, countr4_filter << 2, mem_rd_data, filters[i]);
        end
    endgenerate


endmodule