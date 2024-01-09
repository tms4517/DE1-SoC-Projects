// This module connects the output of the PRBS to two seven segment displays.

`default_nettype none

module topPRBSToSevenSeg
( input  var logic i_clk
, input  var logic i_arst

, output var logic [6:0] o_SEG0
, output var logic [6:0] o_SEG1
);

  logic [6:0] randomValue;

  // NOTE: Pushbotton is '0 when depressed and returns to '1 when released.
  sevenBitPRBS randomNumberGenerator
  ( .i_clk  (!i_clk)
  , .i_arst (!i_arst)
  , .o_randomValue (randomValue)
  );

  logic [3:0] lsbs;
  logic [3:0] msbs;

  always_comb
    lsbs = randomValue[3:0];

  always_comb
    msbs = {1'b0,randomValue[6:4]};

  // Connect the least significant bits from the PRBS output to SEG0.
  hexToSevenSeg LSBToSEG0
  ( .i_number  (lsbs)
  , .o_display (o_SEG0)
  );

  // Connect the most significant bits from the PRBS output to SEG1.
  hexToSevenSeg MSBToSEG1
  ( .i_number  (msbs)
  , .o_display (o_SEG1)
  );

endmodule

`resetall
