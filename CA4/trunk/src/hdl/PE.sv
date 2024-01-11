module pe(clk, start, imgs, filters, pe_num, layer_num, done, mem);
    parameter NUM_IMAGES = 1;
    parameter IMG_SIZE = 16;
    parameter MAX_MEM_SIZE = 128;
    input clk, start;
    input [7:0] imgs[0 : NUM_IMAGES - 1][0:IMG_SIZE * IMG_SIZE - 1];
    input [7:0] filters[0:NUM_IMAGES - 1][0:15];
    input [31:0] pe_num, layer_num;
    output done;
    output [31:0] mem [0:MAX_MEM_SIZE-1];
    wire rst, rst_acc, acc_en, res_buffer_en, rst_res_reg, wr_en, wr_file;
    wire[7:0] img_buffer_index, buffer_cntr, res_index, wr_adr;

    pe_dp #(NUM_IMAGES, IMG_SIZE, MAX_MEM_SIZE) dp(clk, rst, rst_acc, acc_en, res_buffer_en, rst_res_reg, wr_en, wr_file,
                img_buffer_index, buffer_cntr, res_index, wr_adr, imgs, filters, pe_num, layer_num, mem);
    
    pe_cu #(NUM_IMAGES, IMG_SIZE) cu(clk, start, rst, rst_acc, acc_en,
             res_buffer_en, rst_res_reg, wr_en, wr_file, done,
             img_buffer_index, buffer_cntr, res_index, wr_adr);

endmodule