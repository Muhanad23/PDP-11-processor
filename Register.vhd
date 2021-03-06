LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY REG IS
	GENERIC(N : INTEGER := 16);
	PORT(
		CLK,RST	:	IN STD_LOGIC;
		W_EN	:	IN STD_LOGIC;
		D		:	IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		Q		:	OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
	);
END ENTITY REG;

ARCHITECTURE REG_ARCH OF REG IS
COMPONENT DFF IS
	PORT(
		D,CLK,RST	:	IN	STD_LOGIC;
		W_EN		:	IN 	STD_LOGIC;
		Q			:	OUT STD_LOGIC
	);
END COMPONENT;
BEGIN
	LP1:FOR i IN 0 TO N-1 GENERATE
			DF: DFF PORT MAP(D(i),CLK,RST,W_EN,Q(i));
		END GENERATE;
END REG_ARCH;