LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY Control_Unit IS

    PORT (
        clk, FD_Interrupt_Signal_out : IN STD_LOGIC;
        OPCODE : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        IN_en, Carry_en, ALU_en, RegWrite_en, Mem_to_Reg_en, MemWrite_en, MemRead_en, SETC_en, CLRC_en, JZ_en, JC_en, JMP_en, CALL_en, Immediate_en, SP_en, SP_inc_en,
        RET_en, OUT_en, RTI_en, PC_disable , R1_en, R2_en : OUT STD_LOGIC;
        Interrupt_en : OUT STD_LOGIC;
        FLAGS_en : OUT STD_LOGIC;
        PC_or_addrs1_en : OUT STD_LOGIC

    );
END Control_Unit;

--                                                                                                                                                                                                                                                  A4 B3 C2 D1 E0
ARCHITECTURE my_Control_Unit OF Control_Unit IS

SIGNAL SP_en_normal : STD_LOGIC;
SIGNAL SP_inc_en_normal : STD_LOGIC;
SIGNAL SP_en_interrupt : STD_LOGIC;
SIGNAL POP_en_interrupt : STD_LOGIC;
SIGNAL PUSH_en_interrupt : STD_LOGIC;
SIGNAL MemWrite_en_normal : STD_LOGIC;
SIGNAL MemRead_en_normal : STD_LOGIC;
SIGNAL Interrupt_en_sig : STD_LOGIC := '0';
SIGNAL counter : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";

BEGIN

    interrupt : PROCESS (clk)
    BEGIN
        IF rising_edge(clk) AND FD_Interrupt_Signal_out = '1' AND counter ="000" THEN
            -- change PC on rising edge
            Interrupt_en_sig <= '1';
            counter <= "001";
        ELSIF rising_edge(clk) and counter = "100" THEN
            Interrupt_en_sig <= '0';
            counter <= "000";
        ELSIF rising_edge(clk) AND Interrupt_en_sig = '1' THEN
            counter <= STD_LOGIC_VECTOR(unsigned(counter) + 1);
        END IF;
    END PROCESS; -- main_loop

    In_en <= NOT OPCODE(4) AND NOT OPCODE(3) AND OPCODE(2) and (not OPCODE(0));
    Carry_en <= ((not OPCODE(4) and OPCODE(1)) and (not OPCODE(0))) or (not OPCODE(4) and (OPCODE(2) and OPCODE(1))) or ( ( not OPCODE(4) and not OPCODE(2)) and ( not OPCODE(1)  and  OPCODE(0) ) ) or (( not OPCODE(4) and OPCODE(3)) and ( not OPCODE(2)  and  not OPCODE(1) ) ) or (( OPCODE(3) and not OPCODE(2)) and ( not OPCODE(1)  and  OPCODE(0) ) );
    ALU_en <= (not OPCODE(4)) AND OPCODE(3);
    MemRead_en_normal <= ((OPCODE(4) and OPCODE(3)) AND OPCODE(2)) OR ((OPCODE(4) AND OPCODE(1)) AND (not OPCODE(3)));
    Mem_to_Reg_en <= OPCODE(4) AND ((NOT OPCODE(3)) AND OPCODE(1));
    
    ----------- 00100 OR (((NOT OPCODE(4) AND NOT OPCODE(3)) AND (OPCODE(2) AND NOT OPCODE(1))) AND NOT OPCODE(0))
    RegWrite_en <= (((NOT OPCODE(3)) AND (OPCODE(2))) AND OPCODE(0)) OR 
    ((OPCODE(4) AND (NOT OPCODE(3))) AND (OPCODE(1) AND OPCODE(0))) OR 
    (((NOT OPCODE(4))) AND OPCODE(3)) OR (((OPCODE(4) AND NOT OPCODE(3))) AND (((NOT OPCODE(2)) AND NOT OPCODE(1)) AND NOT OPCODE(0)))
    OR (((NOT OPCODE(4) AND NOT OPCODE(3)) AND (OPCODE(2) AND NOT OPCODE(1))) AND NOT OPCODE(0))
    OR (((OPCODE(4) AND NOT OPCODE(3)) AND NOT OPCODE(2)) AND (OPCODE(1) AND NOT OPCODE(0)));
    MemWrite_en_normal <= ((((OPCODE(4) AND (NOT OPCODE(3))) AND (NOT OPCODE(2))) AND (NOT OPCODE(1))) AND OPCODE(0)) OR (((OPCODE(4) AND (NOT OPCODE(3))) AND (OPCODE(2) AND (NOT OPCODE(1)))) AND (NOT OPCODE(0))) OR (((((OPCODE(4) AND OPCODE(3)) AND (NOT OPCODE(2))) AND OPCODE(1))) AND OPCODE(0));
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
    SP_en_normal <= (((OPCODE(4) AND OPCODE(3)) AND (OPCODE(2) AND NOT OPCODE(1))) OR
    (((OPCODE(4) AND NOT OPCODE(3)) AND NOT OPCODE(2)) AND (NOT OPCODE(1) AND OPCODE(0))) OR
    (((OPCODE(4) AND NOT OPCODE(3)) AND NOT OPCODE(2)) AND (OPCODE(1) AND NOT OPCODE(0))) OR
    (((OPCODE(4) AND OPCODE(3)) AND (NOT OPCODE(2) AND OPCODE(1))) AND OPCODE(0)));
    SP_inc_en <=  (((OPCODE(4) AND OPCODE(3)) AND (OPCODE(2) AND NOT OPCODE(1))) OR ((((OPCODE(4) AND NOT OPCODE(3)) AND (NOT OPCODE(2)) AND (OPCODE(1))) AND NOT OPCODE(0))));
    R1_en <= (NOT OPCODE(4) AND OPCODE(3)) OR (OPCODE(3) AND NOT OPCODE(2)) OR (((OPCODE(4) AND NOT OPCODE(3) ) AND (OPCODE(2) AND  NOT OPCODE(1))) AND NOT OPCODE(0));
    R2_en <= ((NOT OPCODE(3) AND NOT OPCODE(2)) AND (OPCODE(1) AND OPCODE(0))) OR (((NOT OPCODE(4) AND NOT OPCODE(3)) AND OPCODE(2)) AND (NOT OPCODE(1) AND OPCODE(0))) OR ((NOT OPCODE(4) AND
    OPCODE(3)) AND (NOT OPCODE(2) AND OPCODE(0))) OR ((NOT OPCODE(4) AND OPCODE(3)) AND (NOT OPCODE(2) AND OPCODE(1))) OR (((NOT OPCODE(4) AND OPCODE(3)) AND (OPCODE(2) AND NOT OPCODE(1))) AND NOT OPCODE(0)) OR
    ((OPCODE(4) AND NOT OPCODE(3)) AND (NOT OPCODE(2) AND OPCODE(0))) OR ((((OPCODE(4) AND NOT OPCODE(3)) AND OPCODE(2)) AND NOT OPCODE(1)) AND NOT OPCODE(0));
    ------ To be removed when interrupt is handled
    -- PUSH FLAGS
    FLAGS_en <= NOT counter(1) AND counter(0); --001

    -- PUSH FLAGS (001) OR PC (010) 01, 10
    PUSH_en_interrupt <= counter(1) XOR counter(0);
    SP_en <= SP_en_normal OR PUSH_en_interrupt;
    MemWrite_en <= MemWrite_en_normal OR  PUSH_en_interrupt;
    
    -- POP M[1] 011 100
    POP_en_interrupt <= (counter(1) AND counter(0)) OR (counter(2) AND (NOT counter(1)) AND (NOT counter(0)));
    MemRead_en <= MemRead_en_normal OR POP_en_interrupt;

    -- Common
    Interrupt_en <= ((NOT counter(1)) AND (counter(0)));
    PC_disable <= Interrupt_en_sig; -- FREEZING WORKS LATE
    PC_or_addrs1_en <= Interrupt_en_sig;

    

END my_Control_Unit;

-----------------------------------------------REFERENCES--------------------------------------------------------------

--  1-  https://www.ilovefreesoftware.com/25/windows/free-truth-table-to-logic-circuit-converter-software-windows.html

--  2 - https://imgur.com/a/24k0Zsk