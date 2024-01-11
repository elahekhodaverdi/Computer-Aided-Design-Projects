module conv_dp(clk, start_mem_l1, start_pe_l1, x, y, z, done_mem_l1, done_pe_l1);
    input clk, start_mem_l1, start_pe_l1;
    input [7:0] x, y, z;
    output done_mem_l1, done_pe_l1;
    wire [7:0] img_data_l1 [0:255];
    wire [7:0] filters_l1 [0:3][0:15];
    wire [3:0] dones_pe_l1;
    mem_reader memr(clk, start_mem_l1, x, y, z, done_mem_l1, img_data_l1, filters_l1);
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_pe
            pe pe(clk, start_pe_l1, z, {img_data_l1}, filters_l1[i:i], i, 1, dones_pe_l1[i]);
        end
    endgenerate
    assign done_pe_l1 = dones_pe_l1[0] & dones_pe_l1[1] & dones_pe_l1[2] & dones_pe_l1[3];

endmodule