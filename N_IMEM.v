module N_IMEM(
	input				CLOCK_50,
	input				rx,
	input				enable,
	input				button,
	input	[7:0]		address,
	output[31:0]	out_instruction
//	output [7:0]		LEDR,
//	output reg[0:0]		LEDG
	);
	
	reg	[31:0]	instruction[0:255];
	reg	[7:0]		nIns = 0;
	reg	[7:0]		newByte;
	wire	[7:0]		getNewByte;
	wire				isNewByte;
	reg	[3:0]		state;
//	reg	[3:0]		sel = 4'b0000;
	
//	assign button	=	KEY[1];
//	assign LEDR = instruction[7:0];
	
	uart_rx			_uart_rx(CLOCK_50,rx,isNewByte,getNewByte);
	assign out_instruction = instruction[address];
	
//	always@(posedge button) begin
//		if(sel<3)
//			sel <= sel + 1;
//		else
//			sel <= 0;
//	end
	
//	initial begin
//		LEDG[0] = 0;
//	end
	
//	assign LEDR[7:0] = 	(sel==2'd0) ? instruction[0][31:24] : 
//								(sel==2'd1) ? instruction[0][23:16] :
//								(sel==2'd2) ? instruction[0][15:8]  :
//								instruction[0][7:0];
	
//	always@(posedge KEY[0]) begin
//		instruction <= 0;
//	end
	
	always@(posedge isNewByte, negedge button) begin
		if(button==0) begin
			nIns <= 0;
		end else
		if(enable) begin
					if(state == 4'b0000)
				begin
					instruction[nIns][31:24] <= getNewByte;
					state <= 4'b0001;
				end
			else if(state == 4'b0001)
				begin
					instruction[nIns][23:16] <= getNewByte;
					state <= 4'b0010;
				end
			else if(state == 4'b0010)
				begin
					instruction[nIns][15:8] <= getNewByte;
					state <= 4'b0011;
				end
			else if(state == 4'b0011)
				begin
					instruction[nIns][7:0] <= getNewByte;
					//LEDR <= newByte;
					state <= 4'b0000;
					nIns <= nIns + 1;
				end
			else
				begin
					state <= 4'b0000;
				end
		end
	end
	
//	always@(newByte) begin
//			if(state == 4'b0000)
//				begin
//					instruction[31:24] = newByte;
//					state = 4'b0001;
//				end
//			else if(state == 4'b0001)
//				begin
//					instruction[23:16] = newByte;
//					state = 4'b0010;
//				end
//			else if(state == 4'b0010)
//				begin
//					instruction[15:8] = newByte;
//					state = 4'b0011;
//				end
//			else if(state == 4'b0011)
//				begin
//					instruction[7:0] = newByte;
//					LEDR = newByte;
//					LEDG[0] = 1;
//					state = 4'b0000;
//				end
//			else
//				begin
//					state = 4'b0000;
//				end

//	end

endmodule
