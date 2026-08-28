module LED_control(clk, ddr_clk, reset, in, RedPixels, GrnPixels, HEX0, HEX1, HEX2, HEX3);
   input  logic               clk, ddr_clk, reset;
	input  logic [3:0]			in; 		  // Button inputs, ~KEY[3:0] (KEY is default inverted, so when key 0 is pressed, in[0] is true)
   output logic [15:0][15:0] 	RedPixels; // 16x16 array of red LEDs
   output logic [15:0][15:0] 	GrnPixels; // 16x16 array of green LEDs
	output logic [6:0] 			HEX0, HEX1, HEX2, HEX3;
	
			 logic [2:0] 			scoreC1, scoreC2, scoreC3, scoreC4;
			 logic [4:0] 			display;
			 logic [15:0][3:0] 	RedC1, RedC2, RedC3, RedC4;
			 logic [15:0][3:0] 	GrnC1, GrnC2, GrnC3, GrnC4;
	
	Light_Column C1 (.clk, .ddr_clk, .reset, .button(in[3]), .RedPixels(RedC1), .GrnPixels(GrnC1), .score(scoreC1), .seed(10'b0000000000));
	Light_Column C2 (.clk, .ddr_clk, .reset, .button(in[2]), .RedPixels(RedC2), .GrnPixels(GrnC2), .score(scoreC2), .seed(10'b0100000000));
	Light_Column C3 (.clk, .ddr_clk, .reset, .button(in[1]), .RedPixels(RedC3), .GrnPixels(GrnC3), .score(scoreC3), .seed(10'b1000000000));
	Light_Column C4 (.clk, .ddr_clk, .reset, .button(in[0]), .RedPixels(RedC4), .GrnPixels(GrnC4), .score(scoreC4), .seed(10'b1100000000));
	
	Score_Update scores (.clk, .ddr_clk, .reset, .scoreC1, .scoreC2, .scoreC3, .scoreC4, .update(display));
	Score_Counter_Display displayScore (.score(display), .ddr_clk, .clk, .reset, .HEX0, .HEX1, .HEX2, .HEX3);
	 
	always_comb 
	begin
	
		// Reset - Turn off all LEDs
		if (reset)
		begin
			RedPixels = '0;
			GrnPixels = '0;
		end
		else
		begin
			RedPixels[00] = {RedC1[00], RedC2[00], RedC3[00], RedC4[00]};
			RedPixels[01] = {RedC1[01], RedC2[01], RedC3[01], RedC4[01]};
			RedPixels[02] = {RedC1[02], RedC2[02], RedC3[02], RedC4[02]};
			RedPixels[03] = {RedC1[03], RedC2[03], RedC3[03], RedC4[03]};
			RedPixels[04] = {RedC1[04], RedC2[04], RedC3[04], RedC4[04]};
			RedPixels[05] = {RedC1[05], RedC2[05], RedC3[05], RedC4[05]};
			RedPixels[06] = {RedC1[06], RedC2[06], RedC3[06], RedC4[06]};
			RedPixels[07] = {RedC1[07], RedC2[07], RedC3[07], RedC4[07]};
			RedPixels[08] = {RedC1[08], RedC2[08], RedC3[08], RedC4[08]};
			RedPixels[09] = {RedC1[09], RedC2[09], RedC3[09], RedC4[09]};
			RedPixels[10] = {RedC1[10], RedC2[10], RedC3[10], RedC4[10]};
			RedPixels[11] = {RedC1[11], RedC2[11], RedC3[11], RedC4[11]};
			RedPixels[12] = {RedC1[12], RedC2[12], RedC3[12], RedC4[12]};
			RedPixels[13] = {RedC1[13], RedC2[13], RedC3[13], RedC4[13]};
			RedPixels[14] = {RedC1[14], RedC2[14], RedC3[14], RedC4[14]};
			RedPixels[15] = {RedC1[15], RedC2[15], RedC3[15], RedC4[15]};
		  
			GrnPixels[00] = {GrnC1[00], GrnC2[00], GrnC3[00], GrnC4[00]};
			GrnPixels[01] = {GrnC1[01], GrnC2[01], GrnC3[01], GrnC4[01]};
			GrnPixels[02] = {GrnC1[02], GrnC2[02], GrnC3[02], GrnC4[02]};
			GrnPixels[03] = {GrnC1[03], GrnC2[03], GrnC3[03], GrnC4[03]};
			GrnPixels[04] = {GrnC1[04], GrnC2[04], GrnC3[04], GrnC4[04]};
			GrnPixels[05] = {GrnC1[05], GrnC2[05], GrnC3[05], GrnC4[05]};
			GrnPixels[06] = {GrnC1[06], GrnC2[06], GrnC3[06], GrnC4[06]};
			GrnPixels[07] = {GrnC1[07], GrnC2[07], GrnC3[07], GrnC4[07]};
			GrnPixels[08] = {GrnC1[08], GrnC2[08], GrnC3[08], GrnC4[08]};
			GrnPixels[09] = {GrnC1[09], GrnC2[09], GrnC3[09], GrnC4[09]};
			GrnPixels[10] = {GrnC1[10], GrnC2[10], GrnC3[10], GrnC4[10]};
			GrnPixels[11] = {GrnC1[11], GrnC2[11], GrnC3[11], GrnC4[11]};
			GrnPixels[12] = {GrnC1[12], GrnC2[12], GrnC3[12], GrnC4[12]};
			GrnPixels[13] = {GrnC1[13], GrnC2[13], GrnC3[13], GrnC4[13]};
			GrnPixels[14] = {GrnC1[14], GrnC2[14], GrnC3[14], GrnC4[14]};
			GrnPixels[15] = {GrnC1[15], GrnC2[15], GrnC3[15], GrnC4[15]};
		end
	end
endmodule


module LED_control_testbench();

	logic 				 reset, clk, ddr_clk;
	logic [3:0] 		 in;
	logic [15:0][15:0] RedPixels, GrnPixels;
	logic [6:0] 		 HEX0, HEX1, HEX2, HEX3;
	logic [4:0]			 ticker;
	
	LED_control dut (.clk, .ddr_clk, .in, .reset, .RedPixels, .GrnPixels, .HEX0, .HEX1, .HEX2, .HEX3);
	
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
		reset <= 1;													@(posedge clk); // Always reset FSMs at start
		reset <= 0;					 								@(posedge clk);
		in[3:0] = 4'b0000;				repeat(256) 		@(posedge clk); // no inputs
		in[3:0] = 4'b1111;  				repeat(256)			@(posedge clk); // See frequency of red
																		@(posedge clk);
		$stop; // End the simulation.
	end
	
endmodule