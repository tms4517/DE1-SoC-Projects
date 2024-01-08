// This module takes a hex number as input and outputs bits that represent the
// state of the lines of the 7 segment display.


`default_nettype none

module hexToSevenSeg
( input  var logic [3:0] i_number
, output var logic [6:0] o_display // Display is active-low.
);

  always_comb
    case(i_number)
      4'h0: o_display = 7'b1000000;
      4'h1: o_display = 7'b1111001;
      4'h2: o_display = 7'b0100100;
      4'h3: o_display = 7'b0110000;
      4'h4: o_display = 7'b0011001;
      4'h5: o_display = 7'b0010010;
      4'h6: o_display = 7'b0000010;
      4'h7: o_display = 7'b1111000;
      4'h8: o_display = 7'b0000000;
      4'h9: o_display = 7'b0011000;
      4'ha: o_display = 7'b0001000;
      4'hb: o_display = 7'b0000011;
      4'hc: o_display = 7'b1000110;
      4'hd: o_display = 7'b0100001;
      4'he: o_display = 7'b0000110;
      4'hf: o_display = 7'b0001110;
      default: o_display = '1;
    endcase

endmodule

`resetall
