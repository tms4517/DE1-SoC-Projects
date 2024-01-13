// This module samples an input pin to determine how many clock cycles later to
// assert an output pin.

`default_nettype none

module delay
#(parameter int unsigned DELAY_W = 7)
( input  var logic i_clk

, input  var logic [DELAY_W-1:0] i_delay
, input  var logic               i_sampleAndStart

, output var logic o_delayComplete
);

  // {{{ Sample delay signal

  logic [DELAY_W-1:0] delay_q;

  always_ff @(posedge i_clk)
    if (i_sampleAndStart)
      delay_q <= i_delay;
    else
      delay_q <= delay_q;

  // }}} Sample delay signal

  // {{{ Assert output after delay number of clk cycles

  logic [DELAY_W-1:0] counter_q;

  always_ff @(posedge i_clk)
    if (i_sampleAndStart)
      counter_q <= '0;
    else
      counter_q <= counter_q + 1'b1;

  always_comb
    o_delayComplete = (counter_q == delay_q);

  // }}} Assert output after delay number of clk cycles

endmodule

`resetall
