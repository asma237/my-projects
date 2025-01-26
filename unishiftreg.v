`timescale 1ns / 1ps
module unishiftreg(
    input clk,
    input rst,
    input [3:0] din,
    input sel,
    output reg [3:0] dout
    );
always@ (posedge clk) begin
   if (rst)
	   dout<=4'b0000;
	else
	   case(sel)
		   1'b0:dout<={din<<3}; //left shift
		   1'b1:dout<={din>>3}; //right shift
		   default: dout<=din;
		endcase
	end
endmodule
