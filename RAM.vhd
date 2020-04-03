LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use std.textio.all;
ENTITY RAM IS
    GENERIC (
        WRD_WIDTH: INTEGER := 16;
        ADD_WIDTH: INTEGER := 12
    );
    PORT (
        CLK,EN_W,EN_R : IN STD_LOGIC;
	    ADDRESS  : IN STD_LOGIC_VECTOR (ADD_WIDTH-1 DOWNTO 0);
	    DATAIN   : IN STD_LOGIC_VECTOR (WRD_WIDTH-1 DOWNTO 0);
        DATAOUT  : OUT STD_LOGIC_VECTOR (WRD_WIDTH-1 DOWNTO 0)
    );
END RAM;

architecture ram_func of ram is
    type MEMORY is array ((2**ADD_WIDTH)-1 DOWNTO 0) of std_logic_vector (WRD_WIDTH-1 downto 0);

    impure function init_ram_bin return MEMORY is
        file text_file : text open read_mode is "Simple2.bin";    --File name here
        variable text_line : line;
        variable ram_content : MEMORY;
        variable bv : bit_vector(ram_content(0)'range);
      begin
        for i in 0 to (2**ADD_WIDTH) - 1 loop
            IF(NOT ENDFILE(text_file)) THEN
                readline(text_file, text_line);
                read(text_line, bv);
                ram_content(i) := To_StdLogicVector(bv);
            else
                ram_content(i) := (OTHERS=>'1') ;
            END IF;
        end loop;
        return ram_content;
      end function;
    signal ram: MEMORY := init_ram_bin;

begin
    process (clk) is
    begin
        IF rising_edge(CLK) THEN
            IF EN_W='1' THEN
                ram(to_integer(unsigned(address))) <= datain;
            END IF;
            -- IF EN_R = '1' THEN
            --     dataout <= ram(to_integer(unsigned((address))));
            -- END IF;
        END IF;
    end process;
    dataout <= ram(to_integer(unsigned((address))));
end ram_func;
