module system(
			input		SYS_clk,
			input		SYS_reset,
			input		SYS_load,
			input [7:0]	SYS_pc_val,
			input [7:0]	SYS_output_sel,
			output reg [26:0]	SYS_leds
);

// Instruction Fetch (IF)
reg [7:0] PC = 8'b0;
wire [7:0] nextPC;
wire [31:0] instruction;
IMEM _IMEM(
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
wire [31:0] instruction_ID;
wire [7:0] PC_ID;
Reg_IF_ID _Reg_IF_ID(
	SYS_clk,
	nextPC,
	instruction,
	PC_ID,
	instruction_ID
);

// Instruction Decode (ID)
wire [10:0] control_signal;
wire [5:0] opcode, funct;
wire [4:0] rs, rt, rd;
wire [31:0] sign_extend;
assign opcode 			= instruction_ID[31:26];
assign funct			= instruction_ID[5:0];
assign rs 				= instruction_ID[25:21];
assign rt 				= instruction_ID[20:16];
assign rd 				= instruction_ID[15:11];
assign sign_extend 	= {instruction_ID[15] == 0 ? 16'b0 : 16'hffff, instruction_ID[15:0]};

control _control(
		opcode,
		control_signal
);

// Decode control signal
wire RegDst 		= control_signal[0];
wire RegWrite 		= control_signal[1];
wire ALUsrc 		= control_signal[2];
wire Exception 	= control_signal[3];
wire [1:0] ALUop 	= control_signal[5:4];
wire Mem2Reg 		= control_signal[6];
wire MemWrite 		= control_signal[7];
wire MemRead 		= control_signal[8];
wire Branch 		= control_signal[9];
wire Jump 			= control_signal[10];

// Register Files
wire [31:0] reg_data1, reg_data2;
REG _REG(
		SYS_clk,
		rs,
		rt,
		rd,
		1'b0,
		32'b0,
		reg_data1,
		reg_data2
);

// ID/EX
wire 			RegDst_EX, RegWrite_EX, Mem2Reg_EX, MemWrite_EX, MemRead_EX, Branch_EX, ALUsrc_EX; 
wire [1:0]	ALUop_EX;
wire [7:0]	PC_EX;
wire [31:0]	instruction_EX;
wire [31:0]	reg_data1_EX;
wire [31:0]	reg_data2_EX; 
wire [31:0]	sign_extend_EX;
wire [5:0]	funct_EX;
wire [4:0]	rt_EX, rd_EX;
Reg_ID_EX _Reg_ID_EX(
		SYS_clk,
		// input
		{RegWrite, Mem2Reg},
		{MemWrite, MemRead, Branch},
		{RegDst, ALUsrc, ALUop},
		PC_ID,
		instruction_ID,
		reg_data1, reg_data2, sign_extend,
		funct,
		rt, rd,
		// output
		{RegWrite_EX, Mem2Reg_EX},
		{MemWrite_EX, MemRead_EX, Branch_EX},
		{RegDst_EX, ALUsrc_EX, ALUop_EX},
		PC_ID_EX,
		instruction_ID_EX,
		reg_data1_EX, reg_data2_EX, sign_extend_EX,
		funct_EX,
		rt_EX, rd_EX,
);

// Select register write's destination
wire [4:0] reg_write;
mux2 mux2_EX_1(
	RegDst_EX,
	rt_EX,
	rd_EX,
	reg_write
);

// Select ALU source
wire [31:0] source_data1, source_data2;
assign source_data1 = reg_data1_EX;
mux2 mux2_EX_2(
	ALUsrc_EX,
	reg_data2_EX,
	sign_extend_EX,
	source_data2
);

// ALU_control
wire [3:0] ALU_control_signal;
ALU_control _ALU_control(
	ALUop_EX,
	funct_EX,
	ALU_control_signal
);

// ALU
wire [31:0] ALU_result;
wire [7:0] ALU_status;
ALU _ALU(
	ALU_control_signal,
	source_data1,
	source_data1,
	ALU_result,
	ALU_status
);

// Display result on leds
always @(SYS_output_sel) begin
	if(SYS_output_sel == 8'd0) begin
		SYS_leds <= reg_data1;
	end
	else if(SYS_output_sel == 8'd1) begin
		SYS_leds <= reg_data2;
	end
	else if(SYS_output_sel == 8'd2) begin
		SYS_leds <= sign_extend;
	end
	else if(SYS_output_sel == 8'd3) begin
		SYS_leds <= {control_signal, 16'b0};
	end
	else if(SYS_output_sel == 8'd4) begin
		SYS_leds <= ALU_result;
	end
	else begin
		SYS_leds <= SYS_leds;
	end
end
endmodule