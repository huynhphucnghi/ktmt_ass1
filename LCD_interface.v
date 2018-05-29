module LCD_interface(
		input		CLOCK_50,
		input 	[3:0] KEY,
		input 	[0:0] GPIO,
		input 	[11:0] SW,
		output 	[7:0] LCD_DATA,
		output	LCD_RS, LCD_RW, LCD_EN,
		output	[3:0] LEDR,
		output 	[1:0] LEDG,
		output 	[6:0] HEX0, HEX1, HEX2
);
	
	LCD_controller _LCD_controller(
		CLOCK_50, 
		!KEY[0], GPIO[0], KEY[3], KEY[1], KEY[2], SW[7:0], SW[11:8], 
		LCD_RS, LCD_RW, LCD_EN, LCD_DATA[7:0], LEDG[0], LEDG[1], LEDR[3:0], HEX0, HEX1, HEX2
	);
	
endmodule


