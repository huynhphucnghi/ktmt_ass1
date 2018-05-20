module system_interface(
			input [3:0] KEY,
			input [17:0] SW,
			output [17:0]LEDR,
			output [8:0] LEDG
);

system _system(
			!KEY[0],
			!KEY[1],
			!KEY[2],
			8'b0,
			SW[7:0],
			{LEDR, LEDG}
);

endmodule