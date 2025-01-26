`timescale 1ns / 1ps
module fullAdderdata(
    input a,
    input b,
    input cin,
    output s,
    output co
    );

assign s=(a^b^cin);
assign co=(a&b)|(b&cin)|(a&cin);
endmodule
