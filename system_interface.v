module system_interface(
			input	[3:0]	KEY,
			input [31:0] DRAM_DQ,
			input [17:0] SW,
			output [17:0]LEDR,
			output [8:0] LEDG,
			output [12:0] DRAM_ADDR
);

system(
			KEY[0],
			KEY[1],
			KEY[2],
			SW[7:0],
			SW[17:10],
			DRAM_DQ,
			{LEDG, LEDR},
			DRAM_ADDR
);

endmodule