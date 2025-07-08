module baud_gen #(
    parameter CLK_FREQ = 10_000,  // System clock frequency in Hz
    parameter BAUD_RATE = 1000    // Desired baud rate (9600)
) (
    input  logic clk,
    input  logic rst,
    output logic baud_tick
);
  
localparam integer BITS_PER_BAUD = CLK_FREQ / BAUD_RATE; // Calculate clock cycles per baud

logic [$clog2(BITS_PER_BAUD)-1:0] counter; // Counter to track clock cycles

  
always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            counter  <= 0;
            baud_tick <= 0;
        end else begin
            if (counter == BITS_PER_BAUD - 1) begin // Check if it's time for a baud tick
                counter  <= 0;
                baud_tick <= 1;             // Generate baud tick
            end else begin
                counter  <= counter + 1; // Increment counter
                baud_tick <= 0;
            end
        end
    end

endmodule

