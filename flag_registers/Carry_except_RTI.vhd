LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY Carry_except_RTI IS 
	PORT ( CF_ALU,SETC_en,CLRC_en,JC_en : IN  std_logic;
			CF_EXCEPT_RTI : OUT std_logic);
END Carry_except_RTI;


ARCHITECTURE Carry_except_RTI_arch OF Carry_except_RTI is
	BEGIN
		
    CF_EXCEPT_RTI <= (not JC_en) and ( ( (CF_ALU) and ( not CLRC_En ) ) or ( ( SETC_en ) and (not CLRC_en) ) ); 

END Carry_except_RTI_arch;