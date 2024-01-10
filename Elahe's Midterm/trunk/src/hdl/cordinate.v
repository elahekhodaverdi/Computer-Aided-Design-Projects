module coordinate_generator #(parameter WIDTH = 4, parameter DEPTH = 4)
(
    input clk,
    input init,
    input enable,
    input [WIDTH-1:0] x_max,
    input [DEPTH-1:0] y_max,
    output reg [WIDTH-1:0] x,
    output reg [DEPTH-1:0] y,
    output y_carryout,
    output x_carryout
);
    wire x_increment;
    assign x_carryout = x == x_max;
    assign y_carryout = y == y_max && x_carryout;
    assign x_increment = x_carryout || init;

    always @(posedge clk) begin
        if (init) begin
            x <= 0;
            y <= 0;
        end else if (enable) begin
            if (x_increment)
                x <= 0;
            else
                x <= x + 1;
            if (y_carryout)
                y <= 0;
            else if (x_increment)
                y <= y + 1;
        end
    end
endmodule
