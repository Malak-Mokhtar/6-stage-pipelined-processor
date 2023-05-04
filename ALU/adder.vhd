LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY adder IS
    PORT (
        FD_Read_Address_out : in STD_LOGIC_VECTOR(15 DOWNTO 0);
        Add_Value : in STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC_Added : out STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END adder;

ARCHITECTURE my_adder OF adder IS
BEGIN
    
PC_Added <= FD_Read_Address_out + Add_Value;
        
END my_adder;