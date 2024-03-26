module Lab5_part5(SW, CLOCK_50, LEDR, HEX0, HEX2, HEX3);
	input [9:0] SW;
	input CLOCK_50;
	output [9:0] LEDR;
	output [6:0] HEX0, HEX2, HEX3;
	wire [3:0] readout;
	

	ramlpm  rm(
	.address(SW[4:0]),
	.clock(CLOCK_50),
	.data(SW[8:5]),
	.wren(SW[9]),
	.q(readout));
	
	assign LEDR[0] = SW[9];
	seven_segment s1(SW[4],HEX3);
	seven_segment s2(SW[3:0],HEX2);
	seven_segment s3(readout,HEX0);
	
endmodule

// Seven-segment desplay //
module seven_segment(in,HEX);
	input [3:0] in;
	output wire [6:0] HEX;
		
	assign HEX[0] = ~in[3]&in[2]&~in[0]|~in[3]&~in[2]&~in[1]&in[0]|in[3]&in[2]&~in[1]&in[0]|in[3]&~in[2]&in[1]&in[0];
	assign HEX[1] = ~in[3]&in[2]&~in[1]&in[0]|in[3]&in[2]&in[1]|in[3]&~in[0]&in[2]|in[2]&in[1]&~in[0]|in[3]&in[1]&in[0];
	assign HEX[2] = in[3]&in[2]&~in[0]|in[3]&in[2]&in[1]|~in[3]&~in[2]&in[1]&~in[0];
	assign HEX[3] = in[3]&~in[2]&in[1]&~in[0]|~in[3]&in[2]&~in[1]&~in[0]|~in[2]&~in[1]&in[0]|in[2]&in[1]&in[0];
	assign HEX[4] = ~in[2]&~in[1]&in[0]|~in[3]&in[0]|~in[3]&in[2]&~in[1];
	assign HEX[5] = ~in[3]&~in[2]&in[0]|~in[3]&~in[2]&in[1]|~in[3]&in[1]&in[0]|in[3]&in[2]&~in[1]&in[0];
	assign HEX[6] = ~in[3]&in[2]&in[1]&in[0]|in[3]&in[2]&~in[1]&~in[0]|~in[3]&~in[2]&~in[1];
endmodule

