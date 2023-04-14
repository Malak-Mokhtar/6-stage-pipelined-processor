LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY NF IS
    PORT (
        NF_ALU, clk, rst, DE_ALU_en_out : IN STD_LOGIC;
        NF_OUT : OUT STD_LOGIC);
END NF;

ARCHITECTURE my_NF OF NF IS
BEGIN
    PROCESS (clk, rst, DE_ALU_en_out)
    BEGIN
        IF (rst = '1') THEN
            NF_OUT <= '0';
        ELSIF falling_edge(clk) AND DE_ALU_en_out = '1' THEN
            NF_OUT <= NF_ALU;
        END IF;
    END PROCESS;
END my_NF;