`timescale 1ns / 1ps
module gray2bingate(
    input [3:0] g,
    output [3:0] b
    );

 buf A4(b[3],g[3]);
 xor A3(b[2],b[3],g[2]);
 xor A2(b[1],b[2],g[1]); 
 xor A1(b[0],b[1],g[0]); 

endmodule
