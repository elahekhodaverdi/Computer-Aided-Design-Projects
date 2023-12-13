module numberORTB();
    reg [31 : 0] in;
    wire [31 : 0] out;
    numberOR numor(in, out);
    initial begin
        in = 31'd12;
        #10 in = 31'd0;
        #10 in = 31'b11111111111111111111111111111111;
        #10 in = 31'd10;
    end

endmodule