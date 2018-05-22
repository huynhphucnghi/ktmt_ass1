module system_interface(
			input CLOCK_50,
			input [3:0] KEY,
			input [17:0] SW,
			output [17:0]LEDR,
			output [8:0] LEDG
);

wire [7:0] PC;

system _system(
			!KEY[0],
			CLOCK_50,
			KEY[1],
			!KEY[2],
			8'b0,
			SW[7:0],
			PC,
			{LEDR, LEDG}
);

endmodule