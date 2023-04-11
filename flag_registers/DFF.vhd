LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY DFF IS
    PORT (
        d, clk, rst, enable : IN STD_LOGIC;
        q : OUT STD_LOGIC);
END DFF;

ARCHITECTURE my_DFF OF DFF IS
BEGIN
    PROCESS (clk, rst, enable)
    BEGIN

        IF (rst = '1') THEN
            q <= '0';
        ELSIF clk'event AND clk = '1' AND enable = '1' THEN
            q <= d;
        END IF;
    END PROCESS;
END my_DFF;