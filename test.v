module DSP48A1 (A,B,C,D,CARRYIN,M,P,CARRYOUT,CARRYOUTF,CLK,OPMODE,CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP,RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP,BCIN,BCOUT,PCIN,PCOUT);
parameter A0REG=0;			//parameters
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

input[17:0]A,B,D,BCIN;										//inputs
input[47:0]C,PCIN;
input CARRYIN,CLK,CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP,RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP;
input[7:0]OPMODE;

output reg[17:0]BCOUT;											//outputs
output reg[47:0]P,PCOUT;
output reg[35:0]M;
output reg CARRYOUT,CARRYOUTF;

reg[17:0]A0_reg,A1_reg,B0_reg,B1_reg,D_reg,A0_mux,A1_mux,B_mux,B0_mux,B1_mux,D_mux,B_D_prime,B_D_mux;					//regs
reg[47:0]C_reg,P_reg,X,Z,C_mux,P_prime;
reg[35:0]M_reg;
reg[7:0]OPMODE_reg,OPMODE_mux;
reg CARRYIN_reg,CARRYOUT_reg,CARRYINCascade,CARRYIN_mux,CYO;

always @(*) begin
	if (A0REG) begin
		A0_mux=A0_reg;
	end
	else begin
		A0_mux=A;
	end
	if (A1REG) begin
		A1_mux=A1_reg;
	end
	else begin
		A1_mux=A0_mux;
	end
	if (B_INPUT=="DIRECT") begin
		B_mux=B;
	end
	else if (B_INPUT=="CASCADE") begin
		B_mux=BCIN;
	end
	else begin
		B_mux=0;
	end
	if (B0REG) begin
		B0_mux=B0_reg;
	end
	else begin
		B0_mux=B_mux;
	end
	if (B1REG) begin
		B1_mux=B1_reg;
		BCOUT = B1_mux;
	end
	else begin
		B1_mux=B_D_mux;
		BCOUT = B1_mux;
	end
	if (CREG) begin
		C_mux=C_reg;
	end
	else begin
		C_mux=C;
	end
	if (DREG) begin
		D_mux=D_reg;
	end
	else begin
		D_mux=D;
	end
	if (OPMODEREG) begin
		OPMODE_mux=OPMODE_reg;
	end
	else begin
		OPMODE_mux=OPMODE;
	end
	if (CARRYINSEL=="CARRYIN") begin
		CARRYINCascade=CARRYIN;
	end
	else if (CARRYINSEL=="OPMODE5") begin
		CARRYINCascade=OPMODE_mux[5];
	end
	else begin
		CARRYINCascade=0;
	end
	if (CARRYINREG) begin
		CARRYIN_mux=CARRYIN_reg;
	end
	else begin
		CARRYIN_mux=CARRYINCascade;
	end
	if (CARRYOUTREG) begin
		CARRYOUT=CARRYOUT_reg;
		CARRYOUTF = CARRYOUT;
	end
	else begin
		CARRYOUT=CYO;
		CARRYOUTF = CARRYOUT;
	end
	if (MREG) begin
		M=M_reg;
	end
	else begin
		M=B1_mux*A1_mux;
	end
	if (PREG) begin
		P=P_reg;
		PCOUT = P;
	end
	else begin
		P=P_prime;
		PCOUT = P;
	end

	case(OPMODE_mux[1:0])
	0:  X = 0;
	1:  X = M;
	2:  X = PCOUT;
	default:  X = {D_mux[11:0],A1_mux,B1_mux};
	endcase
	case(OPMODE_mux[3:2])
	0:  Z = 0;
	1:  Z = PCIN;
	2:  Z = P;
	default:  Z = C_mux;
	endcase
	if (OPMODE_mux[4]) begin
		B_D_mux=B_D_prime;
	end
	else begin
		B_D_mux=B0_mux;
	end
	if (OPMODE_mux[6]) begin
		B_D_prime=B0_mux+D_mux;
	end
	else begin
		B_D_prime=D_mux-B0_mux;
	end
	if (OPMODE_mux[7]) begin
		{CYO,P_prime}=X+Z+CARRYIN_mux;
	end
	else begin
		{CYO,P_prime}=Z-(X+CARRYIN_mux);
	end
end

if (RSTTYPE=="ASYNC")begin
	always @(posedge CLK or posedge RSTA or posedge RSTB or posedge RSTC or posedge RSTCARRYIN or posedge RSTD or posedge RSTM or posedge RSTOPMODE or posedge RSTP) begin
		if (RSTA) begin
			A0_reg<=0;
			A1_reg<=0;
		end
		else if (CEA) begin
			A0_reg<=A;
			A1_reg<=A0_mux;
		end
		if (RSTB) begin
			B0_reg<=0;
			B1_reg<=0;
		end
		else if (CEB) begin
			B0_reg<=B_mux;
			B1_reg<=B_D_mux;
		end
		if (RSTC) begin
			C_reg<=0;
		end
		else if (CEC) begin
			C_reg<=C;
		end
		if (RSTD) begin
			D_reg<=0;
		end
		else if (CED) begin
			D_reg<=D;
		end
		if (RSTM) begin
			M_reg<=0;
		end
		else if (CEM) begin
			M_reg<=B1_mux*A1_mux;
		end
		if (RSTP) begin
			P_reg<=0;
		end
		else if (CEP) begin
			P_reg<=P_prime;
		end
		if (RSTCARRYIN) begin
			CARRYIN_reg<=0;
			CARRYOUT_reg<=0;
		end
		else if (CECARRYIN) begin
			CARRYIN_reg<=CARRYINCascade;
			CARRYOUT_reg<=CYO;
		end
		if (RSTOPMODE) begin
			OPMODE_reg<=0;
		end
		else if (CEOPMODE) begin
			OPMODE_reg<=OPMODE;
		end
	end
end
else if (RSTTYPE=="SYNC")begin
	always @(posedge CLK) begin
		if (RSTA && CEA) begin
			A0_reg<=0;
			A1_reg<=0;
		end
		else if (CEA) begin
			A0_reg<=A;
			A1_reg<=A0_mux;
		end
		if (RSTB && CEB) begin
			B0_reg<=0;
			B1_reg<=0;
		end
		else if (CEB) begin
			B0_reg<=B_mux;
			B1_reg<=B_D_mux;
		end
		if (RSTC && CEC) begin
			C_reg<=0;
		end
		else if (CEC) begin
			C_reg<=C;
		end
		if (RSTD && CED) begin
			D_reg<=0;
		end
		else if (CED) begin
			D_reg<=D;
		end
		if (RSTM && CEM) begin
			M_reg<=0;
		end
		else if (CEM) begin
			M_reg<=B1_mux*A1_mux;
		end
		if (RSTP && CEP) begin
			P_reg<=0;
		end
		else if (CEP) begin
			P_reg<=P_prime;
		end
		if (RSTCARRYIN && CECARRYIN) begin
			CARRYIN_reg<=0;
			CARRYOUT_reg<=0;
		end
		else if (CECARRYIN) begin
			CARRYIN_reg<=CARRYINCascade;
			CARRYOUT_reg<=CYO;
		end
		if (RSTOPMODE && CEOPMODE) begin
			OPMODE_reg<=0;
		end
		else if (CEOPMODE) begin
			OPMODE_reg<=OPMODE;
		end
	end
end
endmodule