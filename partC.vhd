LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY PARTC IS
    PORT(
        A    : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        S    : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        CIN  : IN STD_LOGIC;
        F    : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        COUT : OUT STD_LOGIC
    );
END PARTC;

ARCHITECTURE PARTC_FUNC OF PARTC IS
BEGIN
    COUT <= A(0) WHEN S(1)='1' AND S(0)='0';
    F<= '0' & A(15 DOWNTO 1) WHEN S(1)='0' AND S(0)='0'
    ELSE A(0) & A(15 DOWNTO 1) WHEN S(1)='0' AND S(0)='1'
    ELSE CIN & A(15 DOWNTO 1) WHEN S(1)='1' AND S(0)='0'
    ELSE A(15) & A(15 DOWNTO 1);
END PARTC_FUNC;