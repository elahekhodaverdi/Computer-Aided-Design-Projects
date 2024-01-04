module counter #(parameter MAX_COUNT = 16)(clk, rst, en, carry, count);
    input clk, rst, en;
    output reg carry;
    output reg [7:0] count;
    always @(posedge clk) begin
        if (rst) begin
            count <= 0;
        end
        else if (en) begin
            if (count == MAX_COUNT - 1) begin
                count <= 0;
            end
            else begin
                count <= count + 1;
            end
        end
    end
    assign carry = (count == MAX_COUNT - 1);
endmodule