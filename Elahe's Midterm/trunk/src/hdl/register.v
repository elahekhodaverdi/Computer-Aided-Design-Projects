module register #(parameter N = 8)(
    input clk,
    input init,
    input load,
    input [N-1:0] data_in,
    output reg [N-1:0] data_out
);
    always @(posedge clk) begin
        if(init)
            data_out <= 0;
        else if(load)
            data_out <= data_in;
    end
endmodule
