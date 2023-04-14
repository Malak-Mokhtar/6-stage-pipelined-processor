Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Control_Unit IS
PORT( OPCODE : IN std_logic_vector(4 DOWNTO 0);
IN_en,Carry_en, ALU_en, RegWrite_en, Mem_to_Reg_en, MemWrite_en, MemRead_en : OUT std_logic
);
END Control_Unit;


ARCHITECTURE a_Control_Unit OF Control_Unit IS
BEGIN

-- Note: All enables must put values on them even if will not use to avoid producing latches

PROCESS(OPCODE)
BEGIN
	IF(OPCODE = "00000") THEN -- NOP
		IN_en <= '0';
		Carry_en <= '0';
		ALU_en <= '0';
		RegWrite_en <= '0';
		Mem_to_Reg_en <= '0';
		MemWrite_en <= '0';
		MemRead_en <= '0';

	ELSIF (OPCODE = "01110") THEN --INC
		IN_en <= '0';
		Carry_en <= '1';
		ALU_en <= '1';
		RegWrite_en <= '1';
		Mem_to_Reg_en <= '0';
		MemWrite_en <= '0';
		MemRead_en <= '0';

	ELSIF (OPCODE = "01011") THEN --AND
		IN_en <= '0';
		Carry_en <= '0';
		ALU_en <= '1';
		RegWrite_en <= '1';
		Mem_to_Reg_en <= '0';
		MemWrite_en <= '0';
		MemRead_en <= '0';

	ELSIF (OPCODE = "00100") THEN --IN
		IN_en <= '1';
		Carry_en <= '0';
		ALU_en <= '0';
		RegWrite_en <= '1';
		Mem_to_Reg_en <= '0';
		MemWrite_en <= '0';
		MemRead_en <= '0';

	ELSIF (OPCODE = "10011") THEN --LDD
		IN_en <= '0';
		Carry_en <= '0';
		ALU_en <= '0';
		RegWrite_en <= '1';
		Mem_to_Reg_en <= '1';
		MemWrite_en <= '0';
		MemRead_en <= '1';

	ELSIF (OPCODE = "10100") THEN --STD
		IN_en <= '0';
		Carry_en <= '0';
		ALU_en <= '0';
		RegWrite_en <= '0';
		Mem_to_Reg_en <= '0';
		MemWrite_en <= '1';
		MemRead_en <= '0';

	ELSE
		IN_en <= '-';
		Carry_en <= '-';
		ALU_en <= '-';
		RegWrite_en <= '-';
		Mem_to_Reg_en <= '-';
		MemWrite_en <= '-';
		MemRead_en <= '-';

	END IF;
END PROCESS;

END a_Control_Unit;
