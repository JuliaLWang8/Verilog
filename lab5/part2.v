module part2 (SW, CLOCK_50, HEX0);
	input [9:0] SW;
	input CLOCK_50;
	output [6:0] HEX0;
	//output [7:0] count; 
	//output [6:0] y;
	wire enable;
	wire [3:0] out;
	wire reset;
	assign reset = SW[9];
	reg [10:0] ratedivider;

	
//	assign count= {4'b0, out};
//	assign y= ratedivider;
	
	//starting values for different speeds 
	reg [10:0] speed;
	always @(*)
	begin
		if (SW[0] == 0 && SW[1] == 0) //50MHz option
			speed = 11'b0; 
		else if (SW[0] == 1 && SW[1] == 0)  //1 Hz option
			speed = 11'd499; //499
		else if (SW[0] == 0 && SW[1] == 1) // 0.5 Hz option FIX THIS LATER SWITHCES WRONG
			speed = 11'd999;
		else if (SW[0] == 1 && SW[1] == 1) // 0.25 Hz option
			speed = 11'd1999;
	end
	
	//count down from start, generate enable at 0
	always @(posedge CLOCK_50)
	begin
		if (reset == 1'b1)
			ratedivider <= speed;
		else if (ratedivider != 0) 
			ratedivider <= ratedivider - 1; 
		else
			ratedivider <= speed;
	end
	
	assign enable = (ratedivider == 11'd0)? 1: 0; //if ratedivider reaches 0, turn on enable
	
	counttof displaycounter (CLOCK_50, enable, out, SW[9]);
	
	//assign hex
	decoder2 display (.D(out[0]), .C(out[1]), .B(out[2]), .A(out[3]), .a(HEX0[0]), .b(HEX0[1]), .c(HEX0[2]), .d(HEX0[3]), .e(HEX0[4]), .f(HEX0[5]), .g(HEX0[6]));
	
endmodule

module counttof (clk, enable, q, reset);
	input clk, enable, reset;
	output reg [3:0] q;
	wire [3:0] d;
	
	always @(posedge clk)
	begin
		if (reset == 1'b1)
			q <= 4'd0;
		else if (q == 4'b1111) //at 15
			q <= 4'd0;
		else if (enable == 1'b1)
			q <= q + 1;
		else
			q <= q;

	end
	
endmodule

module decoder2 ( input A, B, C, D, output a, b, c, d, e, f, g);
	assign a = ((~A)&(~B)&(~C)&D) | ((~A)&B&(~C)&(~D)) | (A&(~B)&C&D) | (A&B&(~C)&D);
	assign b = (B&C&(~D)) | (A&C&D) | (A&B&(~D)) | ((~A)&B&(~C)&D);
	assign c = (A&B&(~D)) | (A&B&C) | ((~A)&(~B)&C&(~D));
	assign d = (B&C&D) | ((~A)&(~B)&(~C)&D) | ((~A)&B&(~C)&(~D)) | (A&(~B)&C&(~D));
	assign e = ((~A)&D) | ((~B)&(~C)&D) | ((~A)&B&(~C));//((~A)&(~C)&(~D)) | ((~A)&C&D) | ((~A)&B&(~C)) | (A&(~B)&(~C)&D);
	assign f = ((~A)&(~B)&D) | ((~A)&C&D) | ((~A)&(~B)&C) | (A&B&(~C)&D);
	assign g = ((~A)&(~B)&(~C)) | ((~A)&B&C&D) | (A&B&(~C)&(~D));
endmodule