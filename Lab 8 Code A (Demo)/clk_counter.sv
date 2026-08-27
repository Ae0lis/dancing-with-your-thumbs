// Takes in a clk cycle (designed for 1526 Hz) and activates an enable signal at a division based on difficulty.
// These are: 6Hz, 12Hz, 18Hz, and 24Hz for 00, 01, 10, and 11, respectively.
module clk_counter (clk, reset, difficulty, ddr_clk);
	input logic clk, reset;
	input logic [1:0] difficulty;
	output logic ddr_clk;
	
	logic [7:0] ticker, ns;
	
	always_comb begin
		if(ticker == 8'b11111110) begin
			case(difficulty)
				2'b00: ns <= 8'b00000000;
				2'b01: ns <= 8'b01111111;
				2'b10: ns <= 8'b10101001;
				2'b11: ns <= 8'b10111110;
			endcase
			ddr_clk = 1;
		end
		else begin
			ns = ticker + 8'b00000001;
			ddr_clk = 0;
		end
	end
	
	always_ff @(posedge clk) begin
		if(reset) 	begin
			case(difficulty)
				2'b00: ticker <= 8'b00000000;
				2'b01: ticker <= 8'b01111111;
				2'b10: ticker <= 8'b10101001;
				2'b11: ticker <= 8'b10111110;
			endcase
		end
		else 			ticker <= ns;
	end
endmodule

module clk_counter_testbench();
	logic clk, reset, ddr_clk;
	logic [1:0] difficulty;
	
	clk_counter dut (.clk, .reset, .difficulty, .ddr_clk);
	
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
													@(posedge clk);
		reset <= 1;	difficulty <= 0;		@(posedge clk); // Always reset FSMs at start
		reset <= 0;								@(posedge clk);
		difficulty <= 2'b00; repeat(256)	@(posedge clk);
		difficulty <= 2'b01; repeat(256)	@(posedge clk);
		difficulty <= 2'b10; repeat(256)	@(posedge clk);
		difficulty <= 2'b11; repeat(256)	@(posedge clk);
													@(posedge clk);
													@(posedge clk);
		$stop; // End the simulation.
	end
endmodule
