module ram_double_tb ();
	reg clk;

	reg [7:0] expectedRd1;
	reg [7:0] expectedRd2;

	reg we,rst;
	reg [7:0] wd3;

	reg [6:0] a1;
	reg [6:0] a2;
	reg [6:0] a3;

	wire [7:0] rd1;
	wire [7:0] rd2;

	always begin clk=1; #5; clk=0; #5; end

	ram_double dut (.a1(a1), .a2(a2), .a3(a3), .wd3(wd3),
			.we(we), .rd1(rd1), .rd2(rd2), .clk1(clk), .clk2(clk), .rst(rst));

	integer error;
	integer i;
	parameter numberOfTest=2;
	// a1_a2_a3_wd3_we_rd1_rd2
	// 7+7+7+8+1+8+8 = 46 bits
	reg [45:0] v [numberOfTest-1:0];

	initial begin
		$readmemb ( "/Users/sangmin/schoolProj/Verilog/ram_double.tv", v);
		error = 0; i=0; clk=0;
		rst=1;#30;rst=0;
	end
	always @ (posedge clk) begin
		#1;
		{a1,a2,a3,wd3,we,expectedRd1,expectedRd2} = v[i];
	end

	always @ (negedge clk) begin
		if (rst) $display ("RST called!");
		else if (rd1 == expectedRd1 && rd2 == expectedRd2) $display ("Pass");
		else begin
			error = error+1;
			$display ("Error at %d,\nINPUT\ta1:%b,a2:%b,a3:%b,wd3:%b,we:%b \nOUTPUT\trd1:%b rd2:%b", i,a1,a2,a3,wd3,we,rd1,rd2);
		end
		if (i == numberOfTest-1) begin
			$display ("Number of errors, %d", error);
			$finish;
		end else i=i+1;
	end
endmodule
