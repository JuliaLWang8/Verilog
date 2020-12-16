module part3 (SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

	input [9:0] SW; // A from 4-7 and B from 0-3
	input [2:0] KEY; //push buttons
	output [7:0] LEDR; //displays output
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	//case 0	
	wire c1, c2, c3, s[7:0];
	fulladder U0 (SW[4], SW[0], 0, c1, s[0]);
	fulladder U1 (SW[5], SW[1], c1, c2, s[1]);
	fulladder U2 (SW[6], SW[2], c2, c3, s[2]);
	fulladder U3 (SW[7], SW[3], c3, s[4], s[3]);
	
	//case 1
	wire A, B;
	assign A= {SW[7],SW[6],SW[5],SW[4]};
	assign B= {SW[3],SW[2],SW[1],SW[0]};
	
	reg [7:0] ALUout;
	always @(*)
	begin
		case (KEY[2:0])
			3'b111: ALUout[7:0] = {3'b000, s[4], s[3], s[2], s[1], s[0]}; //from full adder
			3'b110: ALUout[7:0] = {SW[7],SW[6],SW[5],SW[4]}+{SW[3],SW[2],SW[1],SW[0]};
			3'b101: ALUout[7:0] = {SW[3], SW[3],SW[3],SW[3],SW[3], SW[2], SW[1], SW[0]};
			3'b100: ALUout[7:0] = {4'b0000,|{{SW[7],SW[6],SW[5],SW[4]}, {SW[3],SW[2],SW[1],SW[0]}}};
			3'b011: ALUout[7:0] = {4'b0000, &{{SW[7],SW[6],SW[5],SW[4]}, {SW[3],SW[2],SW[1],SW[0]}}};
			3'b010: ALUout[7:0] = {{SW[7],SW[6],SW[5],SW[4]}, {SW[3],SW[2],SW[1],SW[0]}};
			default: ALUout[7:0] = 8'b00000000; //default is 0
		endcase
	end
	
	//HEX: display hex A and B, HEX1 and 3 to 0
	decoder hexa (.D(SW[4]), .C(SW[5]), .B(SW[6]), .A(SW[7]), .a(HEX2[0]), .b(HEX2[1]), .c(HEX2[2]), .d(HEX2[3]), .e(HEX2[4]), .f(HEX2[5]), .g(HEX2[6]));
	decoder hexb (.D(SW[0]), .C(SW[1]), .B(SW[2]), .A(SW[3]), .a(HEX0[0]), .b(HEX0[1]), .c(HEX0[2]), .d(HEX0[3]), .e(HEX0[4]), .f(HEX0[5]), .g(HEX0[6]));
	decoder blank (.D(0), .C(0), .B(0), .A(0), .a(HEX1[0]), .b(HEX1[1]), .c(HEX1[2]), .d(HEX1[3]), .e(HEX1[4]), .f(HEX1[5]), .g(HEX1[6]));
	decoder space (.D(0), .C(0), .B(0), .A(0), .a(HEX3[0]), .b(HEX3[1]), .c(HEX3[2]), .d(HEX3[3]), .e(HEX3[4]), .f(HEX3[5]), .g(HEX3[6]));
	
	//ALU displays
	assign LEDR[7:0] = ALUout[7:0];
	decoder alubeg (.D(ALUout[4]), .C(ALUout[5]), .B(ALUout[6]), .A(ALUout[7]), .a(HEX5[0]), .b(HEX5[1]), .c(HEX5[2]), .d(HEX5[3]), .e(HEX5[4]), .f(HEX5[5]), .g(HEX5[6]));
	decoder aluend (.D(ALUout[0]), .C(ALUout[1]), .B(ALUout[2]), .A(ALUout[3]), .a(HEX4[0]), .b(HEX4[1]), .c(HEX4[2]), .d(HEX4[3]), .e(HEX4[4]), .f(HEX4[5]), .g(HEX4[6]));

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

module fulladder (a, b, cin, cout, s);
	input a, b, cin;
	output s, cout;
	assign s = a^b^cin;
	assign cout = (a&b) + (a & cin) + (b & cin);
endmodule
