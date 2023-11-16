`timescale 1ps / 1ps

module fp_mul(a, b, p, pFlags);
  parameter NEXP = 5;
  parameter NSIG = 10;
  input [NEXP+NSIG:0] a, b;
  output [NEXP+NSIG:0] p;
  `include "ieee-754-flags.vh"
  output [LAST_FLAG-1:0] pFlags;
  reg [LAST_FLAG-1:0] pFlags;

  wire signed [NEXP+1:0] aExp, bExp;
  reg signed [NEXP+1:0] pExp, t1Exp, t2Exp;
  wire [NSIG:0] aSig, bSig;
  reg [NSIG:0] pSig, tSig;

  reg [NEXP+NSIG:0] pTmp;

  wire [2*NSIG+1:0] rawSignificand;

  wire [LAST_FLAG-1:0] aFlags, bFlags;

  reg pSign;

  fp_class #(NEXP,NSIG) aClass(a, aExp, aSig, aFlags);
  fp_class #(NEXP,NSIG) bClass(b, bExp, bSig, bFlags);

  assign rawSignificand = aSig * bSig;

  always @(*)
  begin
    pSign = a[NEXP+NSIG] ^ b[NEXP+NSIG];
    pTmp = {pSign, {NEXP{1'b1}}, 1'b0, {NSIG-1{1'b1}}};  // Initialize p to be an sNaN.
    pFlags = 6'b000000;

    if ((aFlags[SNAN] | bFlags[SNAN]) == 1'b1)
      begin
        pTmp = aFlags[SNAN] == 1'b1 ? a : b;
        pFlags[SNAN] = 1;
      end
    else if ((aFlags[QNAN] | bFlags[QNAN]) == 1'b1)
      begin
        pTmp = aFlags[QNAN] == 1'b1 ? a : b;
        pFlags[QNAN] = 1;
      end
    else if ((aFlags[INFINITY] | bFlags[INFINITY]) == 1'b1)
      begin
        if ((aFlags[ZERO] | bFlags[ZERO]) == 1'b1)
          begin
            pTmp = {pSign, {NEXP{1'b1}}, 1'b1, {NSIG-1{1'b0}}}; // qNaN
            pFlags[QNAN] = 1;
          end
        else
          begin
            pTmp = {pSign, {NEXP{1'b1}}, {NSIG{1'b0}}};
            pFlags[INFINITY] = 1;
          end
      end
    else if ((aFlags[ZERO] | bFlags[ZERO]) == 1'b1 ||
             (aFlags[SUBNORMAL] & bFlags[SUBNORMAL]) == 1'b1)
      begin
        pTmp = {pSign, {NEXP+NSIG{1'b0}}};
        pFlags[ZERO] = 1;
      end
    else // if (((aFlags[SUBNORMAL] | aFlags[NORMAL]) & (bFlags[SUBNORMAL] | bFlags[NORMAL])) == 1'b1)
      begin
        t1Exp = aExp + bExp;

        if (rawSignificand[2*NSIG+1] == 1'b1)
          begin
            tSig = rawSignificand[2*NSIG+1:NSIG+1];
            t2Exp = t1Exp + 1;
          end
        else
          begin
            tSig = rawSignificand[2*NSIG:NSIG];
            t2Exp = t1Exp;
          end

        if (t2Exp < (EMIN - NSIG))  // Too small to even be represented as
          begin                     // a subnormal; round down to zero.
            pTmp = {pSign, {NEXP+NSIG{1'b0}}};
            pFlags[ZERO] = 1;
          end
        else if (t2Exp < EMIN) // Subnormal
          begin
            pSig = tSig >> (EMIN - t2Exp);
            // Remember that we can only store NSIG bits
            pTmp = {pSign, {NEXP{1'b0}}, pSig[NSIG-1:0]};
            pFlags[SUBNORMAL] = 1;
          end
        else if (t2Exp > EMAX) // Infinity
          begin
            pTmp = {pSign, {NEXP{1'b1}}, {NSIG{1'b0}}};
            pFlags[INFINITY] = 1;
          end
        else // Normal
          begin
            pExp = t2Exp + BIAS;
            pSig = tSig;

            pTmp = {pSign, pExp[NEXP-1:0], pSig[NSIG-1:0]};
	    pFlags[NORMAL] = 1;
          end
      end //
  end

  assign p = pTmp;

endmodule