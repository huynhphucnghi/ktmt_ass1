module system(
			input		SYS_clk,
			input		SYS_reset,
			input		SYS_load,
			input [7:0]	SYS_pc_val,
			input [7:0]	SYS_output_sel,
			output reg [31:0]	SYS_leds
);

// Instruction Fetch (IF)
wire [7:0] PC, next_PC;
wire [7:0] Branch_addr_MEM;
wire [7:0] ALU_status_MEM;
wire branch, Branch_MEM;

assign branch = Branch_MEM && ALU_status_MEM[7];

mux2 mux2_IF(
	branch,
	PC + 8'b1,
	Branch_addr_MEM,
	next_PC
);

PC_register _PC_register(
	.clk(SYS_clk), 
	.reset(SYS_reset), 
	.load(SYS_load),
	.PC_load_val(SYS_pc_val),
	.branch(branch),
	.PC_next_val(next_PC),
	.PC(PC)
);

// Instruction memory
wire [31:0] instruction;
IMEM _IMEM(
	{24'b0, PC},
	SYS_clk,
	32'b0,
	1'b0,
	instruction
);


// IF/ID
wire [31:0] instruction_ID;
wire [7:0] PC_ID;
wire valid_PC;
Reg_IF_ID _Reg_IF_ID(
	SYS_clk,
	PC,
	instruction,
	1'b1,
	PC_ID,
	instruction_ID
);

// Instruction Decode (ID)
wire [10:0] control_signal;
wire [5:0] opcode;
wire [4:0] rs, rt, rd;
wire [31:0] sign_extend;
assign opcode 			= instruction_ID[31:26];
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
wire RegWrite_WB;
wire [4:0] RegDst_address_WB;
wire [31:0] Reg_write_data;
REG _REG(
		.clk(!SYS_clk),
		.REG_address_1(rs),
		.REG_address_2(rt),
		.REG_address_wr(RegDst_address_WB),
		.REG_write_1(RegWrite_WB),
		.REG_data_wb_in1(Reg_write_data),
		.REG_data_out1(reg_data1),
		.REG_data_out2(reg_data2)
);

// ID/EX
wire 			RegDst_EX, RegWrite_EX, Mem2Reg_EX, MemWrite_EX, MemRead_EX, Branch_EX, ALUsrc_EX; 
wire [1:0]	ALUop_EX;
wire [7:0]	PC_EX;
wire [31:0]	instruction_EX;
wire [31:0]	reg_data1_EX;
wire [31:0]	reg_data2_EX; 
wire [31:0]	sign_extend_EX;
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
		rt, rd,
		// output
		{RegWrite_EX, Mem2Reg_EX},
		{MemWrite_EX, MemRead_EX, Branch_EX},
		{RegDst_EX, ALUsrc_EX, ALUop_EX},
		PC_EX,
		instruction_EX,
		reg_data1_EX, reg_data2_EX, sign_extend_EX,
		rt_EX, rd_EX
);

// Select register destination address
wire [4:0] RegDst_address;
mux2 mux2_EX_1(
	RegDst_EX,
	rt_EX,
	rd_EX,
	RegDst_address
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
wire [5:0] funct;
assign funct			= sign_extend_EX[5:0];
ALU_control _ALU_control(
	ALUop_EX,
	funct,
	ALU_control_signal
);

// ALU
wire [4:0] shamt;
wire [7:0] ALU_status;
wire [31:0] ALU_result;
assign shamt = sign_extend_EX[10:6];
ALU _ALU(
	ALU_control_signal,
	source_data1,
	source_data2,
	shamt,
	ALU_result,
	ALU_status
);

// Calculate branch address
wire [7:0] Branch_addr;
assign Branch_addr = sign_extend_EX + PC_EX;

// EX/MEM
wire 	RegWrite_MEM, Mem2Reg_MEM, MemWrite_MEM, MemRead_MEM; 
wire [31:0] ALU_result_MEM, write_data, write_data_MEM;
wire [4:0] RegDst_address_MEM;
assign write_data = reg_data2_EX;
Reg_EX_MEM _Reg_EX_MEM(
		SYS_clk,
		// input
		{RegWrite_EX, Mem2Reg_EX},
		{MemWrite_EX, MemRead_EX, Branch_EX},
		ALU_status,
		ALU_result,
		write_data,
		RegDst_address,
		Branch_addr,
		1'b0,
		// output
		{RegWrite_MEM, Mem2Reg_MEM},
		{MemWrite_MEM, MemRead_MEM, Branch_MEM},
		ALU_status_MEM,
		ALU_result_MEM,
		write_data_MEM,
		RegDst_address_MEM,
		Branch_addr_MEM
);

// Data memory
wire [31:0] read_data;
DMEM _DMEM(
		.clk(SYS_clk),
		.DMEM_address(ALU_result_MEM),
		.DMEM_data_in(write_data_MEM),
		.DMEM_mem_write(MemWrite_MEM),
		.DMEM_mem_read(MemRead_MEM),
		.DMEM_data_out(read_data)
);

// MEM/WB
wire Mem2Reg_WB;
wire [31:0] read_data_WB, ALU_result_WB;
Reg_MEM_WB _Reg_MEM_WB(
		.clk(SYS_clk),
		// input
		.WB({RegWrite_MEM, Mem2Reg_MEM}),
		.read_data(read_data),
		.ALU_result(ALU_result_MEM),
		.RegDst_address(RegDst_address_MEM),
		// output
		._WB({RegWrite_WB, Mem2Reg_WB}),
		._read_data(read_data_WB),
		._ALU_result(ALU_result_WB),
		._RegDst_address(RegDst_address_WB)
);

//Select data to write back to register files
mux2 mux2_WB(
	Mem2Reg_WB,
	ALU_result_WB,
	read_data_WB,
	Reg_write_data
);

// Display result on leds
initial begin
	SYS_leds = 27'b0;
end
always @(SYS_output_sel) begin
	if(SYS_output_sel == 8'h0) begin
		SYS_leds = instruction;
	end
	else if(SYS_output_sel == 8'h1) begin
		SYS_leds = reg_data1;
	end
	else if(SYS_output_sel == 8'h2) begin
		SYS_leds = ALU_result;
	end
	else if(SYS_output_sel == 8'h3) begin
		SYS_leds = {10'b0, ALU_status, 9'b0};
	end
	else if(SYS_output_sel == 8'h4) begin
		SYS_leds = read_data;
	end
	else if(SYS_output_sel == 8'h5) begin
		SYS_leds = {7'b0, control_signal, 9'b0};
	end
	else if(SYS_output_sel == 8'h6) begin
		SYS_leds = {14'b0, ALU_control_signal, 9'b0};
	end
	else if(SYS_output_sel == 8'h7) begin
		SYS_leds = {10'b0, PC, 9'b0};
	end
	else if(SYS_output_sel == 8'h81) begin
		SYS_leds = reg_data2;
	end
	else if(SYS_output_sel == 8'h82) begin
		SYS_leds = { RegDst_address_WB, 11'b0, RegWrite_WB, Mem2Reg_WB, 9'b0};
	end
	else begin
		SYS_leds = 27'b0;
	end
end
endmodule