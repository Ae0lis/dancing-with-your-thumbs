module User_Input (clk, ddr_clk, reset, in, out);
	input logic clk, ddr_clk, reset, in;
	output logic out;
	logic between, select;
	
	
	// Two flip flops to prevent metastability
	
	always_ff @(posedge clk) begin
		if (reset)
			between <= 0;
		else
			between <= in;
	end
	
	always_ff @(posedge clk) begin
		if (reset)
			select <= 0;
		else
			select <= between;
	end
	
	// FSM to control the inputs. Outputs true when button is pressed. Outputs true until ddr_clk fires.
	
	enum { neutral, hold } ps, ns;
	
	always_comb begin
		// If the state is neutral, wait until there's an impulse. If hold, output true constantly.
		case (ps)
			neutral: begin
				if (select) ns = hold;
				else 			ns = neutral;
				out = 0;
			end				
			hold: begin
				ns = hold;
				out = 1;
			end
		endcase
	end
	
	// D flip flop
	always_ff @(posedge clk) begin
		if (reset) begin
			ps <= neutral;
		end
		else if (ddr_clk) begin
			ps <= neutral;
		end
		else ps <= ns;	
	end
	
endmodule

module user_input_testbench();
	logic clk, ddr_clk, reset, in, out;
	
	logic [4:0] ticker;
	
	User_Input dut (clk, ddr_clk, reset, in, out);
	
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
		reset <= 1; in <= 0;				@(posedge clk); // Reset FSMs at start
		reset <= 0;					 		@(posedge clk);
		in <= 0;	 repeat(40) 			@(posedge clk); // Try inputs
		in <= 1;  repeat(40)				@(posedge clk);  
		in <= 0;	 repeat(200)			@(posedge clk);
		in <= 1;  repeat(200)			@(posedge clk);
												@(posedge clk);
		$stop; // End the simulation.
	end
	
endmodule