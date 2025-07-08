module uart_tb;

    logic clk, rst;
    logic baud_tick;
    logic data_ready_tx;
    logic [7:0] data_in_tx;
    logic tx_serial, rx_serial;
    logic data_valid_rx;
    logic [7:0] data_out_rx;
    logic [7:0] test_data [4:0];

    parameter CLK_FREQ = 10_000;
    parameter BAUD_RATE = 1000;
    localparam BITS_PER_FRAME = 1 + 8 + 1 + 1;

    // Instantiate Baud Generator
    baud_gen #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) baudgen (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick)
    );

    // TX Instance
    uart_tx #(
        .DATA_WIDTH(8)
    ) dut_tx (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .data_ready(data_ready_tx),
        .data_in(data_in_tx),
        .tx_serial(tx_serial)
    );

    // RX Instance
    uart_rx #(
        .DATA_WIDTH(8)
    ) dut_rx (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .rx_serial(rx_serial),
        .data_valid(data_valid_rx),
        .data_out(data_out_rx)
    );

    assign rx_serial = tx_serial;

    // Clock generation
    initial begin
        clk = 0;
        forever #50 clk = ~clk; // 10kHz clock (100 µs)
    end

    initial begin
        rst = 1;
        data_ready_tx = 0;
        #200 rst = 0;

      test_data[0] = 8'h43; // 'A'
      test_data[1] = 8'h72; // 'B'
      test_data[2] = 8'hA5; // 'C'
      test_data[3] = 8'hE7; // 'D'
      test_data[4] = 8'hF4; // 'E'

        for (int i = 0; i < 5; i++) begin
            @(posedge clk);
            data_in_tx = test_data[i];
            data_ready_tx = 1;
            #50
             @(negedge baud_tick);
                    
          
            data_ready_tx = 0;
            //#( (BITS_PER_FRAME + 2) * (1_000_000_000 / BAUD_RATE) );
           @(posedge dut_rx.data_valid); 
          #1000;
          //$stop;
        end

        #10000
    end

    initial begin
        for (int i = 0; i < 5; i++) begin
            @(posedge dut_rx.data_valid);
            $display("Time: %t | Received: %h | Expected: %h", $time, dut_rx.data_out, test_data[i]);
            assert(dut_rx.data_out == test_data[i]) else $error("Data mismatch!");
        end
    end

    initial begin
        $dumpfile("uart_tb.vcd");
        $dumpvars(0, uart_tb);
    end

endmodule
