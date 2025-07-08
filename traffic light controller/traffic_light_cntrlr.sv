module traffic_light_controller (
    input clk,
    input reset_n,
    input main_road_sensor,  // High when vehicle detected on main road
    input side_road_sensor,  // High when vehicle detected on side road
    output reg [1:0] main_road_light, // 00: Red, 01: Yellow, 10: Green	
    output reg [1:0] side_road_light  // 00: Red, 01: Yellow, 10: Green
);
    localparam [1:0] RED    = 2'b00, 
		     YELLOW = 2'b01,
                     GREEN  = 2'b10;

    typedef enum logic [3:0] {
        MAIN_GREEN,
        MAIN_YELLOW,
        SIDE_GREEN,
        SIDE_YELLOW
    } traffic_state_t;

    traffic_state_t current_state, next_state;

    // Timers for light durations  (Below Values are assuming CLK Period = 10ns, Frequency: 100MHz
    parameter MAIN_GREEN_TIME  = 100_0_000_000; // e.g., 100 seconds (adjust for clock frequency)
    parameter YELLOW_TIME      = 20_0_000_000;  // e.g., 20 seconds
    parameter SIDE_GREEN_TIME  = 50_0_000_000;  // e.g., 50 seconds
    parameter MIN_MAIN_GREEN_HOLD_TIME = 30_0_000_000; // Minimum time 30 sec main road stays green

    logic [31:0] timer_count;
    logic timer_done;
   
    // --- State Register & timer_count Logic---
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= MAIN_GREEN;
            timer_count   <= 0;
        end else begin
            current_state <= next_state;
            if (timer_done) begin
                timer_count <= 0; // Reset timer when a state transition occurs
            end else begin
                timer_count <= timer_count + 1;
            end
        end
    end

    // --- Timer Logic ---
    always_comb begin
        timer_done = 1'b0;
        case (current_state)
            MAIN_GREEN:
                if (timer_count >= MAIN_GREEN_TIME) timer_done = 1'b1;
            MAIN_YELLOW:
                if (timer_count >= YELLOW_TIME) timer_done = 1'b1;
            SIDE_GREEN:
                if (timer_count >= SIDE_GREEN_TIME) timer_done = 1'b1;
            SIDE_YELLOW:
                if (timer_count >= YELLOW_TIME) timer_done = 1'b1;
            default:
                timer_done = 1'b0; // Should not happen
        endcase
    end

    // --- Next State Logic with Prioritization ---
    always_comb begin
        next_state = current_state; // Default: stay in current state

        case (current_state)
            MAIN_GREEN: begin

                // If main road has been green for its full duration, switch regardless of side road sensor
                if (timer_done) begin
                    next_state = MAIN_YELLOW;
                end
                // Prioritization: Main road always has priority.
                // It will only switch if the main road has been green for MIN_MAIN_GREEN_HOLD_TIME
                // AND there's a vehicle on the side road. 
                else if (timer_count >= MIN_MAIN_GREEN_HOLD_TIME
                      && side_road_sensor) begin
                    next_state = MAIN_YELLOW;
                end

            end

              MAIN_YELLOW: begin
                if (timer_done) begin
                    next_state = SIDE_GREEN;
                end
            end

            SIDE_GREEN: begin
                // If there's a vehicle on the main road or it's been side green for its full duration, switch
                if (timer_done || main_road_sensor) begin
                    next_state = SIDE_YELLOW;
                end
            end

            SIDE_YELLOW: begin
                if (timer_done) begin
                    next_state = MAIN_GREEN;
                end
            end

            default: begin
                next_state = MAIN_GREEN; // Should not happen, but safe default
            end
        endcase
    end


    // --- Output Logic ---
    always_comb begin
        main_road_light = RED; // Default to Red
        side_road_light = RED; // Default to Red

        case (current_state)
            MAIN_GREEN: begin
                main_road_light = GREEN; 
                side_road_light = RED; 
            end
            MAIN_YELLOW: begin
                main_road_light = YELLOW; 
                side_road_light = RED; 
            end
            SIDE_GREEN: begin
                main_road_light = RED; 
                side_road_light = GREEN; 
            end
            SIDE_YELLOW: begin
                main_road_light = RED; 
                side_road_light = YELLOW; 
            end
            default: begin
                // Defensive programming: In case of an unexpected state
                main_road_light = RED; // All Red
                side_road_light = RED;
            end
        endcase
    end
endmodule
