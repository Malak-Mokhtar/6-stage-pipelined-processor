LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Reg_file IS
    PORT (
        clk, en : IN STD_LOGIC;
        Read_Address1, Read_Address2, Write_Addesss : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Write_Data : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END Reg_file;

ARCHITECTURE arch OF Reg_file IS

BEGIN

END ARCHITECTURE;