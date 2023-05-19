LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY Sign_Extend IS 
	PORT ( MW_OUT_en_out : IN  std_logic;
			MW_OUT_en_out_extended : OUT std_logic_vector (15 DOWNTO 0));
END Sign_Extend;


ARCHITECTURE Sign_Extend_arch OF Sign_Extend is
	BEGIN
		
    MW_OUT_en_out_extended <= (others=>MW_OUT_en_out);

END Sign_Extend_arch;