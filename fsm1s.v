module top_module(clk, reset, in, out);
    input clk;
    input reset;    // Synchronous reset to state B
    input in;
    output out;// 

    parameter A=0, B=1;
    reg state, next;

    always @(posedge clk) begin
        if (reset) state<=B;
        else state<=next;
    end
    
    always @(*) begin
        case(state)
            A: next<=in? A:B;
            B: next<=in? B:A;
        endcase
    end

    assign out= (state==B);

endmodule
