module vendingMachine_tb;
	
	reg clk;
	reg rst;

	reg N;
	reg D;
	reg Q;

	wire Di;
	wire Rn;
	wire Rd;
	wire Rtd;


	// generate clock
	  always begin clk=1; #5; clk=0; #5; end
	

	parameter numberOfTests = 22;

	integer i;
	integer error;
	reg [6:0] v[0: numberOfTests-1];
	reg [3:0] expected;



	// device under test
	vendingMachine dut ( .clk(clk), .reset(rst), .N(N), .D(D),
			.Q(Q), .Di(Di), .Rn(Rn), .Rd(Rd),
			.Rtd(Rtd) );

	initial begin
		$readmemb ("/Users/sangmin/schoolProj/Verilog/testvector_vendingmachine.tv",
		       	v);
		error = 0; i=0; clk=0;
		{N,D,Q} = 3'b000;
		// pulse clock
		rst=1; #30; rst =0; 
	end

	always @(posedge clk) begin

		#1;
		if (!rst) {N, D, Q, expected} = v[i];
	end


	always @(negedge clk) begin
		if (rst) begin // skip
		end else begin


			if ( {N,D,Q,Di,Rn,Rd,Rtd}  == v[i] ) $display ("PASS");
			else begin
				error = error + 1;
				$display("Error: N: %b, D: %b, Q: %b\nDi: %b, Rn: %b, Rd: %b, Rtd: %b",
					 N, D, Q, Di, Rn, Rd, Rtd);
			end
			if ( i == numberOfTests -1) begin
				$display ( "Number of Errors, %d", error);
				$finish;
			end else i = i + 1;

		end

	end
endmodule
