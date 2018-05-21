module LCD_interface(
		input		CLOCK_50,
		input 	[2:0] KEY,
		input 	[11:0] SW,
		output 	[7:0] LCD_DATA,
		output	LCD_RS, LCD_RW, LCD_EN,
		output	[3:0] LEDR,
		output 	[1:0] LEDG
);
	
	LCD_controller(
		CLOCK_50, 
		!KEY[0], !KEY[1], !KEY[2], SW[7:0], SW[11:8], 
		LCD_RS, LCD_RW, LCD_EN, LCD_DATA[7:0], LEDG[0], LEDG[1], LEDR[3:0]
	);
	
endmodule

