
module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah ); 
    
    parameter L=0, R=1, FL=2, FR=3;
    reg [1:0] state, next;
    
    always @(*)begin
        case(state)
            L: next= (!ground)? FL : ( bump_left? R : L ) ;
            R: next= (!ground)? FR : ( bump_right? L : R ) ;
            FL: next= (ground)? L : FL ;
            FR: next= (ground)? R : FR ;
        endcase
    end
    
    always @(posedge clk or posedge areset)begin
        if (areset) state<= L;
        else state<= next;
    end
    
    assign walk_left= (state==L);
    assign walk_right= (state==R);
    assign aaah= (state==FL || state==FR);
    
endmodule
