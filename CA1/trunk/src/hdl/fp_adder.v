`timescale 1ps / 1ps

module fp_adder #(parameter N=32) (a, b, result);
    input [N-1:0]a;
    input [N-1:0]b;
    output reg [N-1:0] result;

    reg [23:0] a_mantis, b_mantis, temp_mantis;
    reg [22:0] res_mantis;
    wire MSb;
    reg [7:0] a_exp, b_exp, temp_exp, diff_exp, res_exp;
    reg a_sign, b_sign, res_sign;
    reg carry, comp;
    always @(*) begin
        comp =  (a[30:23] > b[30:23])? 1'b1 : 
                (a[30:23] == b[32:23] && a[22:0] > b[22:0]) ? 1'b1 : 1'b0;
        
        a_mantis  = comp ? {1'b1,a[22:0]} : {1'b1,b[22:0]};
        a_exp = comp ? a[30:23] : b[30:23];
        a_sign  = comp ? a[31] : b[31];
        
        b_mantis = comp ? {1'b1,b[22:0]} : {1'b1,a[22:0]};
        b_exp = comp ? b[30:23] : a[30:23];
        b_sign  = comp ? b[31] : a[31];

        diff_exp = a_exp - b_exp;
        b_mantis = (b_mantis >> diff_exp);
        {carry,temp_mantis} =  (a_sign  ~^ b_sign) ? a_mantis + b_mantis : a_mantis- b_mantis ; 
        res_exp = a_exp;
        if(carry)
            begin
                temp_mantis = temp_mantis>>1;
                res_exp = res_exp+1'b1;
            end
        else
            begin
            while(!temp_mantis[23])
                begin
                temp_mantis = temp_mantis<<1;
                res_exp =  res_exp-1'b1;
                end
            end
        res_sign = a_sign; 
        res_mantis = temp_mantis[22:0];
        result = {res_sign, res_exp, res_mantis};
    end
endmodule