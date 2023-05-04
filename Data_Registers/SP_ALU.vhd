LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY SP_ALU IS
    PORT (
        SP_en, inc_en : IN STD_LOGIC;
        sp_before : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        sp_after : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END SP_ALU;

ARCHITECTURE arch OF SP_ALU IS

BEGIN

    sp_after <= STD_LOGIC_VECTOR(unsigned(sp_before) - 1) WHEN SP_en = '1' AND inc_en = '0' ELSE
        STD_LOGIC_VECTOR(unsigned(sp_before) + 1) WHEN SP_en = '1' AND inc_en = '1' ELSE
        sp_before WHEN SP_en = '0' AND inc_en = '0' ELSE
        sp_before WHEN SP_en = '0' AND inc_en = '1';

END ARCHITECTURE;