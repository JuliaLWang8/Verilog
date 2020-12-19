module part1 (SW, KEY, HEX0, HEX1);
	input [9:0] SW; // 0 to 3 is data, 9 is reset
	input [3:0] KEY; //push buttons
	output [6:0] HEX0, HEX1;
	wire a, b, c, d, e, f, g, h;
	
	subcir one (SW[1], KEY[0], SW[0], a);
	subcir two (a, KEY[0], SW[0], b);
	subcir thr (b, KEY[0], SW[0], c);
	subcir four (c, KEY[0], SW[0], d);
	subcir five (d, KEY[0], SW[0], e);
	subcir six (e, KEY[0], SW[0], f);
	subcir seven (f, KEY[0], SW[0], g);
	subcir eight (g, KEY[0], SW[0], h);

	
	//assign hex
	decoder first (.D(d), .C(c), .B(b), .A(a), .a(HEX0[0]), .b(HEX0[1]), .c(HEX0[2]), .d(HEX0[3]), .e(HEX0[4]), .f(HEX0[5]), .g(HEX0[6]));
	decoder second (.D(h), .C(g), .B(f), .A(e), .a(HEX1[0]), .b(HEX1[1]), .c(HEX1[2]), .d(HEX1[3]), .e(HEX1[4]), .f(HEX1[5]), .g(HEX1[6]));

	
endmodule

module tff (T, clk, resetn, Q);
		input T, clk, resetn;
		output reg Q;
		
		always @(posedge clk, negedge resetn) //async reset
		begin
			if (resetn == 1'b0) //active low, resets when clearb is 0
				Q <= 1'b0;
			else
				if (T == 1'b0)
					Q <= T;
				else
					Q <= ~T;
		end
endmodule

module subcir (enable, clk, clearb, out);
	input enable, clk, clearb;
	output out;
	wire a;
	tff sub (enable, clk, clearb, a);
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
