`timescale 1ps/

module register(parameter N = 32)(clk, ld, in , out);
    input[N-1:0] in;
    output[N-1:0] out;

    always @(clk){
        if(ld) 
            out = in;
    }

endmodule 