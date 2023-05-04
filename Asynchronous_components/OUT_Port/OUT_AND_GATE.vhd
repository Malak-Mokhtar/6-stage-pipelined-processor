LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY OUT_AND_GATE IS 
	PORT ( OUT_en_extended, MW_ALU_Out_out : IN  std_logic_vector (15 DOWNTO 0);
			OUT_Port : OUT std_logic_vector (15 DOWNTO 0));
END OUT_AND_GATE;


ARCHITECTURE OUT_AND_GATE_arch OF OUT_AND_GATE is
	BEGIN
		
    OUT_Port <= OUT_en_extended and MW_ALU_Out_out;

END OUT_AND_GATE_arch;