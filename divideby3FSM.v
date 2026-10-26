module divideby3FSM (	input clk,
			input reset,
			output q);
	
	reg [1:0] state, nextState;
	
	parameter S0 = 2'b00;
	parameter S1 = 2'b01;
	parameter S2 = 2'b10;

	// State register
	always @ ( posedge clk, posedge reset ) begin
		if (reset) state <= S0;
		else 	   state <= nextState;
	// next state logic	
	end 
	always @ (*) begin
		case (state)
			// notice the non blocking operators for combinational
			S0: nextState = S1;
			S1: nextState = S2;
			S2: nextState = S0;
			default: nextState = S0;
		endcase
	end
	//output logic
	assign q = (state == S0);
endmodule
