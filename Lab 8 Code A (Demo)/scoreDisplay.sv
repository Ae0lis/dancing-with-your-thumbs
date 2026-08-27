// Takes in a score (max 99) and displays it
module scoreDisplay (score, HEX0, HEX1);
	input logic 	[6:0] score;
	output logic 	[6:0] HEX0, HEX1;
	
	seg7 bottom (.bcd(score[3:0]), .leds(HEX0));
	seg7 top (.bcd({ 1'b0, score[6:4] }), .leds(HEX1));
endmodule
