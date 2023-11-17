module Memory(X_out, W_out);
  parameter N = 4;
  parameter FILENAME_X = "./trunk/sim/file/input.dat";
  localparam WIDTH = 32;
  localparam HEIGHT = 16;
  output reg [WIDTH-1:0] W_out [HEIGHT-1:0];
  output reg [WIDTH-1:0] X_out [3:0];

  integer i ;

  initial begin
    $readmemh(FILENAME_X, X_out);
    for ( i = 0; i < WIDTH; i = i + 1) begin
      if (i == 0 || i == 5 || i == 10 || i == 15) begin
        W_out[i] = 32'h3f800000;
      end else begin
        W_out[i] = 32'hbe4ccccd;
      end
    end
  end
endmodule