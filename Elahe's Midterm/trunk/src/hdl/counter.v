module counter #(parameter N = 4, M = 9) 
(
    input clk,
    input init,
    input load,
    input enable,
    input [N-1:0] load_value,
    input [N-1:0] increment_value,
    output reg [N-1:0] count,
    output reg carry_out
);

    always @(posedge clk) begin
        if (init) begin
            count <= 0;
            carry_out <= 0;
        end
        else if (load) begin
            count <= load_value;
            carry_out <= 0;
        end
        else if (enable) begin
            if (count >= M) begin
                count <= 0;
                // carry_out <= 1;
            end
            else begin
                {carry_out,count} <= count + increment_value;
            end
        end
    end
    assign carry_out = (count >= M) && enable;
endmodule
