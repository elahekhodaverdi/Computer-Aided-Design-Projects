module incrementerby4(clk, en, rst, ld, ld_data, out);
    input clk, en, rst, ld;
    output reg [7:0] out;
    input [7:0] ld_data;
    always @(posedge clk) begin
        if (rst) begin
            out <= ld_data;
        
        end
        else if (ld) begin
            out <= ld_data;
        end 
        else if (en) begin
            out <= out + 4;
        end
    end

endmodule