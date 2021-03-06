LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY HALF_ADDER IS
    PORT(
        X,Y,C : IN STD_LOGIC;
        S,CRY : OUT STD_LOGIC
    );
END HALF_ADDER;

ARCHITECTURE ADD OF HALF_ADDER IS
BEGIN
    S <= ((NOT X) AND (NOT Y) AND (C)) OR ((NOT X)AND Y AND (NOT C)) OR (X AND (NOT Y) AND (NOT C)) OR (X AND Y AND C);
    CRY <= (X AND Y) OR (X AND C) OR (Y AND C);
END ADD;
