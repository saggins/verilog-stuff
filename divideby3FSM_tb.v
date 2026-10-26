module divideby3FSM_tb;
	
	reg clk;
	reg rst;
	wire Y;

	// device under test
	divideby3FSM dut ( clk, rst, Y);


	// generate clock
	
	always
	begin
		clk=1; #5;
	       	clk=0; #5;
	       	clk=1; #5;
	end

	integer i;
	integer error;
	initial begin
		error = 0;
		// pulse clock
		rst=1; #30; rst =0; 
	end

	always @(negedge clk) begin
		if (~rst) begin // skip
		end
		$display ("%b",Y);
		i = i +1;

		if ( i % 3 == 0 && Y ) $display ("PASS");
		if ( i == 15 ) $finish;
	end

endmodule
