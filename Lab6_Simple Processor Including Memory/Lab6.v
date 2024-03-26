module Lab6(KEY,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,LEDR);
	
	input [2:0]  KEY;
	output [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5; 
	output [9:0] LEDR;
	
	wire Resetn, MClock, PClock;
	assign Resetn = KEY[0];
	assign MClock = KEY[1];
	assign PClock = KEY[2];
	
	reg [7:0] BusWires;
	assign LEDR[7:0] = BusWires;
	reg [7:0] R0, R1, R2;
	wire [7:0] DIN;
	
	parameter MV  = 2'b00; 
	parameter MVI = 2'b01; 
	parameter ADD = 2'b10; 
	parameter SUB = 2'b11;

	reg [4:0] address;	
	
	wire [1:0] IR_current;
	wire [3:0] Xreg_current, Yreg_current;
	assign IR_current = DIN[7:6];
	assign Xreg_current = DIN[5:3];
	assign Yreg_current = DIN[2:0];
	
	reg [1:0] IR_past; 
	reg [3:0] Xreg_past, Yreg_past;
	
	always@(posedge PClock)
	begin
		IR_past <= DIN[7:6];
		Xreg_past <= DIN[5:3];
		Yreg_past <= DIN[2:0];
	end
	
	// counter //
	always@(posedge MClock, negedge Resetn) 
	begin
		if(!Resetn)
			address <= 0;
		else 
			address <= address + 1;
	end
	
	romlpm rom(address, MClock, DIN);
	
	seven_segment s1(DIN[7:4],HEX5);
	seven_segment s2(DIN[3:0],HEX4);
	seven_segment s3(R0[7:4],HEX3);
	seven_segment s4(R0[3:0],HEX2);
	seven_segment s5(R1[7:4],HEX1);
	seven_segment s6(R1[3:0],HEX0);
	
	// proc //
	always@(posedge PClock, negedge Resetn) 
	begin
		if(!Resetn) 
		begin
			R0 <= 0;
			R1 <= 0;
			BusWires <= 0;
		end 
		else 
		begin
			BusWires <= DIN;
			
			if(address != 0) 
			begin
				case(IR_current)
					MV: 
					begin
						if(IR_past!=MVI) 
						begin
							if(Xreg_current == 0) 
							begin
								if(Yreg_current == 1) 
								begin
									R0 <= R1;
								end 
								else 
								begin
									R0 <= R2;
								end
							end 
							else if(Xreg_current == 1) 
							begin
								if(Yreg_current == 0) 
									R1 <= R0;
								else
									R1 <= R2;
							end 
							else 
							begin
								if(Yreg_current == 0)
									R2 <= R0;
								else
									R2 <= R1;
							end
						end 
						else if(IR_past==MVI) 
						begin
							if(Xreg_past == 0)
								R0 <= DIN;
							else if(Xreg_past == 1)
								R1 <= DIN;
							else
								R2 <= DIN;
						end
					end
					
					MVI: ;
					
					ADD:R0 <= R0 + R1;

					SUB:
						R0 <= R0 - R1;
					
					default: 
					begin
						R0 <= 0;
						R1 <= 0;
					end
				endcase
			end 
			else begin 
				R0 <= 0;
				R1 <= 0;
			end
		end
	end
	
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