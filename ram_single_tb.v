module ram_single_tb ();
	reg clk;

	reg [7:0] expectedQ;
	reg we;
	reg [7:0] d;
	reg [6:0] a;

	wire [7:0]q;

	// generate clock
	always begin clk=1; #5; clk=0; #5; end

	// device Under test
	ram_single dut ( .q(q), .a(a), .d(d), .we(we),  .clk(clk));

	integer error;
	integer i;
	parameter numberOfTest=2;
	// a_d_we_q
	// 7+ 8 +1 +8  = 24 bits
	reg [23:0] v [numberOfTest-1:0];

	initial begin
		$readmemb ( "/Users/sangmin/schoolProj/Verilog/ram_single.tv", v);
		error = 0; i=0; clk=0;
		// Pulse clock but no RST 
		#30;
	end
	always @ (posedge clk ) begin
		#1;
		{a,d,we, expectedQ} = v[i];
	end
	

	always @ (negedge clk ) begin // Load 
		if ( we ) $display ("Ignoring write");
		else if ( !we &&  expectedQ == q ) $display ("Pass");
		else begin
			error = error+1;
			$display ("Error at %d,\nINPUT\ta:%b,d:%b,we:%b \nOUTPUT\tq:%b", i,a,d,we, q);
		end
		if ( i == numberOfTest-1) begin
			$display ("Number of errors, %d", error);
			$finish;
		end else i=i+1;
	end
endmodule

