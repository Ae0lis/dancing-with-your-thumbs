module counter_10 (clk, reset, increment, decrement, out, overflow);
	input logic 			clk, reset, increment, decrement;
	output logic 			overflow;
	output logic 	[3:0] out;
	
	logic 			[3:0] ns;
	
	always_comb begin
		if ((increment && decrement) | (~increment && ~decrement)) begin
		
															ns = out;
															overflow = 0;
		end
		else if(increment & out != 4'b1001) 	begin
		
															ns = (out + 4'b0001);
															overflow = 0;
		end
		else if (decrement & out != 4'b0000) 	begin
		
															ns = (out + 4'b1111);
															overflow = 0;
		end													
		else if (increment)							begin
		
															ns = 4'b0000;
															overflow = 1;
		end
		else 												begin
															ns = 4'b1001;
															overflow = 1;
		end
	end
	
	always_ff @(posedge clk) begin
		if (reset)
			out <= 0;
		else
			out <= ns;
	end
endmodule

module counter_10_testbench();
	logic clk, reset, increment, decrement, overflow;
	logic [3:0] out;
	
	counter_10 dut (.clk, .reset, .increment, .decrement, .out, .overflow);
	
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
																		@(posedge clk);
		reset <= 1;	increment <= 0; decrement <= 0;		@(posedge clk); // Always reset FSMs at start
		reset <= 0;													@(posedge clk);
		increment <= 1;		repeat(3)						@(posedge clk);
		increment <= 0;											@(posedge clk);
		increment <= 1;		repeat(12)						@(posedge clk);
		decrement <= 1;		repeat(2)						@(posedge clk);
		increment <= 0;		repeat(12)						@(posedge clk);
																		@(posedge clk);
		$stop; // End the simulation.
	end
endmodule