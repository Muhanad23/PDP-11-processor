LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY DECODING_CIRCUIT IS
PORT(IR,FLAG: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	FLAG_OUT: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
	CLK: IN STD_LOGIC;
	NEXT_ADDRESS: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	MICRO_AR: INOUT STD_LOGIC_VECTOR(4 DOWNTO 0));
END ENTITY;


ARCHITECTURE CIRCUIT OF DECODING_CIRCUIT IS
BEGIN
	PROCESS(CLK,IR)
	VARIABLE BRFALSE,NOP_HLT,I_SRC,I_DST,BR,AI_SRC,AI_DST,AD_SRC,AD_DST,R_SRC,R_DST,IND_REG_SRC,IND_REG_DST,D_REG_SRC,D_REG_DST,MOV_CLR,D_REG_DST_MOV,UNCOND,BEQ,BNE,BLO,BLS,BHI,BHS,BRTRUE,IND_OTHERS_SRC,IND_OTHERS_DST,CMP,ORDST: STD_LOGIC;
	VARIABLE ORING1,ORING2,ORING3,ORING4,ORING5,ORING6,FLAG5,FLAG6:STD_LOGIC;
	BEGIN
	--SELECTING WHICH ORING CIRCUIT TO BE EXECUTED
	ORING1:=(NOT MICRO_AR(4)) AND (NOT MICRO_AR(3)) AND (NOT MICRO_AR(2)) AND MICRO_AR(1) AND MICRO_AR(0);
	ORING2:=((NOT MICRO_AR(4)) AND MICRO_AR(3) AND (NOT MICRO_AR(0)) AND (MICRO_AR(1) NAND MICRO_AR(2)));
	ORING3:=(NOT MICRO_AR(4)) AND (MICRO_AR(3)) AND (MICRO_AR(2)) AND (NOT MICRO_AR(1)) AND MICRO_AR(0);
	ORING4:=(NOT MICRO_AR(4)) AND MICRO_AR(3) AND MICRO_AR(2) AND MICRO_AR(1);
	ORING5:=((MICRO_AR(4)) AND (NOT MICRO_AR(3)) AND (MICRO_AR(2)) AND (NOT MICRO_AR(1)) AND (NOT MICRO_AR(0)));
	ORING6:=MICRO_AR(4) AND MICRO_AR(3) AND MICRO_AR(1) AND MICRO_AR(0) AND (NOT MICRO_AR(2));
	MOV_CLR:=(IR(15) AND (NOT IR(14)) AND (NOT IR(13)) AND (NOT IR(12))) OR (IR(15) AND IR(14) AND IR(13) AND (NOT IR(12)) AND (NOT IR(11)) AND (NOT IR(10)) AND IR(9) AND (NOT IR(8)));
	NOP_HLT:=IR(15) AND IR(14) AND IR(13) AND IR(12);
	BR:=IR(15) AND IR(14) AND (NOT IR(13));
	I_SRC:=IR(9) AND IR(10) AND (NOT FLAG(5)) AND (NOT BR);
	I_DST:=IR(3) AND IR(4) AND (FLAG(5)) AND (NOT BR);
	AI_SRC:=(NOT IR(10)) AND IR(9) AND (NOT FLAG(5)) AND (NOT BR);
	AI_DST:=IR(3) AND (NOT IR(4)) AND (FLAG(5)) AND (NOT BR);
	AD_SRC:=IR(10) AND (NOT IR(9)) AND (NOT FLAG(5)) AND (NOT BR);
	AD_DST:=IR(4) AND (NOT IR(3)) AND (FLAG(5)) AND (NOT BR);
	R_SRC:=(NOT IR(10)) AND (NOT IR(9)) AND (NOT FLAG(5)) AND (NOT BR);
	R_DST:=(NOT IR(3)) AND (NOT IR(4)) AND (FLAG(5) ) AND (NOT BR);
	IND_REG_DST:=IR(5) AND (NOT IR(3)) AND (NOT IR(4)) AND (FLAG(5) ) AND (NOT BR);
	IND_REG_SRC:=IR(11) AND (NOT IR(10)) AND (NOT IR(9)) AND (NOT FLAG(5)) AND (NOT BR);
	D_REG_SRC:=(NOT IR(11)) AND (NOT IR(10)) AND (NOT IR(9)) AND (NOT FLAG(5)) AND (NOT BR);
	D_REG_DST:=(NOT IR(5)) AND (NOT IR(4)) AND (NOT IR(3)) AND (FLAG(5) ) AND (NOT MOV_CLR) AND (NOT BR);
	D_REG_DST_MOV:=(NOT IR(5)) AND (NOT IR(4)) AND (NOT IR(3)) AND (FLAG(5) ) AND MOV_CLR AND (NOT BR);
	IND_OTHERS_SRC:=IR(11) AND (AI_SRC OR I_SRC OR AD_SRC);
	IND_OTHERS_DST:=IR(5) AND (AI_DST OR I_DST OR AD_DST);
	CMP:=(NOT IR(15)) AND IR(14) AND IR(13) AND (NOT IR(12));
	UNCOND:=BR AND (NOT IR(12)) AND (NOT IR(11)) AND (NOT IR(10));
	BEQ:=BR AND (NOT IR(12)) AND (NOT IR(11)) AND (IR(10)) AND FLAG(1);
	BNE:=BR AND (NOT IR(12)) AND (IR(11)) AND (NOT IR(10)) AND (NOT FLAG(1));
	BLO:=BR AND (NOT IR(12)) AND (IR(11)) AND (IR(10)) AND (NOT FLAG(0));
	BLS:=BR AND (IR(12)) AND (NOT IR(11)) AND (NOT IR(10)) AND (NOT FLAG(0)) AND FLAG(1);
	BHI:=BR AND (IR(12)) AND (NOT IR(11)) AND (IR(10)) AND (FLAG(0));
	BHS:=BR AND (IR(12)) AND (IR(11)) AND (NOT IR(10)) AND (FLAG(1) OR FLAG(0));
	BRTRUE:=UNCOND OR BEQ OR BNE OR BLO OR BLS OR BHI OR BHS;
	BRFALSE:=BR AND (NOT BRTRUE);
	FLAG5:=(IR(15) AND IR(14) AND IR(13) AND (NOT IR(12))) OR (((NOT NEXT_ADDRESS(4)) AND (NOT NEXT_ADDRESS(3)) AND (NOT NEXT_ADDRESS(2)) AND (NEXT_ADDRESS(1)) AND (NEXT_ADDRESS(0)))AND (NOT FLAG(5)) AND FLAG(6) AND (NOT NOP_HLT));
	FLAG6:=(NOT MICRO_AR(4)) AND (NOT MICRO_AR(3)) AND (NOT MICRO_AR(2)) AND (MICRO_AR(1)) AND (MICRO_AR(0));
	--HANDLING HLT AND NO OPERATION
	IF NOP_HLT='1' THEN
		IF IR(11)='1' THEN
			MICRO_AR<="11111";
		ELSE
			MICRO_AR<="00000";
	
		END IF;
	END IF;
	--HANDLING OR DESTINATIOON
	IF FLAG6='1' THEN
		FLAG_OUT(1)<='1';
	END IF;
	IF FLAG5='1' THEN
		FLAG_OUT(0)<='1';
	END IF;
	IF MICRO_AR="00001" THEN
		FLAG_OUT(1 DOWNTO 0)<="00";
	END IF;
-----------------------------------------------------------WIDE BRANCH (BIT ORING 1)----------------------------------------------------------
	IF FALLING_EDGE(CLK) THEN
		IF ORING1='1' THEN
			--HANDLING BRANCHES
			IF BRTRUE='1' THEN
				MICRO_AR<="10111";

			--SOURCE
			ELSIF I_SRC='1' THEN
				MICRO_AR<="00100";
			ELSIF AI_SRC='1' THEN
				MICRO_AR<="01001";
			ELSIF AD_SRC='1' THEN
				MICRO_AR<="01011";
			ELSIF IND_REG_SRC='1' THEN
				MICRO_AR<="01111";
			ELSIF D_REG_SRC='1' THEN
				MICRO_AR<="10010";

			--DESTINATION
			ELSIF I_DST='1' THEN
				MICRO_AR<="00100";
			ELSIF AI_DST='1' THEN
				MICRO_AR<="01001";
			ELSIF AD_DST='1' THEN
				MICRO_AR<="01011";
			ELSIF IND_REG_DST='1' THEN
				MICRO_AR<="01111";
			ELSIF D_REG_DST='1' THEN
				MICRO_AR<="10011";

			--DESTINATION IN CLEAR , MOV
			ELSIF D_REG_DST_MOV='1' THEN
				MICRO_AR<="11100";

			--FETCH THE NEXT INSTRUCTION IF THERE IS NO WIDE BRANCHES
			ELSE
				MICRO_AR<="00000";
			END IF;

-----------------------------------------------------------(BIT ORING 2)----------------------------------------------------------
		ELSIF ORING2='1' THEN
			IF D_REG_DST_MOV='1' THEN
				MICRO_AR<="01101";
			ELSE
				MICRO_AR<="11010";
			END IF;

-----------------------------------------------------------(BIT ORING 3)----------------------------------------------------------
		ELSIF ORING3='1' THEN
			IF IND_OTHERS_SRC='1' OR  IND_OTHERS_DST='1' THEN
				MICRO_AR<="01110";
			ELSIF FLAG(5)='0' THEN
				MICRO_AR<="10000";
			ELSE
				MICRO_AR<="10001";
			END IF;
-----------------------------------------------------------(BIT ORING 4)----------------------------------------------------------
		ELSIF ORING4='1' THEN
			IF FLAG(5)='1' AND MOV_CLR='1' AND (NOT BR)='1' THEN
				MICRO_AR<="11100";
			ELSE
				MICRO_AR<="11011";
			END IF;
-----------------------------------------------------------(BIT ORING 5)----------------------------------------------------------
		ELSIF ORING5='1' THEN
			IF CMP='1' THEN
				MICRO_AR<="00000";
			ELSIF IR(5)='0' AND IR(4)='0' AND IR(3)='0' THEN
				MICRO_AR<="10110";
			ELSE
				MICRO_AR<="10101";
			END IF;
-----------------------------------------------------------(BIT ORING 6)----------------------------------------------------------
		ELSIF ORING6='1' THEN
			MICRO_AR<= "1000"&FLAG(5);
-----------------------------------------------------------(NO BIT ORING)----------------------------------------------------------
		ELSE
			MICRO_AR<=NEXT_ADDRESS;
		END IF;
	END IF;
	END PROCESS;
END ARCHITECTURE;
