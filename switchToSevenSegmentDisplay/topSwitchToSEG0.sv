// This module connects the switches to the hexToSevenSeg decoder which outputs
// a value that sets SEG0 display.

`default_nettype none

module topSwitchToSEG0
( input  var logic [3:0] i_switch
, output var logic [6:0] o_SEG0
);

  hexToSevenSeg switchToSEG0
  ( .i_number (i_switch)
  , .o_display (o_SEG0)
  );

endmodule

`resetall
