module conv_dp(clk, start_mem_l1, start_pe_l1, start_mem_l2, start_pe_l2, wrmem_en_l2, x, y, z,
                done_mem_l1, done_pe_l1, done_mem_l2, done_pe_l2);
    input clk, start_mem_l1, start_pe_l1, start_mem_l2, start_pe_l2, wrmem_en_l2;
    input [7:0] x, y, z;
    output done_mem_l1, done_pe_l1, done_mem_l2, done_pe_l2;
    wire [7:0] img_data_l1 [0:255];
    wire [7:0] filters_l1 [0:3][0:15];
    wire [3:0] dones_pe_l1;
    wire [3:0] dones_pe_l2;
    wire [3:0] dones_mem_l2;
    wire [31:0] pe_outs_l1 [0:3][0:127];
    wire [31:0] pe_outs_l2 [0:3][0:127];

    wire[7:0] img_data_l2_1 [0:168];
    wire[7:0] img_data_l2_2 [0:168];
    wire[7:0] img_data_l2_3 [0:168];
    wire[7:0] img_data_l2_4 [0:168];
    wire [7:0] filters_l2_1 [0:3][0:15];
    wire [7:0] filters_l2_2 [0:3][0:15];
    wire [7:0] filters_l2_3 [0:3][0:15];
    wire [7:0] filters_l2_4 [0:3][0:15];

    mem_reader #(16, 64, "datatest/input.txt") meml1(clk, start_mem_l1, 1'b0, pe_outs_l1[0], x, y, z, done_mem_l1, img_data_l1, filters_l1);
    
    mem_reader #(13, 43, "datatest/filter1_L2.txt") meml2_1(clk, start_mem_l2, wrmem_en_l2, pe_outs_l1[0], z, y, z, dones_mem_l2[0], img_data_l2_1, filters_l2_1);
    mem_reader #(13, 43, "datatest/filter2_L2.txt") meml2_2(clk, start_mem_l2, wrmem_en_l2, pe_outs_l1[1], z, y, z, dones_mem_l2[1], img_data_l2_2, filters_l2_2);
    mem_reader #(13, 43, "datatest/filter3_L2.txt") meml2_3(clk, start_mem_l2, wrmem_en_l2, pe_outs_l1[2], z, y, z, dones_mem_l2[2], img_data_l2_3, filters_l2_3);
    mem_reader #(13, 43, "datatest/filter4_L2.txt") meml2_4(clk, start_mem_l2, wrmem_en_l2, pe_outs_l1[3], z, y, z, dones_mem_l2[3], img_data_l2_4, filters_l2_4);

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_pe
            pe #(1, 16, 128) pe_l1(clk, start_pe_l1, {img_data_l1}, filters_l1[i:i], i + 1, 1, dones_pe_l1[i], pe_outs_l1[i]);
            pe #(4, 13, 128) pe_l2_1(clk, start_pe_l2, {img_data_l2_1, img_data_l2_2, img_data_l2_3, img_data_l2_4}, filters_l2_1, i + 1, 2, dones_pe_l2[i], pe_outs_l2[i]);

        end
    endgenerate
    
    assign done_pe_l1 = &dones_pe_l1;    
    assign done_pe_l2 = &dones_pe_l2;
    assign done_mem_l2 = &dones_mem_l2;
    
endmodule