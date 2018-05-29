module LCD_controller(
	clk, sys_clk, SYS_rx, SYS_reset_IMEM, rst, load, PC, Out_sel, 
	LCD_RS, LCD_RW, LCD_EN, LCD_DATA, rdy_cmd, rdy_exe, state, HEX_S, HEX_E, HEX_U,
);
	input clk, sys_clk, rst, load;
	input SYS_rx, SYS_reset_IMEM;
	input [7:0] PC;
	input [3:0] Out_sel;
	output LCD_RS, LCD_RW, LCD_EN, rdy_cmd, rdy_exe;
	output [7:0] LCD_DATA;
	output [3:0] state;
	output [6:0] HEX_S, HEX_E, HEX_U;

	wire rdy_cmd;					// ready signal for LCD_command
	reg [3:0] op_cmd;				// operation for LCD_command
	wire [31:0] data_cmd;			// data for LCD_command
	
	wire rdy_exe;					// ready signal for LCD_executor
	wire [3:0] op_exe;				// operation for LCD_executor
	wire [7:0] data_exe;			// data for LCD_executor
	reg enb_exe = 1'b1;
	reg rst_exe = 1'b1;	
	wire [7:0]PC_present;
	LCD_command command(op_cmd, PC_present, Out_sel, data_cmd, rdy_exe, {op_exe, data_exe}, rdy_cmd, state);
	LCD_executor executor(clk, enb_exe, rst_exe, op_exe, data_exe, LCD_RS, LCD_RW, LCD_EN, LCD_DATA, rdy_exe);

	wire stall, exception, PC_unvalid;
	system system(sys_clk, clk, SYS_rx, SYS_reset_IMEM, rst, load, PC, Out_sel, PC_present, stall, 
						exception, PC_unvalid,
						data_cmd);
	
	LED7HEX LED7HEX(HEX_S, HEX_E, HEX_U, stall, exception, PC_unvalid, clk, rst);
	
	
	initial begin
		op_cmd <= 4'd15;
	end
	
	always@(posedge rdy_cmd) begin
		if(!rst) begin								// Reset the game
			op_cmd <= 4'd0;
		end
		
		else begin
			op_cmd <= 4'd1;
		end
		
	end
	
	
	

endmodule