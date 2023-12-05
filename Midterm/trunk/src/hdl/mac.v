module mac
(   input clk,
    input [7:0] a,
    input  [7:0] b,
    input  load,
    input  init,
    output  [7:0] acc
);
    wire [7:0] product;
    wire [15:0] mult = a * b;
    assign product = mult[15:8];
    reg [11:0] sum;
    always@(posedge clk)
    begin
        if(init)
            sum <= 12'b0;
        else if(load)
            sum <= sum + product;
    end
    assign acc = sum[11:4];
endmodule
