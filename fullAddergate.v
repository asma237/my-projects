`timescale 1ns / 1ps
module fullAddergate(
    input a,
    input b,
    input cin,
    output s,
    output co
    );
wire c1,c2,c3,out1;
xor x1(s,a,b,cin);
and a1(c1,a,b);
and a2(c2,b,cin);
and a3(c3,a,cin);
or o1(co,c1,c2,c3);
endmodule
