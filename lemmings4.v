`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:00:57 02/12/2025 
// Design Name: 
// Module Name:    lemmings4 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module lemmings4(
 input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 
    
    parameter L=1,R=2,FL=3,FR=4,DL=5,DR=6,SPLAT=7;
    reg [2:0] state, next;
    integer count;
    
    always @(*) begin
        case(state)
            L: next= (!ground)? FL : (dig? DL : (bump_left? R : L));
            R: next= (!ground)? FR : (dig? DR : (bump_right? L : R));
            FL: next= (ground)? ((count>19)? SPLAT : L) : FL;
            FR: next= (ground)? ((count>19)? SPLAT : R) : FR;
            DL: next= (!ground)? FL : DL; 
            DR: next= (!ground)? FR : DR; 
            SPLAT: next= SPLAT;
        endcase
    end
    
    always @(posedge clk or posedge areset) begin
        if(areset)
            state<=L;
        else 
            state<=next;
    end
    
    always @(posedge clk) begin
        if (areset)
            count<=0;
        else if(state==FL || state==FR)
            count<=count+1;
        else if (count>20)
            count<=count;
        else
            count<=0;
    end
    
    assign walk_left= (state==L);
    assign walk_right= (state==R);
    assign aaah= (state==FL || state==FR);
    assign digging= (state==DL || state==DR);
    
endmodule
