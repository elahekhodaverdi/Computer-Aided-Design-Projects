`ifndef PARAMETERS_VH
`define PARAMETERS_VH


  parameter NORMAL = 0;
  parameter SUBNORMAL = NORMAL + 1;
  parameter ZERO = SUBNORMAL + 1;
  parameter INFINITY = ZERO + 1;
  parameter QNAN = INFINITY + 1;
  parameter SNAN = QNAN + 1;
  parameter LAST_FLAG = SNAN + 1;

  parameter BIAS = ((1 << (NEXP - 1)) - 1); // IEEE 754, section 3.3
  parameter EMAX = BIAS; // IEEE 754, section 3.3
  parameter EMIN = (1 - EMAX); // IEEE 754, section 3.3

`endif

