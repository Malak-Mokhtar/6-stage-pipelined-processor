LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY ZF IS
    PORT (
        ZF_Selected, clk, rst, DE_ALU_en_out, MW_RTI_en_out, DE_JZ_en_out : IN STD_LOGIC;
        ZF_OUT : OUT STD_LOGIC);
END ZF;

ARCHITECTURE my_ZF OF ZF IS
BEGIN
    PROCESS (clk, rst, DE_ALU_en_out)
    BEGIN
        IF (rst = '1') THEN
            ZF_OUT <= '0';
        ELSIF rising_edge(clk) AND (DE_ALU_en_out = '1'  or (MW_RTI_en_out = '1') or (DE_JZ_en_out = '1') ) THEN
            ZF_OUT <= ZF_Selected;
        END IF;
    END PROCESS;
END my_ZF;
