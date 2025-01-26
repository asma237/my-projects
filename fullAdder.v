`timescale 1ns / 1ps
module fullAdder(
    input a,
    input b,
    input cin,
    output reg s,
    output reg co
    );
	 always@(*)
	 begin
	 {co,s}=a+b+cin;
	 end
endmodule
