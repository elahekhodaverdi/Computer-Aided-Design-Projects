`timescale 1ps/

module register(parameter N = 32)(clk, ld, in , out);
    input[N-1:0] in;
    output[N-1:0] out;

    always @(posedge clk)begin 
        if(ld) 
            out = in;
    end

endmodule 