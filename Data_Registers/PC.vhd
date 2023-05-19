LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY PC IS
    PORT (
        clk, rst, DE_JMP_en_out, DE_CALL_en_out, MW_RTI_en_out, MW_RET_en_out, DE_PC_disable_out, en_load_use, en_structural, DE_JZ_en_out, ZF_OUT, DE_JC_en_out, CF_OUT : IN STD_LOGIC;
        IN_PC, IN_DATA : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Read_Address : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END PC;

ARCHITECTURE arch OF PC IS

    SIGNAL PC_final_en, branch : STD_LOGIC;

BEGIN
    branch <= ((DE_JZ_en_out) AND (ZF_OUT)) OR ((DE_JC_en_out) AND (CF_OUT));
    PC_final_en <= ((DE_JMP_en_out NOR DE_CALL_en_out) NOR (MW_RTI_en_out NOR MW_RET_en_out)) NOR ((DE_PC_disable_out NOR en_load_use) NOR (en_structural NOR branch));

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