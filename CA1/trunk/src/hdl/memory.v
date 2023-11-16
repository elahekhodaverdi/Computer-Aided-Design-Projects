module Memory(X_out,W_out);
    parameter N = 4;
    parameter FILENAME_X = "maze.dat";
    parameter FILENAME_W = "maze.dat";
    localparam WIDTH = 16;
    localparam HEIGHT = 32;
    output reg [0:WIDTH - 1] W_out [0:HEIGHT - 1];;

    output reg [0:WIDTH - 1] X_out [0:3];

    initial begin
        $readmemh(FILENAME_X, X_out);
        $readmemh(FILENAME_W, W_out);
    end

endmodule