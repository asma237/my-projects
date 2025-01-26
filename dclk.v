`timescale 1ns / 1ps
module dclk(
    input d,
    input clk,
    output reg q
    );

always @(posedge clk) begin
if (clk==0) q<=q;
else begin
case(d)
   1'b0:q<=1'b0;
   1'b1:q<=1'b1;
	endcase
	end
end
endmodule
