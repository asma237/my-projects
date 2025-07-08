module uart_tx #(
    parameter DATA_WIDTH = 8
) (
    input logic clk,
    input logic rst,
    input logic baud_tick,
    input logic data_ready,
    input logic [DATA_WIDTH-1:0] data_in,
    output logic tx_serial
);

    typedef enum logic [2:0] {IDLE, START_BIT, DATA_BITS, PARITY_BIT, STOP_BIT} state_t;
    state_t state, next_state;

    logic [DATA_WIDTH-1:0] data_reg;
    logic [3:0] bit_counter;
    logic parity;

  //STATE REGISTERS
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else if (baud_tick)
            state <= next_state;
    end

  //STATE TRANSITON LOGIV
    always_comb begin
        next_state = state;
        case (state)
            IDLE:      if (data_ready) next_state = START_BIT;
            START_BIT: next_state = DATA_BITS;
            DATA_BITS: if (bit_counter == DATA_WIDTH - 1) next_state = PARITY_BIT;
            PARITY_BIT: next_state = STOP_BIT;
            STOP_BIT:  next_state = IDLE;
        endcase
    end

  //STATE OUTPUT LOGIC
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            tx_serial   <= 1'b1;
            bit_counter <= 0;
            data_reg    <= 0;
            parity      <= 0;
        end else if (baud_tick) begin
            case (state)
                IDLE: tx_serial <= 1'b1;

                START_BIT: begin
                    tx_serial <= 1'b0;
                    data_reg  <= data_in;
                    parity    <= ^data_in;
                    bit_counter <= 0;
                end

                DATA_BITS: begin
                    tx_serial <= data_reg[bit_counter];
                    bit_counter <= bit_counter + 1;
                end

                PARITY_BIT: tx_serial <= parity;

                STOP_BIT: tx_serial <= 1'b1;
            endcase
        end
    end

endmodule
