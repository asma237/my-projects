`timescale 1ns / 1ps
module decoder3x8data(
    input [2:0] b,
    output [7:0] d
    );
assign d[0]=~b[2]&~b[1]&~b[0];
assign d[1]=~b[2]&~b[1]&b[0];
assign d[2]=~b[2]&b[1]&~b[0];
assign d[3]=~b[2]&b[1]&b[0];
assign d[4]=b[2]&~b[1]&~b[0];
assign d[5]=b[2]&~b[1]&b[0];
assign d[6]=b[2]&b[1]&~b[0];
assign d[7]=b[2]&b[1]&b[0];

endmodule
