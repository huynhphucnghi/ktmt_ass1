module control(
		input		[5:0] opcode,
		output reg	[10:0] control_signal
);

	initial control_signal = 11'b0;
	
	always@(opcode)
	begin
		casex (opcode)
			6'd35 :	// lw
				control_signal = 11'b00101001110;
			6'd43 :	// sw
				control_signal = 11'b0001x00110x;
			6'd4  :	// beq
				control_signal = 11'b0100x011001;
			6'd8  :	// addi
				control_signal = 11'b00000001110;
			6'd0  :	// R-type
				control_signal = 11'b000001x1011;
			default:	// 
				control_signal = 11'b00000000000;
		endcase
	end

endmodule
