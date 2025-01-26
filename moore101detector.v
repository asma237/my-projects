`timescale 1ns / 1ps
module moore101detector(input x,rst,clk,output reg z);
localparam [1:0] reset=0,got1=1,got10=2,got101=3;
reg [1:0] current;
always @(posedge clk) begin
   if (rst) current<=reset;
	else begin
	case (current)
	           reset:begin
				       if (x==1'b1) current<=got1;
						 else current<=reset;
						 end
				  got1:begin
				       if (x==1'b0) current<=got10;
						 else current<=got1;
						 end
				  got10:begin
				       if (x==1'b1) current<=got101;
						 else current<=reset;
						 end
				  got101:begin
				       z<=1'b1;
				       if (x==1'b1) current<=got1;
						 else current<=got10;
						 end
					default: begin
					     current<=reset;
						 end
		 endcase
		 end
	end
endmodule
