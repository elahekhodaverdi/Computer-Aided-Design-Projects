module Memory(X_out, W_out);

  parameter FILENAME_X = "sim/file/input.dat";
  localparam WIDTH = 5;

  output reg [4:0] W_out [15:0];
  output reg [4:0] X_out [3:0];

  integer i ;
  initial begin
    $readmemb(FILENAME_X, X_out);
    for (i = 0; i < 16 ; i = i + 1) begin
      if (i == 0 || i == 5 || i == 10 || i == 15) begin
        W_out[i] = 5'b01000;
      end else begin
        W_out[i] = 5'b11110;
      end
    end
  end
endmodule