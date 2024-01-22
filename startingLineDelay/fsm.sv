// This module implements the control FSM of the starting line delay circuit.
// The FSM consists of 3 states: IDLE, LEDS and DELAY.
// Initially, the FSM is in the IDLE state and asserts `o_enPRBS` to enable the
// PRBS generate random numbers. When `i_trigger` is asserted, the FSM
// transitions to the LEDS state at the next clock edge. In the LEDS state, at
// every clock cycle an LED gets turned on until all the LEDS are turned on.
// The FSM then transitions to the DELAY state and remains in this state for
// the same random number of clock cycles. When the delay is complete and
// `i_delayComplete`is asserted, the FSM transitions back to the IDLE state.

`default_nettype none

module fsm
( input  var logic i_clk
, input  var logic i_tick
, input  var logic i_arst

, input  var logic i_trigger
, input  var logic i_delayComplete

, output var logic o_enPRBS
, output var logic o_startDelay

, output var logic [9:0] o_turnOnLED
);

  // Note: i_tick and i_clk are synchronous signals.

  // {{{ FSM
  typedef enum logic [2:0]
  { STATE_IDLE
  , STATE_LEDS
  , STATE_DELAY
  } ty_STATE_FSM;

  ty_STATE_FSM state_d, state_q;

  logic allLEDSOn;

  always_ff @(posedge i_clk, posedge i_arst)
    if (i_arst)
      state_q <= STATE_IDLE;
    else
      state_q <= state_d;

  always_comb
    case (state_q)
      STATE_IDLE:  state_d = i_trigger       ? STATE_LEDS  : state_q;
      STATE_LEDS:  state_d = allLEDSOn       ? STATE_DELAY : state_q;
      STATE_DELAY: state_d = i_delayComplete ? STATE_IDLE  : state_q;
      default:     state_d =                   STATE_IDLE;
    endcase

  logic stateIsLEDS, stateIsDELAY;

  always_comb
    stateIsLEDS = (state_q == STATE_LEDS);

  always_comb
    stateIsDELAY = (state_q == STATE_DELAY);
  // }}} FSM

  // {{{ Assert outputs
  always_comb
    o_enPRBS = (state_q == STATE_IDLE)   ? '1 : '0;

  // Single pulse when state is delay.
  logic posEdgeDetect_q;

  always_ff @(posedge i_clk)
    posEdgeDetect_q <= stateIsDELAY;

  always_comb
    o_startDelay = (stateIsDELAY && !posEdgeDetect_q) ? '1 : '0;
  // }}} Assert outputs

  // {{{ Turn on LEDS in sequence
  logic [9:0] leds_q;

  always_ff @(posedge i_tick, posedge i_arst)
    if(i_arst)
      leds_q <= '0;
    else if (stateIsLEDS)
      leds_q <= {leds_q[8:0], 1'b1};
    else
      leds_q <= '0;

  // Counter to sequence LEDS
  logic [3:0] counter_q;

  always_ff @(posedge i_tick, posedge i_arst)
    if (i_arst)
      counter_q <= '0;
    else if (stateIsLEDS)
      counter_q <= counter_q + 1'b1;
    else
      counter_q <= '0;

  always_comb
    o_turnOnLED = leds_q;

  always_comb
    allLEDSOn = (counter_q == 4'd10) ? '1 :'0;
  // }}} Turn on LEDS in sequence

endmodule

`resetall
