module system_interface(
			input [3:0] KEY,
			input [17:0] SW,
			output [17:0]LEDR,
			output [8:0] LEDG
);

system _system(
			!KEY[0],
			KEY[1],
			KEY[2],
			SW[10:3],
			SW[17:10],
			{LEDR, LEDG}
);

endmodule