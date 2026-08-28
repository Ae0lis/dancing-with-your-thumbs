// Takes in 4 3 digit score values in 2's comp and updates the currently held score (a value from 0-99) by that number. Will not go below 0.
module Score_Update (clk, ddr_clk, reset, scoreC1, scoreC2, scoreC3, scoreC4, update);
	input  logic 		 clk, ddr_clk, reset;
	input  logic [2:0] scoreC1, scoreC2, scoreC3, scoreC4;
	output logic [4:0] update;
	
	logic [4:0] paddedC1, paddedC2, paddedC3, paddedC4, ns;
	
	always_comb begin
		// Pad the scores so they add properly as 2's comp numbers
		paddedC1[2:0] = scoreC1;
		paddedC1[4:3] = { scoreC1[2], scoreC1[2] };
		
		paddedC2[2:0] = scoreC2;
		paddedC2[4:3] = { scoreC2[2], scoreC2[2] };
		
		paddedC3[2:0] = scoreC3;
		paddedC3[4:3] = { scoreC3[2], scoreC3[2] };
		
		paddedC4[2:0] = scoreC4;
		paddedC4[4:3] = { scoreC4[2], scoreC4[2] };
		
		// Calculate the total change across all columns
		ns = paddedC1 + paddedC2 + paddedC3 + paddedC4;
	end
		
	always_ff @(posedge clk) begin
		if(reset) 			update <= 0;
		else if(ddr_clk) 	update <= ns;
		else					update <= update;
	end
endmodule

module score_update_testbench();
	logic 		reset, clk, ddr_clk;
	logic [2:0] scoreC1, scoreC2, scoreC3, scoreC4;
	logic [4:0] update, ticker;
	
	Score_Update dut (clk, ddr_clk, reset, scoreC1, scoreC2, scoreC3, scoreC4, update);
	
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
		reset <= 1; scoreC1 <= 5'b00000; scoreC2 <= 5'b00000;		scoreC3 <= 5'b00000;		scoreC4 <= 5'b00000; 	@(posedge clk)
		reset <= 0; 																															@(posedge clk)
		scoreC1 <= 5'b00001; scoreC2 <= 5'b00000;		scoreC3 <= 5'b00000;		scoreC4 <= 5'b00000;		repeat(40)	@(posedge clk); // +1
		scoreC1 <= 5'b00010;																									repeat(40)	@(posedge clk); // +2
		scoreC1 <= 5'b11110;																									repeat(40)	@(posedge clk); // -2
		scoreC1 <= 5'b00010;		scoreC2 <= 5'b00010;		scoreC3 <= 5'b00010;		scoreC4 <= 5'b00010;	repeat(40)	@(posedge clk); // +8
		scoreC1 <= 5'b11110; 	scoreC2 <= 5'b11110;		scoreC3 <= 5'b11110;		scoreC4 <= 5'b11110;	repeat(40)	@(posedge clk); // -8
		scoreC1 <= 5'b00010;		scoreC2 <= 5'b00000;		scoreC3 <= 5'b00010;		scoreC4 <= 5'b00010;	repeat(40)	@(posedge clk); // +6
																																					@(posedge clk);
		$stop; // End the simulation.
	end
endmodule
