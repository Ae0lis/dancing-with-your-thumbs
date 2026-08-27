module Perf_Lights (clk, ddr_clk, reset, button, prev_red, Red, Grn, pts, flash, keepflash);
	input logic 			clk, ddr_clk, reset, button, flash, keepflash, prev_red;
	output logic 	[3:0] Red, Grn;
	output logic 			pts;

	enum { none, red, green, yellow } ps, ns;
	
	always_comb begin
		case (ps)
			none: 	begin
							Red = 4'b0000;
							Grn = 4'b0000;
							ns = yellow;
							pts = 0;
						end
						
			red:  	begin
							Red = 4'b1111;
							Grn = 4'b0000;
							ns = yellow;
							if(button) 	pts = 1;
							else 			pts = 0;
						end
						
			green:  	begin
							Red = 4'b0000;
							Grn = 4'b1111;
							if(~keepflash) ns = yellow;
							else 		  	 ns = green;
							pts = 0;
						end
						
			yellow: 	begin
							Red = 4'b1111;
							Grn = 4'b1111;
							if(prev_red && ~button) 	ns = red;
							else if (flash) 				ns = green;
							else 								ns = yellow;
							pts = 0;
						end
		endcase
	end
	
	always_ff @(posedge clk) begin
		if (reset)
			ps <= none;
		else if (ddr_clk)
			ps <= ns;
		else
			ps <= ps;
	end
endmodule

module perfect_lights_testbench();
	logic 		clk, ddr_clk, reset, button, prev_red, flash, keepflash, pts;
	logic [3:0] Red, Grn;
	
	logic [4:0] ticker;
	
	Perfect_Lights dut (clk, ddr_clk, reset, button, prev_red, Red, Grn, pts, flash, keepflash);
	
	// Set up a simulated clock system.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		ddr_clk <= 0;
		ticker <= 0;
		forever begin
			#(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
			if (ticker == 20) begin
				ticker <= 0;
				ddr_clk <= 1;
			end
			else begin 
				ticker <= ticker + 1;
				ddr_clk <= 0;
			end
		end
	end
	
	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
																									@(posedge clk);
		reset <= 1;	button <= 0; prev_red <= 0; flash <= 0; keepflash <= 0;	@(posedge clk); // Always reset FSMs at start
		reset <= 0;																				@(posedge clk);
		prev_red <= 1;											repeat(80)					@(posedge clk); // Turns red?
		button <= 1;											repeat(80)					@(posedge clk); // Button?
		prev_red <= 0; button <= 0; flash <= 1;		repeat(80)					@(posedge clk); // Flash?
		keepflash <= 1;										repeat(80)					@(posedge clk); // Hold flash?
		keepflash <= 0;										repeat(80)					@(posedge clk); // Stop flash?
																									@(posedge clk);
		$stop; // End the simulation.
	end
endmodule