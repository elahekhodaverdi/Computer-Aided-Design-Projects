module check (a, is_finished);
    input [3:0] a;
    output is_finished;
    wire check_1000, check_0100, check_0010, check_0001;
    wire [3:0] bits_1000, bits_0100, bits_0010, bits_0001;
    XOR xor_1_1000(a[3], 1'b1, bits_1000[3]);
    XOR xor_2_1000(a[2], 1'b0, bits_1000[2]);
    XOR xor_3_1000(a[1], 1'b0, bits_1000[1]);
    XOR xor_4_1000(a[0], 1'b0, bits_1000[0]);
    AND4 AND_1000(bits_1000[3], bits_1000[2], bits_1000[1], bits_1000[0], check_1000);
    XOR xor_1_0100(a[3], 1'b0, bits_0100[3]);
    XOR xor_2_0100(a[2], 1'b1, bits_0100[2]);
    XOR xor_3_0100(a[1], 1'b0, bits_0100[1]);
    XOR xor_4_0100(a[0], 1'b0, bits_0100[0]);
    AND4 AND_0100(bits_0100[3], bits_0100[2], bits_0100[1], bits_0100[0], check_0100);
    XOR xor_1_0010(a[3], 1'b0, bits_0010[3]);
    XOR xor_2_0010(a[2], 1'b0, bits_0010[2]);
    XOR xor_3_0010(a[1], 1'b1, bits_0010[1]);
    XOR xor_4_0010(a[0], 1'b0, bits_0010[0]);
    AND4 AND_0010(bits_0010[3], bits_0010[2], bits_0010[1], bits_0010[0], check_0010);
    XOR xor_1_0001(a[3], 1'b0, bits_0001[3]);
    XOR xor_2_0001(a[2], 1'b0, bits_0001[2]);
    XOR xor_3_0001(a[1], 1'b0, bits_0001[1]);
    XOR xor_4_0001(a[0], 1'b1, bits_0001[0]);
    AND4 AND_0001(bits_0001[3], bits_0001[2], bits_0001[1], bits_0001[0], check_0001);
    OR4 OR_CHECK(check_1000, check_0100, check_0010, check_0001, is_finished);
    
endmodule