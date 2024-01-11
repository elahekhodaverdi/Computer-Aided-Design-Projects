`define IDLE 4'b0000
`define INIT 4'b0001
`define READ_MEM 4'b0010
`define PE_L1 4'b0011
`define DONE 4'b0100

module conv_cu(clk, start, done_mem_l1, done_pe_l1, start_mem_l1, start_pe_l1, done);
    input clk, start;
    input done_mem_l1, done_pe_l1;
    output reg start_mem_l1, start_pe_l1;
    output reg done = 0;

    reg[3:0] ns =`IDLE;
    reg[3:0] ps =`IDLE;

    always @(ps, start, done_mem_l1, done_pe_l1) begin 
        case(ps)
            `IDLE:   ns <= ~start ? `IDLE : `INIT;
            `INIT:   ns <= start ? `INIT : `READ_MEM;
            `READ_MEM: ns <= done_mem_l1 ? `PE_L1 : `READ_MEM;
            `PE_L1: ns <= done_pe_l1 ? `DONE : `PE_L1;
            `DONE: ns <= `IDLE; 
        endcase
    end

    always @(*) begin
        {start_mem_l1, start_pe_l1, done} = 0;
        case(ps)
            `INIT:begin  end
            `READ_MEM : begin start_mem_l1 = 1; end
            `PE_L1 : begin start_pe_l1 = 1; end
            `DONE: begin done = 1; end
        endcase
    end

    always @(posedge clk) begin
         ps <= ns;
    end



endmodule