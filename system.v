module system(
			input		SYS_clk,
			input		SYS_reset,
			input		SYS_load,
			input [7:0]	SYS_pc_val,
			input [7:0]	SYS_output_sel,
			output [26:0]	SYS_leds
);

// Instruction Fetch (IF)
reg [7:0] PC = 8'b0;
wire [7:0] nextPC;
wire [31:0] instruction;
IMEM(
	{24'b0, PC},
	SYS_clk,
	32'b0,
	1'b0,
	instruction
);
assign nextPC = PC + 1'b1;
always @(posedge SYS_clk) begin
	if(SYS_reset == 1) begin
		PC <= nextPC;
	end
	else begin
		PC <= 8'b0;
	end
end

// IF/ID
wire [31:0] _instruction, _PC;
Reg_IF_ID(
	SYS_clk,
	nextPC,
	instruction,
	_PC,
	_instruction
);

// Instruction Decode (ID)
wire [10:0] control_signal;
wire [5:0] opcode;
wire [4:0] rs, rt, rd;
assign opcode = _instruction[31:26];
assign rs = _instruction[25:21];
assign rt = _instruction[20:16];
assign rd = _instruction[15:11];

control(
		opcode,
		control_signal
);

assign SYS_leds = {control_signal, 16'b0};

endmodule