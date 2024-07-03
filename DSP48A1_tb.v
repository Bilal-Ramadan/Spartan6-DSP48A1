module DSP48A1_tb ();
parameter A0REG=0;			
parameter A1REG=1;
parameter B0REG=0;
parameter B1REG=1;
parameter CREG=1;
parameter DREG=1;
parameter MREG=1;
parameter PREG=1;
parameter CARRYINREG=1;
parameter CARRYOUTREG=1;
parameter OPMODEREG=1;
parameter CARRYINSEL="OPMODE5";
parameter B_INPUT="DIRECT";
parameter RSTTYPE="SYNC";
reg[17:0]A,B,D,BCIN;
reg[47:0]C,PCIN;
reg CARRYIN,CLK,CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP,RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP;
reg [7:0]OPMODE;
wire[17:0]BCOUT;											
wire[47:0]P,PCOUT;
wire[35:0]M;
wire CARRYOUT,CARRYOUTF;

DSP48A1 #(.A0REG(A0REG),.A1REG(A1REG),.B0REG(B0REG),.B1REG(B1REG),.CREG(CREG),.DREG(DREG),.MREG(MREG),.PREG(PREG),.CARRYINREG(CARRYINREG),.CARRYOUTREG(CARRYOUTREG),
	.OPMODEREG(OPMODEREG),.CARRYINSEL(CARRYINSEL),.B_INPUT(B_INPUT),.RSTTYPE(RSTTYPE)) 
DUT (A,B,C,D,CARRYIN,M,P,CARRYOUT,CARRYOUTF,CLK,OPMODE,CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP,RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP,BCIN,BCOUT,PCIN,PCOUT);
initial begin
CLK = 0;
forever
#1 CLK = ~CLK;
end
initial begin
RSTP = 1;
	repeat (10) begin
		@(negedge CLK);
		A = $random; B = $random; C = $random; D = $random; BCIN = $random; OPMODE = $random; CARRYIN = $random; CEA = $random; CEB = $random; CEC = $random;
		 CECARRYIN = $random; CED = $random; CEM = $random; CEOPMODE = $random; CEP = $random; RSTA = $random; RSTB = $random; RSTC = $random; RSTCARRYIN = $random; RSTD = $random; RSTM = $random; RSTOPMODE = $random; 
		#20
		if (P != 0) begin
			$display("Error");
			$stop;
		end
	end
RSTP=0;
	repeat (500) begin
		@(negedge CLK);
		A = $random; B = $random; C = $random; D = $random; BCIN = $random; OPMODE = $random; CARRYIN = $random; CEA = $random; CEB = $random; CEC = $random;
		 CECARRYIN = $random; CED = $random; CEM = $random; CEOPMODE = $random; CEP = $random; RSTA = $random; RSTB = $random; RSTC = $random; RSTCARRYIN = $random; RSTD = $random; RSTM = $random; RSTOPMODE = $random; 
		end
		$stop;
	end

endmodule