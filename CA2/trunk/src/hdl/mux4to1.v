module mux4to1 #(parameter N = 1) (a, b, c, d, sel, out);
    input [1:0] sel;
    input [N-1:0] a, b, c, d;
    output [N-1:0] out;
    assign out = (sel == 2'b00) ? a :
                 (sel == 2'b01) ? b : 
                 (sel == 2'b10) ? c :
                 (sel == 2'b11) ? d ;
endmodule