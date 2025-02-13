`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:08:22 02/13/2025 
// Design Name: 
// Module Name:    fsmPS2data 
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
module fsmPS2data(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output reg [23:0] out_bytes,
    output done); //
    
    parameter B1=0,B2=1,B3=2,D=3;
    reg [1:0] state,next;

    // State transition logic (combinational)
    always @(*) begin
        case(state)
            B1: next= in[3]?B2:B1;
            B2: next= B3;
            B3: next= D;
            D: next= in[3]? B2:B1;
        endcase
    end
    
    // State flip-flops (sequential)
    always @(posedge clk) begin
        if(reset) state<=B1;
        else begin
            state<=next;
            
    // New: Datapath to store incoming bytes.
            case(next)
                B2: out_bytes[23:16]=in;
                B3: out_bytes[15:8]=in;
                D: out_bytes[7:0]=in;
            endcase
        end
    end
 
    // Output logic
    assign done= (state==D);
    
endmodule
