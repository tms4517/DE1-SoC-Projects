// This module implements the control FSM of the starting line delay circuit.
// The FSM consists of 4 states: IDLE, TRIGGER, LEDS and DELAY.
// Initially, the FSM is in the IDLE state and asserts o_rstPRBS. On the next
// clock edge, the FSM transitions to the TRIGGER state and asserts `o_enPRBS.
// When `i_trigger` is asserted, the FSM transitions to the LEDS state at the
// next clock edge. In the LEDS state, at every clock cycle an LED gets turned
// on until all the LEDS are turned on. The FSM then transitions to the DELAY
// state where the PRBS is disabled. When the delay is complete and
//`i_delayComplete`is asserted, the FSM transitions back to the IDLE state.

`default_nettype none

module fsm
( input  var logic i_clk
, input  var logic i_tick

, input  var logic i_trigger
, input  var logic i_delayComplete

, output var logic o_rstPRBS
, output var logic o_enPRBS
, output var logic o_startDelay

, output var logic [9:0] o_turnOnLED
);

  // Note: i_tick and i_clk are synchronous signals.

  // {{{ FSM
  typedef enum logic [2:0]
  { STATE_IDLE
  , STATE_TRIGGER
  , STATE_LEDS
  , STATE_DELAY
  } ty_STATE_FSM;

  ty_STATE_FSM state_d, state_q;

  logic allLEDSOn;

  always_ff @(posedge i_clk)
    state_q <= state_d;

  always_comb
    case (state_q)
      STATE_IDLE:    state_d =             STATE_TRIGGER;
      STATE_TRIGGER: state_d = i_trigger ? STATE_LEDS : state_q;
      STATE_LEDS:    state_d = allLEDSOn ? STATE_DELAY : state_q;
      STATE_DELAY:   state_d = i_delayComplete ? STATE_IDLE : state_q;
      default:       state_d =             STATE_IDLE;
    endcase

  logic stateIsLEDS;

  always_comb
    stateIsLEDS = (state_q == STATE_LEDS);
  // }}} FSM

  // {{{ Assert outputs
  always_comb
    o_rstPRBS  = (state_q == STATE_IDLE)    ? '1 : '0;

  always_comb
    o_enPRBS = (state_q == STATE_TRIGGER) ? '1 : '0;

  always_comb
    o_startDelay = (state_q == STATE_DELAY)   ? '1 : '0;
  // }}} Assert outputs

  // {{{ Turn on LEDS in sequence
  logic [9:0] leds_d, leds_q;

  always_ff @(posedge i_tick)
    if (stateIsLEDS)
      leds_q <= leds_d;
    else
      leds_q <= '0;

  // Counter to sequence LEDS
  logic [3:0] counter_q;

  always_ff @(posedge i_tick)
    if (i_trigger)
      counter_q <= '0;
    else
      counter_q <= counter_q + 1'b1;

  for (genvar i = 0; i < 10; i++) begin: perLED

    always_comb
      o_turnOnLED[i] = ((counter_q > i) || (counter_q == i)) ? '1 : '0;

  end: perLED

  always_comb
    allLEDSOn = (counter_q == 4'd10) ? '1 :'0;
  // }}} Turn on LEDS in sequence

endmodule

`resetall
