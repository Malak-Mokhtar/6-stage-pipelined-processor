LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY Concatenation_Extension IS 
	PORT ( ZF_OUT, CF_OUT, NF_OUT : IN  std_logic;
			Flags : OUT std_logic_vector (15 DOWNTO 0));
END Concatenation_Extension;

-- 0000 0000 0000 0(ZF)(CF)(NF)

ARCHITECTURE Concatenation_Extension_Arch OF Concatenation_Extension is
	BEGIN

	Flags <= (2=>ZF_OUT, 1=>CF_OUT, 0=>NF_OUT,others=>'0');
    
END Concatenation_Extension_Arch;