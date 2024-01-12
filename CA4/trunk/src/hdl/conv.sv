module conv(clk, start, x, y, z, done);
    input clk, start, done;
    input [7:0] x, y, z;
    wire done_mem_l1, done_mem_l2, done_pe_l1, done_pe_l2, start_mem_l1, start_pe_l1, start_mem_l2, start_pe_l2 , wrmem_en_l2;
     
    conv_cu cu(clk, start, done_mem_l1, done_pe_l1, done_mem_l2, done_pe_l2,
          wrmem_en_l2, start_mem_l1, start_pe_l1, start_mem_l2, start_pe_l2, done);

    conv_dp dp(cclk, start_mem_l1, start_pe_l1, start_mem_l2, start_pe_l2, wrmem_en_l2,
          x, y, z, done_mem_l1, done_pe_l1, done_mem_l2, done_pe_l2);


endmodule