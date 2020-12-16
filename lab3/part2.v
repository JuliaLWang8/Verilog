module part2 (SW, LEDR);
	input [9:0] SW; //cin SW[8]
	output [9:0] LEDR; //cout LEDR[9]
	wire c1, c2, c3;
	
	fulladd U0 (SW[4], SW[0], SW[8], c1, LEDR[0]);
	fulladd U1 (SW[5], SW[1], c1, c2, LEDR[1]);
	fulladd U2 (SW[6], SW[2], c2, c3, LEDR[2]);
	fulladd U3 (SW[7], SW[3], c3, LEDR[9], LEDR[3]);
	
endmodule

module fulladd (a, b, cin, cout, s);
	input a, b, cin;
	output s, cout;
	assign s = a^b^cin;
	assign cout = (a&b) + (a & cin) + (b & cin);
endmodule
