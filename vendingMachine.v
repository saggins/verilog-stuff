module vendingMachine (	input clk,
			input reset,
			input N, // Nickle
			input D, // Dime
			input Q, // Qauter
			output Di,// Dispense?
			output Rn,// Return Nickle
			output Rd,// Return dime
			output Rtd// Return Two dimes
		); 
	
	reg [4:0] state, nextState;
	
	parameter S0 =  5'b00001;
	parameter S5 =  5'b00010;
	parameter S10 = 5'b00100;
	parameter S15 = 5'b01000;
	parameter S20 = 5'b10000;

	// State register
	always @ ( posedge clk, posedge reset ) begin
		if (reset) state <= S0;
		else 	   state <= nextState;
	// next state logic	
	end 

	// Input Logic

	always @ (*) begin
		case (state)
			// notice the non blocking operators for combinational
			S0: if (N) nextState = S5;
			else if (D) nextState = S10;
			else        nextState = S0; // assumes quaters

			S5: if (N) nextState = S10;
			else if (D) nextState = S15;
			else        nextState = S0; // assumes quaters

			S10: if (N) nextState = S15;
			else if (D) nextState = S20;
			else        nextState = S0; // assumes quaters

			S15: if (N) nextState = S20;
			else if (D) nextState = S0;
			else        nextState = S0; // assumes quaters
			S20:       nextState = S0;
			default: 	nextState = nextState; // No coins?, stay as is
		endcase
	end
	//output logic
	
	// Dispense?
	assign Di = ((state == S0) && Q || 
		     (state == S5) && Q || 
		    (state == S10) && Q || 
		    (state == S15) && D ||
		    (state == S15) && Q || 
		    (state == S20) && N || 
		    (state == S20) && D || 
		    (state == S20) && Q);
	
	// Return Nickle
	assign Rn = (state == S5)&&Q ||
		    (state == S15)&&Q||
		    (state ==S20) && D;
	//Return Dime
	assign Rd = (state == S10)&&Q ||
		    (state == S15) && Q;
	// Return Two Dimes
	assign Rtd = (state == S20)&&Q;

	
endmodule
