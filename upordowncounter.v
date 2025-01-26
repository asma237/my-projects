`timescale 1ns / 1ps
module upordowncounter
   #(parameter COUNTER_WIDTH=5)
	(clk,rst_n,en,up_down_n,count,ovflw);
input clk,rst_n,en,up_down_n;
output reg [COUNTER_WIDTH-1:0] count;
output ovflw;
reg [3:0] next_state, state;

localparam IDLE = 4'b0001;
localparam CNTUP = 4'b0010;
localparam CNTDN = 4'b0100;
localparam OVFLW = 4'b1000;

always @*
   case (state)
	   IDLE: begin
		   if(en)
				if(up_down_n) 
				   next_state = CNTUP;
				else 
				   next_state = CNTDN;
			else
				 next_state = IDLE;
		end
		CNTUP: begin
		   if(en)
			   if(up_down_n)
				   if(count==(1<<COUNTER_WIDTH)-1)
					   next_state = OVFLW;
					else
					   next_state = CNTUP;
				else
				   if(count== 'b0)
					   next_state = OVFLW;
					else
					   next_state = CNTDN;
			else
			   next_state = IDLE;
		end
		CNTDN: begin
		   if(en)
			   if(up_down_n)
				   if(count==(1<<COUNTER_WIDTH)-1)
					   next_state = OVFLW;
					else
					   next_state = CNTUP;
				else
				   if(count== 'b0)
					   next_state = OVFLW;
					else
					   next_state = CNTDN;
			else
			   next_state = IDLE;
		end
		OVFLW: begin
		   next_state = OVFLW;
		end
		default: begin
		   next_state = 'bx;
			$display("%t: State machine not initialized\n",$time);
		end
	endcase

always @(posedge clk or negedge rst_n)
   if(!rst_n)
	   state <= IDLE;
	else
	   state <= next_state;

always @(posedge clk or negedge rst_n) 
   if(!rst_n)
	   count <= 'b0;
	else 
		if (state==CNTUP) 
		   count <= count+1'b1; 
		else if (state==CNTDN) 
		   count <= count-1'b1;

assign ovflw=(state==OVFLW) ? 1'b1 : 1'b0;

endmodule
