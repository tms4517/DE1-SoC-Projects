// This module asserts the output every 'div' number of i_clk cycles.

`default_nettype none

module clkDiv
#(parameter int unsigned    DIV_W = 16
, parameter bit [DIV_W-1:0] DIV   = 50000
)
( input  var logic i_clk
, input  var logic i_en
, input  var logic i_arst

, output var logic o_clk
);

  logic [DIV_W-1:0] counter_q, counter_d;

  always_ff @(posedge i_clk, posedge i_arst)
    if (i_arst)
      counter_q <= '0;
    else if (i_en)
      counter_q <= counter_d;
    else
      counter_q <= counter_q;

  always_comb
    if (counter_q == (DIV-1))
      counter_d = '0;
    else
      counter_d = counter_q + 1'b1;

  always_comb
    o_clk = (counter_q == DIV-1);

endmodule

`resetall
