`timescale 1ns / 1ps
module tff(q,clk,rst);
output reg q;
input clk,rst;
always @(posedge clk) begin
if(rst)
   q<=1'b0;
else
   q<=~q;
end 
endmodule

module ripplecounter(
    input clk,
    input rst,
    output [3:0] q
    );
tff tff0(q[0],~clk,rst);
tff tff1(q[1],~q[0],rst);
tff tff2(q[2],~q[1],rst);
tff tff3(q[3],~q[2],rst);
endmodule
