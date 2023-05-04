LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY MUX_DEC_ADD IS 
	PORT ( Immediate_en : IN  std_logic;
			Add_Value : OUT std_logic_vector (15 DOWNTO 0));
END MUX_DEC_ADD;


ARCHITECTURE when_else_mux OF MUX_DEC_ADD is
	BEGIN
		
    Add_Value <= (0=>'1',others=>'0') when Immediate_en = '0'
	else (1=>'1',others=>'0') ; 
END when_else_mux;