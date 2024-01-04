module multiplier (a, b, out);
    input [7:0] a, b;
    wire [15:0] result;
    assign result = a * b;
    output [7:0] out;
    //assign out = {result[15], result[13:7]};
    assign out = {result[15:8]};
    
endmodule