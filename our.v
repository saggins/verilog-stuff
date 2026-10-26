module our;
	initial begin
		$display("Hello World");
		#10;
		$stop;
		#10;
		$display("sup");
		$finish;


	end
endmodule
