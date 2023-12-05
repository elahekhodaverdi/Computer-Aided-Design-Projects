module mac
(   input clk,
    input [7:0] a,
    input  [7:0] b,
    input  load,
    input  init,
    output  [7:0] acc
);
    wire [7:0] product = a * b;
    reg [7:0] sum;
    always@(posedge clk)
    begin
        if(init)
            sum <= 8'b0;
        else if(load)
            sum <= sum + product;
    end
    assign acc = sum;
endmodule
