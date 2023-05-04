LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY MUX_MEM_DATA IS 
	PORT ( ALU_out,Read_Address,Flags: IN std_logic_vector (15 DOWNTO 0);
			Flags_en, Interrupt_en : IN  std_logic;
			Read_Data : OUT std_logic_vector (15 DOWNTO 0));
END MUX_MEM_DATA;


ARCHITECTURE when_else_mux OF MUX_MEM_DATA is
	BEGIN
		
    Read_Data <= 	ALU_out when Flags_en = '0' and Interrupt_en = '0'
	else	Read_Address when Flags_en = '0' and Interrupt_en = '1'
	else	Flags; 
END when_else_mux;