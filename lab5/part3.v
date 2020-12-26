/*
Morse code encoder:
Take in one of the 8 letters of the alphabet and translate it to the morse code on LEDS (via flashing). Inputs for letters are SW 2-0. 
KEY[1] acts as the enable, and KEY[0] is the active-low synchronous reset. 
*/
module part3 (SW, KEY, LEDR, CLOCK_50);
	input [2:0] SW;
	input [3:0] KEY;
	input CLOCK_50;
	output [9:0] LEDR;
	wire enable;
	wire [10:0] d;
	wire [10:0] out;

	wire [7:0] speed;
	assign speed = 8'd249; //249;
	
	//output [7:0] x;
	//assign x = out;
	
	//LUT
	reg [11:0] letter;
	always @(*)
	begin
		case (SW[2:0])
			3'b000: letter= 12'b000000111010; //A
			3'b001: letter= 12'b001010101110;//B
			3'b010: letter= 12'b101110101110;//C
			3'b011: letter= 12'b000010101110; //D
			3'b100: letter= 12'b000000000010;//E
			3'b101: letter= 12'b001011101010; //F
			3'b110: letter= 12'b001011101110;//G
			3'b111: letter= 12'b000010101010; //H
		endcase
	end
	

	reg [8:0] ratedivider;
	always @(posedge CLOCK_50)
		begin
			if (KEY[0] == 1'b0) //active low reset
				ratedivider <= speed;
			else if (ratedivider != 0) 
				ratedivider <= ratedivider - 1; 
			else
				ratedivider <= speed;
		end
	
	assign enable = (ratedivider == 11'd0)? 1: 0;
	assign d = letter;
	
	shiftreg blah (CLOCK_50, KEY[0], enable, KEY[1], out, d);
	assign LEDR[0] = out[0];

endmodule


module shiftreg (clock, reset, enable, load, out, in);
	input [11:0] in;
	output reg [11:0] out;
	input reset, enable, clock, load;
	/*reg loadin;
	reg prev = 1'b1;
	
	always @(posedge clock)
	begin
		if (load == 1'b0 && prev == 1'b1) begin
			loadin <= 1'b0;
			prev <= 1'b0;
		end
		else if (load == 1'b0 && prev == 1'b0) begin
			loadin <= 1'b1;
			prev <= 1'b0;
		end
		else begin
			loadin <= load;
			prev <= load;
		end
	end	*/
	
	always @(posedge load)
		out <= in;
	
	always @(negedge reset)
		out <= 12'b0;
	
	always @(posedge clock, negedge reset) //async
	begin
		/*if (reset == 1'b0) //active low reset
			out <= 12'b0;
		else */
		if (enable == 1'b1) begin
			/*if (loadin == 1'b0) 
				out <= in << 1; //shift left to add a 0
			else if (loadin == 1'b1)
				out <= out >> 1; //shift right 1 */
			out[10:0] <= out[11:1];
			out[11] <= 1'b0;
		end
	end
endmodule
