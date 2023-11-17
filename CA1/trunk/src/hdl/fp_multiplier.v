`timescale 1ps / 1ps

module fp_mult #(parameter N=32) (a, b, result);

    input [N-1:0]a;
    input [N-1:0]b;
    output reg [N-1:0] result;

    reg [23:0] a_mantis, b_mantis;
    reg [22:0] res_mantis;
    reg [47:0] temp_mantis;
    reg [7:0] a_exp, b_exp, temp_exp, res_exp;
    reg a_sign, b_sign, res_sign;
    always@(*)
    begin
        a_mantis = {1'b1,a[22:0]};
        a_exp = a[30:23];
        a_sign = a[31];
        
        b_mantis = {1'b1,b[22:0]};
        b_exp  = b[30:23];
        b_sign  = b[31];

        temp_exp = a_exp+b_exp- 127;
        temp_mantis = a_mantis*b_mantis;
        res_mantis = temp_mantis[47] ? temp_mantis[46:24] : temp_mantis[45:23];
        res_exp = temp_mantis[47] ? temp_exp+1'b1 : temp_exp;
        res_sign = a_sign^b_sign; 
        result = (a == 32'b0 || b == 32'b0) ? 0 : {res_sign,res_exp,res_mantis};
    end
endmodule