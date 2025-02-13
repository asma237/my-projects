`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:44:09 02/13/2025 
// Design Name: 
// Module Name:    fsmOneHot 
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
module fsmOneHot(
	 input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2);
   
    assign next_state[0]=!in&(state[0]|state[1]|state[2]|state[3]|state[4]|state[7]|state[8]|state[9]);
    assign next_state[1]=in&(state[0]|state[8]|state[9]);
    assign next_state[2]=in&state[1];
    assign next_state[3]=in&state[2];
    assign next_state[4]=in&state[3];
    assign next_state[5]=in&state[4];
    assign next_state[6]=in&state[5];
    assign next_state[7]=in&(state[6]|state[7]);
    assign next_state[8]=!in&state[5];
    assign next_state[9]=!in&state[6];
    
    assign out1=state[8]||state[9];
    assign out2=state[7]||state[9];
    
endmodule
