`timescale 1ps/1ps

module register #(parameter N = 32)(clk, ld, in , out);
    input clk, ld;
    input[N-1:0] in;
    output reg[N-1:0] out;

    always @(posedge clk)begin 
        if(ld) 
            out = in;
    end

endmodule 