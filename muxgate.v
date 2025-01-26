`timescale 1ns / 1ps
module muxgate(
    input [3:0] i,
    input [1:0] s,
    output o
    );
	 wire [1:0]sb;
	 wire [3:0]a;
	 not u(sb[1],s[1]);
	 not u0(sb[0],s[0]);
	 and u1(a[0],sb[1],sb[0],i[0]);
	 and u2(a[1],sb[1],s[0],i[1]);
	 and u3(a[2],s[1],sb[0],i[2]);
	 and u4(a[3],s[1],s[0],i[3]);
	 or o5(o,a[0],a[1],a[2],a[3]);
endmodule
