`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:07:27 02/11/2025 
// Design Name: 
// Module Name:    lemmings3 
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
module lemmings3(
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
    
    parameter L=0,R=1,FL=2,FR=3,DL=4,DR=5;
    reg [2:0] state,next;
    
    always @(*) begin
        case (state)
            L : next= (!ground)? FL : (dig ? DL : (bump_left ? R : L)) ;
            R : next= (!ground)? FR : (dig ? DR : (bump_right ? L : R)) ;
            FL: next= ground ? L : FL ;
            FR: next= ground ? R : FR ;
            DL: next= (!ground)? FL : DL ; 
            DR: next= (!ground)? FR : DR ; 
        endcase
    end
    
    always @(posedge clk or posedge areset) begin
        if (areset) state <= L ;
        else state <= next ;
    end
    
    assign walk_left= (state==L);
    assign walk_right= (state==R);
    assign aaah= (state== FL || state== FR);
    assign digging= (state== DL || state== DR);

endmodule
