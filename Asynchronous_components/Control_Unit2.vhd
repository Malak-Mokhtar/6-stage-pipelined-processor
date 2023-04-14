LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Control_Unit IS

PORT( 
OPCODE : IN std_logic_vector(4 DOWNTO 0);
IN_en,Carry_en, ALU_en, RegWrite_en, Mem_to_Reg_en, MemWrite_en, MemRead_en : OUT std_logic);
END Control_Unit;

ARCHITECTURE my_Control_Unit OF Control_Unit IS
BEGIN

In_en <= not OPCODE(4) and not OPCODE(3) and OPCODE(2);
Carry_en <= OPCODE(3) and not OPCODE(0);
ALU_en <= OPCODE(3);
RegWrite_en <= OPCODE(1) OR (not OPCODE(4) AND OPCODE(2));
Mem_to_Reg_en <= not OPCODE(3) and OPCODE(1);
MemWrite_en <= OPCODE(4) and not OPCODE(1);
MemRead_en <= not OPCODE(3) and OPCODE(1);


END my_Control_Unit;



-----------------------------------------------REFERENCES--------------------------------------------------------------

--  1-  https://www.ilovefreesoftware.com/25/windows/free-truth-table-to-logic-circuit-converter-software-windows.html

--  2 - https://imgur.com/a/24k0Zsk