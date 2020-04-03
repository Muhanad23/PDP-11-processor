LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY ALSU IS
    PORT(
        A,B  : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        S    : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        CIN  : IN STD_LOGIC;
        COUT : out STD_LOGIC;
        F    : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        FLAGS  :  OUT  STD_LOGIC_VECTOR (4 DOWNTO 0)
    );
END ALSU;

ARCHITECTURE ALSU_FUNC OF ALSU IS
  COMPONENT ALU IS
      PORT(
          A,B : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
          S   : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
          CIN : IN STD_LOGIC;
          COUT: OUT STD_LOGIC;
          F   : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
      );
  END COMPONENT;
  COMPONENT PARTA IS
      PORT(
          A,B : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
          S   : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
          CIN : IN STD_LOGIC;
          COUT: OUT STD_LOGIC;
          F   : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
      );
  END COMPONENT;
    SIGNAL F0,F1,TMP_F: STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL C0,C1: STD_LOGIC;
begin
    ALU_C: ALU PORT MAP (B,A,S,CIN,C0,F0);
    PART_A: PARTA PORT MAP (A,B,S (1 DOWNTO 0),CIN,C1,F1);
    F<= F1 WHEN S(3 DOWNTO 2)="00"
    ELSE F0;
    COUT<= C1 WHEN S(3 DOWNTO 2)="00"
    ELSE C0;

    TMP_F <= F1 WHEN S(3 DOWNTO 2)="00"
    ELSE F0;

    -- Flag(0) => C
    -- Flag(1) => Z
    -- Flag(2) => N
    -- Flag(3) => P
    -- Flag(4) => O
    -- FLAG <= (OTHERS => 'Z');
    FLAGS(0) <= C1 WHEN S(3 DOWNTO 2)="00"
                ELSE C0;
    FLAGS(1) <= '1' WHEN TMP_F = X"0000"
                ELSE '0';
    FLAGS(2) <= TMP_F(15);
    FLAGS(3) <= NOT TMP_F(0);
    FLAGS(4) <= '1' WHEN (S="0001" AND ((A(15)='0' AND B(15)='0' AND TMP_F(15)='1') OR (A(15)='1' AND B(15)='1' AND TMP_F(15)='0')))
                        OR (S="0010" AND ((A(15)='0' AND B(15)='1' AND TMP_F(15)='1') OR (A(15)='1' AND B(15)='0' AND TMP_F(15)='0')))
                ELSE '0';

END ALSU_FUNC;
