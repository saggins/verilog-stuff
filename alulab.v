module alulab (
	input  [31:0] A,
	input  [31:0] B,
	input  [2:0]  F,      	// F[2] = invert B, F[1:0] = op select
	
	output reg    OF,	// overflow flag
	output        Cout,
	output reg [31:0] Y
);

	wire [31:0] BB;
	assign BB = F[2] ? ~B : B;

	wire [31:0] S;
	assign {Cout, S} = A + BB + F[2]; // 2's compliment ~B +1


	always @(*) begin
		// Overflow Flag - See Ipad Table
		// Two +Nums -> -Sum
		// Two -Sum -> +Sum
		OF = A[0] && B[0] && ~S[0] ||
			~A[0] && ~B[0] && S[0] ;

		case (F[1:0])
			2'b00:   Y = A & BB;
			2'b01:   Y = A | BB;
			2'b10:   Y = S;
			2'b11:   Y = {31'b0, S[31]};   // SLT: sign bit
			default: Y = 32'b0;
		endcase
	end
endmodule
