module LCD_executor(
	CLK, ENB, RST, OP, DATA, LCD_RS, LCD_RW, LCD_E, LCD_DB, RDY
);
input CLK;
input ENB;				// Tells the module that the data is valid and start reading DATA and OPER
input RST;				// reset
input [3:0] OP;		// command from LCD_controller, can be write, read data,...
input [7:0] DATA;

output LCD_RS, LCD_RW, LCD_E;
output [7:0] LCD_DB;
output RDY;			// Indicates that the module is idle or not

wire ENB;
reg RDY = 0;

reg [7:0] LCD_DB=0;
reg LCD_RW;
reg LCD_RS;
reg LCD_E=0;

// Set flags
wire flag_250ns, flag_42us, flag_100us, flag_1640us, flag_4100us, flag_15000us, flag_2s, flag_250ms;
reg flag_rst = 1;
flag_controller flags(CLK, flag_rst, flag_250ns, flag_42us, flag_100us, flag_1640us, flag_4100us, flag_15000us, flag_2s, flag_250ms);



//------------------------------Define the BASIC Command Set-------------------------------------
// (Execution time: thoi gian thuc thi lenh)
parameter [7:0] SETUP		= 8'b00111000;		// 42us, sets to 8-bit interface, 2-line display, 5x7 dots
parameter [7:0] DISP_ON		= 8'b00001100;		// 42us, Turn ON Display
parameter [7:0] ALL_ON		= 8'b00001111;		// 42us, Turn ON All Display
parameter [7:0] ALL_OFF		= 8'b00001000;		// 42us, Turn OFF All Display
parameter [7:0] CLEAR 		= 8'b00000001; 	// 1.64ms, Clear Display
parameter [7:0] ENTRY_N		= 8'b00000110;		// 42us, Normal Entry, Cursor increments, Display is not shifted
parameter [7:0] HOME 		= 8'b00000010; 	// 1.64ms, Return Home
parameter [7:0] C_SHIFT_L 	= 8'b00010000; 	// 42us, Cursor Shift
parameter [7:0] C_SHIFT_R 	= 8'b00010100; 	// 42us, Cursor Shift
parameter [7:0] D_SHIFT_L 	= 8'b00011000; 	// 42us, Display Shift
parameter [7:0] D_SHIFT_R 	= 8'b00011100; 	// 42us, Display Shift
parameter [7:0] SET_CGRAM_ADD = 8'b01000000; // 42us, Set CGRAM address



//-----------------------------Create the FSM------------------------------------

reg [7:0] STATE=0;
reg [1:0] SUBSTATE=0;

always @(posedge CLK) begin
	if(ENB)
	case(STATE)
		//---------------------------------------------------------------------------------------
		0: begin //---------------Initiate Command Sequence (RS=LOW)-----------------------------
			LCD_RS	<=		1'b0;
			LCD_RW	<= 	1'b0;
			LCD_E		<=		1'b0;
			LCD_DB 	<= 	8'b00000000;
			RDY					<= 1'b0;
			SUBSTATE	<=		0;
			if(!flag_15000us) begin									//WAIT 15ms...worst case scenario
				STATE				<=	STATE;
				flag_rst			<=	1'b0;
			end
			else begin 				
				STATE				<=	1;
				flag_rst			<=	1'b1;
			end		
		end
		//---------------------------------------------------------------------------------------
		1: begin //-----------SET FUNCTION #1, 8-bit interface, 2-line display, 5x7 dots---------
			LCD_RS				<=	1'b0;
			LCD_RW				<=	1'b0;
			RDY					<= 1'b0;
			if(SUBSTATE==0)begin	 		
				LCD_E				<=	1'b0;
				LCD_DB 			<=	LCD_DB;
				STATE				<=	STATE;					
				SUBSTATE			<=	1;
			end			
			if(SUBSTATE==1)begin				
				LCD_E				<=	1'b1;						
				LCD_DB 			<= SETUP;					
				if(!flag_250ns) begin						
					SUBSTATE		<=	SUBSTATE;				
					flag_rst		<=	1'b0; 									
				end
				else begin 				
					SUBSTATE		<=	SUBSTATE+1'b1;				
					flag_rst		<=	1'b1; 					
				end
			end
			if(SUBSTATE==2)begin
				LCD_E				<=	1'b0;						
				LCD_DB 			<= LCD_DB;					
				if(!flag_4100us) begin						
					STATE			<=	STATE;					
					SUBSTATE		<=	SUBSTATE;				
					flag_rst		<=	1'b0; 													
				end
				else begin 		
					STATE			<=	2;					
					SUBSTATE		<=	0;							
					flag_rst		<=	1'b1; 					
				end
			end	
		end
		//---------------------------------------------------------------------------------------
		2: begin //---------Normal ENTRY, Cursor increments, Display is not shifted--------------
			LCD_RS				<=	1'b0;						
			LCD_RW				<=	1'b0;						
			RDY					<= 1'b0;						
			if(SUBSTATE==0)begin	 		
				LCD_E				<=	1'b0;						
				LCD_DB 			<=	LCD_DB;					
				STATE				<=	STATE;				
				SUBSTATE			<=	1;
			end			
			if(SUBSTATE==1)begin				
				LCD_E				<=	1'b1;						
				LCD_DB 			<= ENTRY_N;					
				if(!flag_250ns) begin						
					SUBSTATE		<=	SUBSTATE;				
					flag_rst		<=	1'b0; 					
				end
				else begin 				
					SUBSTATE		<=	SUBSTATE+1'b1;				
					flag_rst		<=	1'b1; 					
				end
			end
			if(SUBSTATE==2)begin
				LCD_E				<=	1'b0;						
				LCD_DB 			<= LCD_DB;					
				if(!flag_42us) begin							
					STATE			<=	STATE;					
					SUBSTATE		<=	SUBSTATE;				
					flag_rst		<=	1'b0; 													
				end
				else begin 		
					STATE			<=	3;					
					SUBSTATE		<=	0;							
					flag_rst		<=	1'b1; 					
				end
			end
		end
		//---------------------------------------------------------------------------------------
		3: begin //-----------------DISPLAY, Display ON, Cursor ON, Blinking ON------------------
			LCD_RS				<=	1'b0;						
			LCD_RW				<=	1'b0;						
			RDY					<= 1'b0;						
			if(SUBSTATE==0)begin	 		
				LCD_E				<=	1'b0;						
				LCD_DB 			<=	LCD_DB;					
				STATE				<=	STATE;				
				SUBSTATE			<=	1;
			end			
			if(SUBSTATE==1)begin				
				LCD_E				<=	1'b1;						
				LCD_DB 			<= DISP_ON;//ALL_ON;		
				if(!flag_250ns) begin						
					SUBSTATE		<=	SUBSTATE;				
					flag_rst		<=	1'b0; 					
				end
				else begin 				
					SUBSTATE		<=	SUBSTATE+1'b1;				
					flag_rst		<=	1'b1; 					
				end
			end
			if(SUBSTATE==2)begin
				LCD_E				<=	1'b0;						
				LCD_DB 			<= LCD_DB;					
				if(!flag_42us) begin							
					STATE			<=	STATE;					
					SUBSTATE		<=	SUBSTATE;				
					flag_rst		<=	1'b0; 													
				end
				else begin 		
					STATE			<=	4;					
					SUBSTATE		<=	0;							
					flag_rst		<=	1'b1; 					
				end
			end
		end
		//---------------------------------------------------------------------------------------
		4: begin //-------------------DISPLAY CLEAR, clear the display screen--------------------		
			LCD_RS				<=	1'b0;						
			LCD_RW				<=	1'b0;						
			RDY					<= 1'b0;						
			if(SUBSTATE==0)begin	 		
				LCD_E				<=	1'b0;						
				LCD_DB 			<=	LCD_DB;					
				STATE				<=	STATE;				
				SUBSTATE			<=	1;
			end			
			if(SUBSTATE==1)begin				
				LCD_E				<=	1'b1;						
				LCD_DB 			<= CLEAR;					
				if(!flag_250ns) begin						
					SUBSTATE		<=	SUBSTATE;				
					flag_rst		<=	1'b0; 					
				end
				else begin 				
					SUBSTATE		<=	SUBSTATE+1'b1;				
					flag_rst		<=	1'b1; 					
				end
			end
			if(SUBSTATE==2)begin
				LCD_E				<=	1'b0;						
				LCD_DB 			<= LCD_DB;					
				if(!flag_4100us) begin						
					STATE			<=	STATE;					
					SUBSTATE		<=	SUBSTATE;
					flag_rst		<=	1'b0;
				end
				else begin 		
					STATE			<=	15;
					SUBSTATE		<=	0;
					flag_rst		<=	1'b1;
				end
			end
		end
		//---------------------------------------------------------------------------------------
		5: begin//----------------------------- WRITE DATA -------------------------------------
			LCD_RS				<=	1'b1;						//Indicate an instruction is to be sent soon
			LCD_RW				<=	1'b0;						//Indicate a write operation	
			RDY					<= 1'b0;						//Indicate that the module is busy
			if(SUBSTATE==0)begin	 		
				LCD_E				<=	1'b0;						//Disable Bus
				LCD_DB 			<=	LCD_DB;					//Maintain Previous Data on the Bus
				STATE				<=	STATE;				
				SUBSTATE			<=	1;
			end			
			if(SUBSTATE==1)begin				
				LCD_E				<=	1'b1;						//Enable Bus		
				LCD_DB 			<= DATA;						//WRITE THE CHARACTER
				if(!flag_250ns) begin						//WAIT at least 250ns (required for LCD_E)
					SUBSTATE		<=	SUBSTATE;				//Maintain current SUBSTATE
					flag_rst		<=	1'b0; 					//Start or Continue counting									
				end
				else begin 				
					SUBSTATE		<=	SUBSTATE+1'b1;				//Go to next SUBSTATE
					flag_rst		<=	1'b1; 					//Stop counting					
				end
			end
			if(SUBSTATE==2)begin
				LCD_E				<=	1'b0;						//Disable Bus, Triggers LCD to read BUS
				LCD_DB 			<= LCD_DB;					//Keep Data Valid
				if(!flag_42us) begin						//WAIT at least 250ns (required for LCD_E)
					STATE			<=	STATE;					//Maintain current STATE
					SUBSTATE		<=	SUBSTATE;				//Maintain current SUBSTATE
					flag_rst		<=	1'b0; 					//Start or Continue counting									
				end
				else begin 		
					STATE			<=	15;
					SUBSTATE		<=	0;
					flag_rst		<=	1'b1;
				end
			end		
		end
		//---------------------------------------------------------------------------------------
		6: begin//----------------------------- SET CGRAM ADDRESS -------------------------------------
			LCD_RS				<=	1'b0;						
			LCD_RW				<=	1'b0;						
			RDY					<= 1'b0;						
			if(SUBSTATE==0)begin	 		
				LCD_E				<=	1'b0;						
				LCD_DB 			<=	LCD_DB;
				STATE				<=	STATE;
				SUBSTATE			<=	1;
			end			
			if(SUBSTATE==1)begin				
				LCD_E				<=	1'b1;						
				LCD_DB 			<= SET_CGRAM_ADD;					
				if(!flag_250ns) begin						
					SUBSTATE		<=	SUBSTATE;				
					flag_rst		<=	1'b0;
				end
				else begin 				
					SUBSTATE		<=	SUBSTATE+1'b1;				
					flag_rst		<=	1'b1;
				end
			end
			if(SUBSTATE==2)begin
				LCD_E				<=	1'b0;						
				LCD_DB 			<= LCD_DB;					
				if(!flag_42us) begin					
					STATE			<=	STATE;					
					SUBSTATE		<=	SUBSTATE;				
					flag_rst		<=	1'b0; 								
				end
				else begin 		
					STATE			<=	15;
					SUBSTATE		<=	0;
					flag_rst		<=	1'b1;
				end
			end		
		end
		//---------------------------------------------------------------------------------------
		7: begin//----------------------------- SET DDRAM ADDRESS -------------------------------------
			LCD_RS				<=	1'b0;						
			LCD_RW				<=	1'b0;						
			RDY					<= 1'b0;						
			if(SUBSTATE==0)begin	 		
				LCD_E				<=	1'b0;						
				LCD_DB 			<=	LCD_DB;
				STATE				<=	STATE;
				SUBSTATE			<=	1;
			end			
			if(SUBSTATE==1)begin				
				LCD_E				<=	1'b1;						
				LCD_DB 			<= {1'b1, DATA[6:0]};						
				if(!flag_250ns) begin						
					SUBSTATE		<=	SUBSTATE;				
					flag_rst		<=	1'b0;
				end
				else begin 				
					SUBSTATE		<=	SUBSTATE+1'b1;				
					flag_rst		<=	1'b1;
				end
			end
			if(SUBSTATE==2)begin
				LCD_E				<=	1'b0;						
				LCD_DB 			<= LCD_DB;					
				if(!flag_42us) begin					
					STATE			<=	STATE;					
					SUBSTATE		<=	SUBSTATE;				
					flag_rst		<=	1'b0; 								
				end
				else begin 		
					STATE			<=	15;
					SUBSTATE		<=	0;
					flag_rst		<=	1'b1;
				end
			end		
		end
		//---------------------------------------------------------------------------------------
		8: begin//----------------------------- WAIT 2 SECONDs -------------------------------------
			LCD_RS				<=	LCD_RS;						
			LCD_RW				<=	LCD_RW;						
			RDY					<= 1'b0;		
			LCD_E				<=	1'b0;						
			LCD_DB 			<= LCD_DB;					
			if(!flag_2s) begin					
				STATE			<=	STATE;					
				flag_rst		<=	1'b0; 								
			end
			else begin 		
				STATE			<=	15;
				flag_rst		<=	1'b1;
			end	
		end
		9: begin
			LCD_RS				<=	LCD_RS;						
			LCD_RW				<=	LCD_RW;						
			RDY					<= 1'b0;
			if(RST==0)
				STATE <= 0;
			else case(OP)
				0: STATE <= 4;		// clear display
				1: STATE <= 5;		// write data
				2: STATE <= 6;		// set CGRAM address
				3: STATE <= 7;		// set DDRAM address
				4: STATE <= 8;		// wait 2 seconds
				15: STATE <= 15;	// return to default
				default: STATE <= STATE;
			endcase
		end
		//---------------------------------------------------------------------------------------
		default: begin
			LCD_RS	<=		LCD_RS;
			LCD_RW	<= 	LCD_RW;
			LCD_DB 	<= 	LCD_DB;
			LCD_E		<=		1'b0;
			RDY		<=		1'b1;
			STATE <= 9;
		end
	endcase
end
endmodule