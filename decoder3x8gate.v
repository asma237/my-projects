`timescale 1ns / 1ps
module decoder3x8gate(
    input [2:0] b,
    output [7:0] d
    );
    wire bb2,bb1,bb0;
	 not n0(bb0,b[0]);
	 not n1(bb1,b[1]);
	 not n2(bb2,b[2]);
    and u1(d[0],bb2,bb1,bb0);
    and u2(d[1],bb2,bb1,b[0]);
    and u3(d[2],bb2,b[1],bb0);
    and u4(d[3],bb2,b[1],b[0]);
    and u5(d[4],b[2],bb1,bb0);
    and u6(d[5],b[2],bb1,b[0]);
    and u7(d[6],b[2],b[1],bb0);
    and u8(d[7],b[2],b[1],b[0]);
endmodule
