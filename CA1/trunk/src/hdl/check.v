module check  (zero0, zero1, zero2, zero3, is_finished);
    input zero0, zero1, zero2, zero3;
    output is_finished;
    assign is_finished = ((zero0 & zero1) & (zero2 ^ zero3)) | ((zero0 ^ zero1) & (zero2 & zero3));    
endmodule