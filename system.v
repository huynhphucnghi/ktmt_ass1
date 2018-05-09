module system(
			input		SYS_clk,
			input		SYS_reset,
			input		SYS_load,
			input [7:0]	SYS_pc_val,
			input [7:0]	SYS_output_sel,
			output [26:0]SYS_leds
);

reg [31:0] addr = 32'b0;
wire [4:0] temp;

always @(posedge SYS_clk) begin
	addr = (addr + 1'b1);
end

test _test(
	addr,
	SYS_load,
	32'h0a0a0a0a,
	!SYS_reset,
	{temp, SYS_leds}
	);

endmodule