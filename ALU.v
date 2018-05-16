module ALU(
		input 		[3:0] ALU_control,
		input		[31:0] ALU_operand_1,
		input		[31:0] ALU_operand_2,
		input		[4:0] ALU_shamt,
		output reg	[31:0] ALU_result,
		output		[7:0] ALU_status
);
	reg zero, overflow, carry, negative, invalid_address, div_zero;
	initial begin
		zero = 0;
		overflow = 0;
		carry = 0;
		negative = 0;
		invalid_address = 0;
		div_zero = 0;
	end

	always@(ALU_control, ALU_operand_1, ALU_operand_2)
	begin
		case (ALU_control)
		4'b0000:	begin	// and
					ALU_result = ALU_operand_1 & ALU_operand_2;			
					zero = (ALU_result == 32'b0);
					overflow = 1'b0;
					carry = 1'b0;
				end	
		4'b0001:	begin	// or
					ALU_result = ALU_operand_1 | ALU_operand_2;			
					zero = (ALU_result == 32'b0);
					overflow = 1'b0;
					carry = 1'b0;
				end	
		4'b0010:	begin	// add
					ALU_result = ALU_operand_1 + ALU_operand_2;			
					zero = (ALU_result == 32'b0);
					overflow = {ALU_operand_1[31], ALU_operand_2[31], ALU_result[31]} == 3'b001 ||
								{ALU_operand_1[31], ALU_operand_2[31], ALU_result[31]} == 3'b110;
					carry = {ALU_operand_1[31], ALU_operand_2[31], ALU_result[31]} == 3'b010 ||
							{ALU_operand_1[31], ALU_operand_2[31], ALU_result[31]} == 3'b100 ||
							{ALU_operand_1[31], ALU_operand_2[31]} == 2'b11;
				end	
		4'b0110:	begin	// sub
					ALU_result = ALU_operand_1 - ALU_operand_2;			
					zero = (ALU_result == 32'b0);
					overflow = {ALU_operand_1[31], ALU_operand_2[31], ALU_result[31]} == 3'b011 ||
								{ALU_operand_1[31], ALU_operand_2[31], ALU_result[31]} == 3'b100;
					carry = {ALU_operand_1[31], ALU_operand_2[31], ALU_result[31]} == 3'b001 ||
							{ALU_operand_1[31], ALU_operand_2[31], ALU_result[31]} == 3'b111 ||
							{ALU_operand_1[31], ALU_operand_2[31]} == 2'b01;
				end	
		4'b0111:	begin	// slt
					ALU_result = (ALU_operand_1 < ALU_operand_2) ? 32'b1 : 32'b0;		
					zero = (ALU_result == 32'b0);
					overflow = 1'b0;
					carry = 1'b0;
				end	
		4'b1100:	begin	// nor
					ALU_result = ~(ALU_operand_1 | ALU_operand_2);	
					zero = (ALU_result == 32'b0);
					overflow = 1'b0;
					carry = 1'b0;
				end	
		4'b1110:	begin	//	sll
					ALU_result = ALU_operand_1 << ALU_shamt;
					zero = (ALU_result == 32'b0);
					overflow = 1'b0;
					carry = 1'b0;
				end
		default:	begin	// 
					ALU_result = ALU_result;	
					zero = zero;
					overflow = overflow;
					carry = carry;
				end	
		endcase
		negative = ALU_result[31];
		invalid_address = ~(ALU_result[0] == 0 && ALU_result[1] == 0);
		div_zero = 0;
	end
	
	assign ALU_status = {zero, overflow, carry, negative, invalid_address, div_zero, 2'b00};
	
endmodule

