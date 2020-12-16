module part3 (SW, HEX0);
	input [3:0] SW;
	output [6:0] HEX0;
	
	decoder blah (.D(SW[0]), .C(SW[1]), .B(SW[2]), .A(SW[3]), .a(HEX0[0]), .b(HEX0[1]), .c(HEX0[2]), .d(HEX0[3]), .e(HEX0[4]), .f(HEX0[5]), .g(HEX0[6]));
	
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
