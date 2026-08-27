module Top_Lights (clk, reset, button, Prev_Color, Red, Grn, pts, loss, flash, progress, endflash);
	input logic 			clk, reset, button, flash, progress, endflash;
	input logic 	[1:0] Prev_Color; // 00 = none, 01 = red, 10 = green, 11 = yellow
	output logic 	[3:0] Red, Grn; 		// 00 = none, 01 = red, 10 = green, 11 = yellow
	output logic 			pts, loss;

	logic pressed;

	enum { none, red, green, yellow } ps, ns;
	
	always_comb begin
		case (ps)
			none: 	begin
							Red = 4'b0000;
							Grn = 4'b0000;
							ns = green;
							pts = 0;
							loss = 0;
						end
						
			red:  	begin
							Red = 4'b1111;
							Grn = 4'b0000;
							if(progress) begin
								ns = green;
								if(pressed) 
								begin 
									pts = 1;
									loss = 0;
								end
								else 
								begin
									loss = 1;
									pts = 0;
								end
							end
							else begin
								ns = red;
								pts = 0;
								loss = 0;
							end
						end
						
			green:  	begin
							Red = 4'b0000;
							Grn = 4'b1111;
							if(Prev_Color == 2'b01 && ~pressed && progress) 	ns = red;
							else if (flash) 							ns = yellow;
							else 											ns = green;
							pts = 0;
							loss = 0;
						end
						
			yellow: 	begin
							Red = 4'b1111;
							Grn = 4'b1111;
							if(endflash)	ns = green;
							else 			ns = yellow;
							pts = 0;
							loss = 0;
						end
		endcase
	end
	
	always_latch begin
		if(ps == red || Prev_Color == 2'b01) begin
			if(button) pressed = 1;
		end
		else pressed = 0;
	end
	
	always_ff @(posedge clk) begin
		if (reset)
			ps <= none;
		else
			ps <= ns;
	end
endmodule
