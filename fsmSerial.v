`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:11:27 02/14/2025 
// Design Name: 
// Module Name:    fsmSerial 
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
module fsmSerial(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
); 
    parameter IDLE=0, START=1, DATA=2, STOP=3, ERROR=4;
    reg [2:0] state,next;
    integer count;
    
    always @(*)begin
        case(state)
            START: next= DATA;
            DATA: next= (count>=7)? (in?STOP: ERROR) : DATA;
            STOP: next= in? IDLE : START;
            ERROR: next= in? IDLE : ERROR;
            IDLE: next= !in? START : IDLE;
            default: next= IDLE;
        endcase
    end
    
    always @(posedge clk) begin
        if (reset)
            state<=IDLE;
        else 
            state<=next;
    end
    
    
    always @(posedge clk) begin
        if(reset)
            count<=0;
        else if(state== DATA)
            count<=count+1;
        else
            count<=0;
    end
    
    assign done= (state==STOP);
    
endmodule
