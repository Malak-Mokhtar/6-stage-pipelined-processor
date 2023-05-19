LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Control_Unit IS

    PORT (
        OPCODE : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        IN_en, Carry_en, ALU_en, RegWrite_en, Mem_to_Reg_en, MemWrite_en, MemRead_en, SETC_en, CLRC_en, JZ_en, JC_en, JMP_en, CALL_en, Immediate_en, SP_en, SP_inc_en,
        RET_en, OUT_en, RTI_en, PC_disable : OUT STD_LOGIC;
        Interrupt_en : OUT STD_LOGIC;
        FLAGS_en : OUT STD_LOGIC;
        PC_or_addrs1_en : OUT STD_LOGIC

    );
END Control_Unit;

--                                                                                                                                                                                                                                                  A4 B3 C2 D1 E0
ARCHITECTURE my_Control_Unit OF Control_Unit IS
BEGIN

    In_en <= NOT OPCODE(4) AND NOT OPCODE(3) AND OPCODE(2) and (not OPCODE(0));
    Carry_en <= ((not OPCODE(4) and OPCODE(1)) and (not OPCODE(0))) or (not OPCODE(4) and (OPCODE(2) and OPCODE(1))) or ( ( not OPCODE(4) and not OPCODE(2)) and ( not OPCODE(1)  and  OPCODE(0) ) ) or (( not OPCODE(4) and OPCODE(3)) and ( not OPCODE(2)  and  not OPCODE(1) ) ) or (( OPCODE(3) and not OPCODE(2)) and ( not OPCODE(1)  and  OPCODE(0) ) );
    ALU_en <= (not OPCODE(4)) AND OPCODE(3);
    MemRead_en <= ((OPCODE(4) and OPCODE(3)) AND OPCODE(2)) OR ((OPCODE(4) AND OPCODE(1)) AND (not OPCODE(3)));
    Mem_to_Reg_en <= OPCODE(4) AND ((NOT OPCODE(3)) AND OPCODE(1));
    
    ---------
    RegWrite_en <= (((NOT OPCODE(3)) AND (OPCODE(2))) AND OPCODE(0)) OR ((OPCODE(4) AND (NOT OPCODE(3))) AND (OPCODE(1) AND OPCODE(0))) OR (((NOT OPCODE(4))) AND OPCODE(3)) OR (((OPCODE(4) AND NOT OPCODE(3))) AND (((NOT OPCODE(2)) AND NOT OPCODE(1)) AND NOT OPCODE(0))); -- OR In instruction
    MemWrite_en <= ((((OPCODE(4) AND (NOT OPCODE(3))) AND (NOT OPCODE(2))) AND (NOT OPCODE(1))) AND OPCODE(0)) OR (((OPCODE(4) AND (NOT OPCODE(3))) AND (OPCODE(2) AND (NOT OPCODE(1)))) AND (NOT OPCODE(0))) OR (((((OPCODE(4) AND OPCODE(3)) AND (NOT OPCODE(2))) AND OPCODE(1))) AND OPCODE(0));
    --------
    SETC_en <= (NOT OPCODE(4)) AND (NOT OPCODE(3)) AND (NOT OPCODE(2)) AND (NOT OPCODE(1)) AND OPCODE(0);
    CLRC_en <= (NOT OPCODE(4)) AND (NOT OPCODE(3)) AND (NOT OPCODE(0)) AND OPCODE(1);
    JZ_en <= OPCODE(4) AND OPCODE(3) AND (NOT OPCODE(2)) AND (NOT OPCODE(1)) AND (NOT OPCODE(0));
    JC_en <= OPCODE(4) AND OPCODE(3) AND (NOT OPCODE(2)) AND (NOT OPCODE(1)) AND OPCODE(0);
    JMP_en <= OPCODE(4) AND OPCODE(3) AND OPCODE(1) AND (NOT OPCODE(0));
    CALL_en <= OPCODE(4) AND OPCODE(3) AND (NOT OPCODE(2)) AND OPCODE(1) AND OPCODE(0);
    Immediate_en <= ((NOT OPCODE(4)) AND OPCODE(3) AND (NOT OPCODE(2)) AND (NOT OPCODE(1)) AND (NOT OPCODE(0))) OR (OPCODE(4) AND (NOT OPCODE(3)) AND (NOT OPCODE(2)) AND (NOT OPCODE(1)) AND (NOT OPCODE(0)));
    RET_en <= OPCODE(4) AND OPCODE(3) AND OPCODE(2) AND (NOT OPCODE(1)) AND (NOT OPCODE(0));
    OUT_en <= NOT OPCODE(4) AND (NOT OPCODE(3)) AND (NOT OPCODE(2)) AND OPCODE(1) AND OPCODE(0);
    RTI_en <= OPCODE(4) AND OPCODE(3) AND OPCODE(2) AND (NOT OPCODE(1)) AND OPCODE(0);
    Interrupt_en <= '0';
    FLAGS_en <= '0';
    PC_or_addrs1_en <= '0';
    SP_en <= '0';
    SP_inc_en <= '0';

    ------ To be removed when interrupt is handled
    PC_disable <= '0';


END my_Control_Unit;

-----------------------------------------------REFERENCES--------------------------------------------------------------

--  1-  https://www.ilovefreesoftware.com/25/windows/free-truth-table-to-logic-circuit-converter-software-windows.html

--  2 - https://imgur.com/a/24k0Zsk