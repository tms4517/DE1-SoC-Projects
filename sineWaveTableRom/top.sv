// This module implements a table ROM whose contents is initalised using a .mif
// file. The ROM is addressed using switches and the data at the specific
// location is displayed using 3 7-Segment displays.

`default_nettype none

module top
( input  var logic i_clk          // CLOCK_50

, input  var logic [9:0] i_switch // Switches

, output var logic [6:0] o_7Seg0  // 7 Segment display 0
, output var logic [6:0] o_7Seg1  // 7 Segment display 1
, output var logic [6:0] o_7Seg2  // 7 Segment display 2
);

  logic [9:0] data;

  ROM u_ROM
  ( .clock (i_clk)

  , .address (i_switch)
  , .q       (data)
  );

  hexTo7Seg seg0
  ( .i_number  (data[3:0])
  , .o_display (o_7Seg0)
  );

  hexTo7Seg seg1
  ( .i_number  (data[7:4])
  , .o_display (o_7Seg1)
  );

  hexTo7Seg seg2
  ( .i_number  (data[9:8])
  , .o_display (o_7Seg2)
  );

endmodule
`resetall
