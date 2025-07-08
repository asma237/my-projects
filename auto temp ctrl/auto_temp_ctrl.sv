module auto_temp_controller (
  input       clk, reset,
  input [7:0] current_temp, desired_temp,
  input [3:0] temp_tolerance,
  output reg  heater_on, cooler_on
);

//One hot encoded 
localparam [2:0] IDLE    = 3'b001,
	             HEATING = 3'b010,
	             COOLING = 3'b100;
reg [2:0] state, next_state;

//STATE REG LOGIC
always @(posedge clk, posedge reset)
   begin
      if (reset)
          state <= IDLE;
      else
          state <= next_state;
   end	       


//STATE TRANSITION COMBINATIONAL LOGIC

always@*
begin
//-----------------------------------------------------------------	
   case (state)
        //----------------------------------------------------------	
        IDLE: 
          begin
   	     if(current_temp < (desired_temp - temp_tolerance))
   		       next_state = HEATING;
   	     else if(current_temp > (desired_temp + temp_tolerance))
   		       next_state = COOLING;
   	     else
   		       next_state = IDLE;
          end
        //----------------------------------------------------------	
        HEATING: 
   	  begin
   	     if(current_temp >= desired_temp)
   		       next_state = IDLE;
   	     else
   		       next_state = HEATING;
          end
        //----------------------------------------------------------	
        COOLING: 
   	   begin
   	     if(current_temp <= desired_temp)
   		       next_state = IDLE;
   	     else
   		       next_state = COOLING;
           end
        //----------------------------------------------------------	
        default:
           //begin
                       next_state =  IDLE;
           //end
        //----------------------------------------------------------	
   endcase
//-----------------------------------------------------------------	
end



//STATE OUTPUT LOGIC
always @(posedge clk, posedge reset)
   begin
      //-----------------------------	      
      if (reset) begin
        heater_on <= 1'b0;
        cooler_on <= 1'b0;
      //-----------------------------	      
      end else begin
      //-----------------------------	      
	  if (state == IDLE) begin
            heater_on <= 1'b0;
            cooler_on <= 1'b0;
	  end else if (state == HEATING)
            heater_on <= 1'b1;
	  else if (state == COOLING)
            cooler_on <= 1'b1;
      end
      //-----------------------------	      
   end	       

endmodule

