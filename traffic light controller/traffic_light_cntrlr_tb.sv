`timescale 1ns / 1ps 
module tb_traffic_light_controller;

    // --- Testbench Parameters ---
    parameter CLK_PERIOD = 10ns; // 100 MHz clock
    // Adjust these based on the DUT's parameters if you change them
    parameter MAIN_GREEN_TIME_TB  = 100;//100_000_000; // e.g., 10 seconds (100M cycles for 100MHz clock)
    parameter YELLOW_TIME_TB      = 20;//20_000_000;  // e.g., 2 seconds
    parameter SIDE_GREEN_TIME_TB  = 50;//50_000_000;  // e.g., 5 seconds
    parameter MIN_MAIN_GREEN_HOLD_TIME_TB = 30;//30_000_000; // Minimum time main road stays green

    // --- DUT Signals (Wires connected to DUT) ---
    logic clk;
    logic reset_n;
    logic main_road_sensor;
    logic side_road_sensor;
    wire [1:0] main_road_light;
    wire [1:0] side_road_light;

    // --- Instantiation of the Device Under Test (DUT) ---
  traffic_light_controller  #(
        .MAIN_GREEN_TIME          (MAIN_GREEN_TIME_TB),
        .YELLOW_TIME              (YELLOW_TIME_TB),
        .SIDE_GREEN_TIME          (SIDE_GREEN_TIME_TB),   
        .MIN_MAIN_GREEN_HOLD_TIME  (MIN_MAIN_GREEN_HOLD_TIME_TB)  
    ) dut (
        .clk             (clk),
        .reset_n         (reset_n),
        .main_road_sensor(main_road_sensor),
        .side_road_sensor(side_road_sensor),
        .main_road_light (main_road_light),
        .side_road_light (side_road_light)
    );

    // --- Clock Generation ---
    always # (CLK_PERIOD / 2) clk = ~clk;

    // --- Initial Block for Test Scenarios ---
    initial begin
        // Initialize signals
        clk = 1'b0;
        reset_n = 1'b0; // Assert reset
        main_road_sensor = 1'b0;
        side_road_sensor = 1'b0;

        // Apply reset
        # (CLK_PERIOD * 5); // Hold reset for a few clock cycles
        reset_n = 1'b1;     // De-assert reset
        $display("-------------------------------------------");
        $display("Starting Traffic Light Controller Testbench");
        $display("-------------------------------------------");

        // --- Test Scenario 1: Normal Operation (No side road traffic) ---
        $display("\n--- Test Scenario 1: Normal Operation (No side road traffic) ---");
        # (MAIN_GREEN_TIME_TB * CLK_PERIOD); // Main road stays green for full duration
        $display("Time %0t: Main Road GREEN (Expected), Side Road RED (Expected)", $time);
        $display("Main Light: %b, Side Light: %b", main_road_light, side_road_light);
        assert(main_road_light == 2'b10 && side_road_light == 2'b00) else $error("Test 1 Failed: Main Green state check");

        # (YELLOW_TIME_TB * CLK_PERIOD); // Main road goes yellow
        $display("Time %0t: Main Road YELLOW (Expected), Side Road RED (Expected)", $time);
        assert(main_road_light == 2'b01 && side_road_light == 2'b00) else $error("Test 1 Failed: Main Yellow state check");

        # (SIDE_GREEN_TIME_TB * CLK_PERIOD); // Side road goes green (even without sensor, it gets its turn)
        $display("Time %0t: Main Road RED (Expected), Side Road GREEN (Expected)", $time);
        assert(main_road_light == 2'b00 && side_road_light == 2'b10) else $error("Test 1 Failed: Side Green state check");

        # (YELLOW_TIME_TB * CLK_PERIOD); // Side road goes yellow
        $display("Time %0t: Main Road RED (Expected), Side Road YELLOW (Expected)", $time);
        assert(main_road_light == 2'b00 && side_road_light == 2'b01) else $error("Test 1 Failed: Side Yellow state check");

        // --- Test Scenario 2: Side Road Vehicle Arrives During Main Green (After MIN_MAIN_GREEN_HOLD_TIME) ---
        $display("\n--- Test Scenario 2: Side Road Vehicle Arrives During Main Green (After MIN_MAIN_GREEN_HOLD_TIME) ---");
        // We are now back in MAIN_GREEN state from previous scenario
        main_road_sensor = 1'b0; // Ensure main road sensor is off
        side_road_sensor = 1'b0; // Ensure side road sensor is off

        # (MIN_MAIN_GREEN_HOLD_TIME_TB * CLK_PERIOD / 2); // Wait for half of hold time
        $display("Time %0t: Main Road GREEN, Side Road sensor HIGH (premature)", $time);
        side_road_sensor = 1'b1; // Side road car arrives
        // Should NOT switch immediately, due to MIN_MAIN_GREEN_HOLD_TIME

        # (MIN_MAIN_GREEN_HOLD_TIME_TB * CLK_PERIOD / 2); // Wait for the remaining half (total MIN_MAIN_GREEN_HOLD_TIME)
        // At this point, the main road should transition to yellow if side_road_sensor is high
        $display("Time %0t: Expected transition to Main Yellow due to side road sensor and MIN_HOLD_TIME met.", $time);
        assert(main_road_light == 2'b01 && side_road_light == 2'b00) else $error("Test 2 Failed: Main Yellow transition with side sensor");

        # (YELLOW_TIME_TB * CLK_PERIOD);
        $display("Time %0t: Expected transition to Side Green.", $time);
        assert(main_road_light == 2'b00 && side_road_light == 2'b10) else $error("Test 2 Failed: Side Green transition");
        side_road_sensor = 1'b0; // Car has passed, sensor off

        // --- Test Scenario 3: Main Road Vehicle Arrives During Side Green ---
        $display("\n--- Test Scenario 3: Main Road Vehicle Arrives During Side Green ---");
        // Currently in SIDE_GREEN from previous scenario
        # (SIDE_GREEN_TIME_TB * CLK_PERIOD / 4); // Let side road be green for a short while
        $display("Time %0t: Main Road sensor HIGH (forcing early exit from Side Green)", $time);
        main_road_sensor = 1'b1; // Main road car arrives

        # (1 * CLK_PERIOD); // Give it one cycle to react
        $display("Time %0t: Expected transition to Side Yellow due to main road sensor.", $time);
        assert(main_road_light == 2'b00 && side_road_light == 2'b01) else $error("Test 3 Failed: Side Yellow transition due to main sensor");

        # (YELLOW_TIME_TB * CLK_PERIOD);
        $display("Time %0t: Expected transition to Main Green.", $time);
        assert(main_road_light == 2'b10 && side_road_light == 2'b00) else $error("Test 3 Failed: Main Green transition");
        main_road_sensor = 1'b0; // Car has passed, sensor off

        // --- Test Scenario 4: Side Road Vehicle Arrives Immediately (Before MIN_MAIN_GREEN_HOLD_TIME) ---
        $display("\n--- Test Scenario 4: Side Road Vehicle Arrives Immediately (Before MIN_MAIN_GREEN_HOLD_TIME) ---");
        // We are currently in MAIN_GREEN state
        $display("Time %0t: Side Road sensor HIGH immediately, but MIN_HOLD_TIME prevents switch.", $time);
        side_road_sensor = 1'b1;

        # (MIN_MAIN_GREEN_HOLD_TIME_TB * CLK_PERIOD / 2); // Wait for half of hold time, should still be GREEN
        $display("Time %0t: Expect Main Green (MIN_HOLD_TIME not met yet)", $time);
        assert(main_road_light == 2'b10 && side_road_light == 2'b00) else $error("Test 4 Failed: Premature switch from Main Green");

        # (MIN_MAIN_GREEN_HOLD_TIME_TB * CLK_PERIOD / 2); // Wait for the remaining half
        $display("Time %0t: Expected transition to Main Yellow as MIN_HOLD_TIME met and side sensor high.", $time);
        assert(main_road_light == 2'b01 && side_road_light == 2'b00) else $error("Test 4 Failed: Main Yellow transition after hold time");
        side_road_sensor = 1'b0; // Turn off sensor after transition

        # (YELLOW_TIME_TB * CLK_PERIOD);
        # (SIDE_GREEN_TIME_TB * CLK_PERIOD);
        # (YELLOW_TIME_TB * CLK_PERIOD); // Go through the cycle to get back to Main Green for next test

        // --- Test Scenario 5: Multiple Side Road Vehicles Arrive (No effect on main road if not at turn) ---
        $display("\n--- Test Scenario 5: Multiple Side Road Vehicles Arrive (No effect if main road not ready) ---");
        // Currently in MAIN_GREEN state
        $display("Time %0t: Multiple side road vehicles detected.", $time);
        side_road_sensor = 1'b1; // First car
        # (10 * CLK_PERIOD);
        side_road_sensor = 1'b0; // First car leaves
        # (5 * CLK_PERIOD);
        side_road_sensor = 1'b1; // Second car arrives

        // Main road should still be green until MIN_MAIN_GREEN_HOLD_TIME is met AND a side road sensor is high
        # (MAIN_GREEN_TIME_TB * CLK_PERIOD - (15 * CLK_PERIOD)); // Wait for rest of main green time
        $display("Time %0t: Expected transition to Main Yellow after full Main Green time (even with side sensor).", $time);
        assert(main_road_light == 2'b01 && side_road_light == 2'b00) else $error("Test 5 Failed: Main Yellow transition after full time");
        side_road_sensor = 1'b0; // Turn off sensor

        // --- Finish Simulation ---
        $display("\n-------------------------------------------");
        $display("Traffic Light Controller Testbench Finished");
        $display("-------------------------------------------");
        
    end

    // --- Display current state and lights for debugging ---
    always @(posedge clk) begin
        if (reset_n) begin
            $display("Time %0t | State: %s | MR_Sensor: %b | SR_Sensor: %b | Main_Light: %b | Side_Light: %b",
                     $time, dut.current_state.name(), main_road_sensor, side_road_sensor, main_road_light, side_road_light);
        end
    end
  
  initial begin
    $dumpfile("tb_traffic_light_controller.vcd");
    $dumpvars(0, tb_traffic_light_controller);
  end

endmodule

