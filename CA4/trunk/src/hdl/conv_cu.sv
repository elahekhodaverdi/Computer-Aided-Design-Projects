`define IDLE 4'b0000
`define INIT 4'b0001
`define READ_MEM_L1 4'b0010
`define PE_L1 4'b0011
`define LD_RES_L1 4'b0101
`define READ_MEM_L2 4'b0110
`define PE_L2 4'b0111
`define DONE 4'b0100

module conv_cu(clk, start, done_mem_l1, done_pe_l1, done_mem_l2, done_pe_l2,
        wrmem_en_l2, start_mem_l1, start_pe_l1, start_mem_l2, start_pe_l2, done);
    
    input clk, start;
    input done_mem_l1, done_pe_l1, done_mem_l2, done_pe_l2;
    output reg wrmem_en_l2, start_mem_l1, start_pe_l1, start_mem_l2, start_pe_l2;
    output reg done ;

    initial begin
        wrmem_en_l2 = 0;
        start_mem_l1 = 0;
        start_pe_l1 = 0;
        start_mem_l2 = 0;
        start_pe_l2 = 0;
        done = 0;
    end

    reg[3:0] ns =`IDLE;
    reg[3:0] ps =`IDLE;

    always @(ps, start, done_mem_l1, done_pe_l1, done_mem_l2, done_pe_l2) begin 
        case(ps)
            `IDLE:   ns <= ~start ? `IDLE : `INIT;
            `INIT:   ns <= start ? `INIT : `READ_MEM_L1;
            `READ_MEM_L1: ns <= done_mem_l1 ? `PE_L1 : `READ_MEM_L1;
            `PE_L1: ns <= done_pe_l1 ? `LD_RES_L1 : `PE_L1;
            `LD_RES_L1: ns <= `READ_MEM_L2;
            `READ_MEM_L2: ns <= done_mem_l2 ? `PE_L2 : `READ_MEM_L2; 
            `PE_L2: ns <= done_pe_l2 ? `DONE : `PE_L2;
            `DONE: ns <= `IDLE; 
        endcase
    end

    always @(*) begin
        {wrmem_en_l2, start_mem_l1, start_pe_l1, start_mem_l2, start_pe_l2, done} = 0;
        case(ps)
            `INIT:begin  end
            `READ_MEM_L1 : begin start_mem_l1 = 1; end
            `PE_L1 : begin start_pe_l1 = 1; end
            `LD_RES_L1 : begin wrmem_en_l2 = 1; end
            `READ_MEM_L2 : begin start_mem_l2 = 1; end
            `PE_L2 : begin start_pe_l2 = 1; end
            `DONE: begin done = 1; end
        endcase
    end

    always @(posedge clk) begin
         ps <= ns;
    end



endmodule