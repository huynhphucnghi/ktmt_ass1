module ALU_control(
		input 		[1:0] ALU_op,
		input 		[5:0] ALU_funct,
		output reg	[3:0] ALU_control
);

	always@(ALU_op, ALU_funct)
	begin
		case (ALU_op)
		2'b00:	ALU_control = 4'b0010;	// lw, sw
		2'b01:	ALU_control = 4'b0110;	// beq, bne
		2'b10: 	begin
					case(ALU_funct)
					6'b100100:	ALU_control = 4'b0000;	// and
					6'b100101:	ALU_control = 4'b0001;	// or
					6'b100000:	ALU_control = 4'b0010;	// add
					6'b100010:	ALU_control = 4'b0110;	// sub
					6'b101010:	ALU_control = 4'b0111;	// slt
					6'b100111:	ALU_control = 4'b1100;	// nor
					6'b000000:	ALU_control = 4'b1110;	// sll
					6'b000010:	ALU_control = 4'b1111;	// slr
					6'b011000:	ALU_control = 4'b0011;	// mul
					6'b011010:	ALU_control = 4'b0100;	// div
					default: 		ALU_control = 4'b0;
					endcase
				end
		default:	ALU_control = 4'b0;
		endcase
	end
endmodule