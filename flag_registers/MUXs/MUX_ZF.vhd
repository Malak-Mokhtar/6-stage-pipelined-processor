LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY MUX_ZF IS 
	PORT ( ZF_EXCEPT_RTI,ZF_RTI,RTI_en : IN  std_logic;
			ZF_selected : OUT std_logic);
END MUX_ZF;


ARCHITECTURE when_else_mux OF MUX_ZF is
	BEGIN
		
    ZF_selected <= 	ZF_EXCEPT_RTI when RTI_en = '0'
	else	ZF_RTI; 
END when_else_mux;