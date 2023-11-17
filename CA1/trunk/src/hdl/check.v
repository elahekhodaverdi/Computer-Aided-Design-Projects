module check  (a, is_finished);
    input [3:0]a ;
    output is_finished;
    assign is_finished = (a == 4'b0001 || a == 4'b0010 || a == 4'b0100 || a == 4'b1000);    
endmodule