LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY adder IS
    PORT (
        FD_Read_Address_out : in STD_LOGIC_VECTOR(15 DOWNTO 0);
        IN_PC : out STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END adder;

ARCHITECTURE my_adder OF adder IS
BEGIN
    
IN_PC <= STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(FD_Read_Address_out)) + 1, 16));
        
 
END my_adder;