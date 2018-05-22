module PC_register(
	input 		clk, reset, load,
	input [7:0] PC_load_val,
	input 		branch, stall,
	input [7:0] PC_next_val,
	output reg [7:0] 	PC
);

	initial begin
		PC = 8'b0;
	end
	
	always@(posedge clk, negedge reset) begin
		if(!reset) begin
			PC <= 8'b0;
		end
		else if(stall) begin
			PC <= PC;
		end
		else begin
			PC <= PC_next_val;
		end
	end
endmodule