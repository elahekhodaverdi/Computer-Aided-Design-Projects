`timescale 1ps/1ps

module encoder_4to2 (
    input [3:0] in,
    output [1:0] out,
    output enable
);

assign enable = |in;

always @ (in) begin
    case (in)
        4'b0001: out = 2'b00;
        4'b0010: out = 2'b01;
        4'b0100: out = 2'b10;
        4'b1000: out = 2'b11;
        default: out = 2'b00;
    endcase
end

endmodule
