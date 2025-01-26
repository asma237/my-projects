`timescale 1ns / 1ps
module decodergate(
    input [1:0] b,
    output [3:0] d
    );
wire [1:0]b_bar;
not u0(b_bar[1],b[1]);
not u1(b_bar[0],b[0]);
and u2(d[0],b_bar[1],b_bar[0]);
and u3(d[1],b_bar[1],b[0]);
and u4(d[2],b[1],b_bar[0]);
and u5(d[3],b[1],b[0]);
endmodule
