LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY PC IS
    PORT (
        clk, rst, JMP_en, CALL_en, MW_RTI_en_out, MW_RET_en_out, PC_disable, en_load_use, en_structural, DE_JZ_en_out, ZF_OUT, DE_JC_en_out, CF_OUT: IN STD_LOGIC;
        IN_PC, IN_DATA : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Read_Address : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END PC;

ARCHITECTURE arch OF PC IS

signal PC_final_en, branch: std_logic;

BEGIN
branch <= ( (DE_JZ_en_out) and (ZF_OUT) ) or ( (DE_JC_en_out) and (CF_OUT));
PC_final_en <= JMP_en nor CALL_en nor MW_RTI_en_out nor MW_RET_en_out nor PC_disable nor en_load_use nor en_structural nor branch;

    main_loop : PROCESS (clk)
    BEGIN
        IF rst = '1' THEN
            -- async reset
            Read_Address <= IN_DATA;
        ELSIF rising_edge(clk) AND PC_final_en = '1' THEN
            -- change PC on rising edge
            Read_Address <= IN_PC;
        END IF;
    END PROCESS; -- main_loop

END ARCHITECTURE;