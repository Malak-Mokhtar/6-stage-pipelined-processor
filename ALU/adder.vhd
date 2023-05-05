LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY adder IS
    PORT (
        FD_Read_Address_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Add_Value : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC_Added : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
END adder;

ARCHITECTURE my_adder OF adder IS
BEGIN

    PC_Added <= FD_Read_Address_out + Add_Value;

END my_adder;