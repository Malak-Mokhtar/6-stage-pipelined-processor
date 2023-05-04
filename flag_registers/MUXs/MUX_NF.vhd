LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY MUX_NF IS 
	PORT ( NF_ALU,NF_RTI,RTI_en : IN  std_logic;
			NF_selected : OUT std_logic);
END MUX_NF;


ARCHITECTURE when_else_mux OF MUX_NF is
	BEGIN
		
    NF_selected <= 	NF_ALU when RTI_en = '0'
	else	NF_RTI; 
END when_else_mux;