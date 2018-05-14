module ALU_tb;
		reg 		[3:0] ALU_control;
		reg		[31:0] ALU_operand_1;
		reg		[31:0] ALU_operand_2;
		wire		[31:0] ALU_result;
		wire		[7:0] ALU_status;

	ALU ALU(ALU_control, ALU_operand_1, ALU_operand_2, ALU_result, ALU_status);
	
	initial begin
		ALU_control = 4'b0;
		ALU_operand_1 = 31'b1000101001;
		ALU_operand_2 = 31'b10111011000010;
	#10	ALU_control = 4'b1;
	#10 	ALU_control = 4'b0010;
	#10 	ALU_control = 4'b0110;
	#10 	ALU_control = 4'b0111;
	#10 	ALU_control = 4'b1100;
	#10 	ALU_control = 4'b1111;
	end
	
endmodule