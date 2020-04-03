LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY TRI_STATE_BUFFER IS
    GENERIC(N : INTEGER := 16);
    PORT(
        EN      :   IN  STD_LOGIC;
        INPT    :   IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        OUTPT   :   OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE BUFFER_FUNC OF TRI_STATE_BUFFER IS
BEGIN

  OUTPT <= INPT WHEN EN='1'
          ELSE (OTHERS => 'Z');
    -- PROCESS(EN)
    -- BEGIN
    --     IF EN = '1' THEN
    --         OUTPT <= INPT;
    --     ELSE
    --         OUTPT <= (OTHERS => 'Z');
    --     END IF;
    -- END PROCESS;
END BUFFER_FUNC;
