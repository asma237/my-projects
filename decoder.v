`timescale 1ns / 1ps
module decoder(
    input [1:0] b,
    output [3:0] d
    );
	 reg [3:0] d;
always @(b)
begin
case (b)
2'b00: d=4'b0001;
2'b01: d=4'b0010;
2'b10: d=4'b0100;
2'b11: d=4'b1000;
endcase
end
endmodule
