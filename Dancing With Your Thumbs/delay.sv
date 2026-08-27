// Takes a start signal, holds stay true until exactly 5 ddr_clk cycles later.
module delay (start, stay, clk, ddr_clk, reset);
	input  logic start, clk, ddr_clk, reset;
	output logic stay;
	logic [2:0] ps, ns;
	
	always_comb begin
		if (ps == 3'b101)						ns = 3'b000;
		else if (~start & ps == 3'b000) 	ns = ps;
		else 										ns = ps + 3'b001;
		
		if (ps == 3'b101 | (~start & ps == 3'b000)) 	stay = 0;
		else 														stay = 1;
	end
	
	always_ff @(posedge clk) begin
		if(reset) 			ps <= 3'b000;
		else if (ddr_clk) ps <= ns;
		else					ps <= ps;
	end
	
endmodule

module delay_testbench();
	logic 		start, stay, clk, ddr_clk, reset;
	logic [4:0] ticker;
	
	delay dut (.start, .stay, .clk, .ddr_clk, .reset);
	
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
		reset <= 1;						@(posedge clk); // Always reset FSMs at start
		reset <= 0;						@(posedge clk);
		start <= 1;		repeat(20)	@(posedge clk);
		start <= 0;		repeat(775)	@(posedge clk);
											@(posedge clk);
		start <= 1;		repeat(775)	@(posedge clk);
											@(posedge clk);
		start <= 0;		repeat(775)	@(posedge clk);
											@(posedge clk);
		$stop; // End the simulation.
	end
endmodule
			
		
		