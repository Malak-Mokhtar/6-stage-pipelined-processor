LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY Zero_except_RTI IS 
	PORT ( ZF_ALU,JZ_en : IN  std_logic;
			ZF_EXCEPT_RTI : OUT std_logic);
END Zero_except_RTI;


ARCHITECTURE Zero_except_RTI_arch OF Zero_except_RTI is
	BEGIN
		
    ZF_EXCEPT_RTI <= (ZF_ALU) and (not JZ_en);
    
END Zero_except_RTI_arch;