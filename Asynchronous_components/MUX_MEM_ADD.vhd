LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY MUX_MEM_ADD IS 
	PORT ( Read_Data1,SP_Before,SP_After: IN std_logic_vector (15 DOWNTO 0);
			SP_en,SP_inc_en,PC_or_addr1_en : IN  std_logic;
			Read_Addrs : OUT std_logic_vector (15 DOWNTO 0));
END MUX_MEM_ADD;


ARCHITECTURE when_else_mux OF MUX_MEM_ADD is
	BEGIN
		
    Read_Addrs <= 	Read_Data1 when SP_en = '0' and (SP_inc_en = '0' or PC_or_addr1_en = '0')
	else	x"0001" when SP_en = '0' and (SP_inc_en = '0' or PC_or_addr1_en = '1')
	else	SP_Before when SP_en = '1' and (SP_inc_en = '0' or PC_or_addr1_en = '0')
    else	SP_After; 
END when_else_mux;