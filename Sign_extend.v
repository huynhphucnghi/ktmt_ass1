module Sign_extend(
		input		[15:0] data_in,
		input		[4:0] shamt,
		output reg	[31:0] data_out
);
	
	always@(data_in)
		data_out = {16'b0,data_in};

endmodule