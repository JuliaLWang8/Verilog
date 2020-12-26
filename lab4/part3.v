/*
Rotating shift register that can shift both left and right, has parallel load, active-high reset. 
Used a subcircuit containing 2 mux's and a D flip-flop, where 1 mux controlled by LoadLeft determines the rotation direction, the other mux ParallelLoadn enables parallel load. 
If ASRight is enabled, and we are rotating right, then it is an arithmetic shift right. 
Assignments:
	- SW7-0: Data in (load for parallel load)
	- SW9: active high sync reset button
	- KEY1: ParallelLoadn
	- KEY2: LoadLeft
	- KEY3: ASRight
	- KEY0: clock
	- LEDs: output display
*/
module part3 (SW, KEY, LEDR);
	input [9:0] SW, LEDR;
	input [3:0] KEY;
	reg a;
	
	always @(*)
	begin
		if (KEY[1] == 0 && KEY[2] == 0 && KEY[3] == 0)
			a = LEDR[7];
		else
			a = LEDR[0];
	end
	
	//asright implementation mux's
	//mux21 child1 (.x(LEDR[0]), .y(LEDR[7]), .s(~KEY[3]), .m(a));
	
	subcirc u0 ( LEDR[6], a, ~KEY[2], SW[7], ~KEY[1], KEY[0], SW[9], LEDR[7]);
	subcirc u1 ( LEDR[5], LEDR[7], ~KEY[2], SW[6], ~KEY[1], KEY[0], SW[9], LEDR[6]);
	subcirc u2 ( LEDR[4], LEDR[6], ~KEY[2], SW[5], ~KEY[1], KEY[0], SW[9], LEDR[5]);
	subcirc u3 ( LEDR[3], LEDR[5], ~KEY[2], SW[4], ~KEY[1], KEY[0], SW[9], LEDR[4]);
	subcirc u4 ( LEDR[2], LEDR[4], ~KEY[2], SW[3], ~KEY[1], KEY[0], SW[9], LEDR[3]);
	subcirc u5 ( LEDR[1], LEDR[3], ~KEY[2], SW[2], ~KEY[1], KEY[0], SW[9], LEDR[2]);
	subcirc u6 ( LEDR[0], LEDR[2], ~KEY[2], SW[1], ~KEY[1], KEY[0], SW[9], LEDR[1]);
	subcirc u7 ( LEDR[7], LEDR[1], ~KEY[2], SW[0], ~KEY[1], KEY[0], SW[9], LEDR[0]);

endmodule

module subcirc (right, left, LoadLeft, D, loadn, clock, reset, Q);
	input right, left, LoadLeft, D, loadn, clock, reset;
	output Q;
	wire a, b;
	
	mux21 first(.x(right), .y(left), .s(LoadLeft), .m(a));
	mux21 second(.x(D), .y(a), .s(loadn), .m(b));
	
	ff floop(clock, reset, b, Q);
	
endmodule

module ff(clock, reset, d, q);
	input clock, reset;
	input [7:0] d;
	output reg [7:0] q;
	
	always @(posedge clock)
	begin
		if (reset == 1'b1) //for active high
			q <= 8'd0;
		else
			q <= d;
	end
endmodule

module mux21(input x, y, s, output m);
    assign m = s ? y : x;
endmodule
