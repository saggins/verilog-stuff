module alulab_tb;
	
	reg clk;
	reg rst;

	reg [31:0] A;
	reg [31:0] B;
	reg [3:0] F;

	wire       Cout;
	wire [31:0] Y;
	wire 	OF;


	// generate clock
	always begin clk=1; #5; clk=0; #5; end

	parameter numberOfTests = 8;

	integer i;
	integer error;
	// OF_F_A_B_Cout_Y
	// 4_4_32_32_4_32= 108 bits
	// OF = [107:104]
	// F = 	[103:100]
	// A = 	99:68
	// B =	67:36
	// Cout=35:32
	// Y=	31:0

	reg [107:0] v[0: numberOfTests-1];
	reg [3:0] expCout;
	reg [31:0] expY;
	reg [0:3] expOF;

	
	
	// device under test
	alulab dut ( .A ( A), .B(B), .F(F[2:0]), .Cout( Cout),
		.Y(Y), .OF(OF));

	initial begin
		$readmemh ("/Users/sangmin/schoolProj/Verilog/alulab.tv",
		       	v);
		error = 0; i=0; clk=0;
		A =0; B=0;F=0;
		// pulse clock
		rst=1; #30; rst =0; 
	end

	always @(posedge clk) begin
		#1;

		// OF_F_A_B_Cout_Y
		// 4_4_32_32_4_32= 108 bits
		if (!rst) begin 
			{expOF,F,A,B,expCout, expY} = v[i];
		end
	end


	always @(negedge clk) begin
		if (rst) begin // skip
		end else begin
			if ( {3'b000, OF} === expOF && {3'b000, Cout } === expCout && Y === expY) $display ("PASS");
			else begin
				error = error + 1;
				$display("Error: F: %h, A: %h, B: %h, Cout: %b, OF %b, Sum:%h expected Cout %b, expected Su, %h, expected OF = %b",
				       		F,A,B,Cout, OF,Y,expCout[0], expY, expOF[0]);
			end
			if ( i == numberOfTests -1) begin
				$display ( "Number of Errors, %d", error);
				$finish;
			end else i = i + 1;

		end

	end
endmodule
