module LFSR10_Seeded (clk, reset, seed, out);
	input logic clk, reset;
	input logic  [9:0] seed;
	// when lightOn is true, the center light should be on.
	output logic [9:0] out;
	logic [9:0] ns;
	
	always_comb begin
		ns[8:0] = out[9:1];
		ns[9] = out[3] ~^ out[0];
	end
	
	// Flip flop to control the light's state
	always_ff @(posedge clk) begin
		if (reset)
			out <= seed;
		else
			out <= ns;
	end
endmodule

module lfsr10_testbench();
	logic clk, reset;
	logic [9:0] out, seed;
	
	LFSR10 dut (clk, reset, out, seed);
	
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
														@(posedge clk);
		reset <= 1;	seed <= 10'b0000000000;	@(posedge clk); // Always reset FSMs at start
		reset <= 0;									@(posedge clk);
		repeat(256)									@(posedge clk);
		reset <= 1;	seed <= 10'b1000000000;	@(posedge clk); // Check if seed is working
		reset <= 0;									@(posedge clk);
		repeat(256)									@(posedge clk);
														@(posedge clk);
		$stop; // End the simulation.
	end
endmodule