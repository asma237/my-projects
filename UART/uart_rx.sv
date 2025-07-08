module uart_rx #(
    parameter DATA_WIDTH = 8
) (
    input  logic clk,
    input  logic rst,
    input  logic baud_tick,
    input  logic rx_serial,
    output logic data_valid,
    output logic [DATA_WIDTH-1:0] data_out
);
  
    typedef enum logic [2:0] {IDLE, START_BIT, DATA_BITS, PARITY_BIT, STOP_BIT} state_t;
    state_t state, next_state;

    logic [DATA_WIDTH-1:0] data_reg;
    logic [3:0] bit_counter;
    logic parity_received, parity_calculated;
    logic rx_sample;

    always_ff @(posedge clk) begin
      if (baud_tick)
        rx_sample <= rx_serial;
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else if (baud_tick)
            state <= next_state;
    end

    always_comb begin
        next_state = state;
        case (state)
          IDLE:       if (rx_serial == 0) next_state = START_BIT;
            START_BIT:  next_state = DATA_BITS;
            DATA_BITS:  if (bit_counter == DATA_WIDTH - 1) next_state = PARITY_BIT;
            PARITY_BIT: next_state = STOP_BIT;
            STOP_BIT:   next_state = IDLE;
        endcase
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            data_valid   <= 0;
            data_out     <= 0;
            bit_counter  <= 0;
            parity_calculated <=0;
            parity_received <=0;
        end else if (baud_tick) begin
            data_valid <= 0;
            case (state)
                START_BIT: begin 
                  data_valid <=0; // Do nothing
                  bit_counter<=0;
                end
                DATA_BITS: begin
                    data_reg[bit_counter] <= rx_sample;
                    bit_counter <= bit_counter + 1;
                end

                PARITY_BIT: begin
                     parity_received   <= rx_sample;
                     parity_calculated <= ^data_reg;
                end

                STOP_BIT: begin
                  if (rx_sample == 1) begin
                        if (parity_received == parity_calculated) begin
                            data_out   <= data_reg;
                            data_valid <= 1;
                        end else $error("Parity error!");
                    end else $error("Stop bit error!");
                    bit_counter <= 0;
                end
            endcase
        end
    end

endmodule  

