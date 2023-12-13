module register (clk, rst, data_in, data_out);
    parameter N = 32;
    input clk, rst;
    input [31 : 0] data_in;
    output [31 : 0] data_out;
    S2 s2(.D0(data_in), .D1(0), .D2(0), .D3(0), .A1(0), .B1(0), .A0(0), .B0(0), .clr(rst), .clk(clk), .out(data_out));
endmodule