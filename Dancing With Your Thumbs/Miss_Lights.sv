module Miss_Lights (clk, ddr_clk, reset, button, prev_red, Red, Grn, loss);
	input logic 			clk, ddr_clk, reset, button, prev_red; // 0 = none, 1 = red
	output logic 	[3:0] Red, Grn;
	output logic 			loss;

	enum { none, red } ps, ns;
	
	always_comb begin
		case (ps)
			none: 	begin
							Red = 4'b0000;
							Grn = 4'b0000;
							if(prev_red && ~button) 	ns = red;
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

module miss_lights_testbench();
	logic 		clk, ddr_clk, reset, button, prev_red, loss;
	logic [3:0] Red, Grn;
	
	logic [4:0] ticker;
	
	Miss_Lights dut (clk, ddr_clk, reset, button, prev_red, Red, Grn, loss);
	
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
		reset <= 1;	button <= 0; prev_red <= 0; 	@(posedge clk); // Always reset FSMs at start
		reset <= 0;											@(posedge clk);
		prev_red <= 1;		repeat(80)					@(posedge clk); // Turns red?
		button <= 1;		repeat(80)					@(posedge clk); // Button?
		prev_red <= 0;		repeat(80)					@(posedge clk); // Miss penalty?
																@(posedge clk);
		$stop; // End the simulation.
	end
endmodule