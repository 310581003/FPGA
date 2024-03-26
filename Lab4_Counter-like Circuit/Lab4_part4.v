module Lab4_part4(SW, KEY, HEX0);
	input [2:0] SW;
	input [3:0] KEY;
	output [6:0] HEX0;
	wire [3:0] HEX_out;
	
	assign w1=SW[2];
	assign w0=SW[1];
	
	counter cr(SW[0],w1, w0, KEY[0], HEX_out[3:0]);
	
	seven_segment s(HEX_out[3:0],HEX0[6:0]);
endmodule


module counter(SW, w1, w0, KEY,  HEX_out);

	input SW, w1, w0, KEY;
	output reg [3:0]HEX_out;
	
	always @(negedge KEY)
	begin 
	if (SW==0)
		HEX_out<=0;
	else if (HEX_out==9 & w1==0 & w0==1)
		HEX_out<=0;
	else if (HEX_out==9 & w1==1 & w0==0)
		HEX_out<=1;
	else if (HEX_out==8 & w1==1 & w0==0)
		HEX_out<=0;
	else if (HEX_out==0 & w1==1 & w0==1)
		HEX_out<=9;
	else
	begin
		case ({w1,w0})
			2'b00 : HEX_out<=HEX_out;
			2'b01 : HEX_out<=HEX_out+1;
			2'b10 : HEX_out<=HEX_out+2;
			2'b11 : HEX_out<=HEX_out-1;
		endcase
	end
	end
endmodule

module seven_segment(in,HEX);
	input [3:0] in;
	output wire [6:0] HEX;
		
	assign HEX[0]=~in[3]&in[2]&~in[1]&~in[0]|~in[3]&~in[2]&~in[1]&in[0];
	assign HEX[1]=in[3]&in[2]|in[3]&in[1]|in[2]&~in[1]&in[0]|in[2]&in[1]&~in[0];
	assign HEX[2]=in[3]&in[2]|in[3]&in[1]|~in[2]&in[1]&~in[0];
	assign HEX[3]=~in[3]&in[2]&~in[1]&~in[0]|~in[3]&~in[2]&~in[1]&in[0]|~in[3]&in[2]&in[1]&in[0];
	assign HEX[4]=in[3]&in[2]|in[3]&in[1]|in[2]&~in[1]|in[0];
	assign HEX[5]=in[3]&in[2]|~in[3]&~in[2]&in[0]|~in[2]&in[1]|in[1]&in[0];
	assign HEX[6]=in[3]&in[2]|in[3]&in[1]|in[2]&in[1]&in[0]|~in[3]&~in[2]&~in[1];
endmodule
	
	