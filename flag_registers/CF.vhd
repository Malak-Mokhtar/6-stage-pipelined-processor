LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY CF IS
    PORT (
        CF_Selected, clk, rst, DE_Carry_en_out, MW_FLAGS_en_out : IN STD_LOGIC;
        CF_OUT : OUT STD_LOGIC);
END CF;

ARCHITECTURE my_CF OF CF IS
BEGIN
    PROCESS (clk, rst, DE_Carry_en_out)
    BEGIN
        IF (rst = '1') THEN
            CF_OUT <= '0';
        ELSIF rising_edge(clk) AND (DE_Carry_en_out = '1' or MW_FLAGS_en_out = '1' )THEN
            CF_OUT <= CF_Selected;
        END IF;
    END PROCESS;
END my_CF;
