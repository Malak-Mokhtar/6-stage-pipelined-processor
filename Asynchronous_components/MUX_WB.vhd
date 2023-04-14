LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY MUX_WB IS 
	PORT ( Read_Data,ALU_out,IN_PORT: IN std_logic_vector (15 DOWNTO 0);
			Mem_to_Reg_en, IN_en : IN  std_logic;
			Write_Data : OUT std_logic_vector (15 DOWNTO 0));
END MUX_WB;


ARCHITECTURE when_else_mux OF MUX_WB is
	BEGIN
		
    Write_Data <= 	ALU_out when Mem_to_Reg_en = '0' and IN_en = '0'
	else	IN_PORT when Mem_to_Reg_en = '0' and IN_en = '1'
	else	Read_Data; 
END when_else_mux;