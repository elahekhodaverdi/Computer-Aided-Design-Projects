module decoder (a, out);
    parameter N = 4;
    input [7:0] a;
    output reg [N-1:0] out;
    reg [N-1:0] i;
    always @(*) begin
        for (i = 0; i < N; i = i + 1) begin
            if (i == a) begin
                out[i] = 1;
            end
            else begin
                out[i] = 0;
            end
        end
    end
endmodule