module conv(clk, start, x, y, z, done);
    input clk, start, done;
    input [7:0] x, y, z;
    wire done_mem_l1, done_pe_l1, start_mem_l1, start_pe_l1;
    conv_cu cu(clk, start, done_mem_l1, done_pe_l1, start_mem_l1, start_pe_l1, done);
    conv_dp dp(clk, start_mem_l1, start_pe_l1, x, y, z, done_mem_l1, done_pe_l1);


endmodule