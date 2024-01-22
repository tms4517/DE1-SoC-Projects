// This module connects the sub-modules together to form the complete starting
// line delay circuit.

`default_nettype none

module top
( input  var logic i_clk          // CLOCK_50
, input  var logic i_arst         // Physical KEY 1
, input  var logic i_key          // Physical KEY 0

, output var logic [9:0] o_led    // LEDs
, output var logic [6:0] o_7Seg0
, output var logic [6:0] o_7Seg1
, output var logic [6:0] o_7Seg2
, output var logic [6:0] o_7Seg3
, output var logic [6:0] o_7Seg4
);

  logic tick_ms;

  clkDiv
  #(.DIV (50000))
  div50K
  ( .i_clk
  , .i_en ('1)
  , .i_arst (!i_arst)

  , .o_clk (tick_ms)
  );

  logic tick_hs;

  clkDiv
  #(.DIV (5000))
  div5K
  ( .i_clk
  , .i_en   (tick_ms)
  , .i_arst (!i_arst)

  , .o_clk (tick_hs)
  );

  logic delayComplete;
  logic enPRBS;
  logic startDelay;

  fsm u_fsm
  ( .i_clk  (tick_ms)
  , .i_tick (tick_hs)
  , .i_arst (!i_arst)

  , .i_trigger       (!i_key)
  , .i_delayComplete (delayComplete)

  , .o_enPRBS     (enPRBS)
  , .o_startDelay (startDelay)

  , .o_turnOnLED (o_led)
  );

  logic [6:0] randomValue;

  prbs sevenBitPRBS
  ( .i_clk  (tick_ms)
  , .i_arst (!i_arst)
  , .i_en   (enPRBS)

  , .o_randomValue (randomValue)
  );

  delay delayByPRBS
  ( .i_clk  (tick_ms)
  , .i_arst (!i_arst)

  , .i_delay          (randomValue)
  , .i_sampleAndStart (startDelay)

  , .o_delayComplete (delayComplete)
  );

  // {{{ Display random value
  logic [3:0] bcd0, bcd1, bcd2, bcd3, bcd4;

  bin2bcd_16 randomValue2bcd
  ( .B ({9'b0, randomValue})

  , .BCD_0 (bcd0)
  , .BCD_1 (bcd1)
  , .BCD_2 (bcd2)
  , .BCD_3 (bcd3)
  , .BCD_4 (bcd4)
  );

  hexTo7Seg bcd0To7Seg
  ( .i_number  (bcd0)
  , .o_display (o_7Seg0)
  );

  hexTo7Seg bcd1To7Seg
  ( .i_number  (bcd1)
  , .o_display (o_7Seg1)
  );

  hexTo7Seg bcd2To7Seg
  ( .i_number  (bcd2)
  , .o_display (o_7Seg2)
  );

  hexTo7Seg bcd3To7Seg
  ( .i_number  (bcd3)
  , .o_display (o_7Seg3)
  );

  hexTo7Seg bcd4To7Seg
  ( .i_number  (bcd4)
  , .o_display (o_7Seg4)
  );
  // }}} Display random value

endmodule

`resetall
