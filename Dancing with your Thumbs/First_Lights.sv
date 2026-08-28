module First_Lights (clk, ddr_clk, reset, button, Red, Grn, loss, anyRed, seed);
	input logic 			clk, ddr_clk, reset, button, anyRed;
	input logic  	[9:0] seed;
	output logic 	[3:0] Red, Grn;
	output logic 			loss;

	enum { none, red } ps, ns;
	logic [9:0] bobotplay;
	LFSR10_Seeded bobot(.clk, .reset, .out(bobotplay), .seed);
	
	logic bobotMove;
	Stupid_Comparator comp (.A(10'b0010000000), .B(bobotplay), .out(bobotMove));
	
	always_comb begin
		case (ps)
			none: 	begin
							Red = 4'b0000;
							Grn = 4'b0000;
							if(bobotMove & ~anyRed) 	ns = red;
							else 								ns = none;
							loss = 0;
						end
						
			red:  	begin
							Red = 4'b1111;
							Grn = 4'b0000;
							ns = none;
							if (button) 					loss = 1;
							else 								loss = 0;
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

module first_lights_testbench();
	logic clk, ddr_clk, reset, button, loss, anyRed;
	logic [3:0] Red, Grn;
	logic [4:0] ticker;
	
	First_Lights dut (.clk, .ddr_clk, .reset, .button, .Red, .Grn, .loss, .anyRed, .seed( )); // Seed tested in LFSR testbench
	
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
		reset <= 1;	anyRed <= 0; button <= 0;	@(posedge clk); // Always reset FSMs at start
		reset <= 0;						repeat(200)	@(posedge clk); // Go a while
		anyRed <= 1;					repeat(200)	@(posedge clk); // Supress new lights
		anyRed <= 0; button <= 1; 	repeat(200)	@(posedge clk); // Masher
															@(posedge clk);
		$stop; // End the simulation.
	end
endmodule