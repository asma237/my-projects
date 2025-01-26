`timescale 1ns / 1ps
module fullSubdata(
    input a,
    input b,
    input bin,
    output d,
    output bout
    );
assign d=(a^b^bin);
assign bout=(~a&b)|(b&bin)|(~a&bin);
endmodule
