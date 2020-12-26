/* 8-bit counter incrementing on the positive edge of the clock if the enable signal is on. 
Resets to 0 when clear_b is low (active low synchronous clear). The following assignments were made:
clock: KEY[0]
enable: SW[1]
clearb: SW[0]
display on: HEX0 and HEX1
*/

module part1 (SW, KEY, HEX0, HEX1);
	input [9:0] SW; 
	input [3:0] KEY; //push buttons
	output [6:0] HEX0, HEX1;
	wire a, b, c, d, e, f, g, h;
	wire [7:0] hexout;
	
	/*
	subcirc one (SW[1], KEY[0], SW[0], a, hexout[0]);
	subcirc two (a, KEY[0], SW[0],b, hexout[1]);
	subcirc thr (b, KEY[0], SW[0], c, hexout[2]);
	subcirc four (c, KEY[0], SW[0],d, hexout[3]);
	subcirc five (d, KEY[0], SW[0],e ,hexout[4]);
	subcirc six (e, KEY[0], SW[0], f, hexout[5]);
	subcirc seven (f, KEY[0], SW[0],g ,hexout[6]);
	subcirc eight (g, KEY[0], SW[0], h, hexout[7]);*/
	
	t_ff one (SW[1], KEY[0], SW[0], hexout[0]);
	t_ff two (SW[1] && hexout[0], KEY[0], SW[0],hexout[1]);
	t_ff thr (SW[1] && hexout[0] && hexout[1], KEY[0], SW[0], hexout[2]);
	t_ff fou (SW[1] && hexout[0] && hexout[1] && hexout[2], KEY[0], SW[0], hexout[3]);
	t_ff fiv (SW[1] && hexout[0] && hexout[1] && hexout[2] && hexout[3], KEY[0], SW[0], hexout[4]);
	t_ff six (SW[1] && hexout[0] && hexout[1] && hexout[2] && hexout[3] && hexout[4], KEY[0], SW[0], hexout[5]);
	t_ff sev (SW[1] && hexout[0] && hexout[1] && hexout[2] && hexout[3] && hexout[4] && hexout[5], KEY[0], SW[0], hexout[6]);
	t_ff eit (SW[1] && hexout[0] && hexout[1] && hexout[2] && hexout[3] && hexout[4] && hexout[5] && hexout[6], KEY[0], SW[0], hexout[7]);

	
	//assign hex
	decoder first (.D(hexout[0]), .C(hexout[1]), .B(hexout[2]), .A(hexout[3]), .a(HEX0[0]), .b(HEX0[1]), .c(HEX0[2]), .d(HEX0[3]), .e(HEX0[4]), .f(HEX0[5]), .g(HEX0[6]));
	decoder second (.D(hexout[4]), .C(hexout[5]), .B(hexout[6]), .A(hexout[7]), .a(HEX1[0]), .b(HEX1[1]), .c(HEX1[2]), .d(HEX1[3]), .e(HEX1[4]), .f(HEX1[5]), .g(HEX1[6]));

	
endmodule

module t_ff (T, clk, resetn, Q);
		input T, clk, resetn;
		output reg Q;
		
		always @(posedge clk, negedge resetn) //async reset
		begin
			if (resetn == 1'b0) //active low, resets when clearb is 0
				Q <= 1'b0;
			else
				if (T == 1'b0)
					Q <= Q;
				else
					Q <= ~Q;
		end
endmodule

module subcirc (enable, clk, clearb, out, beforeand);
	input enable, clk, clearb;
	output out, beforeand;
	wire a;
	assign beforeand = a;
	t_ff sub (enable, clk, clearb, a);
	assign out = a & enable;
	
endmodule

module decoder ( input A, B, C, D, output a, b, c, d, e, f, g);
	assign a = ((~A)&(~B)&(~C)&D) | ((~A)&B&(~C)&(~D)) | (A&(~B)&C&D) | (A&B&(~C)&D);
	assign b = (B&C&(~D)) | (A&C&D) | (A&B&(~D)) | ((~A)&B&(~C)&D);
	assign c = (A&B&(~D)) | (A&B&C) | ((~A)&(~B)&C&(~D));
	assign d = (B&C&D) | ((~A)&(~B)&(~C)&D) | ((~A)&B&(~C)&(~D)) | (A&(~B)&C&(~D));
	assign e = ((~A)&D) | ((~B)&(~C)&D) | ((~A)&B&(~C));//((~A)&(~C)&(~D)) | ((~A)&C&D) | ((~A)&B&(~C)) | (A&(~B)&(~C)&D);
	assign f = ((~A)&(~B)&D) | ((~A)&C&D) | ((~A)&(~B)&C) | (A&B&(~C)&D);
	assign g = ((~A)&(~B)&(~C)) | ((~A)&B&C&D) | (A&B&(~C)&(~D));
endmodule
