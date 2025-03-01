`timescale 1ns / 1ps
module muxdata(
    input [3:0] i,
    input [1:0] s,
    output o
    );
assign o=~s[1]&~s[0]&i[0] | ~s[1]&s[0]&i[1] | s[1]&~s[0]&i[2] | s[1]&s[0]&i[3];
endmodule
