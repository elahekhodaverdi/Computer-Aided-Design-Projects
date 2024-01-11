module conv(clk, start, x, y, z, done);
    input clk, start, done;
    input [7:0] x, y, z;
    wire done_mem_l1, done_pe_l1, done_mem_l2_1, done_mem_l2_2, done_mem_l2_3, done_mem_l2_4,
         start_mem_l1, start_pe_l1, start_mem_l2, start_pe_l2;
    conv_cu cu(clk, start, done_mem_l1, done_pe_l1, start_mem_l1, start_pe_l1, done);
    conv_dp dp(clk, start_mem_l1, start_pe_l1, x, y, z, start_mem_l2, start_pe_l2,
                done_mem_l1, done_pe_l1, done_mem_l2_1, done_mem_l2_2, done_mem_l2_3, done_mem_l2_4);


endmodule