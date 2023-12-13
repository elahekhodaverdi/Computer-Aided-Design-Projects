module buffer4x1(
    input clk,
    input init,
    input [1:0] address,
    input [7:0] data_in,
    input write,
    output reg [31:0] data_out
);
    reg [7:0] buffer [3:0];

    always @(posedge clk) begin
        if (init) begin
            buffer[0] <= 8'b0;
            buffer[1] <= 8'b0;
            buffer[2] <= 8'b0;
            buffer[3] <= 8'b0;
        end else if (write) begin
            buffer[address] <= data_in;
        end
    end

    always @(*) begin
        data_out = {buffer[0], buffer[1], buffer[2], buffer[3]};
    end
endmodule
