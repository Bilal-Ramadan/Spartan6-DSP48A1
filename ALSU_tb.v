module ALSU_tb ();
parameter INPUT_PRIORITY="A";
parameter FULL_ADDER="ON";
reg clk, rst, cin, serial_in, red_op_A, red_op_B, bypass_A, bypass_B, direction;
reg [2: 0] A, B, opcode;
wire [15: 0] leds_tb;
wire [5: 0] out_tb;
ALSU #(.INPUT_PRIORITY(INPUT_PRIORITY),.FULL_ADDER(FULL_ADDER)) DUT (A,B, opcode, cin, serial_in, direction, red_op_A, red_op_B, bypass_A, bypass_B, clk, rst, out_tb, leds_tb);
initial begin
clk = 0;
forever
#1 clk = ~clk;
end
initial begin
	rst = 1;
	repeat (10) begin
		@(negedge clk);
		A = $random; B = $random; opcode = $random; cin = $random; serial_in = $random;; red_op_A = $random; red_op_B = $random; bypass_A = $random; bypass_B = $random; direction = $random;
		if ((out_tb != 0) || (leds_tb != 0)) begin
			$display("Error");
			$stop;
		end
	end
	rst = 0;
	bypass_A = 1; bypass_B = 0;
	repeat (10) begin
		@(negedge clk);
		A = $random; B = $random; opcode = $random; cin = $random; serial_in = $random; direction = $random; red_op_A = $random; red_op_B = $random;
		if ((out_tb != A) || (leds_tb != 0)) begin
			$display("Error");
			$stop;
		end
	end
	bypass_A = 0; bypass_B = 1;
	repeat (10) begin
		@(negedge clk);
		A = $random; B = $random; opcode = $random; cin = $random; serial_in = $random; direction = $random; red_op_A = $random; red_op_B = $random;
		if ((out_tb != B) || (leds_tb != 0)) begin
			$display("Error");
			$stop;
		end
	end
	bypass_A = 1;
	repeat (10) begin
		@(negedge clk);
		A = $random; B = $random; opcode = $random; cin = $random; serial_in = $random; direction = $random; red_op_A = $random;red_op_B = $random;
		if ((out_tb != A) || (leds_tb != 0)) begin
			$display("Error");
			$stop;
		end
	end
	bypass_A = 0; bypass_B = 0;
	repeat (100) begin
		@(negedge clk);
		A = $random; B = $random; opcode = $random; cin = $random;serial_in = $random; direction = $random; red_op_A = $random;red_op_B = $random;
	end
	$stop;
end
initial
$monitor("time = %0t, A = %b, B = %b, opcode = %b, cin = %b, serial_in = %b, direction= %b, red_op_A = %b, red_op_B = %b, bypass_A = %b, bypass_B = %b, clk = %b,
rst= %b, out = %b, leds = %b",$time,A, B, opcode, cin, serial_in, direction, red_op_A, red_op_B, bypass_A, bypass_B, clk, rst, out_tb, leds_tb);
endmodule