module pe(clk, start, z, imgs, filters, pe_num, layer_num, done);
    parameter NUM_IMAGES = 1;
    parameter IMG_SIZE = 16;
    input clk, start;
    input [7:0] z;
    input [7:0] imgs[0 : NUM_IMAGES - 1][0:IMG_SIZE * IMG_SIZE - 1];
    input [7:0] filters[0:NUM_IMAGES - 1][0:15];
    input [31:0] pe_num, layer_num;
    output done;
    wire rst, rst_acc, acc_en, res_buffer_en, rst_res_reg, wr_en, wr_file;
    wire[7:0] img_buffer_index, buffer_cntr, res_index, wr_adr;

    pe_dp dp(clk, rst, rst_acc, acc_en, res_buffer_en, rst_res_reg, wr_en, wr_file,
                z, img_buffer_index, buffer_cntr, res_index, wr_adr, imgs, filters, pe_num, layer_num);
    
    pe_cu cu(clk, start, rst, rst_acc, acc_en,
             res_buffer_en, rst_res_reg, wr_en, wr_file, done,
             img_buffer_index, buffer_cntr, res_index, wr_adr);

endmodule