// This module implements a simple up-counter.

`default_nettype none

module simpleCounter
( input  var logic        i_clk
, output var logic [31:0] o_counter
);

  logic [31:0] counter_q;

  always_ff @(posedge i_clk)
    counter_q <= counter_q + 1;

  always_comb
    o_counter = counter_q;

endmodule

`resetall
