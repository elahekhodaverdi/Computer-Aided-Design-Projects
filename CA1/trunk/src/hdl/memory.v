module Memory(X_out, W_out);
  parameter N = 4;
  parameter FILENAME_X = "input.dat";
  localparam WIDTH = 16;
  localparam HEIGHT = 32;
  output reg [WIDTH-1:0] W_out [HEIGHT-1:0];
  output reg [WIDTH-1:0] X_out [3:0];
  integer i ;

  initial begin
    $readmemh(FILENAME_X, X_out);
    for ( i = 0; i < WIDTH; i = i + 1) begin
      if (i == WIDTH-1 || i == WIDTH-5 || i == WIDTH-10 || i == WIDTH-15) begin
        W_out[i] = 32'h3e4ccccd;
      end else begin
        W_out[i] = 32'hbf800000;
      end
    end
  end
endmodule