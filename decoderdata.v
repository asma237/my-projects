`timescale 1ns / 1ps
module decoderdata(
    input [1:0] b,
    output [3:0] d
    );
assign d[0]=~b[1]&~b[0];
assign d[1]=~b[1]&b[0];
assign d[2]=b[1]&~b[0];
assign d[3]=b[1]&b[0];

endmodule
