`timescale 1ns / 1ps
module johnson(
    input clk,
    input rst,
    output reg [3:0] q
    );
integer i;
always @(posedge clk)
begin
if (rst)
   q<=4'b0000;
else begin
   q[3]<=~q[0];
	for (i=0;i<3;i=i+1)
	   q[i]<=q[i+1];
	end
end
endmodule
