module washing_machine (
    input  clk,
    input  rst,
    input  start,
    input  water_level_full,
    input  drain_empty,
    output logic fill_valve_on,
    output logic drain_valve_on,
    output logic motor_cw,	
    output logic motor_off
);

 // Parameters (in clock cycles)
    parameter WASH_TIME = 200;
    parameter RINSE_TIME = 150;
    parameter SPIN_TIME = 300;

  // States
  enum logic [3:0] {IDLE, FILL, WASH, DRAIN, RINSE, SPIN, END} state, next_state;

  // Timers
  reg [31:0] timer;

  // State Register
  always_ff @(posedge clk or posedge rst) begin
    if (rst) state <= IDLE;
    else state <= next_state;
  end	

  // Next State Logic
  always_comb begin
    next_state = state;
    case (state)
      IDLE: if (start) next_state = FILL;
      FILL: if (water_level_full) next_state = WASH;
      WASH: if (timer >= WASH_TIME) next_state = DRAIN;
      DRAIN: if (drain_empty) next_state = RINSE;
      RINSE: if (timer >= RINSE_TIME) next_state = SPIN;
      SPIN: if (timer >= SPIN_TIME) next_state = END;
      END: next_state = IDLE;
      default: next_state = IDLE;
    endcase
  end

  // Output & Timer Logic
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      fill_valve_on  <= 0;
      drain_valve_on <= 0;
      motor_cw       <= 0;
      motor_off      <= 1;
      timer          <= 0;
    end else begin
      fill_valve_on  <= (state == FILL) | (state == RINSE);
      drain_valve_on <= (state == DRAIN) | (state == SPIN);
      motor_cw       <= (state == WASH) | (state == RINSE) | (state ==SPIN);
      motor_off      <= (state == IDLE) | (state == END);

        if (state == WASH || state == SPIN) begin // Timer increments only during WASH or SPIN
            timer <= timer + 1;
        end else if (state == RINSE) begin // Special handling for RINSE state
            //---------------------------------------------------------
            if (timer >= RINSE_TIME) 
                timer <= 0; // Reset timer when RINSE_TIME is reached in RINSE state
            else 
                timer <= timer + 1; // Otherwise, continue incrementing
            //--------------------------------
        end else begin // For all other states, or when timer should not be active
            timer <= 0; // Reset timer
        end
 
    end
  end
endmodule
