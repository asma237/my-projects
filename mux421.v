`timescale 1ns / 1ps
module mux421(
    input [1:0] s,
    input [3:0] i,
    output o
    );
	 reg o;
always@(i or s)
begin
case(s)
2'b00:o=i[0];
2'b01:o=i[1];
2'b10:o=i[2];
2'b11:o=i[3];
endcase
end
endmodule
