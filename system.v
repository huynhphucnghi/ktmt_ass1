module system(
			input		SYS_clk,
			input		SYS_reset,
			input		SYS_load,
			input 		[7:0] SYS_pc_val,
			input 		[7:0] SYS_output_sel,
			input 		[31:0] SYS_dram_input,
			output 		[26:0] SYS_leds,
			output 		[12:0] SYS_dram_addr
);

endmodule