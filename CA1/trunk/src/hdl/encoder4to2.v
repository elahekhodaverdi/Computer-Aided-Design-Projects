`timescale 1ps/1ps


module encoder4to2 (in, out);

    input [3:0] in;
    output reg [1:0] out;
    always @ (in) begin
        case (in)
            4'b0001: out = 2'b11;
            4'b0010: out = 2'b10;
            4'b0100: out = 2'b01;
            4'b1000: out = 2'b00;
            default: out = 2'b00;
        endcase
    end

endmodule
