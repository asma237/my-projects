`timescale 1ns / 1ps
module ex32bcd(
    input [3:0] e,
    output reg [3:0]b
    );
always @(*) begin
case (e)
    4'b0000:b=4'bXXXX;
    4'b0001:b=4'bXXXX;
    4'b0010:b=4'bXXXX;
	 4'b0011:b=4'b0000;
	 4'b0100:b=4'b0001;  
	 4'b0101:b=4'b0010;  
	 4'b0110:b=4'b0011;   
	 4'b0111:b=4'b0100;   
	 4'b1000:b=4'b0101;  
	 4'b1001:b=4'b0110;  
	 4'b1010:b=4'b0111;  
	 4'b1011:b=4'b1000;
    4'b1100:b=4'b1001;
    4'b1101:b=4'bXXXX;
    4'b1110:b=4'bXXXX;
    4'b1111:b=4'bXXXX;
endcase
end
endmodule
