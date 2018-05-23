	module control(
		input		[5:0] opcode,
		input		two_reg_are_equal,		// For branch
		output reg	[10:0] control_signal
);

	initial control_signal = 11'b0;
	
	always@(opcode, two_reg_are_equal)
	begin
		case (opcode)
			//Jump 10
			//Branch 9
			//MemRead 8
			//MemWrite 7
			//Mem2Reg 6
			//ALUop [4:5]
			//Exception 3
			//ALUsrc 2
			//RegWrite 1
			//RegDst 0
			6'd35 :	// lw
				control_signal = 11'b00101000110;
			6'd43 :	// sw
				control_signal = 11'b0001x00010x;
			6'd4  :	// beq
				if(two_reg_are_equal) begin
					control_signal = 11'b01000010000;
				end
				else begin
					control_signal = 11'b00000010000;
				end
			6'd5  :	// bne
				if(two_reg_are_equal) begin
					control_signal = 11'b00000010000;
				end
				else begin
					control_signal = 11'b01000010000;
				end
			6'd8  :	// addi
				control_signal = 11'b00000000110;
			6'd0  :	// R-type
				control_signal = 11'b000001x0011;
			6'd2  :	// Jump
				control_signal = 11'b10000000000;
			default:	// 
				control_signal = 11'b00000001000;
		endcase
	end

endmodule


