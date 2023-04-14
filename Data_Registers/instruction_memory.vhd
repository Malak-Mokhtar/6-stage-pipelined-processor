LIBRARY IEEE;

USE IEEE.std_logic_1164.ALL;

USE IEEE.numeric_std.ALL;

ENTITY IC IS
    PORT (
        -- clk: IN STD_LOGIC;
        Read_Address : IN STD_LOGIC_VECTOR(15 DOWNTO 0); --input read address

        Inst : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END IC;

ARCHITECTURE arch OF IC IS

    TYPE IC_type IS ARRAY (0 TO 65535) OF STD_LOGIC_VECTOR(15 DOWNTO 0);

    SIGNAL instruction_cache : IC_type; -- 65535 by 16 bit array

BEGIN
    --getting the address of 16 bits and the one near it
    Inst <= instruction_cache(to_integer(unsigned(Read_Address))) & instruction_cache(to_integer(unsigned(Read_Address)) + 1);
END ARCHITECTURE; -- arch