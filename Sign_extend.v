module Sign_extend(
		input		[15:0] data_in,
		input		[4:0] shamt,
		output reg	[31:0] data_out
);
	
	always@(data_in)
		data_out = data_in[15] ? {16'hFFFF,data_in} : {16'h0,data_in};

endmodule