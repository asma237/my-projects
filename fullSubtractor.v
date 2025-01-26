`timescale 1ns / 1ps
module fullSubtractor(
    input a,
    input b,
    input bin,
    output reg d,
    output reg bout
    );
	 always@(*)
	 begin
	 case ({a,b,bin})
	 3'b000: d=0;
	 3'b001: d=1;
	 3'b010: d=1;
	 3'b011: d=0;
	 3'b100: d=1;
	 3'b101: d=0;
	 3'b110: d=0;
	 3'b111: d=1;
	 default: d=0;
	 endcase
		 
	 case ({a,b,bin})
	 3'b000: bout=0;
	 3'b001: bout=1;
	 3'b010: bout=1;
	 3'b011: bout=1;
	 3'b100: bout=0;
	 3'b101: bout=0;
	 3'b110: bout=0;
	 3'b111: bout=1;
	 default: bout=0;
	 endcase
	 end

endmodule
