
module v7404 (input pin1, pin3, pin5, pin9, pin11, pin13, output pin2, pin4, pin6, pin8, pin10, pin12);
	assign pin2 = (~pin1);
	assign pin4 = (~pin3);
	assign pin6 = (~pin5);
	assign pin12 = (~pin13);
	assign pin10 = !pin11;
	assign pin8 = !pin9;
endmodule

module v7408 (input pin1, pin2, pin4, pin5, pin12, pin13, pin9, pin10, output pin3, pin6, pin11, pin8);
	assign pin3 = pin1 & pin2;
	assign pin6 = pin4 & pin5;
	assign pin11 = pin12 & pin13;
	assign pin8 = pin10 & pin9;
endmodule

module v7432 (input pin1, pin2, pin4, pin5, pin12, pin13, pin9, pin10, output pin3, pin6, pin11, pin8);
	assign pin3 = pin1 | pin2;
	assign pin6 = pin4 | pin5;
	assign pin11 = pin12 | pin13;
	assign pin8 = pin10 | pin9;
endmodule

module part2 (SW, LEDR);
	input [9:0] SW;
	output [9:0] LEDR;
	wire a, b, c;
	v7404 notgates (.pin1(SW[9]), .pin3(), .pin5(), .pin9(), .pin11(), .pin13(), .pin2(a), .pin4(), .pin6(), .pin8(), .pin10(), .pin12());
	v7408 andgates (.pin1(SW[0]), .pin2(a), .pin3(b), .pin4(SW[1]), .pin5(SW[9]), .pin6(c), .pin8(), .pin9(), .pin10(), .pin11(), .pin12(), .pin13());
	v7432 orrgates (.pin1(c), .pin2(b), .pin3(LEDR[0]), .pin4(), .pin5(), .pin6(), .pin8(), .pin9(), .pin10(), .pin11(), .pin12(), .pin13());
endmodule