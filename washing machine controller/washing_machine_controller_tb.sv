`timescale 1ns/1ps
module washing_machine_tb;

  // Inputs
  logic clk;
  logic rst;
  logic start;
  logic water_level_full;
  logic drain_empty;

  // Outputs
  logic fill_valve_on;
  logic drain_valve_on;
  logic motor_cw;
  logic motor_off;

  // Instantiate DUT
  washing_machine dut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .water_level_full(water_level_full),
    .drain_empty(drain_empty),
    .fill_valve_on(fill_valve_on),
    .drain_valve_on(drain_valve_on),
    .motor_cw(motor_cw),
    .motor_off(motor_off)
  );

  // Clock Generation
  initial clk = 0;
  always #5 clk = ~clk; // 10ns period -> 100MHz

  // Task: Reset
  task apply_reset();
    begin
      rst = 1;
      water_level_full = 0;
      drain_empty = 0;
      start = 0;
      #20;
      rst = 0;
    end
  endtask

  // Task: Simulate washing machine cycle
  task simulate_cycle();
    begin
      start = 1;
      #10;
      start = 0;

      // FILL
      repeat(5) @(posedge clk);
      water_level_full = 1;
      @(posedge clk);
      water_level_full = 0;

      // WASH
      repeat(dut.WASH_TIME + 5) @(posedge clk);

      // DRAIN
      drain_empty = 1;
      @(posedge clk);
      drain_empty = 0;

      // RINSE
      repeat(dut.RINSE_TIME + 5) @(posedge clk);

      // SPIN
      repeat(dut.SPIN_TIME + 5) @(posedge clk);
    end
  endtask

  // Stimulus
  initial begin
    $display("Starting Washing Machine Test...");
    apply_reset();
    simulate_cycle();
    #100;
    $display("Test Completed.");
  end
  
    // Monitor all signals
  initial begin
    $monitor("Time=%0t | State=%s | Start=%b | WaterFull=%b | DrainEmpty=%b || FillValve=%b | DrainValve=%b | MotorCW=%b | MotorOff=%b",
      $time,
      dut.state.name(),
      start,
      water_level_full,
      drain_empty,
      fill_valve_on,
      drain_valve_on,
      motor_cw,
      motor_off
    );
  end

  // Optional waveform
  initial begin
    $dumpfile("washing_machine_tb.vcd");
    $dumpvars(0, washing_machine_tb);
  end

endmodule
