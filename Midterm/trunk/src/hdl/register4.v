module register4word(clk, en, rst, addr, write_data, out);
    input clk, en, rst;
    input [7:0] addr;
    input [7:0] write_data;
    reg [7:0] data [0:3];
    output [31:0] out;
    always @(posedge clk) begin
        if (rst) begin
            data[0] <= 0;
            data[1] <= 0;
            data[2] <= 0;
            data[3] <= 0;
        end 
        else if (en) begin
            data[addr] <= write_data;
        end
    end
    assign out = {data[0], data[1], data[2], data[3]};
endmodule