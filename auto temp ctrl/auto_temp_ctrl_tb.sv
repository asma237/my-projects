`timescale 1ns/1ps
module atc_tb;

  parameter integer HEATER_CYCLE_DELAY = 10;  // steps every 10 cycles
  parameter integer COOLER_CYCLE_DELAY = 5;   // steps every 5 cycles
  parameter integer HEATER_STEP = 2;
  parameter integer COOLER_STEP = 3;
  parameter integer CLK_PERIOD = 10;

  reg clk, reset;
  reg [7:0] c_temp, d_temp;
  reg [3:0] temp_tol;
  wire      ht_on, cl_on;

  auto_temp_controller atc_inst(
    .clk(clk),
    .reset(reset),
    .current_temp(c_temp),
    .desired_temp(d_temp),
    .temp_tolerance(temp_tol),
    .heater_on(ht_on),
    .cooler_on(cl_on)
  );

  //-----------------------------------------------
  always #(CLK_PERIOD/2) clk = ~clk;

  //-----------------------------------------------
  // Heater & Cooler Environment Simulation
  reg [31:0] heat_tick, cool_tick;

  always @(posedge clk) begin
    if (reset) begin
      heat_tick <= 0;
      cool_tick <= 0;
    end else begin
      if (ht_on)
        heat_tick <= heat_tick + 1;
      else
        heat_tick <= 0;

      if (cl_on)
        cool_tick <= cool_tick + 1;
      else
        cool_tick <= 0;

      if (ht_on && heat_tick % HEATER_CYCLE_DELAY == 0)
        c_temp <= c_temp + HEATER_STEP;
      else if (cl_on && cool_tick % COOLER_CYCLE_DELAY == 0)
        c_temp <= c_temp - COOLER_STEP;
      
    end
  end

  //-----------------------------------------------
  task automatic test_case(input [7:0] init_temp, input [7:0] set_temp, input [31:0] wait_time);
    begin
      $display("\nStarting test case: current=%0d, desired=%0d", init_temp, set_temp);
      c_temp = init_temp;
      d_temp = set_temp;
      #wait_time;
      assert((ht_on === 1'b0 && cl_on === 1'b0) && 
             (c_temp >= d_temp - temp_tol && c_temp <= d_temp + temp_tol))
        else $error("? Temperature did not stabilize around desired value within tolerance.");
      $display("? Test case passed. Temp=%0d", c_temp);
    end
  endtask

  //-----------------------------------------------
  initial begin
    clk      = 1'b0;
    reset    = 1'b1;
    c_temp   = 0;
    d_temp   = 0;
    temp_tol = 4'd2;

    #100; 
    reset = 1'b0;

    // Normal heating case
    test_case(60, 70, 1500);

    // Normal cooling case
    test_case(80, 70, 1500);

    // Cold Winter: Very low temp jump
    test_case(40, 70, 3000);

    // Hot Summer: Very high temp jump
    test_case(95, 70, 3000);

    $display("?? All tests completed.");
    #100;
    $stop;
  end

  //-----------------------------------------------
  initial begin
    $monitor($time, " current_temp=%d, desired_temp=%d, heater_on=%b, cooler_on=%b",
             c_temp, d_temp, ht_on, cl_on);
  end

  //-----------------------------------------------
  initial begin
    $dumpfile("atc_tb.vcd");
    $dumpvars(0, atc_tb);
  end

endmodule

