`timescale 1ns / 1ps
module ring(
    output reg [3:0] q,
    input clk,
    input clr
    );
always @(posedge clk)
begin
if (clr)
   q<=4'b1000;
else
   begin
	   q[3]<=q[0];
	   q[2]<=q[3];
	   q[1]<=q[2];
	   q[0]<=q[1];
   end
end
endmodule
