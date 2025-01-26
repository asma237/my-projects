module full_sub(
    input a,
    input b,
    input bin,
    output d,
    output bout
    );

wire w1,w4,w5,w6;
xor x1(d,a,b,bin);
not n1(w1,a);
and a1(w4,w1,b);
and a2(w5,w1,bin);
and a3(w6,b,bin);
or o1(bout,w4,w5,w6);

endmodule
