// This module implements a 7-bit PRBS generator of polynomial 1 + X + X^(7).

`default_nettype none

module sevenBitPRBS
( input  var logic i_clk
, input  var logic i_arst

, output var logic [6:0] o_randomValue
);

  logic [6:0] shiftRegister_q;

  always_ff @(posedge i_clk, posedge i_arst)
    if (i_arst)
      shiftRegister_q <= 7'b1;
    else
      shiftRegister_q <= { shiftRegister_q[6:1]
                         , shiftRegister_q[6]^shiftRegister_q[0]
                         };

  always_comb
    o_randomValue = shiftRegister_q;

endmodule

`resetall
