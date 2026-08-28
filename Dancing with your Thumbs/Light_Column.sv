module Light_Column (clk, ddr_clk, reset, button, RedPixels, GrnPixels, score, seed);
	input  logic 				 	clk, ddr_clk, reset, button;
	input  logic [9:0] 			seed;
   output logic [15:0][3:0] 	RedPixels; // 16x3 array of red LEDs
   output logic [15:0][3:0] 	GrnPixels; 
	output logic [2:0] 			score;
	
			 logic [13:0] 			loss;
			 logic 					good1, good0, perf, anyRed, keepflash;
	
	// Delay for flashes upon getting a good or perfect
	delay flashdelay (.start(perf | good1 | good0), .stay(keepflash), .clk, .ddr_clk, .reset);
	
	// Scoring lights
	Good_Lights  G1   (.clk, .ddr_clk, .reset, .button, .prev_red(~GrnPixels[1][0] & RedPixels[1][0]), .Red(RedPixels[0]),  .Grn(GrnPixels[0]), .pts(good1), .flash(perf), 			.keepflash, .loss(loss[13]));
	Perf_Lights  P	 	(.clk, .ddr_clk, .reset, .button, .prev_red(~GrnPixels[2][0] & RedPixels[2][0]), .Red(RedPixels[1]),  .Grn(GrnPixels[1]), .pts(perf),  .flash(good0 | good1), .keepflash);
	Good_Lights  G0   (.clk, .ddr_clk, .reset, .button, .prev_red(~GrnPixels[3][0] & RedPixels[3][0]), .Red(RedPixels[2]),  .Grn(GrnPixels[2]), .pts(good0), .flash(perf), 			.keepflash, .loss( ));
	
	// Body lights
	genvar i;
	generate
		for(i=0; i<12; i++) begin : mlights
			Miss_Lights ml (.clk, .ddr_clk, .reset, .button, .prev_red(RedPixels[i+4][0]), .Red(RedPixels[i+3]),  .Grn(GrnPixels[i+3]), .loss(loss[i]));
		end
	endgenerate
	
	// Bottom lights
	First_Lights F 	(.clk, .ddr_clk, .reset, .button, .Red(RedPixels[15]), .Grn(GrnPixels[15]), .loss(loss[12]), .anyRed, .seed);
	
	// Check if any lights are currently red or if the system is currently flashing. Used to supress new lights.
	assign anyRed = RedPixels[15][0] | RedPixels[14][0] | RedPixels[13][0] | RedPixels[12][0] | RedPixels[11][0] | RedPixels[10][0] | RedPixels[9][0] | 
						 RedPixels[8][0]  | RedPixels[7][0]  | RedPixels[6][0]  | RedPixels[5][0]  | RedPixels[4][0]  | RedPixels[3][0]  |
						 (RedPixels[2][0] & ~GrnPixels[2][0]) | (RedPixels[1][0] & ~GrnPixels[1][0]) | (RedPixels[0][0] & ~GrnPixels[0][0]) | 
						 perf | good1 |good0 | keepflash;

	// Output logic					 
	always_comb begin
		if		  (loss != 14'b00000000000000) 	score = 3'b110; // -2 (loss is true at some value)
		else if (good0 | good1) 					score = 3'b001; // +1
		else if (perf) 								score = 3'b010; // +2
		else												score = 3'b000; // +0
	end
endmodule

module light_column_testbench();
	logic 					clk, ddr_clk, reset, button;
	logic [15:0][3:0] 	RedPixels, GrnPixels;
	logic [2:0] 			score;
	logic [4:0] 			ticker;
	
	Light_Column dut (clk, reset, button, RedPixels, GrnPixels, score);
	
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
		reset <= 1;		@(posedge clk); // Always reset FSMs at start
		reset <= 0;		@(posedge clk);
		repeat(1024)	@(posedge clk); // Just go a while (button behavior checked in light testbenches)
							@(posedge clk);
		$stop; // End the simulation.
	end
endmodule
