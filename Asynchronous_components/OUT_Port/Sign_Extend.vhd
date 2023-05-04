LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY Sign_Extend IS 
	PORT ( OUT_en : IN  std_logic;
			OUT_en_extended : OUT std_logic_vector (15 DOWNTO 0));
END Sign_Extend;


ARCHITECTURE Sign_Extend_arch OF Sign_Extend is
	BEGIN
		
    OUT_en_extended <= (others=>OUT_en);

END Sign_Extend_arch;