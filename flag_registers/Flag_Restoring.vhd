LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY Flag_Restoring IS 
	PORT ( Read_Data: IN std_logic_vector (15 DOWNTO 0);
			ZF_RTI,CF_RTI,NF_RTI : OUT std_logic);
END Flag_Restoring;


ARCHITECTURE Flag_Restoring_arch OF Flag_Restoring is
	BEGIN
		
    ZF_RTI <= Read_Data(2);
    CF_RTI <= Read_Data(1);
    NF_RTI <= Read_Data(0);

END Flag_Restoring_arch;