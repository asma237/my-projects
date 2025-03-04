`timescale 1ns / 1ps
module srff(
    input s,
    input r,
	 input clk,
    output reg q
    );
always @(posedge clk) begin
if (clk==0) q<=q;
else 
case ({s,r})
   2'b00:q<=q;
   2'b01:q<=1'b0;
   2'b10:q<=1'b1;
   2'b11:q<=1'bX;
	endcase
end
endmodule
