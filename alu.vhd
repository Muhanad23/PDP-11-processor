LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY ALU IS
    PORT(
        A,B : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        S   : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        CIN : IN STD_LOGIC;
        COUT: OUT STD_LOGIC;
        F   : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
END ALU;

ARCHITECTURE ALU_FUNC OF ALU IS
  COMPONENT PARTB IS
      PORT(
          A,B   : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
          S     : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
          CIN   : IN STD_LOGIC;
          F     : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
          COUT  : OUT STD_LOGIC
      );
  END COMPONENT;
  COMPONENT PARTC IS
      PORT(
          A    : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
          S    : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
          CIN  : IN STD_LOGIC;
          F    : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
          COUT : OUT STD_LOGIC
      );
  END COMPONENT;
  COMPONENT PARTD IS
      PORT(
          A    : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
          S    : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
          CIN  : IN STD_LOGIC;
          F    : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
          COUT : OUT STD_LOGIC
      );
  END COMPONENT;
    SIGNAL FB,FC,FD   : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL COUTB,COUTC,COUTD: STD_LOGIC;
BEGIN
    PPART_B: PARTB PORT MAP(A,B,S(1 DOWNTO 0),CIN,FB,COUTB);
    PART_C: PARTC PORT MAP(A,S(1 DOWNTO 0),CIN,FC,COUTC);
    PART_D: PARTD PORT MAP(A,S(1 DOWNTO 0),CIN,FD,COUTD);

    COUT <= COUTC WHEN S (3 DOWNTO 2)="10"
    ELSE COUTD WHEN S (3 DOWNTO 2) ="11"
    ELSE COUTB;

    F <= FB WHEN S (3 DOWNTO 2) ="01"
    ELSE FC WHEN S (3 DOWNTO 2) ="10"
    ELSE FD WHEN S (3 DOWNTO 2) ="11";

END ALU_FUNC;
