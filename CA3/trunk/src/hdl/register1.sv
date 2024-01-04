module register1word(clk, en, rst, write_data, out);
    input clk, en, rst;
    input [11:0] write_data;
    output reg [11:0] out;
    always @(posedge clk) begin
        if (rst) begin
            out <= 0;
        end else if (en) begin
            out <= write_data;
        end
    end

endmodule