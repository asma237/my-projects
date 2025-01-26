`timescale 1ns / 1ps
module tclk(
    input t,
    input clk,
    output reg q=0
    );
always @ (posedge clk) begin
case(t)
    1'b0:q<=q;
    1'b1:q<=~q;
endcase
end
endmodule
