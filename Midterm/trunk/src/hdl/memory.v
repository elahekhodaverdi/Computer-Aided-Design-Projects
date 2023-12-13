module Memory(
    input wire clk,
    input wire we,
    input wire [6:0] write_address,
    input wire [6:0] read_address,
    input wire [31:0] data_in,
    output reg [31:0] data_out
);

    parameter FILENAME_X = "file/test1234.dat";
    localparam WIDTH = 32;
    localparam DEPTH = 128;
    reg [WIDTH-1:0] memory [DEPTH-1:0];

    initial begin
        $readmemh(FILENAME_X, memory);
    end

    always @(posedge clk) begin
        if (we) begin
            memory[write_address] <= data_in;
        end
    end
    assign data_out = memory[read_address];

endmodule
