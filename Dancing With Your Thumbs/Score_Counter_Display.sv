// Takes in the current score, quickly increments or decrements counters until they match.
module Score_Counter_Display (score, ddr_clk, clk, reset, HEX0, HEX1, HEX2, HEX3);
	input logic 			ddr_clk, clk, reset;
	input logic 	[4:0] score;
	output logic 	[6:0] HEX0, HEX1, HEX2, HEX3;
	
	logic [4:0] ps, ns;
	
	logic increment, decrement, botOverflow, lowOverflow, higOverflow, topOverflow, max;
	logic [3:0] bot, low, hig, top;
	logic [3:0] botnum, lownum, hignum, topnum;
	
	counter_10 botDigs 	(.clk, .reset, .increment, 								 .decrement, 								  .out(bot), .overflow(botOverflow));
	counter_10 lowDigs 	(.clk, .reset, .increment(increment & botOverflow), .decrement(decrement & botOverflow), .out(low), .overflow(lowOverflow));
	counter_10 higDigs 	(.clk, .reset, .increment(increment & lowOverflow), .decrement(decrement & lowOverflow), .out(hig), .overflow(higOverflow));
	counter_10 topDigs 	(.clk, .reset, .increment(increment & higOverflow), .decrement(decrement & higOverflow), .out(top), .overflow(topOverflow));
	
	seg7 botDisplay (.bcd(botnum), .leds(HEX0));
	seg7 lowDisplay (.bcd(lownum), .leds(HEX1));
	seg7 higDisplay (.bcd(hignum), .leds(HEX2));
	seg7 topDisplay (.bcd(topnum), .leds(HEX3));
	
	always_comb begin
		botnum = bot;
		lownum = low;
		hignum = hig;
		topnum = top;
		if(max) begin
			botnum = 4'b1001;
			lownum = 4'b1001;
			hignum = 4'b1001;
			topnum = 4'b1001;
		end
	end
	
	// Counter logic, takes a current value and slowly whittles it down to 0 while incrementing or decrementing the counter accordingly
	always_comb begin
		// If negative, decrement score and add 1 to the current value
		if (ps[4] == 1 && ({ bot, low, hig, top } != 16'b0000000000000000)) begin
			ns = ps + 5'b00001;
			increment = 0;
			decrement = 1;
		end
		// If positive, increment score and subtract 1 from the current value
		else if (ps != 5'b00000 & ps[4] == 0) begin
			ns = ps + 5'b11111;
			increment = 1;
			decrement = 0;
		end
		// Otherwise, do nothing
		else begin
			ns = ps;
			increment = 0;
			decrement = 0;
		end
	end
	
	always_ff @(posedge clk) begin
		if(reset) 			ps <= 5'b00000;
		else if (ddr_clk)	ps <= score;						
		else					ps <= ns;
		
		if(reset) 					max <= 0;
		else if (topOverflow) 	max <= 1;
		else							max <= max;
	end
endmodule

module score_counter_display_testbench();
	logic clk, ddr_clk, reset;
	logic [4:0] score, ticker;
	logic [6:0] HEX0, HEX1, HEX2, HEX3;
	
	Score_Counter_Display dut (score, ddr_clk, clk, reset, HEX0, HEX1, HEX2, HEX3);
	
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
		reset <= 1; score <= 0;					@(posedge clk); // Always reset FSMs at start
		reset <= 0;									@(posedge clk);
		score <= 5'b00001;	repeat(60) 		@(posedge clk); 	// +1
		score <= 5'b00010;	repeat(60) 		@(posedge clk); 	// +2
		score <= 5'b11110;	repeat(200) 	@(posedge clk); 	// -2, try to go below 0
		score <= 5'b00010;	repeat(120000) @(posedge clk); 	// +2 to try to overflow
														@(posedge clk);
		$stop; // End the simulation.
	end
	
endmodule