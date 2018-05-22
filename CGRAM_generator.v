module CGRAM_generator( 
	output reg [11:0] DATA, 
	output reg EN_out,
	input EN, 
	input rdy
);
	
	parameter [7:0]
		khoang_trang = 8'b00100000;		
		
	parameter [3:0] 
		clear = 4'b0000,
		write = 4'b0001,
		setcg = 4'b0010,
		setad = 4'b0011,
		wait1 = 4'b1111,
		wait2 = 4'b0100;
		
/////////////////////////////////SET_CHAR///////////////////////////////////////////////////		
	parameter [7:0]
		char_0_0 = 8'b000_00000,
		char_0_1 = 8'b000_00000,
		char_0_2 = 8'b000_00100,
		char_0_3 = 8'b000_00000,
		char_0_4 = 8'b000_00000,
		char_0_5 = 8'b000_00000,
		char_0_6 = 8'b000_00000,
		char_0_7 = 8'b000_00000;
		
	parameter [7:0]
		char_1_0 = 8'b000_00011,
		char_1_1 = 8'b000_00011,
		char_1_2 = 8'b000_00100,
		char_1_3 = 8'b000_11000,
		char_1_4 = 8'b000_00000,
		char_1_5 = 8'b000_00000,
		char_1_6 = 8'b000_00000,
		char_1_7 = 8'b000_00000;
		
	parameter [7:0]
		char_2_0 = 8'b000_00100,
		char_2_1 = 8'b000_00000,
		char_2_2 = 8'b000_01111,
		char_2_3 = 8'b000_01110,
		char_2_4 = 8'b000_01110,
		char_2_5 = 8'b000_01001,
		char_2_6 = 8'b000_10001,
		char_2_7 = 8'b000_00000;
		
	parameter [7:0]
		char_3_0 = 8'b000_00000,
		char_3_1 = 8'b000_00000,
		char_3_2 = 8'b000_00000,
		char_3_3 = 8'b000_00000,
		char_3_4 = 8'b000_00100,
		char_3_5 = 8'b000_00000,
		char_3_6 = 8'b000_00000,
		char_3_7 = 8'b000_00000;
		
	parameter [7:0]
		char_4_0 = 8'b000_00000,
		char_4_1 = 8'b000_00000,
		char_4_2 = 8'b000_00000,
		char_4_3 = 8'b000_00000,
		char_4_4 = 8'b000_00000,
		char_4_5 = 8'b000_00000,
		char_4_6 = 8'b000_00100,
		char_4_7 = 8'b000_00000;
		
		
	parameter [7:0]
		char_5_0 = 8'b000_00100,
		char_5_1 = 8'b000_00000,
		char_5_2 = 8'b000_00000,
		char_5_3 = 8'b000_00000,
		char_5_4 = 8'b000_00000,
		char_5_5 = 8'b000_00000,
		char_5_6 = 8'b000_00000,
		char_5_7 = 8'b000_00000;
		
	parameter [7:0]
		char_6_0 = 8'b000_11000,
		char_6_1 = 8'b000_11000,
		char_6_2 = 8'b000_00100,
		char_6_3 = 8'b000_00011,
		char_6_4 = 8'b000_00000,
		char_6_5 = 8'b000_00000,
		char_6_6 = 8'b000_00000,
		char_6_7 = 8'b000_00000;
		
	parameter [7:0]
		char_7_0 = 8'b000_00100,
		char_7_1 = 8'b000_00000,
		char_7_2 = 8'b000_11110,
		char_7_3 = 8'b000_01110,
		char_7_4 = 8'b000_01110,
		char_7_5 = 8'b000_10010,
		char_7_6 = 8'b000_10001,
		char_7_7 = 8'b000_00000;
/////////////////////////////////////////////////////////////////////////////////////////////////
	reg [3:0]state;
	reg [7:0]substate;
	
	initial EN_out = 1'b0;

	always@(posedge rdy) begin
		if(EN) begin
		case(state)
		0: begin
			case (substate)
			0:		begin substate <= substate + 1 ;DATA 	<= {setcg, 8'd00};		end
			1: 	begin substate <= substate + 1 ;DATA 	<= {write, char_0_0};	end
			2: 	begin substate <= substate + 1 ;DATA 	<= {write, char_0_1};	end
			3: 	begin substate <= substate + 1 ;DATA 	<= {write, char_0_2};	end
			4: 	begin substate <= substate + 1 ;DATA 	<= {write, char_0_3};	end
			5: 	begin substate <= substate + 1 ;DATA 	<= {write, char_0_4};	end
			6: 	begin substate <= substate + 1 ;DATA 	<= {write, char_0_5};	end
			7: 	begin substate <= substate + 1 ;DATA 	<= {write, char_0_6};	end
			8: 	begin substate <= substate + 1 ;DATA 	<= {write, char_0_7};	end
			9: 	begin substate <= substate + 1 ;DATA 	<= {write, char_1_0};	end
			10: 	begin substate <= substate + 1 ;DATA 	<= {write, char_1_1};	end
			11: 	begin substate <= substate + 1 ;DATA 	<= {write, char_1_2};	end
			12: 	begin substate <= substate + 1 ;DATA 	<= {write, char_1_3};	end
			13: 	begin substate <= substate + 1 ;DATA 	<= {write, char_1_4};	end
			14: 	begin substate <= substate + 1 ;DATA 	<= {write, char_1_5};	end
			15: 	begin substate <= substate + 1 ;DATA 	<= {write, char_1_6};	end
			16: 	begin substate <= substate + 1 ;DATA 	<= {write, char_1_7};	end
			17: 	begin substate <= substate + 1 ;DATA 	<= {write, char_2_0};	end
			18: 	begin substate <= substate + 1 ;DATA 	<= {write, char_2_1};	end
			19: 	begin substate <= substate + 1 ;DATA 	<= {write, char_2_2};	end
			20: 	begin substate <= substate + 1 ;DATA 	<= {write, char_2_3};	end
			21: 	begin substate <= substate + 1 ;DATA 	<= {write, char_2_4};	end
			22	:	begin substate <= substate + 1 ;DATA 	<= {write, char_2_5};	end
			23	:	begin substate <= substate + 1 ;DATA 	<= {write, char_2_6};	end
			24	:	begin substate <= substate + 1 ;DATA 	<= {write, char_2_7};	end
			25	:	begin substate <= substate + 1 ;DATA 	<= {write, char_3_0};	end
			26 :	begin substate <= substate + 1 ;DATA 	<= {write, char_3_1};	end
			27 :	begin substate <= substate + 1 ;DATA 	<= {write, char_3_2};	end
			28	:	begin substate <= substate + 1 ;DATA 	<= {write, char_3_3};	end
			29	:	begin substate <= substate + 1 ;DATA 	<= {write, char_3_4};	end
			30	:	begin substate <= substate + 1 ;DATA 	<= {write, char_3_5};	end
			31	:	begin substate <= substate + 1 ;DATA 	<= {write, char_3_6};	end
			32	: 	begin substate <= substate + 1 ;DATA 	<= {write, char_3_7};	end
			33	:	begin substate <= substate + 1 ;DATA  	<= {write, char_4_0};	end
			34	:	begin substate <= substate + 1 ;DATA  	<= {write, char_4_1};	end
			35	:	begin substate <= substate + 1 ;DATA  	<= {write, char_4_2};	end
			36	:	begin substate <= substate + 1 ;DATA  	<= {write, char_4_3};	end
			37	:	begin substate <= substate + 1 ;DATA  	<= {write, char_4_4};	end
			38	:	begin substate <= substate + 1 ;DATA  	<= {write, char_4_5};	end
			39	:	begin substate <= substate + 1 ;DATA  	<= {write, char_4_6};	end
			40	:	begin substate <= substate + 1 ;DATA  	<= {write, char_4_7};	end
			41	:	begin substate <= substate + 1 ;DATA  	<= {write, char_5_0};	end
			42	:	begin substate <= substate + 1 ;DATA  	<= {write, char_5_1};	end
			43	:	begin substate <= substate + 1 ;DATA  	<= {write, char_5_2};	end
			44	:	begin substate <= substate + 1 ;DATA  	<= {write, char_5_3};	end
			45	:	begin substate <= substate + 1 ;DATA  	<= {write, char_5_4};	end
			46	:	begin substate <= substate + 1 ;DATA  	<= {write, char_5_5};	end
			47	:	begin substate <= substate + 1 ;DATA  	<= {write, char_5_6};	end
			48	:	begin substate <= substate + 1 ;DATA  	<= {write, char_5_7};	end
			49	:	begin substate <= substate + 1 ;DATA  	<= {write, char_6_0};	end
			50	:	begin substate <= substate + 1 ;DATA  	<= {write, char_6_1};	end
			51	:	begin substate <= substate + 1 ;DATA  	<= {write, char_6_2};	end
			52	:	begin substate <= substate + 1 ;DATA  	<= {write, char_6_3};	end
			53	:	begin substate <= substate + 1 ;DATA  	<= {write, char_6_4};	end
			54	:	begin substate <= substate + 1 ;DATA  	<= {write, char_6_5};	end
			55	:	begin substate <= substate + 1 ;DATA  	<= {write, char_6_6};	end
			56	:	begin substate <= substate + 1 ;DATA  	<= {write, char_6_7};	end
			57	:	begin substate <= substate + 1 ;DATA  	<= {write, char_7_0};	end
			58	:	begin substate <= substate + 1 ;DATA  	<= {write, char_7_1};	end
			59	:	begin substate <= substate + 1 ;DATA  	<= {write, char_7_2};	end
			60	:	begin substate <= substate + 1 ;DATA  	<= {write, char_7_3};	end
			61	:	begin substate <= substate + 1 ;DATA  	<= {write, char_7_4};	end
			62	:	begin substate <= substate + 1 ;DATA  	<= {write, char_7_5};	end
			63	:	begin substate <= substate + 1 ;DATA  	<= {write, char_7_6};	end
			64	:	begin substate <= substate + 1 ;DATA  	<= {write, char_7_7};	end
			default : begin substate = 6'b0; state <= 1; DATA = {wait1,8'd00}; EN_out <= 1'b1; end
			endcase
		end
					
		default: DATA 	<= DATA;
		endcase
		end
	end
	
endmodule