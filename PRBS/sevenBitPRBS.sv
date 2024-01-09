// This module implements a 7-bit PRBS generator of polynomial 1 + X + X^(7).

`default_nettype none

module sevenBitPRBS
( input  var logic i_clk

, output var logic [6:0] o_randomValue
);

  logic [6:0] shiftRegister_q;

  // Note: Initial construct is non-synthesizable however Quartus SW is able to
  // create power-up settings for variables.
  initial shiftRegister_q = 7'b1;

  always_ff @(posedge i_clk)
    shiftRegister_q <= { shiftRegister_q[5:0]
                       , shiftRegister_q[6]^shiftRegister_q[0]
                       };

  always_comb
    o_randomValue = shiftRegister_q;

endmodule

`resetall
