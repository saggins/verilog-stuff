module ram_double (rd1, rd2, a1, a2, a3, wd3, we, clk1, clk2, rst);
	output reg [7:0] rd1;
	output reg [7:0] rd2;

	input [7:0] wd3;

	input [6:0] a1;
	input [6:0] a2;
	input [6:0] a3;

	input we, clk1, clk2, rst;
	reg [7:0] mem [127:0];

	genvar i;
	generate
		for (i = 0; i < 128; i = i + 1) begin : mem_reset
			always @(posedge rst) begin
				mem[i] <= 8'b0;
			end
		end
	endgenerate

	always @(posedge clk1, posedge rst) begin
		if (rst)	rd1<= 8'b0;
		else		rd1 <= mem[a1];
	end
	always @(posedge clk2, posedge rst) begin
		if (rst)	rd2<= 8'b0;
		else		rd2 <= mem[a2];
	end

	always @(posedge clk1, posedge clk2) begin
		if (!rst) mem[a3] <= wd3;
	end
endmodule
