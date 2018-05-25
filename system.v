module system(
			input		SYS_clk,
			input		SYS_clk_50,
			input		SYS_reset,
			input		SYS_load,
			input [7:0]	SYS_pc_val,
			input [7:0]	SYS_output_sel,
			output [7:0] PC,
			output reg [31:0]	SYS_leds
);

////////////////////////////////////////////
// Instruction Fetch (IF)
////////////////////////////////////////////

wire [7:0] PC_4, next_PC, next_PC_final;
assign PC_4 = PC + 8'd4;
mux2 mux2_branch(
	Branch,
	PC_4,
	Branch_addr,
	next_PC
);

mux2 mux2_jump(
	Jump,
	next_PC,
	jump_addr[7:0],
	next_PC_final
);

PC_register _PC_register(
	.clk(SYS_clk), 
	.reset(SYS_reset), 
	.load(SYS_load),
	.PC_load_val(SYS_pc_val),
	.stall(load_hazard_signal),
	.PC_next_val(next_PC_final),
	.PC(PC)
);

// Instruction memory
wire [31:0] instruction;
IMEM _IMEM(
	{26'b0, PC[7:2]},
	SYS_clk_50,
	32'b0,
	1'b0,
	instruction
);

// EPC
wire PC_valid;
EPC _EPC(
		.PC(PC),
		.PC_valid(PC_valid)
);


// IF/ID
wire [31:0] instruction_ID;
wire [7:0] PC_ID;
Reg_IF_ID _Reg_IF_ID(
	.clk(SYS_clk),
	.PC(PC_4),
	.instruction(instruction),
	.valid_PC(PC_valid),
	.flush(Jump || Branch),
	.stall(load_hazard_signal),
	._PC(PC_ID),
	._instruction(instruction_ID)
);

////////////////////////////////////////////
// Instruction Decode (ID)
////////////////////////////////////////////

wire [10:0] control_signal;
wire [5:0] opcode;
wire [4:0] rs, rt, rd;
wire [31:0] sign_extend;
wire [31:0] jump_addr;
assign opcode 			= instruction_ID[31:26];
assign rs 				= instruction_ID[25:21];
assign rt 				= instruction_ID[20:16];
assign rd 				= instruction_ID[15:11];
assign sign_extend 	= {instruction_ID[15] == 0 ? 16'b0 : 16'hffff, instruction_ID[15:0]};
assign jump_addr		= { 4'b0, instruction_ID[25:0], 2'b0 };

control _control(
		opcode,
		two_reg_are_equal,
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
		.clk(SYS_clk),
		.REG_address_1(rs),
		.REG_address_2(rt),
		.REG_address_wr(RegDst_address_WB),
		.REG_write_1(RegWrite_WB),
		.REG_data_wb_in1(Reg_write_data),
		.REG_data_out1(reg_data1),
		.REG_data_out2(reg_data2)
);

// Load-use data hazard
wire load_hazard_signal;
Data_hazard _Data_hazard(
	.IF_ID_rs(rs), 
	.IF_ID_rt(rt),
	.ID_EX_rt(rt_EX),
	.ID_EX_mem_read(MemRead_EX),
	.load_hazard_signal(load_hazard_signal)
);

// Mux to handle load-use data hazard
wire [7:0] WB_M_EX;
mux2 mux2_load_use(
	load_hazard_signal,
	{ 	RegWrite, Mem2Reg, 
		MemWrite, MemRead,
		RegDst, ALUsrc, ALUop	},
	8'b0,
	WB_M_EX
);

// Early calculate branch address at ID phase
wire [31:0] forward_reg_data1 = 	(F1_control == 2'b00) ? reg_data1 : 
											(F1_control == 2'b01) ? ALU_result : 
											Mem2Reg_MEM ? read_data : ALU_result_MEM;
wire [31:0] forward_reg_data2 = 	(F2_control == 2'b00) ? reg_data2 : 
											(F2_control == 2'b01) ? ALU_result : 
											Mem2Reg_MEM ? read_data : ALU_result_MEM;
wire two_reg_are_equal = (forward_reg_data1 == forward_reg_data2) ? 1'b1 : 1'b0;
// Calculate branch address
wire [7:0] Branch_addr;
assign Branch_addr = {sign_extend[29:0], 2'b0} + PC_ID;

// Handle hazard when execute
// For example:
// addi $s0, $s0, 12
// beq $s0, $s1, 16
// This will not happen if we didn't calculate branch address early.
wire [1:0] F1_control, F2_control;
Control_Forwarding _Control_Forwarding(
	.ID_EX_RegWrite(RegWrite_EX),
	.EX_MEM_RegWrite(RegWrite_MEM),
	.ID_EX_rd(RegDst_address),
	.EX_MEM_rd(RegDst_address_MEM),
	.IF_ID_rs(rs),
	.IF_ID_rt(rt),
	.F1(F1_control),
	.F2(F2_control)
);

// ID/EX
wire 			RegDst_EX, RegWrite_EX, Mem2Reg_EX, MemWrite_EX, MemRead_EX, Branch_EX, ALUsrc_EX; 
wire [1:0]	ALUop_EX;
wire [7:0]	PC_EX;
wire [31:0]	instruction_EX;
wire [31:0]	reg_data1_EX;
wire [31:0]	reg_data2_EX; 
wire [31:0]	sign_extend_EX;
wire [4:0]	rs_EX, rt_EX, rd_EX;
Reg_ID_EX _Reg_ID_EX(
		SYS_clk,
		// input
		WB_M_EX[7:6],
		WB_M_EX[5:4],
		WB_M_EX[3:0],
		PC_ID,
		instruction_ID,
		reg_data1, reg_data2, sign_extend,
		rs, rt, rd,
		// output
		{RegWrite_EX, Mem2Reg_EX},
		{MemWrite_EX, MemRead_EX},
		{RegDst_EX, ALUsrc_EX, ALUop_EX},
		PC_EX,
		instruction_EX,
		reg_data1_EX, reg_data2_EX, sign_extend_EX,
		rs_EX, rt_EX, rd_EX
);

////////////////////////////////////////////
// Execute (EXE)
////////////////////////////////////////////

// Select register destination address
wire [4:0] RegDst_address;
mux2 mux2_EX_1(
	RegDst_EX,
	rt_EX,
	rd_EX,
	RegDst_address
);

// Select ALU source
// Handle data hazard by forwarding (See Forwarding module below)
wire [31:0] source_data1, source_data2, mux3_data1, mux3_data2;
assign mux3_data1 = (F1 == 2'b00) ? reg_data1_EX : ((F1 == 2'b01) ? ALU_result_MEM : Reg_write_data);
assign mux3_data2 = (F2 == 2'b00) ? reg_data2_EX : ((F2 == 2'b01) ? ALU_result_MEM : Reg_write_data);
assign source_data1 = mux3_data1;
mux2 mux2_EX_2(
	ALUsrc_EX,
	mux3_data2,
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

// Exception handle
wire disable_signal;
exception_handle _exception_handle(
		.ALU_status(ALU_status),
		.RegDst_address(RegDst_address),
		.mem_read(MemRead_EX), .mem_write(MemWrite_EX),
		.disable_signal(disable_signal)
);

// EX/MEM
wire 	RegWrite_MEM, Mem2Reg_MEM, MemWrite_MEM, MemRead_MEM; 
wire [31:0] ALU_result_MEM, write_data, write_data_MEM;
wire [4:0] RegDst_address_MEM;
wire [7:0] ALU_status_MEM;
assign write_data = (F3 == 2'b00) ? reg_data2_EX : ((F3 == 2'b01) ? ALU_result_MEM : Reg_write_data);
Reg_EX_MEM _Reg_EX_MEM(
		SYS_clk,
		// input
		{RegWrite_EX, Mem2Reg_EX},
		{MemWrite_EX, MemRead_EX},
		ALU_status,
		ALU_result,
		write_data,
		RegDst_address,
		disable_signal,
		// output
		{RegWrite_MEM, Mem2Reg_MEM},
		{MemWrite_MEM, MemRead_MEM},
		ALU_status_MEM,
		ALU_result_MEM,
		write_data_MEM,
		RegDst_address_MEM,
);

////////////////////////////////////////////
// Memory (MEM)
////////////////////////////////////////////

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

////////////////////////////////////////////
// Write Back (WB)
////////////////////////////////////////////

wire RegWrite_WB;
wire [4:0] RegDst_address_WB;
wire [31:0] Reg_write_data;
//Select data to write back to register files
mux2 mux2_WB(
	Mem2Reg_WB,
	ALU_result_WB,
	read_data_WB,
	Reg_write_data
);

// Data Forwarding
wire [1:0] F1, F2, F3;
Forwarding _Forwarding(
	.ID_EX_rs(rs_EX),
	.ID_EX_rt(rt_EX),
	.EX_MEM_rd(RegDst_address_MEM),
	.MEM_WB_rd(RegDst_address_WB),
	.EX_MEM_RegWrite(RegWrite_MEM),
	.MEM_WB_RegWrite(RegWrite_WB),
	.ID_EX_MemWrite(MemWrite_EX),
	.F1(F1),
	.F2(F2),
	.F3(F3)
);

// Display result on leds
initial begin
	SYS_leds = 27'b0;
end
always @(SYS_output_sel) begin
	case (SYS_output_sel)
		8'h0: 	SYS_leds = instruction;
		8'h1: 	SYS_leds = reg_data1;
		8'h2: 	SYS_leds = ALU_result;
		8'h3: 	SYS_leds = {10'b0, ALU_status, 9'b0};
		8'h4: 	SYS_leds = read_data;
		8'h5: 	SYS_leds = {7'b0, control_signal, 9'b0};
		8'h6: 	SYS_leds = {14'b0, ALU_control_signal, 9'b0};
		8'h7: 	SYS_leds = {10'b0, PC, 9'b0};
		8'h8: 	SYS_leds = {17'b0, disable_signal, 9'b0};
		8'h81: 	SYS_leds = reg_data2;
		8'h82: 	SYS_leds = { RegDst_address_WB, 11'b0, RegWrite_WB, Mem2Reg_WB, 9'b0};
		8'h83: 	SYS_leds = {  F3, F1, F2 };
		default: SYS_leds = 27'hfffffff;
	endcase
end

endmodule