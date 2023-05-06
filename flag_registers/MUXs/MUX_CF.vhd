LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY MUX_CF IS 
	PORT ( CF_EXCEPT_RTI,CF_RTI,FLAGS_en : IN  std_logic;
			CF_selected : OUT std_logic);
END MUX_CF;


ARCHITECTURE when_else_mux OF MUX_CF is
	BEGIN
		
    CF_selected <= 	CF_EXCEPT_RTI when FLAGS_en = '0'
	else	CF_RTI; 
END when_else_mux; --T3BT