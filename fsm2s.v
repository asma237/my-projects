
module top_module(
    input clk,
    input reset,    // Synchronous reset to OFF
    input j,
    input k,
    output out); //  

    parameter OFF=0, ON=1; 
    reg state, next;

    always @(*) begin
        // State transition logic
        case(state)
            OFF: next=j?ON:OFF;
            ON: next=k?OFF:ON;
            default: next=OFF;
        endcase
    end

    always @(posedge clk) begin
        // State flip-flops with synchronous reset
        if (reset) state<=OFF;
        else state<=next;
    end

    // Output logic
    assign out = (state == ON);

endmodule
