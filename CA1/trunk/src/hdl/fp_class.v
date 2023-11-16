`timescale 1ps / 1ps

module fp_class(f, fExp, fSig, fFlags);
    parameter NEXP = 5;
    parameter NSIG = 10;
    parameter CLOG2_NSIG = $clog2(NSIG+1);
    input [NEXP+NSIG:0] f;
    output signed [NEXP+1:0] fExp;
    reg signed [NEXP+1:0] fExp;
    output [NSIG:0] fSig;
    reg [NSIG:0] fSig;
    `include "ieee-754-flags.vh"
    output [LAST_FLAG-1:0] fFlags;

    wire expOnes, expZeroes, sigZeroes;

    assign expOnes   =  &f[NEXP+NSIG-1:NSIG];
    assign expZeroes = ~|f[NEXP+NSIG-1:NSIG];
    assign sigZeroes = ~|f[NSIG-1:0];

    assign fFlags[SNAN]      =  expOnes   & ~sigZeroes & ~f[NSIG-1];
    assign fFlags[QNAN]      =  expOnes                &  f[NSIG-1];
    assign fFlags[INFINITY]  =  expOnes   &  sigZeroes;
    assign fFlags[ZERO]      =  expZeroes &  sigZeroes;
    assign fFlags[SUBNORMAL] =  expZeroes & ~sigZeroes;
    assign fFlags[NORMAL]    = ~expOnes   & ~expZeroes;

    reg [NSIG:0] mask = ~0;
    reg [CLOG2_NSIG-1:0] sa;

    integer i;

    always @(*)
      begin
        fExp = f[NEXP+NSIG-1:NSIG];
        fSig = f[NSIG-1:0];

        sa = 0;

        if (fFlags[NORMAL])
          {fExp, fSig} = {f[NEXP+NSIG-1:NSIG] - BIAS, 1'b1, f[NSIG-1:0]};
        else if (fFlags[SUBNORMAL])
          begin
            for (i = (1 << (CLOG2_NSIG - 1)); i > 0; i = i >> 1)
              begin
                if ((fSig & (mask << (NSIG + 1 - i))) == 0)
                  begin
                    fSig = fSig << i;
                    sa = sa | i;
                  end
              end

            fExp = EMIN - sa;
          end
      end

endmodule