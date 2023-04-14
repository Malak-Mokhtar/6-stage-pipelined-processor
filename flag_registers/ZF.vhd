LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY ZF IS
    PORT (
        ZF_ALU, clk, rst, DE_ALU_en_out : IN STD_LOGIC;
        ZF_OUT : OUT STD_LOGIC);
END ZF;

ARCHITECTURE my_ZF OF ZF IS
BEGIN
    PROCESS (clk, rst, DE_ALU_en_out)
    BEGIN
        IF (rst = '1') THEN
            ZF_OUT <= '0';
        ELSIF falling_edge(clk) AND DE_ALU_en_out = '1' THEN
            ZF_OUT <= ZF_ALU;
        END IF;
    END PROCESS;
END my_ZF;
