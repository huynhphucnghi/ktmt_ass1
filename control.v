module control(
		input		[5:0] opcode,
		output reg	[10:0] control_signal
);

	initial control_signal = 11'b0;
	
	always@(opcode)
	begin
		case (opcode)
			//Tên bit
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
				control_signal = 11'b0100x01000x;
			6'd8  :	// addi
				control_signal = 11'b00000000110;
			6'd0  :	// R-type
				control_signal = 11'b000001x0011;
			default:	// 
				control_signal = 11'b00000001000;
		endcase
	end

endmodule


