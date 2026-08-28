// Compares two 10 digit numbers, returns true if A is larger and false otherwise. More efficient than Comparator.sv
module Stupid_Comparator (A, B, out);
	output logic 		out;
	input logic [9:0] A, B;
	
	assign out =                     (A[9] && ~B[9]) || 
					 ((A[9] ~^ B[9]) && ((A[8] && ~B[8]) || 
					 ((A[8] ~^ B[8]) && ((A[7] && ~B[7]) || 
					 ((A[7] ~^ B[7]) && ((A[6] && ~B[6]) || 
					 ((A[6] ~^ B[6]) && ((A[5] && ~B[5]) || 
					 ((A[5] ~^ B[5]) && ((A[4] && ~B[4]) || 
					 ((A[4] ~^ B[4]) && ((A[3] && ~B[3]) || 
					 ((A[3] ~^ B[3]) && ((A[2] && ~B[2]) || 
					 ((A[2] ~^ B[2]) && ((A[1] && ~B[1]) || 
					 ((A[1] ~^ B[1]) &&  (A[0] && ~B[0]))))))))))))))))));
endmodule 

module stupid_comparator_testbench();
	logic out;
	logic [9:0] A, B;
	
	Stupid_Comparator dut (A, B, out);
	initial begin
		A=10'b0000000000; B=10'b0000000000; #10;
		A=10'b0000000001; B=10'b0000000000; #10;
		A=10'b0000000000; B=10'b0000000001; #10;
		A=10'b0000100000; B=10'b0000001000; #10;
		A=10'b0000001000; B=10'b0100000000; #10;
		A=10'b1000000001; B=10'b1000000000; #10;
		A=10'b1111111111; B=10'b1111111111; #10;
	end
endmodule 