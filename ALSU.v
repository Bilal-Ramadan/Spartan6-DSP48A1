module ALSU (clk,rst,A,B,cin,serial_in,red_op_A,red_op_B,opcode,bypass_A,bypass_B,direction,leds,out);
parameter INPUT_PRIORITY="A";
parameter FULL_ADDER="ON";
input clk,rst,cin,serial_in,red_op_A,red_op_B,bypass_A,bypass_B,direction;
input [2:0]A,B,opcode;
output reg[15:0] leds;
output reg[5:0] out;
reg cin_ff,serial_in_ff,red_op_A_ff,red_op_B_ff,opcode_ff,bypass_A_ff,bypass_B_ff,direction_ff;
reg [2:0]A_ff,B_ff;
always @(posedge clk) begin
	cin_ff<=cin;
	serial_in_ff<=serial_in;
	red_op_A_ff<=red_op_A;
	red_op_B_ff<=red_op_B;
	opcode_ff<=opcode_ff;
	bypass_A_ff<=bypass_A;
	bypass_B_ff<=bypass_B;
	direction_ff<=direction;
end
always @(posedge clk or posedge rst) begin
	if (rst) begin
		out<=0;
		leds<=0;
	end
	else if ((bypass_A_ff&&!bypass_B_ff)||(bypass_A_ff&&bypass_B_ff&&INPUT_PRIORITY=="A")) begin
		leds<=0;
		out<=A_ff;
	end
	else if ((!bypass_A_ff&&bypass_B_ff)||(bypass_A_ff&&bypass_B_ff&&INPUT_PRIORITY=="B")) begin
		leds<=0;
		out<=B_ff;
	end
	else begin
		case(opcode_ff) 
		0:
		begin
			leds<=0;
			if ((red_op_A_ff&&!red_op_B_ff)||(red_op_A_ff&&red_op_B_ff&&INPUT_PRIORITY=="A")) begin
				out<=&A_ff;
			end
			else if ((!red_op_A_ff&&red_op_B_ff)||(red_op_A_ff&&red_op_B_ff&&INPUT_PRIORITY=="B")) begin
				out<=&B_ff;
			end
			else begin
				out<=A_ff&B_ff;
			end
		end
		1: 
		begin
			leds<=0;
			if ((red_op_A_ff&&!red_op_B_ff)||(red_op_A_ff&&red_op_B_ff&&INPUT_PRIORITY=="A")) begin
				out<=^A_ff;
			end
			else if ((!red_op_A_ff&&red_op_B_ff)||(red_op_A_ff&&red_op_B_ff&&INPUT_PRIORITY=="B")) begin
				out<=^B_ff;
			end
			else begin
				out<=A_ff^B_ff;
			end
		end
		2:
		begin
			leds<=0;
			if (red_op_A_ff||red_op_B_ff) begin //invalid case
				leds<=~leds;
				out<=0;
			end	
			else if (FULL_ADDER=="ON") begin
				out<=A_ff+B_ff+cin_ff;
			end
			else begin
				out<=A_ff+B_ff;
			end
		end
		3: 
		begin
			leds<=0;
			if (red_op_A_ff||red_op_B_ff) begin //invalid case
				leds<=~leds;
				out<=0;
			end	
			else begin
				out<=A_ff*B_ff;
			end
		end
		4: 
		begin
			leds<=0;
			if (red_op_A_ff||red_op_B_ff) begin //invalid case
				leds<=~leds;
				out<=0;
			end	
			else if(direction_ff) begin
				out<=out*2+serial_in_ff;
			end
			else begin
				out<={serial_in_ff,out[5],out[4],out[3],out[2],out[1]};
			end
		end
		5: 
		begin
			leds<=0;
			if (red_op_A_ff||red_op_B_ff) begin //invalid case
				leds<=~leds;
				out<=0;
			end	
			else if(direction_ff) begin
				out<={out[4],out[3],out[2],out[1],out[0],out[5]};
			end
			else begin
				out<={out[0],out[5],out[4],out[3],out[2],out[1]};
			end
		end
		6:										//invalid case
		begin
			leds<=~leds;
			out<=0;
		end
		7:										//invalid case
		begin
			leds<=~leds;
			out<=0;
		end
		endcase
	end
end
endmodule